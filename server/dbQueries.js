const oracledb = require("oracledb");

const loadEnvFile = require("./utils/envUtil");
const envVariables = loadEnvFile("../.env");

// Database configuration setup. Ensure your .env file has the required database credentials.
const DB_CONFIG = {
	user: envVariables.ORACLE_USER,
	password: envVariables.ORACLE_PASS,
	connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
	poolMax: 1
};

// Wrapper to manage OracleDB actions, simplifying connection handling.
// https://piazza.com/class/lkk1xyugpas6fo/post/545
let poolMade = false;
let pool;
const withOracleDB = async(action) => {
    let connection;
    try {
        if (!poolMade) {
            await oracledb.createPool(DB_CONFIG);
            pool = oracledb.getPool();
            poolMade = true;
        }

        connection = await pool.getConnection();
        return await action(connection);
    } catch (err) {
        console.error(err);
        throw err;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
}

const testOracleConnection = async () => {
	return await withOracleDB(async (connection) => {
		console.log("Oracle connection success!");
		return true;
	}).catch(() => {
		console.log("Oracle connection failed!");
		return false;
	});
}

const getAllNamePositionTeam = () => {
	return withOracleDB((connection) => {
		return connection.execute(`
			SELECT person_id, name, position, current_team as team
			FROM Athlete, PositionDetails
			WHERE Athlete.jersey_num = PositionDetails.jersey_num
		`).catch((err) => {
			throw err;
		});
	});
}

const getTeams = () => {
	return withOracleDB((connection) => {
		return connection.execute(`
			SELECT team_name
			FROM Team
		`).catch((err) => {
			throw err;
		});
	});
}

const getPositions = () => {
	return withOracleDB((connection) => {
		return connection.execute(`
			SELECT *
			FROM PositionDetails
		`).catch((err) => {
			throw err;
		});
	});
};

const insertAthlete = (body) => {
	const { 
		person_id,
		name,
		birthdate,
		height,
		weight,
		phone_number,
		email,
		address,
		date_started,
		jersey_num,
		current_team,
		salary
	} = body;

	return withOracleDB((connection) => {
		return connection.execute(`
			INSERT INTO Athlete VALUES (
				:person_id, 
				:name, 
				TO_DATE(:birthdate, 'YYYY-MM-DD'),
				:height, 
				:weight, 
				:phone_number, 
				:email, 
				:address, 
				TO_DATE(:date_started, 'YYYY-MM-DD'),
				:jersey_num, 
				:current_team, 
				:salary
			)`, [	
				person_id,
				name,
				birthdate,
				height,
				weight,
				phone_number,
				email,
				address,
				date_started,
				jersey_num,
				current_team,
				salary
			],
			{ autoCommit: true}
		).catch((err) => {
			throw err;
		});
	});
};

const deleteAthlete = (person_id) => {
	return withOracleDB((connection) => {
		return connection.execute(`
				DELETE FROM Athlete
				WHERE person_id = :person_id
			`, 
			[person_id],
			{ autoCommit: true }
		).catch((err) => {
			throw err;
		});
	});
};

const getAthlete = (person_id) => {
	return withOracleDB((connection) => {
		return connection.execute(`
			SELECT *
			FROM Athlete
			WHERE Athlete.person_id = ${person_id}
		`).catch((err) => {
			throw err;
		});
	});
};

const updateAthlete = (body) => {
	const { 
		person_id,
		name,
		birthdate,
		height,
		weight,
		phone_number,
		email,
		address,
		date_started,
		jersey_num,
		current_team,
		salary
	} = body;

	// for some reason bind parameters don't work here...
	return withOracleDB((connection) => {
		return connection.execute(`
				UPDATE Athlete 
				SET name='${name}',
					birthdate=TO_DATE('${birthdate}', 'YYYY-MM-DD'),
					height=${height}, 
					weight=${weight}, 
					phone_number=${phone_number}, 
					email='${email}', 
					address='${address}', 
					date_started=TO_DATE('${date_started}', 'YYYY-MM-DD'),
					jersey_num=${jersey_num}, 
					current_team='${current_team}', 
					salary=${salary}
				WHERE person_id=${person_id}
			`, []
			, { autoCommit: true })
		.catch((err) => {
			throw err;
		});
	});
};

const getPlayerAwards = (person_id) => {
	return withOracleDB((connection) => {
		return connection.execute(`
			SELECT Athlete.person_id, Awards.year, Awards.award_name
			FROM Athlete, WinsAward, Awards
			WHERE Athlete.person_id=WinsAward.person_id AND WinsAward.award_id=Awards.award_id AND Athlete.person_id=${person_id}
		`).catch((err) => {
			throw err;
		});
	});	
};

const getTables = () => {
	return withOracleDB((connection) => {
		// not allowing user to see certain "private" tables, but otherwise is dynamic
		// https://www.sqltutorial.org/sql-list-all-tables/
		return connection.execute(`
			SELECT table_name
			FROM user_tables
			WHERE table_name <> 'PARTICIPATESIN' AND
				table_name <> 'LOCATEDIN' AND
				table_name <> 'HASSPONSOR' AND
				table_name <> 'GIVENBY' AND
				table_name <> 'WINSAWARD' AND
				table_name <> 'PLAYSFOR' AND
				table_name <> 'COACHES' AND
				table_name <> 'REFEREES'
		`).catch((err) => {
			throw err;
		});
	});	
};

const getAttributes = (table_name) => {
	// https://stackoverflow.com/a/32240681
	return withOracleDB((connection) => {
		return connection.execute(`
			SELECT column_name
			FROM USER_TAB_COLS
			WHERE table_name=UPPER('${table_name}')
		`).catch((err) => {
			throw err;
		});
	});	
} 

const getTable = (body) => {
	const { table, attributes } = body;

	return withOracleDB((connection) => {
		return connection.execute(`SELECT ${attributes.toString()} FROM ${table}`)
			.catch((err) => {
				throw err;
			});
	});
}

const getStandings = () => {
	// TODO: update to do the correct one

	const queries = [
		"DROP VIEW AvgGoalsPerGame",
		"DROP VIEW MaxAvgGoalsPerGame",
		`
		CREATE VIEW AvgGoalsPerGame AS
			(SELECT home as team, total_goals
			FROM HomeGoals)
			UNION ALL
			(SELECT away as team, total_goals
			FROM AwayGoals)`,
		`CREATE VIEW MaxAvgGoalsPerGame AS
		SELECT team, avg(total_goals) as AvgGoalsPerGame
		FROM AvgGoalsPerGame a
		GROUP BY team
		HAVING avg(total_goals) >= all  (SELECT avg(a.total_goals)
										FROM AvgGoalsPerGame a
										GROUP BY a.team)`
	]

	return withOracleDB(async (connection) => {

		for (let query of queries) {
			await connection.execute(query);
		}

		let result = await connection.execute("SELECT * FROM MAXAVGGOALSPERGAME");
		return result;

	});
};


const getMaxAvgGoalsPerGame = () => {

	const queries = [
		"DROP VIEW AvgGoalsPerGame",
		"DROP VIEW MaxAvgGoalsPerGame",
		`
		CREATE VIEW AvgGoalsPerGame AS
			(SELECT home as team, total_goals
			FROM HomeGoals)
			UNION ALL
			(SELECT away as team, total_goals
			FROM AwayGoals)`,
		`CREATE VIEW MaxAvgGoalsPerGame AS
		SELECT team, avg(total_goals) as AvgGoalsPerGame
		FROM AvgGoalsPerGame a
		GROUP BY team
		HAVING avg(total_goals) >= all  (SELECT avg(a.total_goals)
										FROM AvgGoalsPerGame a
										GROUP BY a.team)`
	]

	return withOracleDB(async (connection) => {

		for (let query of queries) {
			await connection.execute(query);
		}

		let result = await connection.execute("SELECT * FROM MAXAVGGOALSPERGAME");
		return result;

	});
};

module.exports = {
	testOracleConnection,
	getAllNamePositionTeam,
	getTeams,
	getPositions,
	insertAthlete,
	deleteAthlete,
	getAthlete,
	updateAthlete,
	getPlayerAwards,
	getTables,
	getAttributes,
	getTable,
	getStandings,
	getMaxAvgGoalsPerGame
};
