import React from "react";

import Container from "react-bootstrap/Container";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";

const NavigationBar = () => {
	return (
		<>
		<Navbar expand="lg" bg="dark" variant="dark">
			<Container>
				<Navbar.Brand href="/">Soccer Management System</Navbar.Brand>
				<Navbar.Toggle aria-controls="basic-navbar-nav" />
				<Navbar.Collapse id="basic-navbar-nav">
					<Nav className="me-auto">
						<Nav.Link href="/players">Players</Nav.Link>
						<Nav.Link href="/teams">Teams</Nav.Link>
						<Nav.Link href="/games">Games</Nav.Link>
					</Nav>
				</Navbar.Collapse>
			</Container>
		</Navbar>
		</>
	);
};

export default NavigationBar;
