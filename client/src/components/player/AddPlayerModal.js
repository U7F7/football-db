import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";

const AddPlayerModal = ({ showAddPlayer, setShowAddPlayer }) => {

	return (
		<Modal centered show={showAddPlayer} onHide={() => setShowAddPlayer(false)}>
			<Modal.Header closeButton>
				<Modal.Title>Add Player</Modal.Title>
			</Modal.Header>
			<Modal.Body>
				Add Player text
			</Modal.Body>
			<Modal.Footer>
				<Button variant="primary" onClick={() => setShowAddPlayer(false)}>
					Save Changes
				</Button>
			</Modal.Footer>
		</Modal>
	);
}

export default AddPlayerModal;
