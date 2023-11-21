import { useState } from "react";

import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";
import Form from "react-bootstrap/Form";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";

const AddAthleteModal = ({ athletes, showAddAthlete, setShowAddAthlete }) => {

	const getNextId = () => {
		let max = 0;
		athletes.forEach((a) => {
			if (a.person_id > max) {
				max = a.person_id;
			}
		});
		return max + 1;
	};

	// will be api eventually
	const [teams, setTeams] = useState({
		"teams": [
			"Vancouver Vipers",
			"Richmond Thunder",
			"Burnaby Warriors",
			"Surrey Titans",
			"Coquitlam Sharks",
			"Langley Bears"
		]
	});

	const [athlete, setAthlete] = useState({
		person_id: getNextId(),
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
								<Form.Control type="text" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="height">
								<Form.Label>Height</Form.Label>
								<Form.Control type="number" min="0" placeholder="Enter height (cm)" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="weight">
								<Form.Label>Weight</Form.Label>
								<Form.Control type="number" min="0" placeholder="Enter weight (kg)" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="birthdate">
								<Form.Label>Birth Date</Form.Label>
								<Form.Control type="date" required/>
							</Form.Group>
						</Col>
					</Row>
					<Row>
						<Col>
							<Form.Group controlId="jersey">
								<Form.Label>Jersey Number/Position</Form.Label>
								<Form.Select aria-label="Default select example">
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
							<Form.Group controlId="start-date">
								<Form.Label>Start Date</Form.Label>
								<Form.Control type="date" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="salary">
								<Form.Label>Salary</Form.Label>
								<Form.Control type="number" min="0" placeholder="" required/>
							</Form.Group>
						</Col>
					</Row>
					<Row>
						<Col>
							<Form.Group controlId="address">
								<Form.Label>Address</Form.Label>
								<Form.Control type="text" placeholder="1234 Main St, Vancouver" required/>
							</Form.Group>
						</Col>
					</Row>
					<Row>
						<Col>
							<Form.Group controlId="email">
								<Form.Label>Email address</Form.Label>
								<Form.Control type="email" placeholder="name@example.com" required/>
							</Form.Group>
						</Col>
						<Col>
							<Form.Group controlId="phone">
								<Form.Label>Phone #</Form.Label>
								<Form.Control type="text" required/>
							</Form.Group>
						</Col>
					</Row>

				</Form>
			</Modal.Body>
			<Modal.Footer>
				<Button variant="primary" onClick={() => setShowAddAthlete(false)}>
					Add
				</Button>
			</Modal.Footer>
		</Modal>
	);
}

export default AddAthleteModal;
