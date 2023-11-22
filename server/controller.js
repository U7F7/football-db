const express = require("express");
const { 
	testOracleConnection,
	getTable,
	getAllNamePositionTeam,
	getTeams,
	getPositions,
	insertAthlete,
	deleteAthlete
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
		res.status(404).send("Not found");
	}
	res.status(200).json(queryToJson(result));
});

router.get("/name-position-team", async (req, res) => {
	let result;
	try {
		result = await getAllNamePositionTeam();
	} catch (err) {
		res.status(404).send("Not found");
	}
	res.status(200).json(queryToJson(result));
});

router.get("/teams", async (req, res) => {
	let result;
	try {
		result = await getTeams();
	} catch (err) {
		res.status(404).send("Not found"); 
	}
	res.status(200).json(queryToJson(result));	
});

router.get("/positions", async (req, res) => {
	let result;
	try {
		result = await getPositions();
	} catch (err) {
		res.status(404).send("Not found"); 
	}
	res.status(200).json(queryToJson(result));	
});

router.post("/athlete", async (req, res) => {
	let result;
	try {
		result = await insertAthlete(req.body);
		res.json({ success: true });
	} catch (err) {
		res.status(500).json({ success: false });
	}
});

router.delete("/athlete/:person_id", async (req, res) => {
	let result = await deleteAthlete(req.params.person_id);
    if (result) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});



module.exports = router;