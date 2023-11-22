import { React, useEffect, useState } from "react";

import AddAthleteModal from "./AddAthleteModal";

import Container from "react-bootstrap/Container";
import Col from "react-bootstrap/Col";
import Row from "react-bootstrap/Row";
import Button from "react-bootstrap/Button";
import Table from "react-bootstrap/Table";

import { ArrowDownUp } from "react-bootstrap-icons";

import axios from "axios";

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
	
	const [athletes, setAthletes] = useState([]);

	useEffect(() => {
		axios.get("http://localhost:65535/name-position-team")
			.then((res) => {
				setAthletes(res.data);
			})
			.catch((err) => {
				console.error(err);
			})
	}, []);

	const ASC = false;
	const DESC = true;

	const [sortDir, setSortDir] = useState({ name: ASC, position: ASC, team: ASC });
	const [showAddAthlete, setShowAddAthlete] = useState(false);

	const handleSort = (e) => {
		if (e.currentTarget.id === "name-up") {
			athletes.sort((a, b) => a.name.localeCompare(b.name));
			setSortDir({...sortDir, name: DESC})
			return;
		}
		if (e.currentTarget.id === "name-down") {
			athletes.sort((a, b) => b.name.localeCompare(a.name));
			setSortDir({...sortDir, name: ASC})
			return;
		}
		if (e.currentTarget.id === "position-up") {
			athletes.sort((a, b) => a.position.localeCompare(b.position));
			setSortDir({...sortDir, position: DESC})
			return;
		}
		if (e.currentTarget.id === "position-down") {
			athletes.sort((a, b) => b.position.localeCompare(a.position));
			setSortDir({...sortDir, position: ASC})
			return;
		}
		if (e.currentTarget.id === "team-up") {
			athletes.sort((a, b) => a.team.localeCompare(b.team));
			setSortDir({...sortDir, team: DESC})
			return;
		}
		if (e.currentTarget.id === "team-down") {
			athletes.sort((a, b) => b.team.localeCompare(a.team));
			setSortDir({...sortDir, team: ASC})
			return;
		}
	};

	const handleDelete = (e) => {
		// TODO
		// should make a modal to confirm!
		// do changes in database too
		// if not legal alert!!

		axios.delete(`http://localhost:65535/athlete/${e.currentTarget.id}`)
			.then((res) => {
				console.log(res);
			})
			.catch((err) => {
				console.error(err);
			});

		setAthletes(athletes.filter(athlete => athlete.person_id != e.currentTarget.id));
	}

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
			<AddAthleteModal athletes={athletes} setAthletes={setAthletes} showAddAthlete={showAddAthlete} setShowAddAthlete={setShowAddAthlete} />
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
					{athletes.map((obj) => {
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
												<Button id={obj.person_id} variant="danger" onClick={handleDelete}>Delete</Button>
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
