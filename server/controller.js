const express = require("express");
const { 
	testOracleConnection,
	getTable,
	getAllNamePositionTeam,
	getTeams,
	getMaxPersonID,
	getPositions

} = require("./dbQueries");

const router = express.Router();

const queryToJson = require("./utils/helpers");

router.get("/check-db-connection", async (req, res) => {
    const isConnect = await testOracleConnection();
    if (isConnect) {
        res.send("Connected!");
    } else {
        res.send("Unable to connect!");
    }
});

router.get("/table/:table", async (req, res) => {	
	let result;
	try {
		result = await getTable(req.params.table);
	} catch (err) {
		return res.status(404).send("Not found");
	}
	return res.status(200).json(queryToJson(result));
});

router.get("/name-position-team", async (req, res) => {
	let result;
	try {
		result = await getAllNamePositionTeam();
	} catch (err) {
		return res.status(404).send("Not found");
	}
	return res.status(200).json(queryToJson(result));
});

router.get("/teams", async (req, res) => {
	let result;
	try {
		result = await getTeams();
	} catch (err) {
		return res.status(404).send("Not found"); 
	}
	return res.status(200).json(queryToJson(result));	
});

router.get("/max-id/:person", async (req, res) => {
	let result;
	try {
		result = await getMaxPersonID(req.params.person);
	} catch (err) {
		return res.status(404).send("Not found"); 
	}
	return res.status(200).json(queryToJson(result));	
});

router.get("/positions", async (req, res) => {
	let result;
	try {
		result = await getPositions();
	} catch (err) {
		return res.status(404).send("Not found"); 
	}
	return res.status(200).json(queryToJson(result));	
});



module.exports = router;