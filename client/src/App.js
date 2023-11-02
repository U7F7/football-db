import "./App.css";
import axios from "axios";
import { React, useState, useEffect } from "react";

const App = () => {
	const [data, setData] = useState({});

	useEffect(() => {
		axios.get("http://localhost:65535/table/Awards")
			.then((res) => {
				setData(res.data);
			})
			.catch(err => console.error(err));
	}, [data]);

	// const data = JSON.stringify({a: "1"});

	return (
		<div className="App">
			<h1>Hello World</h1>
			<p>{Object.keys(data).length !== 0 ? JSON.stringify(data) : "Loading..."}</p>
		</div>
	);
};

export default App;
