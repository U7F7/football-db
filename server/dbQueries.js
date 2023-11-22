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

const getTable = (table) => {
	return withOracleDB((connection) => {
		return connection.execute(`SELECT * FROM ${table}`)
			.catch((err) => {
				throw err;
			});
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

module.exports = {
	testOracleConnection,
	getTable,
	getAllNamePositionTeam,
	getTeams,
	getPositions,
	insertAthlete,
	deleteAthlete,
	getAthlete,
	updateAthlete
};