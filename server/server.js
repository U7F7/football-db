const express = require("express");

// Load environment variables from .env file
// Ensure your .env file has the required database credentials.
const loadEnvFile = require("./utils/envUtil");
const envVariables = loadEnvFile("../.env");
const oracledb = require("oracledb");

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

app.get("/", (req, res) => {
	res.json({hi: "hello world"});
});


