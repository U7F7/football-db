import React from "react";

import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Standings from "./Standings";
import RecentGames from "./RecentGames";

const HomePage = () => {
	return (
		<Container style={{ marginTop: "20px" }}>
			<p>
				Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce a mi lectus. Nam facilisis posuere elit, at faucibus augue elementum ac. Proin at mi non ligula tempor interdum a nec neque. Duis a viverra velit, eu lacinia sapien. Fusce tempor egestas faucibus. Integer et justo at erat fringilla tempus a sed dolor. Donec auctor arcu at lectus maximus, quis efficitur leo aliquet. Cras tincidunt ultrices rutrum. Suspendisse in justo ipsum. Nullam pulvinar, nulla eget viverra mollis, nisi ligula laoreet sapien, ac hendrerit ipsum sem ac justo. Quisque pretium vel augue eu iaculis. Suspendisse viverra ex eget nisi consequat, vitae molestie nunc scelerisque. Aliquam erat volutpat. Mauris fringilla, turpis in rutrum sodales, mi felis scelerisque mi, et tincidunt risus odio eu ligula. Nulla hendrerit, tellus ut sagittis pharetra, mi erat fermentum lectus, eget tempor est nisi ut justo. Vivamus malesuada tincidunt ligula, et hendrerit libero blandit sed.
			</p>
			<Row>
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
