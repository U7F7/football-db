import React from "react";

import Modal from "react-bootstrap/Modal";
import Button from "react-bootstrap/Button";

const DeleteAthleteModal = ({ person_id, athletes, handleDelete, showDeleteAthlete, setShowDeleteAthlete }) => {
	let athlete;
	for (let a of athletes) {
		if (a.person_id == person_id) {
			athlete = a;
			break;
		}
	}

	return (
		<Modal centered show={showDeleteAthlete} onHide={() => setShowDeleteAthlete(false)}>
			<Modal.Header closeButton>
				<Modal.Title>Delete Athlete</Modal.Title>
			</Modal.Header>
			<Modal.Body>Are you sure you want to delete {athlete?.name}?</Modal.Body>
			<Modal.Footer>
				<Button id={person_id} variant="danger" onClick={handleDelete}>
					Delete
				</Button>
			</Modal.Footer>
		</Modal>
	);
};

export default DeleteAthleteModal;
