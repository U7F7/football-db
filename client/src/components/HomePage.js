import React from "react";

import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Card from "react-bootstrap/Card";

import Standings from "./Standings";
import RecentGames from "./RecentGames";

const HomePage = () => {
	const dummyNews = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc a ipsum quam. Quisque accumsan sem et tincidunt semper. Suspendisse facilisis fringilla est, in viverra libero pharetra ac. Nullam lectus ex, malesuada vel fringilla ac, venenatis quis nibh. Phasellus placerat risus risus. Nam tincidunt elit ut interdum auctor. In hac habitasse platea dictumst. Sed purus mi, lobortis id justo et, finibus blandit tellus. Etiam enim massa, tristique a velit at, cursus facilisis sem.

	Morbi eu molestie risus, vel eleifend libero. Vestibulum sed laoreet tortor. Vivamus mattis libero sed tempor mollis. Sed porttitor, justo et rhoncus interdum, purus turpis consequat nibh, quis tempor purus purus quis ligula. Sed luctus nunc quis justo malesuada auctor id et sapien. Duis fermentum at nibh quis laoreet. Quisque nec ornare nunc. Fusce consequat dolor sed facilisis pulvinar. Mauris quis massa quis mi egestas gravida. Donec quis tincidunt nunc. Proin arcu enim, iaculis at venenatis vitae, viverra ut quam. Nunc luctus, turpis vitae euismod pretium, lacus urna accumsan sem, in tincidunt urna leo sit amet justo.`;

	return (
		<Container style={{ marginTop: "20px" }}>
			<Row>
				<Col>
					<Card>
						<Card.Header as="h5">Current News</Card.Header>
						<Card.Body>
							<Card.Title>The Thunder Win Again!</Card.Title>
							<Card.Text>{dummyNews}</Card.Text>
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
