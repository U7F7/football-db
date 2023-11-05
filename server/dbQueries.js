const oracledb = require("oracledb");

const loadEnvFile = require("./utils/envUtil");
const envVariables = loadEnvFile("../.env");

// Database configuration setup. Ensure your .env file has the required database credentials.
const DB_CONFIG = {
	user: envVariables.ORACLE_USER,
	password: envVariables.ORACLE_PASS,
	connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
};

// Wrapper to manage OracleDB actions, simplifying connection handling.
const withOracleDB = (action) => {
	let connection;

	return oracledb.getConnection(DB_CONFIG)
		.then((conn) => {
			connection = conn;
			return action(connection)
				.then((result) => {
					return result;
				})
				.catch((err) => {
					console.error(err);
					throw err;
				});
		})
		.catch((err) => {
			console.error(err);
			throw err;
		})
		.finally(() => {
			if (connection) {
				return connection.close()
					.catch((err) => {
						console.error(err);
					});
			}
		});
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
			.catch(() => {
				return {};
			});
	});
}

module.exports = {
	testOracleConnection,
	getTable
};