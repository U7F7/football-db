import { useEffect, useState } from "react";

import axios from "axios";

import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";
import Form from "react-bootstrap/Form";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";

const AddAthleteModal = ({ athletes, setAthletes, showAddAthlete, setShowAddAthlete }) => {
	const [positions, setPositions] = useState({});

	useEffect(() => {
		axios.get("http://localhost:65535/positions")
			.then((res) => {
				let ret = {};
				for (let d of res.data) {
					ret[d.jersey_num] = d.position
				}
				setPositions(ret);
			})
			.catch((err) => {
				console.error(err);
			});
	}, []);

	const [teams, setTeams] = useState([]);

	useEffect(() => {
		axios.get("http://localhost:65535/teams")
			.then((res) => {
				setTeams(res.data.map((obj) => obj.team_name));
			})
			.catch((err) => {
				console.error(err);
			});
	}, []);

	const [athlete, setAthlete] = useState({
		person_id:  0,
		name: "",
		birthdate: "",
		height: 0,
		weight: 0,
		phone_number: "",
		email: "",
		address: "",
		date_started: "",
		jersey_num: 0,
		current_team: "",
		salary: 0
	});

	const handleFormChange = (e) => {
		e.persist();
		setAthlete(oldState => {
			return {
				...oldState,
				[e.target.name]: e.target.value
			};
		});
	};

	const addAthlete = () => {
		// try to add to database
		// add the athlete locally only to not reload whole table
		// check for sql injection (in the api not here!)
		const nextID = Math.max(...athletes.map((a) => a.person_id)) + 1;
		setAthlete({...athlete, person_id: nextID});

		setAthletes([{ 
			"person_id": athlete.person_id,
			"name": athlete.name, 
			"position": positions[athlete.jersey_num], 
			"team": athlete.current_team 
		}, ...athletes]);
		setShowAddAthlete(false);
	}

	return (
		<Modal centered size="lg" show={showAddAthlete} onHide={() => setShowAddAthlete(false)}>
			<Modal.Header closeButton>
				<Modal.Title>Add Athlete</Modal.Title>
			</Modal.Header>
			<Modal.Body>
				<Form>
					<Row>
						<Col>
							<Form.Group controlId="name">
								<Form.Label>Full Name</Form.Label>
								<Form.Control type="text" name="name" onChange={handleFormChange} required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="height">
								<Form.Label>Height</Form.Label>
								<Form.Control type="number" min="0" name="height" onChange={handleFormChange} placeholder="Enter height (cm)" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="weight">
								<Form.Label>Weight</Form.Label>
								<Form.Control type="number" min="0" name="weight" onChange={handleFormChange} placeholder="Enter weight (kg)" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="birthdate">
								<Form.Label>Birth Date</Form.Label>
								<Form.Control type="date" name="birthdate" onChange={handleFormChange} required/>
							</Form.Group>
						</Col>
					</Row>
					<Row>
						<Col>
							<Form.Group controlId="jersey">
								<Form.Label>Jersey Number/Position</Form.Label>
								<Form.Select aria-label="Default select example" name="jersey_num" onChange={handleFormChange}>
									<option value="default">-</option>
									<option value="1">1 (Goalkeeper)</option>
									<option value="2">2 (Right Back)</option>
									<option value="3">3 (Left Back)</option>
									<option value="4">4 (Sweeper)</option>
									<option value="5">5 (Central Back)</option>
									<option value="6">6 (Defensive Midfielder)</option>
									<option value="7">7 (Winger)</option>
									<option value="8">8 (Central Midfielder)</option>
									<option value="9">9 (Striker)</option>
									<option value="10">10 (Central Attacking Midfielder)</option>
									<option value="11">11 (Outside Midfielder)</option>
								</Form.Select>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="team">
								<Form.Label>Team</Form.Label>
								<Form.Select aria-label="Default select example" name="current_team" onChange={handleFormChange}>
									<option value="default">-</option>
									{teams.map((t, i) => {
										return (
											<option key={i} value={t}>{t}</option>
										);
									})}
								</Form.Select>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="start-date">
								<Form.Label>Start Date</Form.Label>
								<Form.Control type="date" name="date_started" onChange={handleFormChange} required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="salary">
								<Form.Label>Salary</Form.Label>
								<Form.Control type="number" name="salary" onChange={handleFormChange} min="0" placeholder="" required/>
							</Form.Group>
						</Col>
					</Row>
					<Row>
						<Col>
							<Form.Group controlId="address">
								<Form.Label>Address</Form.Label>
								<Form.Control type="text" name="address" onChange={handleFormChange} placeholder="1234 Main St, Vancouver" required/>
							</Form.Group>
						</Col>
					</Row>
					<Row>
						<Col>
							<Form.Group controlId="email">
								<Form.Label>Email address</Form.Label>
								<Form.Control type="email" name="email" onChange={handleFormChange} placeholder="name@example.com" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="phone">
								<Form.Label>Phone #</Form.Label>
								<Form.Control type="text" name="phone_number" onChange={handleFormChange} required/>
							</Form.Group>
						</Col>
					</Row>

				</Form>
			</Modal.Body>
			<Modal.Footer>
				<Button variant="primary" onClick={addAthlete}>
					Add
				</Button>
			</Modal.Footer>
		</Modal>
	);
}

export default AddAthleteModal;
