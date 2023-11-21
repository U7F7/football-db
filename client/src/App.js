import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import NavigationBar from "./components/NavigationBar";
import HomePage from "./components/homepage/HomePage";
import Players from "./components/player/Players";
import Teams from "./components/teams/Teams";
import Games from "./components/games/Games";

const App = () => {

	return (
		<Router>
			<NavigationBar />
			<Routes>
				<Route exact path="/" element={<HomePage />} />
				<Route exact path="/players" element={<Players />} />
				<Route exact path="/teams" element={<Teams />} />
				<Route exact path="/games" element={<Games />} />
			</Routes>
		</Router>
	);
};

export default App;
