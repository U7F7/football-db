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

	const queries = [
		`CREATE OR REPLACE VIEW GamesPerTeam(team_name, games_played) AS
			SELECT t.team_name, COUNT(*) as games_played
			FROM Game g, Team t, ParticipatesIn p
			WHERE g.game_id = p.game_id AND (t.team_name = p.team_1 OR t.team_name = p.team_2)
			GROUP BY t.team_name`,
		
		`CREATE OR REPLACE VIEW GoalsPerAthlete(stats_id, person_id, game_id, total_goals) AS
			SELECT s.stats_id, s.person_id, s.game_id, SUM(s.goals) AS total_goals
			FROM Athlete a, Statistics s
			WHERE s.person_id = a.person_id
			GROUP BY s.stats_id, s.person_id, s.game_id
			ORDER BY s.stats_id`,
		
		`CREATE OR REPLACE VIEW GoalsPerGame(stats_id, person_id, game_id, total_goals) AS
			SELECT gpa.stats_id, gpa.person_id, gpa.game_id, gpa.total_goals
			FROM GoalsPerAthlete gpa
			ORDER BY gpa.stats_id`,
		
		`CREATE OR REPLACE VIEW GoalsPerTeam(stats_id, game_id, CURRENT_TEAM, home, away, total_goals) AS
			SELECT gpg.stats_id, gpg.game_id, a.CURRENT_TEAM, g.home, g.away, gpg.total_goals
			FROM GoalsPerGame gpg, athlete a, Game g
			WHERE gpg.person_id = a.person_id AND gpg.game_id = g.game_id`,
		
		`CREATE OR REPLACE VIEW HomeGoals(game_id, home, total_goals) AS
			SELECT gpt.game_id, gpt.home, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.home
			GROUP BY gpt.game_id, gpt.home`,
		
		`CREATE OR REPLACE VIEW AwayGoals(game_id, away, total_goals) AS
			SELECT gpt.game_id, gpt.away, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.away
			GROUP BY gpt.game_id, gpt.away`,
		
		`CREATE OR REPLACE VIEW HomeWins AS
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals > t2.total_goals`,
		
		`CREATE OR REPLACE VIEW AwayWins AS
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals < t2.total_goals`,
		
		`CREATE OR REPLACE VIEW WinnerPerGame AS
			SELECT aw.game_id as game_id, aw.away as team
			FROM AwayWins aw
			UNION
			SELECT hw.game_id as game_id, hw.home as team
			FROM HomeWins hw`,
		
		`CREATE OR REPLACE VIEW CountWins AS
			SELECT w.team, Count(*) as winCount
			FROM WinnerPerGame w
			GROUP BY w.team`,
		
		`CREATE OR REPLACE VIEW CountWinsAll AS
			SELECT team_name, COALESCE(cw.winCount, 0) as winCount
			FROM team t
				LEFT OUTER JOIN CountWins cw ON t.TEAM_NAME = cw.TEAM`,
		
		`CREATE OR REPLACE VIEW HomeLosses AS
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals < t2.total_goals`,
		
		`CREATE OR REPLACE VIEW AwayLosses AS
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals > t2.total_goals`,
		
		`CREATE OR REPLACE VIEW LosersPerGame AS
			SELECT al.game_id as game_id, al.away as team
			FROM AwayLosses al
			UNION
			SELECT hl.game_id as game_id, hl.home as team
			FROM HomeLosses hl`,
		
		`CREATE OR REPLACE VIEW CountLosses AS
			SELECT l.team, Count(*) as lossCount
			FROM LosersPerGame l
			GROUP BY l.team`,
		
		`CREATE OR REPLACE VIEW CountLossesAll AS
			SELECT team_name, COALESCE(lossCount, 0) as lossCount
			FROM team t
				LEFT OUTER JOIN CountLosses cl ON t.TEAM_NAME = cl.TEAM`,
		
		`CREATE OR REPLACE VIEW HomeDraws AS
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals = t2.total_goals`,
		
		`CREATE OR REPLACE VIEW AwayDraws AS
			SELECT t1.game_id, t1.home, t1.total_goals as home_goals, t2.away, t2.total_goals as away_goals
			FROM HomeGoals t1, AwayGoals t2
			WHERE t1.game_id = t2.game_id AND t1.total_goals = t2.total_goals`,
		
		`CREATE OR REPLACE VIEW DrawsPerGame AS
			SELECT ad.game_id as game_id, ad.away as team
			FROM AwayDraws ad
			UNION
			SELECT hd.game_id as game_id, hd.home as team
			FROM HomeDraws hd`,
		
		`CREATE OR REPLACE VIEW CountDraws AS
			SELECT d.team, Count(*) as drawCount
			FROM DrawsPerGame d
			GROUP BY d.team`,
		
		`CREATE OR REPLACE VIEW CountDrawsAll AS
			SELECT team_name, COALESCE(drawCount, 0) as drawCount
			FROM team t
				LEFT OUTER JOIN CountDraws cd ON t.TEAM_NAME = cd.TEAM`,

		`CREATE OR REPLACE VIEW Standings AS
			SELECT t.team_name as TeamName, g.games_played as GamesPlayed,
				w.winCount as WinCount, l.lossCount as LossCount, d.drawCount as DrawCount
			FROM team t, GamesPerTeam g, CountWinsAll w, CountLossesAll l, CountDrawsAll d
			WHERE t.TEAM_NAME = g.TEAM_NAME AND t.TEAM_NAME = w.TEAM_NAME AND
				t.TEAM_NAME = l.TEAM_NAME AND t.TEAM_NAME = d.TEAM_NAME`
	]

	return withOracleDB(async (connection) => {

		for (let query of queries) {
			await connection.execute(query);
		}

		let result = await connection.execute("SELECT * FROM STANDINGS ORDER BY winCount DESC");
		return result;

	});
};


const getMaxAvgGoalsPerGame = () => {
	const queries = [
		`CREATE OR REPLACE VIEW HomeGoals(game_id, home, total_goals) AS
			SELECT gpt.game_id, gpt.home, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.home
			GROUP BY gpt.game_id, gpt.home`,
	
		`CREATE OR REPLACE VIEW AwayGoals(game_id, away, total_goals) AS
			SELECT gpt.game_id, gpt.away, SUM(gpt.total_goals) as total_goals
			FROM GoalsPerTeam gpt
			WHERE gpt.CURRENT_TEAM = gpt.away
			GROUP BY gpt.game_id, gpt.away`,

		`CREATE OR REPLACE VIEW AvgGoalsPerGame AS
			(SELECT home as team, total_goals
			FROM HomeGoals)
			UNION ALL
			(SELECT away as team, total_goals
			FROM AwayGoals)`,
		
		`CREATE OR REPLACE VIEW MaxAvgGoalsPerGame AS
			SELECT team, avg(total_goals) as AvgGoalsPerGame
			FROM AvgGoalsPerGame a
			GROUP BY team
			HAVING avg(total_goals) >= all  (SELECT avg(a.total_goals)
											FROM AvgGoalsPerGame a
											GROUP BY a.team)`
	];

	return withOracleDB(async (connection) => {
		try {
			for (let query of queries) {
				await connection.execute(query);
			}
			return await connection.execute("SELECT * FROM MaxAvgGoalsPerGame");
		} catch (err) {
			throw err;
		}
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
