import { React, useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import axios from "axios";

import NavigationBar from "./components/NavigationBar";
import HomePage from "./components/HomePage";
import Players from "./components/Players";
import Player from "./components/Player";
import Teams from "./components/Teams";
import Team from "./components/Team";
import Games from "./components/Games";
import Game from "./components/Game";

const App = () => {

	return (
		<Router>
			<NavigationBar />
			<Routes>
				<Route exact path="/" element={<HomePage />} />
				<Route exact path="/players" element={<Players />} />
				<Route exact path="/players/:id" element={<Player />} />
				<Route exact path="/teams" element={<Teams />} />
				<Route exact path="/teams/:id" element={<Team />} />
				<Route exact path="/games" element={<Games />} />
				<Route exact path="/games/:id" element={<Game />} />
			</Routes>
		</Router>
	);
};

export default App;
