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

	const teamScoreStyle = { 
		display: "flex", 
		justifyContent: "right", 
		padding: 0
	};

	return (
		<Card>
			<Card.Body>
				<Card.Title>{date}</Card.Title>
				<Container>
					<Row>
						<Col xs="auto" style={teamNameStyle}>
							<p style={{ marginBottom: 0 }}>{home}</p>
						</Col>
						<Col style={teamScoreStyle}>
							<p style={{ marginBottom: 0 }}>{homeScore}</p>
						</Col>
					</Row>
					<Row>
						<Col xs="auto" style={teamNameStyle}>
							<p style={{ marginBottom: 0 }}>{away}</p>
						</Col>
						<Col style={teamScoreStyle}>
							<p style={{ marginBottom: 0 }}>{awayScore}</p>
						</Col>
					</Row>
				</Container>
			</Card.Body>
		</Card>
	); 
};

export default RecentGame;
