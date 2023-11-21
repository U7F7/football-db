import { React, useState } from "react";

import AddAthleteModal from "./AddAthleteModal";

import Container from "react-bootstrap/Container";
import Col from "react-bootstrap/Col";
import Row from "react-bootstrap/Row";
import Button from "react-bootstrap/Button";
import Table from "react-bootstrap/Table";

import { ArrowDownUp } from "react-bootstrap-icons";


const Athletes = () => {
	const addButtonStyle = {
		display: "flex", 
		justifyContent: "right", 
		padding: "12px"
	};

	const thStyle = {
		display: "flex",
		float: "left"
	};

	const sortButtonStyle = {
		display: "flex",
		float: "right"
	};
	
	const [dummyData, setDummyData] = useState([
		{
			"person_id": 1,
			"name": "John Doe",
			"position": "Goalkeeper",
			"team": "Vancouver Vipers"
		},
		{
			"person_id": 2,
			"name": "Jane Smith",
			"position": "Right Back",
			"team": "Vancouver Vipers"
		},
		{
			"person_id": 3,
			"name": "Mike Johnson",
			"position": "Left Back",
			"team": "Vancouver Vipers"
		},
		{
			"person_id": 4,
			"name": "Billy Bob",
			"position": "Goalkeeper",
			"team": "Vancouver Thunder"
		},
		{
			"person_id": 5,
			"name": "Danielle Chu",
			"position": "Right Back",
			"team": "Vancouver Thunder"
		},
		{
			"person_id": 6,
			"name": "Darren Sam",
			"position": "Left Back",
			"team": "Vancouver Thunder"
		},
		{
			"person_id": 7,
			"name": "Parker Fin",
			"position": "Goalkeeper",
			"team": "Vancouver Warriors"
		},
		{
			"person_id": 8,
			"name": "Lauren Shim",
			"position": "Right Back",
			"team": "Vancouver Warriors"
		},
		{
			"person_id": 9,
			"name": "Markus Duff",
			"position": "Left Back",
			"team": "Vancouver Warriors"
		},
		{
			"person_id": 10,
			"name": "Adam Desmond",
			"position": "Goalkeeper",
			"team": "Vancouver Titans"
		},
		{
			"person_id": 11,
			"name": "Brittany Peterson",
			"position": "Right Back",
			"team": "Vancouver Titans"
		},
		{
			"person_id": 12,
			"name": "Ryan Son",
			"position": "Left Back",
			"team": "Vancouver Titans"
		},
		{
			"person_id": 13,
			"name": "Harry Ford",
			"position": "Goalkeeper",
			"team": "Vancouver Sharks"
		},
		{
			"person_id": 14,
			"name": "Ruth North",
			"position": "Right Back",
			"team": "Vancouver Sharks"
		},
		{
			"person_id": 15,
			"name": "Luke Sky",
			"position": "Sweeper",
			"team": "Vancouver Sharks"
		},
		{
			"person_id": 16,
			"name": "James Fort",
			"position": "Goalkeeper",
			"team": "Vancouver Bears"
		},
		{
			"person_id": 17,
			"name": "Ivana Lee",
			"position": "Right Back",
			"team": "Vancouver Bears"
		},
		{
			"person_id": 18,
			"name": "Jim Gear",
			"position": "Left Back",
			"team": "Vancouver Bears"
		},
	]);

	const ASC = false;
	const DESC = true;

	const [sortDir, setSortDir] = useState({ name: ASC, position: ASC, team: ASC });

	const handleSort = (e) => {
		if (e.currentTarget.id === "name-up") {
			dummyData.sort((a, b) => a.name.localeCompare(b.name));
			setSortDir({...sortDir, name: DESC})
			return;
		}
		if (e.currentTarget.id === "name-down") {
			dummyData.sort((a, b) => b.name.localeCompare(a.name));
			setSortDir({...sortDir, name: ASC})
			return;
		}
		if (e.currentTarget.id === "position-up") {
			dummyData.sort((a, b) => a.position.localeCompare(b.position));
			setSortDir({...sortDir, position: DESC})
			return;
		}
		if (e.currentTarget.id === "position-down") {
			dummyData.sort((a, b) => b.position.localeCompare(a.position));
			setSortDir({...sortDir, position: ASC})
			return;
		}
		if (e.currentTarget.id === "team-up") {
			dummyData.sort((a, b) => a.team.localeCompare(b.team));
			setSortDir({...sortDir, team: DESC})
			return;
		}
		if (e.currentTarget.id === "team-down") {
			dummyData.sort((a, b) => b.team.localeCompare(a.team));
			setSortDir({...sortDir, team: ASC})
			return;
		}
	};

	const [showAddAthlete, setShowAddAthlete] = useState(false);

	return (
		<Container style={{ marginTop: "20px" }}>
			<Row>
				<Col xs={10}>
					<h1>Athletes</h1>
				</Col>
				<Col xs={2} style={addButtonStyle}>
					<Button variant="primary" onClick={() => setShowAddAthlete(true)}>Add Athlete</Button>
				</Col>
			</Row>
			<AddAthleteModal athletes={dummyData} setAthletes={setDummyData} showAddAthlete={showAddAthlete} setShowAddAthlete={setShowAddAthlete} />
			<Table striped bordered>
				<thead>
					<tr>
						<th>
							<div style={thStyle}>
								Name
							</div>
							<div style={sortButtonStyle}>
								<ArrowDownUp id={sortDir.name === ASC ? "name-up" : "name-down"} onClick={handleSort} />
							</div>
						</th>
						<th>
							<div style={thStyle}>
								Position
							</div>
							<div style={sortButtonStyle}>
								<ArrowDownUp id={sortDir.position === ASC ? "position-up" : "position-down"} onClick={handleSort} />
							</div>
						</th>
						<th>
							<div style={thStyle}>
								Team
							</div>
							<div style={sortButtonStyle}>
								<ArrowDownUp id={sortDir.team === ASC ? "team-up" : "team-down"} onClick={handleSort} />
							</div>
						</th>
						<th style={{ width: "15%" }}>Action</th>
					</tr>
				</thead>
				<tbody>
					{dummyData.map((obj) => {
						return (
							<tr key={obj.person_id}>
								<td>{obj.name}</td>
								<td>{obj.position}</td>
								<td>{obj.team}</td>
								<td>
									<Container style={{ display: "flex", justifyContent: "center" }}>
										<Row>
											<Col>
												<Button id={obj.person_id} variant="warning">Edit</Button>
											</Col>
											<Col>
												<Button id={obj.person_id} variant="danger">Delete</Button>
											</Col>
										</Row>	
									</Container>
								</td>
							</tr>
						);
					})}
				</tbody>
			</Table>
		</Container>
	);
};

export default Athletes;
