// Server Model (server.js, dbQueries.js, controller.js) inspired by
// https://github.students.cs.ubc.ca/CPSC304/CPSC304_Node_Project

const express = require("express");
const app = express();
const controller = require("./controller");

const loadEnvFile = require("./utils/envUtil");
const envVariables = loadEnvFile("../.env");
const PORT = envVariables.PORT || 65534; // Adjust the PORT if needed (e.g., if you encounter a "port already occupied" error)

// Middleware setup
// mount the router
app.use("/", controller);

// Parse incoming JSON payloads
app.use(express.json()); 

// CORS to allow front end to query backend
app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
	res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
	res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
	next();
});

// Starting the server
app.listen(PORT, () => {
	console.log(`Server running at http://localhost:${PORT}/`);
});

