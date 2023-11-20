import React from "react";

import { useParams } from "react-router-dom";

const Player = () => {
	const { id } = useParams();

	return <div>{id}</div>;
};

export default Player;
