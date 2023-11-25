import { React, useEffect, useState } from "react";

import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Card from "react-bootstrap/Card";
import Spinner from "react-bootstrap/Spinner";

import Standings from "./Standings";
import RecentGames from "./RecentGames";

import axios from "axios";

const HomePage = () => {
	const [maxGoals, setMaxGoals] = useState([]);

	useEffect(() => {
		axios.get("http://localhost:65535/max-avg-goals-per-game")
			.then((res) => {
				setMaxGoals(res.data);
			})
			.catch((err) => {
				console.error(err);
			});
	}, []);

	return (
		<Container style={{ marginTop: "20px" }}>
			<Row>
				<Col>
					<Card>
						<Card.Header as="h5">Current News</Card.Header>
						{maxGoals.length !== 0 ?
						<Card.Body>
							<Card.Title>Championship Contenders</Card.Title>
							<Card.Text>
								Here are the contenders for this season! These team(s) feature their average goals scored per game as the maximum over all teams' average goals per game across the whole league.
							</Card.Text>
							<ul>
								{maxGoals.map((n) => {
									return (
										<li>{n.team}: {n.avggoalspergame} average goals per game</li>
									);
								})}
							</ul>
						</Card.Body> :
						<div style={{ padding: "50px" }}>
							<Spinner animation="border"/>
						</div>}
					</Card>
				</Col>
			</Row>
			<Row style={{ marginTop: "20px" }}>
				<Col>
					<Standings />
				</Col>
				<Col>
					<RecentGames />
				</Col>
			</Row>
		</Container>
	);
};

export default HomePage;
