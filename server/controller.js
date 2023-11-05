const express = require("express");
const { 
	testOracleConnection,
	getTable 
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
	const result = await getTable(req.params.table);
	if (Object.keys(result).length === 0) {
		return res.status(404).send("Not found");
	}
	return res.status(200).json(queryToJson(result));
});

module.exports = router;