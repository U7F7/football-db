import React from "react";

import Card from "react-bootstrap/Card";
import Table from "react-bootstrap/Table";

const Standings = () => {
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
						<tr>
							<td>Vancouver Vipers</td>
							<td>15</td>
							<td>7</td>
							<td>0</td>
							<td>8</td>
						</tr>
						<tr>
							<td>Vancouver Thunder</td>
							<td>15</td>
							<td>15</td>
							<td>0</td>
							<td>0</td>
						</tr>
						<tr>
							<td>Vancouver Warriors</td>
							<td>15</td>
							<td>2</td>
							<td>2</td>
							<td>11</td>
						</tr>
						<tr>
							<td>Vancouver Titans</td>
							<td>15</td>
							<td>8</td>
							<td>2</td>
							<td>5</td>
						</tr>
						<tr>
							<td>Vancouver Sharks</td>
							<td>15</td>
							<td>4</td>
							<td>1</td>
							<td>10</td>
						</tr>
					</tbody>
				</Table>
			</Card.Body>
		</Card>
	);
};

export default Standings;
