import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import NavigationBar from "./components/NavigationBar";
import HomePage from "./components/homepage/HomePage";
import Athletes from "./components/athlete/Athletes";
import Teams from "./components/teams/Teams";
import Games from "./components/games/Games";
import Advanced from "./components/advanced/Advanced";

const App = () => {

	return (
		<Router>
			<NavigationBar />
			<Routes>
				<Route exact path="/" element={<HomePage />} />
				<Route exact path="/athletes" element={<Athletes />} />
				<Route exact path="/teams" element={<Teams />} />
				<Route exact path="/games" element={<Games />} />
				<Route exact path="/advanced" element={<Advanced />} />
			</Routes>
		</Router>
	);
};

export default App;
