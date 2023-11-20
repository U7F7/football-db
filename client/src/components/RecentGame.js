import React from "react";

import Card from "react-bootstrap/Card";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";

const RecentGame = ({ date, home, homeScore, away, awayScore }) => {
	const teamNameStyle = { 
		display: "flex", 
		justifyContent: "left", 
		padding: 0
	};

	return (
		<Card>
			<Card.Body>
				<Card.Title>{date}</Card.Title>
				<Container>
					<Row>
						<Col xs={10} style={teamNameStyle}>
							<p style={{ marginBottom: 0 }}>{home}</p>
						</Col>
						<Col xs={2}>
							{homeScore}
						</Col>
					</Row>
					<Row>
						<Col xs={10} style={teamNameStyle}>
							<p style={{ marginBottom: 0 }}>{away}</p>
						</Col>
						<Col xs={2}>
							{awayScore}
						</Col>
					</Row>
				</Container>
			</Card.Body>
		</Card>
	); 
};

export default RecentGame;
