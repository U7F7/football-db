import { React, useEffect, useState } from "react";

import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Card from "react-bootstrap/Card";

import Standings from "./Standings";
import RecentGames from "./RecentGames";

import axios from "axios";

const HomePage = () => {
	const [news, setNews] = useState([]);

	useEffect(() => {
		axios.get("http://localhost:65535/max-avg-goals-per-game")
			.then((res) => {
				setNews(res.data);
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
						<Card.Body>
							<Card.Title>The Thunder Win Again!</Card.Title>
							<Card.Text>Here are the top contenders for the championship so far:</Card.Text>
							<ul>
								{news.map((n) => {
									return (
										<li>{n.team}: {n.avggoalspergame} average goals per game</li>
									);
								})}
							</ul>
						</Card.Body>
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
