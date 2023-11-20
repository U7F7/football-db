import React from "react";

import Card from "react-bootstrap/Card";
import Table from "react-bootstrap/Table";

const Standings = () => {
	const dummyData = [
		{
			team: "Vancouver Vipers",
			gamesPlayed: 15,
			wins: 7,
			draws: 0,
			losses: 8
		},
		{
			team: "Vancouver Thunder",
			gamesPlayed: 15,
			wins: 15,
			draws: 0,
			losses: 0
		},
		{
			team: "Vancouver Warriors",
			gamesPlayed: 15,
			wins: 2,
			draws: 2,
			losses: 11
		},
		{
			team: "Vancouver Titans",
			gamesPlayed: 15,
			wins: 8,
			draws: 2,
			losses: 5
		},
		{
			team: "Vancouver Sharks",
			gamesPlayed: 15,
			wins: 4,
			draws: 1,
			losses: 10
		},	
	]

	return (
		<Card>
			<Card.Header as="h5">Standings</Card.Header>
			<Card.Body>
				<Table striped bordered>
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
						{dummyData.map(row => {
							return (
								<tr>
									<td>{row.team}</td>
									<td>{row.gamesPlayed}</td>
									<td>{row.wins}</td>
									<td>{row.draws}</td>
									<td>{row.losses}</td>
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
