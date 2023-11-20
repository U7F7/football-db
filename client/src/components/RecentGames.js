import React from "react";

import RecentGame from "./RecentGame";

import Card from "react-bootstrap/Card";
import Container from "react-bootstrap/Container"
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";


const RecentGames = () => {
	const dummyData = [
		{
			date: "2023-10-20",
			home: "Vancouver Thunder",
			homeScore: 3,
			away: "Vancouver Sharks",
			awayScore: 1
		},
		{
			date: "2023-10-20",
			home: "Vancouver Thunder",
			homeScore: 3,
			away: "Vancouver Sharks",
			awayScore: 1
		},
		{
			date: "2023-10-20",
			home: "Vancouver Thunder",
			homeScore: 3,
			away: "Vancouver Sharks",
			awayScore: 1
		},
		{
			date: "2023-10-20",
			home: "Vancouver Thunder",
			homeScore: 3,
			away: "Vancouver Sharks",
			awayScore: 1
		},
	]

	return (
		<Card>
			<Card.Header as="h5">Recent Games</Card.Header>
			<Card.Body style={{ paddingTop: 0 }}>
				<Container>
					{dummyData.map((obj, i) => {
						return (
							<Row style={{ marginTop: "20px" }}>
								<Col>
									{2 * i < dummyData.length ? <RecentGame {...dummyData[2 * i]}/> : ""}
								</Col>
								<Col>
									{2 * i + 1 < dummyData.length ? <RecentGame {...dummyData[2 * i + 1]}/> : ""}
								</Col>
							</Row>
						);
					})}
				</Container>
			</Card.Body>
		</Card>
	);
};

export default RecentGames;
