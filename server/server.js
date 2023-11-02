const express = require("express");

// Load environment variables from .env file
// Ensure your .env file has the required database credentials.
const loadEnvFile = require("./utils/envUtil");
const envVariables = loadEnvFile("../.env");
const oracledb = require("oracledb");
const queryToJson = require("./utils/helpers");

const app = express();
const PORT = envVariables.PORT || 65534; // Adjust the PORT if needed (e.g., if you encounter a "port already occupied" error)

// Database configuration setup. Ensure your .env file has the required database credentials.
const DB_CONFIG = {
	user: envVariables.ORACLE_USER,
	password: envVariables.ORACLE_PASS,
	connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
};

// Starting the server
app.listen(PORT, () => {
	console.log(`Server running at http://localhost:${PORT}/`);
});

// Middleware setup
app.use(express.json()); // Parse incoming JSON payloads
// CORS fix
app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
	res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
	res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
	next();
});


app.get("/test", (req, res) => {
	res.json({hi: "hello world"});
});

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

async function testOracleConnection() {
    return await withOracleDB(async (connection) => {
		console.log("Oracle connection success!");
        return true;
    }).catch(() => {
		console.log("Oracle connection failed!");
        return false;
    });
}

testOracleConnection();

const getTable = (table) => {
    return withOracleDB((connection) => {
        return connection.execute(`SELECT * FROM ${table}`)
            .then((result) => {
                return result;
            })
            .catch(() => {
                return {};
            });
    });
}

app.get("/table/:table", async (req, res) => {
	const result = await getTable(req.params.table);
	if (Object.keys(result).length === 0) {
		return res.status(404).send("Not found");
	}
	return res.status(200).json(queryToJson(result));
});