import { React, useEffect, useState } from "react";

import Card from "react-bootstrap/Card";
import Table from "react-bootstrap/Table";

import axios from "axios";

const Standings = () => {

	const [news, setNews] = useState([]);

	useEffect(() => {
		axios.get("http://localhost:65535/standings")
			.then((res) => {
				setNews(res.data);
			})
			.catch((err) => {
				console.error(err);
			});
	}, []);

	return (
		<Card>
			<Card.Header as="h5">Standings</Card.Header>
			<Card.Body style={{ paddingTop: 0 }}>
				<Table striped bordered style={{ marginTop: "20px" }}>
					<thead>
						<tr>
							<th>Team</th>
							<th>Games Played</th>
							<th>Wins</th>
							<th>Draws</th>
							<th>Losses</th>
						</tr>
					</thead>
					<tbody>
						{news.map(row => {
							return (
								<tr>
									<td>{row.teamname}</td>
									<td>{row.gamesplayed}</td>
									<td>{row.wincount}</td>
									<td>{row.losscount}</td>
									<td>{row.drawcount}</td>
								</tr>	
							);
						})}
					</tbody>
				</Table>
			</Card.Body>
		</Card>
	);
};

export default Standings;
