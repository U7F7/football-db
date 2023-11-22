const express = require("express");
const { 
	testOracleConnection,
	getTable,
	getAllNamePositionTeam,
	getTeams,
	getPositions,
	insertAthlete,
	deleteAthlete,
	getAthlete,
	updateAthlete
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
	let result = await getTable(req.params.table);
	if (result) {
		res.status(200).json(queryToJson(result));
	} else {
		res.status(404).send("Not found");
	}
	
});

router.get("/name-position-team", async (req, res) => {
	let result = await getAllNamePositionTeam();
	if (result) {
		res.status(200).json(queryToJson(result));
	} else {
		res.status(404).send("Not found");
	}
	
});

router.get("/teams", async (req, res) => {
	let result = await getTeams();
	if (result) {
		res.status(200).json(queryToJson(result));	
	} else {
		res.status(404).send("Not found"); 
	}
	
});

router.get("/positions", async (req, res) => {
	let result = await getPositions();
	if (result) {
		res.status(200).json(queryToJson(result));	
	} else {
		res.status(404).send("Not found"); 
	}
	
});

router.get("/athlete/:person_id", async (req, res) => {
	let result = await getAthlete(req.params.person_id);
	if (result) {
		res.status(200).json(queryToJson(result));
	} else {
		res.status(404).send("Not found");
	}
});

router.post("/athlete", async (req, res) => {
	let result = await insertAthlete(req.body);
	if (result) {
		res.json({ success: true });
	} else {
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

router.put("/athlete", async (req, res) => {
	let result = await updateAthlete(req.body);
	if (result) {
		res.json({ success: true });
	} else {
		res.status(500).json({ success: false });
	}
});




module.exports = router;