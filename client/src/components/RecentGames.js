import React from "react";

import RecentGame from "./RecentGame";

import Card from "react-bootstrap/Card";
import Container from "react-bootstrap/Container"
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";


const RecentGames = () => {
	return (
		<Card>
			<Card.Header as="h5">Recent Games</Card.Header>
			<Card.Body>
				<Container>
					<Row>
						<Col>
							<RecentGame date="2023-10-20" home="Vancouver Thunder" homeScore="3" away="Vancouver Sharks" awayScore="1"/>
						</Col>
						<Col>
							<RecentGame date="2023-10-20" home="Vancouver Thunder" homeScore="3" away="Vancouver Sharks" awayScore="1"/>
						</Col>
					</Row>
					<Row style={{ marginTop: "20px" }}>
						<Col>
							<RecentGame date="2023-10-20" home="Vancouver Thunder" homeScore="3" away="Vancouver Sharks" awayScore="1"/>
						</Col>
						<Col>
							<RecentGame date="2023-10-20" home="Vancouver Thunder" homeScore="3" away="Vancouver Sharks" awayScore="1"/>
						</Col>
					</Row>
				</Container>
			</Card.Body>
		</Card>
	);
};

export default RecentGames;
