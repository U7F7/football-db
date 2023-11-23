-- drop relational tables first
drop table PARTICIPATESIN;
drop table LOCATEDIN;
drop table HASSPONSOR;
drop table GIVENBY;
drop table WINSAWARD;
drop table PLAYSFOR;
drop table COACHES;
drop table REFEREES;

-- drop entities (order may matter for PK/FKs)
drop table COACH;
drop table REFEREE;
drop table AWARDS;
drop table SPONSOR;
drop table INJURY;
drop table STATISTICS;
drop table ATHLETE;
drop table TEAM;
drop table VENUE;
drop table GAME;

-- drop DETAILS last
drop table POSITIONDETAILS;

/* Entities */

CREATE TABLE Venue(
	venue_address varchar(100),
	venue_name varchar(100) UNIQUE,
	capacity int,
	PRIMARY KEY(venue_address)
);

CREATE TABLE Team(
	team_name varchar(100),
	team_owner varchar(100),
	home_venue_address varchar(100) NOT NULL,
	PRIMARY KEY(team_name),
	FOREIGN KEY(home_venue_address) REFERENCES Venue(venue_address)
--         ON DELETE NO ACTION // not required
		/* ON UPDATE NO ACTION not supported will impl another way */
);

CREATE TABLE PositionDetails(
	jersey_num int,
	position varchar(100),
	PRIMARY KEY(jersey_num)
);

CREATE TABLE Athlete(
	person_id int,
	name varchar(100),
	birthdate date,
	height float,
	weight float,
	phone_number int UNIQUE,
	email varchar(100) UNIQUE,
	address varchar(100),
	date_started date,
    jersey_num int,
    current_team varchar(100) NOT NULL,
	salary int,
	PRIMARY KEY(person_id),
	FOREIGN KEY(current_team) REFERENCES Team(team_name),
--         ON DELETE NO ACTION, /* must point team to another team first*/ no required
		/* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY(jersey_num) REFERENCES PositionDetails(jersey_num)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE, not supported will impl another way */
);

CREATE TABLE Coach(
	person_id int,
	name varchar(100),
	birthdate date,
	height float,
	weight float,
	phone_number int UNIQUE,
	email varchar(100) UNIQUE,
	address varchar(100),
	date_started date,
    current_team varchar(100) NOT NULL,
    specialization varchar(100),
    PRIMARY KEY(person_id),
	FOREIGN KEY(current_team) REFERENCES Team(team_name)
--         ON DELETE NO ACTION /* must point team to another team first*/ // not required
		/* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Referee(
	person_id int,
	name varchar(100),
	birthdate date,
	height float,
	weight float,
	phone_number int UNIQUE,
	email varchar(100) UNIQUE,
	address varchar(100),
	date_started date,
	certification_level int,
    PRIMARY KEY(person_id)
);

CREATE TABLE Game(
	game_id int,
	home varchar(100),
	away varchar(100),
	game_date date,
	PRIMARY KEY(game_id)
);

CREATE TABLE Statistics(
	stats_id int,
	person_id int NOT NULL,
	game_id int NOT NULL,
	goals int,
	shots_taken int,
	passes_attempted int,
	turnovers int,
	possession_percent float,
	PRIMARY KEY(stats_id),
    FOREIGN KEY (person_id) REFERENCES Athlete(person_id)
		ON DELETE CASCADE,
		/* ON UPDATE CASCADE not supported will impl another way */
	FOREIGN KEY (game_id) REFERENCES Game(game_id)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Awards(
	award_id int,
	year int,
	award_name varchar(50),
	PRIMARY KEY(award_id)
);

CREATE TABLE Sponsor(
	sponsor_name varchar(100),
	sponsor_email varchar(100) UNIQUE,
	money_granted int,
	PRIMARY KEY(sponsor_name)
);

CREATE TABLE Injury(
	injury_type varchar(100),
	injury_date date,
	injury_status int, /*0 is false, other is true*/
	person_id int,
	PRIMARY KEY(person_id, injury_type, injury_date),
	FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE not supported will impl another way */
);

/* Relationship Tables */

CREATE TABLE PlaysFor(
	person_id int,
	team_name varchar(100),
	PRIMARY KEY(person_id, team_name),
	FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
	    ON DELETE CASCADE,
	    /* ON UPDATE CASCADE not supported will impl another way */
	FOREIGN KEY(team_name) REFERENCES Team(team_name)
        ON DELETE CASCADE
	    /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Coaches(
	person_id int,
	team_name varchar(100),
	PRIMARY KEY(person_id, team_name),
    FOREIGN KEY(person_id) REFERENCES Coach(person_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(team_name) REFERENCES Team(team_name)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE ParticipatesIn(
	game_id int,
	team_1 varchar(100),
	team_2 varchar(100),
	PRIMARY KEY(game_id),
    FOREIGN KEY(team_1) REFERENCES Team(team_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(team_2) REFERENCES Team(team_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE LocatedIn(
	game_id int,
	venue_address varchar(100),
	PRIMARY KEY(game_id, venue_address),
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(venue_address) REFERENCES Venue(venue_address)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE HasSponsor(
	team_name varchar(100),
	sponsor_name varchar(100),
	PRIMARY KEY(team_name, sponsor_name),
    FOREIGN KEY(team_name) REFERENCES Team(team_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(sponsor_name) REFERENCES Sponsor(sponsor_name)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE GivenBy(
	sponsor_name varchar(100),
	award_id int,
	PRIMARY KEY(sponsor_name, award_id),
    FOREIGN KEY(sponsor_name) REFERENCES Sponsor(sponsor_name)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(award_id) REFERENCES Awards(award_id)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE WinsAward(
	award_id int,
	person_id int,
	team_name varchar(100),
	PRIMARY KEY(award_id),
    -- 	UNIQUE(person_id, team_name),
    FOREIGN KEY(award_id) REFERENCES Awards(award_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(team_name) REFERENCES Team(team_name)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Referees(
    person_id int,
    game_id int,
    PRIMARY KEY(person_id, game_id),
    FOREIGN KEY(person_id) REFERENCES Referee(person_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);
/* INSERTS */

INSERT ALL
	INTO PositionDetails VALUES (1, 'Goalkeeper')
	INTO PositionDetails VALUES (2, 'Right Back')
	INTO PositionDetails VALUES (3, 'Left Back')
	INTO PositionDetails VALUES (4, 'Sweeper')
	INTO PositionDetails VALUES (5, 'Central Back')
	INTO PositionDetails VALUES (6, 'Defensive Midfielder')
	INTO PositionDetails VALUES (7, 'Winger')
	INTO PositionDetails VALUES (8, 'Central Midfielder')
	INTO PositionDetails VALUES (9, 'Striker')
	INTO PositionDetails VALUES (10, 'Central Attacking Midfielder')
    INTO PositionDetails VALUES (11, 'Outside Midfielder')
SELECT * FROM dual;

INSERT ALL
	INTO Venue VALUES ('5123 Main Street, Vancouver', 'Benz Stadium', 10000)
	INTO Venue VALUES ('5456 Oak Avenue, Richmond', 'Mountain View Stadium', 20000)
	INTO Venue VALUES ('5789 Elm Road, Burnaby', 'Evergreen Arena', 15000)
	INTO Venue VALUES ('5101 Maple Lane, Surrey', 'Harbor View Stadium', 5000)
	INTO Venue VALUES ('5234 Pine Street, Coquitlam', 'Sea View Arena', 34500)
    INTO Venue VALUES ('1923 River Road, Langley', 'Waterways Stadium', 17000)
    INTO Venue VALUES ('7212 Orange Crescent, Vancouver', 'Natural Neon Arena', 7500)
    INTO Venue VALUES ('1182 History Street, Vancouver', 'Old Books Building', 800)
SELECT * FROM dual;

INSERT ALL
	INTO Team VALUES ('Vancouver Vipers', 'John Wong', '5123 Main Street, Vancouver')
	INTO Team VALUES ('Richmond Thunder', 'Emily Johnson', '5456 Oak Avenue, Richmond')
	INTO Team VALUES ('Burnaby Warriors', 'Michael Brown', '5789 Elm Road, Burnaby')
	INTO Team VALUES ('Surrey Titans', 'Sarah Lee', '5101 Maple Lane, Surrey')
	INTO Team VALUES ('Coquitlam Sharks', 'Robert Davis', '5234 Pine Street, Coquitlam')
    INTO Team VALUES ('Langley Bears', 'Chris Huk', '1923 River Road, Langley')
SELECT * FROM dual;

INSERT ALL
-- Vancouver Vipers
    INTO Athlete VALUES (1, 'John Doe', '1989-12-05', 178, 77, 6041234567, 'john.doe@soccer.com', '123 Main St, Vancouver', '2006-11-30', 1, 'Vancouver Vipers', 60000)
    INTO Athlete VALUES (2, 'Jane Smith', '1993-04-30', 170, 68, 778980912, 'jane.smith@soccer.com', '123 Oak St, Vancouver', '2014-09-07', 2, 'Vancouver Vipers', 70000)
    INTO Athlete VALUES (3, 'Mike Johnson', '1980-06-14', 188, 91, 6041820192, 'mike.johnson@soccer.com', '461 Fir St, Vancouver', '2000-04-18', 3, 'Vancouver Vipers', 120000)
    INTO Athlete VALUES (4, 'Michelle Zhu', '1987-02-09', 178, 82, 7781920391, 'michell.zhu@soccer.com', '192 Oats Rd, Vancouver', '2010-10-10', 4, 'Vancouver Vipers', 100000)
    INTO Athlete VALUES (5, 'Michael Dune', '1993-09-12', 203, 132, 6045129102, 'michael.dune@soccer.com', '101 Chem Drive, Vancouver', '2011-03-18', 5, 'Vancouver Vipers', 500000)
    INTO Athlete VALUES (6, 'Serena Storm', '1985-11-20', 170, 56, 7889129301, 'serena.storm@soccer.com', '783 Balsam St, Vancouver', '2005-02-05', 6, 'Vancouver Vipers', 190000)
    INTO Athlete VALUES (7, 'Daniel Kee', '1991-07-06', 178, 76, 6045919203, 'daniel.kee@soccer.com', '912 Mark Lane, Vancouver', '2018-08-14', 7, 'Vancouver Vipers', 1200000)
    INTO Athlete VALUES (8, 'Emily Carr', '1988-03-19', 170, 86, 778902183, 'emily.carr@soccer.com', '281 Fox St, Vancouver', '2002-12-22', 8, 'Vancouver Vipers', 80000)
    INTO Athlete VALUES (9, 'Jason Bills', '1996-05-02', 130, 39, 7781029301, 'jason.bills@soccer.com', '292 Blue Drive, Vancouver', '2015-12-30', 9, 'Vancouver Vipers', 180000)
    INTO Athlete VALUES (10, 'Rachel Jordan', '1982-07-16', 175, 67, 6045881923, 'rachel.jordan@soccer.com', '778 Phone St, Vancouver', '2004-06-03', 10, 'Vancouver Vipers', 175000)
    INTO Athlete VALUES (11, 'Rick Tord', '1998-11-25', 183, 78, 7786758192, 'rick.tord@soccer.com', '182 Dubious Lane, Vancouver', '2009-07-12', 11, 'Vancouver Vipers', 250000)
    -- Richmond Thunder
    INTO Athlete VALUES (12, 'Billy Bob', '1981-01-03', 198, 127, 6045557892, 'billy.bob@socer.com', '872 Fire Lane, Vancouver', '2007-09-27', 1, 'Richmond Thunder', 280000)
    INTO Athlete VALUES (13, 'Danielle Chu', '1994-06-28', 163, 56, 7789901203, 'danielle.chu@soccer.com', '897 Key St, Vancouver', '2013-04-19', 2, 'Richmond Thunder', 3400000)
    INTO Athlete VALUES (14, 'Darren Sam', '1989-08-11', 185, 84, 6045589102, 'darren.sam@soccer.com', '291 Bin Rd, Vancouver', '2001-08-09', 3, 'Richmond Thunder', 120000)
    INTO Athlete VALUES (15, 'Cynthia Game', '1995-12-14', 168, 59, 6049012930, 'cynthia.game@soccer.com', '448 Elm Rd, Vancouver', '2016-01-07', 4, 'Richmond Thunder', 190000)
    INTO Athlete VALUES (16, 'Mark Nguyen', '1984-02-28', 185, 82, 7781920192, 'mark.nguyen@soccer.com', '909 Flower Dr, Vancouver', '2003-09-14', 5, 'Richmond Thunder', 1700000)
    INTO Athlete VALUES (17, 'Jillian Prim', '1990-04-10', 173, 51, 6047781029, 'jillian.prim@soccer.com', '180 Priority St, Vancouver', '2019-02-21', 6, 'Richmond Thunder', 2000000)
    INTO Athlete VALUES (18, 'Simon Jones', '1986-10-21', 216, 44, 7786521829, 'simon.jones@soccer.com', '728 Current Dr, Vancouver', '2006-07-16', 7, 'Richmond Thunder', 70000)
    INTO Athlete VALUES (19, 'Adora Park', '1992-02-03', 157, 45, 6045781029, 'adora.park@soccer.com', '182 Princeton Way, Vancouver', '2009-05-14', 8, 'Richmond Thunder', 900000)
    INTO Athlete VALUES (20, 'Matt Dracos', '1983-08-26', 198, 94, 7785648189, 'matt.dracos@soccer.com', '994 Slogan Dr, Vancouver', '2017-08-25', 9, 'Richmond Thunder', 90000)
    INTO Athlete VALUES (21, 'Heidi Gram', '1997-01-09', 173, 36, 6048891203, 'heidi.gram@soccer.com', '444 Dragon Rd, Vancouver', '2006-04-30', 10, 'Richmond Thunder', 170000)
    INTO Athlete VALUES (22, 'Jeremy Lim', '1980-12-23', 170, 67, 7786541092, 'jeremy.lim@soccer.com', '182 Basket Way, Vancouver', '2014-11-07', 11, 'Richmond Thunder', 240000)
    -- Burnaby Warriors
    INTO Athlete VALUES (23, 'Parker Fin', '1986-04-17', 168, 53, 6057810293, 'parker.fin@soccer.com', '982 Bingo St, Vancouver', '2000-11-18', 1, 'Burnaby Warriors', 170000)
    INTO Athlete VALUES (24, 'Lauren Shim', '1992-09-15', 163, 40, 77867182911, 'lauren.shim@soccer.com', '821 Heart Way, Vancouver', '2008-10-01', 2, 'Burnaby Warriors', 256000)
    INTO Athlete VALUES (25, 'Markus Duff', '1988-11-23', 203, 86, 6045579012, 'markus.duff@soccer.com', '192 Rock Lane, Vancouver', '2012-06-12', 3, 'Burnaby Warriors', 400000)
    INTO Athlete VALUES (26, 'Fiora Moon', '1995-07-09', 170, 64, 7786541297, 'fiora.moon@soccer.com', '872 Piano Dr, Vancouver', '2005-08-23', 4, 'Burnaby Warriors', 187000)
    INTO Athlete VALUES (27, 'Wolf Sun', '1982-03-26', 107, 61, 6045709908, 'wolf.sun@soccer.com', '126 Error Rd, Vancouver', '2017-04-05', 5, 'Burnaby Warriors', 80000)
    INTO Athlete VALUES (28, 'MJ Heart', '1998-06-12', 168, 45, 7781112345, 'mj.heart@soccer.com', '988 Nest Way, Vancouver', '2003-02-14', 6, 'Burnaby Warriors', 190000)
    INTO Athlete VALUES (29, 'Jordan Tan', '1987-08-28', 229, 70, 6048990765, 'jordan.tan@soccer.com', '444 Bike Lane, Vancouver', '2014-10-30', 7, 'Burnaby Warriors', 761000)
    INTO Athlete VALUES (30, 'Ellie Howling', '1990-02-15', 115, 40, 7789912232, 'ellie.howling@soccer.com', '291 Desk Rd, Vancouver', '2009-03-01', 8, 'Burnaby Warriors', 19000)
    INTO Athlete VALUES (31, 'Darius Wong', '1986-12-21', 216, 77, 7786098801, 'darius.wong@soccer.com', '321 Turn St, Vancouver', '2006-09-20', 9, 'Burnaby Warriors', 172000)
    INTO Athlete VALUES (32, 'Delilah Kim', '1994-05-06', 168, 36, 6045578901, 'delilah.kim@soccer.com', '124 Function Rd, Vancouver', '2010-12-10', 10, 'Burnaby Warriors', 900000)
    INTO Athlete VALUES (33, 'Francis David', '1983-07-01', 201, 101, 7786543389, 'francis.david@soccer.com', '127 Bacon St, Vancouver', '2001-01-15', 11, 'Burnaby Warriors', 876000)
	-- Surrey Titans
	INTO Athlete VALUES (34, 'Adam Desmond', '1997-11-13', 178, 65, 6045578896, 'adam.desmond@soccer.com', '778 Philosophy Lane, Vancouver', '2015-07-17', 1, 'Surrey Titans', 178000)
	INTO Athlete VALUES (35, 'Brittany Peterson', '1981-01-27', 137, 59, 7786129993, 'brittany.peterson@soccer.com', '560 Canuck St, Vancouver', '2004-11-08', 2, 'Surrey Titans', 200000)
	INTO Athlete VALUES (36, 'Ryan Son', '1999-03-10', 231, 84, 6046678901, 'ryan.son@soccer.com', '329 Jensen Way, Vancouver', '2018-06-25', 3, 'Surrey Titans', 678000)
	INTO Athlete VALUES (37, 'Georgia Cheng', '1984-07-21', 180, 59, 778019812, 'georgia.cheng@soccer.com', '008 Armour Dr, Vancouver', '2007-03-03', 4, 'Surrey Titans', 192000)
	INTO Athlete VALUES (38, 'Jared Sinew', '1991-04-03', 196, 139, 6040580095, 'jared.sinew@soccer.com', '776 Corpus Lane, Vancouver', '2012-08-14', 5, 'Surrey Titans', 70800)
	INTO Athlete VALUES (39, 'Ashley Shu', '1996-09-17', 168, 54, 7783220119, 'ashley.shu@soccer.com', '887 Compass Rd, Vancouver', '2002-05-20', 6, 'Surrey Titans', 1000000)
	INTO Athlete VALUES (40, 'Lucas Man', '1989-12-30', 203, 38, 6048571002, 'lucas.man@soccer.com', '812 Lead Dr, Vancouver', '2016-04-09', 7, 'Surrey Titans', 240000)
	INTO Athlete VALUES (41, 'Sherry Van', '1993-05-15', 188, 50, 7780091435, 'sherry.van@soccer.com', '441 Floor Rd, Vancouver', '2008-01-12', 8, 'Surrey Titans', 700000)
	INTO Athlete VALUES (42, 'Vincent Lu', '1980-07-29', 178, 43, 6044478990, 'vincent.lu@soccer.com', '128 Douglas Dr, Vancouver', '2011-09-27', 9, 'Surrey Titans', 860000)
	INTO Athlete VALUES (43, 'Mary Jane', '1987-02-27', 180, 49, 7787563299, 'mary.jane@soccer.com', '888 Thunder Rd, Vancouver', '2005-06-22', 10, 'Surrey Titans', 978000)
	INTO Athlete VALUES (44, 'Jason Billy', '1993-09-20', 180, 57, 6049890071, 'jason.billy@soccer.com', '449 Apple St, Vancouver', '2017-01-05', 11, 'Surrey Titans', 170000)
	-- Coquitlam Sharks
	INTO Athlete VALUES (45, 'Harry Ford', '1985-11-18', 188, 71, 7786543090, 'harry.ford@soccer.com', '192 Falcon Dr, Vancouver', '2003-12-14', 1, 'Coquitlam Sharks', 16700000)
	INTO Athlete VALUES (46, 'Ruth North', '1991-07-12', 137, 149, 6045589012, 'ruth,north@soccer.com', '514 Fox Way, Vancouver', '2014-07-30', 2, 'Coquitlam Sharks', 40000)
	INTO Athlete VALUES (47, 'Luke Sky', '1988-03-25', 203, 241, 7786543998, 'luke.sky@soccer.com', '123 Force Lane, Vancouver', '2009-05-01', 3, 'Coquitlam Sharks', 990000)
	INTO Athlete VALUES (48, 'Noon Locomotion', '1996-05-18', 137, 68, 7780091002, 'noon.locomotion@soccer.com', '443 Train Rd, Vancouver', '2006-10-20', 4, 'Coquitlam Sharks', 54600)
	INTO Athlete VALUES (49, 'Parker Jones', '1982-07-26', 178, 190, 6041123009, 'parker.jones@soccer.com', '652 Stone Lane, Vancouver', '2011-01-10', 5, 'Coquitlam Sharks', 981000)
	INTO Athlete VALUES (50, 'Jamie Flame', '1998-11-27', 180, 167, 7784439012, 'jamie.flame@soccer.com', '332 Yang St, Vancouver', '2001-02-15', 6, 'Coquitlam Sharks', 728000)
	INTO Athlete VALUES (51, 'Dennis Honda', '1981-01-09', 195, 136, 6045589900, 'dennis.honda@soccer.com', '126 Arch Way, Vancouver', '2015-08-17', 7, 'Coquitlam Sharks', 971000)
	INTO Athlete VALUES (52, 'Karina Allen', '1994-07-27', 178, 94, 7786519822, 'karina.allen@soccer.com', '349 Synchronization Lane, Vancouver', '2004-12-08', 8, 'Coquitlam Sharks', 144000)
	INTO Athlete VALUES (53, 'John Under', '1989-09-15', 146, 119, 6045567124, 'john.under@soccer.com', '448 Dream Rd, Vancouver', '2018-07-25', 9, 'Coquitlam Sharks', 322900)
	INTO Athlete VALUES (54, 'Alicia Yoo', '1995-11-18', 168, 120, 7781129945, 'alicia.yoo@soccer.com', '229 Ocean Rd, Vancouver', '2007-04-03', 10, 'Coquitlam Sharks', 890000)
	INTO Athlete VALUES (55, 'Cameron Jonas', '1984-03-30', 185, 146, 7781009020, 'cameron.jones@soccer.com', '776 Sting St, Vancouver', '2012-09-14', 11, 'Coquitlam Sharks', 750000)
	-- Langley Bears
	INTO Athlete VALUES (56, 'James Fort', '1990-07-17', 210, 156, 6049125567, 'james.fort@soccer.com', '554 Knob Rd, Vancouver', '2002-06-20', 1, 'Langley Bears', 150000)
	INTO Athlete VALUES (57, 'Ivana Lee', '1986-09-02', 137, 144, 7786990001, 'ivana.lee@soccer.com', '447 Jelly Way, Vancouver', '2016-05-09', 2, 'Langley Bears', 800000)
	INTO Athlete VALUES (58, 'Jim Gear', '1992-02-04', 180, 239, 6045578990, 'jim.gear@soccer.com', '761 Willow Drive, Vancouver', '2008-02-12', 3, 'Langley Bears', 60000)
	INTO Athlete VALUES (59, 'Sophia Turn', '1983-08-23', 163, 129, 77866548888, 'sophia.turn@soccer.com', '551 Sunflower Way, Vancouver', '2011-10-27', 4, 'Langley Bears', 765000)
	INTO Athlete VALUES (60, 'Andrew Lim', '1997-01-19', 196, 178, 6049980073, 'andrew.lim@soccer.com', '060 Focus St, Vancouver', '2005-07-22', 5, 'Langley Bears', 236000)
	INTO Athlete VALUES (61, 'Evelyn Crow', '1980-12-03', 137, 144, 7786527778, 'evelyn.crow@soccer.com', '445 Gold Lane, Vancouver', '2017-02-05', 6, 'Langley Bears', 743000)
	INTO Athlete VALUES (62, 'Tim Shore', '1986-04-15', 203, 345, 6045590087, 'tim.shore@soccer.com', '112 Plane Rd, Vancouver', '2004-01-14', 7, 'Langley Bears', 76500)
	INTO Athlete VALUES (63, 'Rebecca Salvador', '1992-09-30', 157, 100, 6048891112, 'rebecca.salvador@soccer.com', '887 Leaf Way, Vancouver', '2015-07-30', 8, 'Langley Bears', 106700)
	INTO Athlete VALUES (64, 'Jean Fargo', '1988-11-07', 168, 178,7782234778, 'jean.fargo@soccer.com', '119 Boar Dr, Vancouver', '2010-05-01', 9, 'Langley Bears', 178000)
	INTO Athlete VALUES (65, 'Selena An', '1995-07-12', 144, 110, 6045009122, 'selena.an@soccer.com', '132 Stores Way, Vancouver', '2006-11-20', 10, 'Langley Bears', 1780000)
	INTO Athlete VALUES (66, 'Ahmed Tom', '1982-03-06', 188, 143, 7786223489, 'ahmed.tom@soccer.com', '443 Manager St. Vancouver', '2011-02-10', 11, 'Langley Bears', 166500)
SELECT * FROM dual;

INSERT ALL
	INTO Injury VALUES ('Arm', '2022-04-20', 0, 1)
	INTO Injury VALUES ('ACL', '2023-10-15', 1, 2)
	INTO Injury VALUES ('Leg', '2022-09-21', 0, 3)
	INTO Injury VALUES ('Head', '2021-10-30', 1, 4)
	INTO Injury VALUES ('Finger', '2022-01-22', 0, 5)
SELECT * FROM dual;

INSERT ALL
	INTO Game VALUES (1, 'Vancouver Vipers', 'Richmond Thunder', '2022-01-28')
	INTO Game VALUES (2, 'Burnaby Warriors', 'Surrey Titans', '2022-02-01')
	INTO Game VALUES (3, 'Coquitlam Sharks', 'Langley Bears', '2022-06-02')
	INTO Game VALUES (4, 'Vancouver Vipers', 'Burnaby Warriors','2022-08-15')
	INTO Game VALUES (5, 'Richmond Thunder', 'Coquitlam Sharks', '2022-10-01')
	INTO Game VALUES (6, 'Surrey Titans', 'Langley Bears', '2022-11-27')
	INTO Game VALUES (7, 'Vancouver Vipers', 'Surrey Titans', '2022-12-18')
	INTO Game VALUES (8, 'Burnaby Warriors', 'Coquitlam Sharks', '2023-02-05')
	INTO Game VALUES (9, 'Richmond Thunder', 'Langley Bears', '2023-02-17')
	INTO Game VALUES (10, 'Vancouver Vipers', 'Coquitlam Sharks', '2023-03-13')
	INTO Game VALUES (11, 'Burnaby Warriors', 'Langley Bears', '2023-05-24')
	INTO Game VALUES (12, 'Richmond Thunder', 'Surrey Titans', '2023-08-16')
	INTO Game VALUES (13, 'Vancouver Vipers', 'Langley Bears', '2023-09-01')
	INTO Game VALUES (14, 'Richmond Thunder', 'Burnaby Warriors', '2023-09-08')
	INTO Game VALUES (15, 'Coquitlam Sharks', 'Surrey Titans', '2023-11-19')
SELECT * FROM dual;

INSERT ALL
	INTO Sponsor VALUES ('Coca-Cola', 'sponsor@coca-colacompany.com', 50000)
	INTO Sponsor VALUES ('Adidas', 'sponsor@adidas.com', 40000)
	INTO Sponsor VALUES ('Visa', 'sponsor@visa.ca', 60000)
	INTO Sponsor VALUES ('UBC', 'sponsor@ubc.ca', 2000)
	INTO Sponsor VALUES ('Hyundai', 'sponsor@hyundaimotorgroup.com', 80000)
SELECT * FROM dual;

INSERT ALL
	INTO Awards VALUES (1, 2023, 'Offensive Player of the Year')
	INTO Awards VALUES (2, 2023, 'Defensive Player of the Year')
	INTO Awards VALUES (3, 2022, 'Offensive Player of the Year')
	INTO Awards VALUES (4, 2022, 'Team of the Year')
	INTO Awards VALUES (5, 2023, 'Team of the Year')
    INTO Awards VALUES (6, 2021, 'Offensive Player of the Year')
SELECT * FROM dual;

INSERT ALL
    INTO Statistics VALUES (1, 1, 1, 0, 9, 68, 9, 22.19)
    INTO Statistics VALUES (2, 1, 4, 4, 8, 37, 11, 43.26)
    INTO Statistics VALUES (3, 1, 7, 2, 13, 42, 13, 74.99)
    INTO Statistics VALUES (4, 1, 10, 3, 9, 73, 8, 45.38)
    INTO Statistics VALUES (5, 1, 13, 3, 5, 43, 18, 98.97)
    INTO Statistics VALUES (6, 2, 1, 1, 4, 38, 11, 16.57)
    INTO Statistics VALUES (7, 2, 4, 5, 8, 27, 14, 48.7)
    INTO Statistics VALUES (8, 2, 7, 4, 7, 55, 19, 33.91)
    INTO Statistics VALUES (9, 2, 10, 0, 9, 22, 20, 74.2)
    INTO Statistics VALUES (10, 2, 13, 0, 3, 79, 8, 64.27)
    INTO Statistics VALUES (11, 3, 1, 1, 7, 49, 0, 58.05)
    INTO Statistics VALUES (12, 3, 4, 5, 14, 40, 18, 83.43)
    INTO Statistics VALUES (13, 3, 7, 1, 7, 57, 12, 86.86)
    INTO Statistics VALUES (14, 3, 10, 3, 13, 75, 15, 85.64)
    INTO Statistics VALUES (15, 3, 13, 2, 3, 66, 9, 72.39)
    INTO Statistics VALUES (16, 4, 1, 1, 11, 31, 11, 12.12)
    INTO Statistics VALUES (17, 4, 4, 5, 13, 75, 16, 82.83)
    INTO Statistics VALUES (18, 4, 7, 1, 14, 47, 2, 40.33)
    INTO Statistics VALUES (19, 4, 10, 5, 16, 26, 15, 61.05)
    INTO Statistics VALUES (20, 4, 13, 3, 9, 33, 17, 8.46)
    INTO Statistics VALUES (21, 5, 1, 3, 9, 47, 6, 22.04)
    INTO Statistics VALUES (22, 5, 4, 5, 13, 78, 14, 37.04)
    INTO Statistics VALUES (23, 5, 7, 0, 16, 50, 15, 86.37)
    INTO Statistics VALUES (24, 5, 10, 5, 10, 81, 13, 90.39)
    INTO Statistics VALUES (25, 5, 13, 5, 14, 35, 20, 2.19)
    INTO Statistics VALUES (26, 6, 1, 5, 12, 71, 6, 29.31)
    INTO Statistics VALUES (27, 6, 4, 5, 15, 75, 21, 84.36)
    INTO Statistics VALUES (28, 6, 7, 5, 9, 10, 3, 61.09)
    INTO Statistics VALUES (29, 6, 10, 5, 13, 36, 15, 66.91)
    INTO Statistics VALUES (30, 6, 13, 2, 10, 70, 19, 13.42)
    INTO Statistics VALUES (31, 7, 1, 2, 13, 4, 1, 73.94)
    INTO Statistics VALUES (32, 7, 4, 4, 12, 79, 19, 21.23)
    INTO Statistics VALUES (33, 7, 7, 1, 5, 29, 5, 13.11)
    INTO Statistics VALUES (34, 7, 10, 3, 5, 16, 6, 91.15)
    INTO Statistics VALUES (35, 7, 13, 1, 3, 66, 4, 85.95)
    INTO Statistics VALUES (36, 8, 1, 1, 15, 53, 0, 90.82)
    INTO Statistics VALUES (37, 8, 4, 5, 16, 44, 13, 38.98)
    INTO Statistics VALUES (38, 8, 7, 4, 13, 33, 8, 95.23)
    INTO Statistics VALUES (39, 8, 10, 3, 10, 53, 8, 90.32)
    INTO Statistics VALUES (40, 8, 13, 1, 14, 39, 20, 64.76)
    INTO Statistics VALUES (41, 9, 1, 4, 8, 63, 9, 6.78)
    INTO Statistics VALUES (42, 9, 4, 2, 7, 18, 4, 63.8)
    INTO Statistics VALUES (43, 9, 7, 4, 12, 68, 11, 96.92)
    INTO Statistics VALUES (44, 9, 10, 3, 15, 31, 9, 83.19)
    INTO Statistics VALUES (45, 9, 13, 1, 12, 77, 0, 95.44)
    INTO Statistics VALUES (46, 10, 1, 3, 14, 56, 10, 68.93)
    INTO Statistics VALUES (47, 10, 4, 2, 7, 74, 0, 41.56)
    INTO Statistics VALUES (48, 10, 7, 1, 11, 48, 15, 31.22)
    INTO Statistics VALUES (49, 10, 10, 5, 16, 26, 6, 2.52)
    INTO Statistics VALUES (50, 10, 13, 0, 11, 11, 7, 60.27)
    INTO Statistics VALUES (51, 11, 1, 4, 16, 57, 10, 40.57)
    INTO Statistics VALUES (52, 11, 4, 0, 1, 58, 11, 56.73)
    INTO Statistics VALUES (53, 11, 7, 2, 4, 58, 21, 1.25)
    INTO Statistics VALUES (54, 11, 10, 1, 12, 27, 3, 98.6)
    INTO Statistics VALUES (55, 11, 13, 0, 12, 28, 9, 14.4)
    INTO Statistics VALUES (56, 12, 1, 0, 1, 20, 14, 90.24)
    INTO Statistics VALUES (57, 12, 5, 0, 1, 20, 17, 81.21)
    INTO Statistics VALUES (58, 12, 9, 5, 6, 13, 9, 79.13)
    INTO Statistics VALUES (59, 12, 12, 5, 11, 28, 18, 96.2)
    INTO Statistics VALUES (60, 12, 14, 5, 13, 60, 12, 36.96)
    INTO Statistics VALUES (61, 13, 1, 3, 6, 22, 10, 84.84)
    INTO Statistics VALUES (62, 13, 5, 4, 5, 52, 9, 62.93)
    INTO Statistics VALUES (63, 13, 9, 2, 6, 66, 14, 90.2)
    INTO Statistics VALUES (64, 13, 12, 1, 13, 64, 5, 43.1)
    INTO Statistics VALUES (65, 13, 14, 3, 9, 34, 11, 47.12)
    INTO Statistics VALUES (66, 14, 1, 0, 2, 77, 14, 16.86)
    INTO Statistics VALUES (67, 14, 5, 2, 4, 45, 10, 3.17)
    INTO Statistics VALUES (68, 14, 9, 4, 11, 11, 2, 50.09)
    INTO Statistics VALUES (69, 14, 12, 2, 10, 35, 17, 20.52)
    INTO Statistics VALUES (70, 14, 14, 5, 10, 39, 10, 67.68)
    INTO Statistics VALUES (71, 15, 1, 5, 13, 59, 1, 17.51)
    INTO Statistics VALUES (72, 15, 5, 0, 11, 80, 5, 55.61)
    INTO Statistics VALUES (73, 15, 9, 2, 3, 38, 6, 88.77)
    INTO Statistics VALUES (74, 15, 12, 5, 7, 31, 0, 24.43)
    INTO Statistics VALUES (75, 15, 14, 3, 6, 58, 5, 22.31)
    INTO Statistics VALUES (76, 16, 1, 2, 4, 48, 11, 82.37)
    INTO Statistics VALUES (77, 16, 5, 1, 11, 76, 21, 64.83)
    INTO Statistics VALUES (78, 16, 9, 2, 10, 55, 15, 19.09)
    INTO Statistics VALUES (79, 16, 12, 5, 6, 75, 19, 7.39)
    INTO Statistics VALUES (80, 16, 14, 0, 1, 59, 13, 47.17)
    INTO Statistics VALUES (81, 17, 1, 2, 15, 30, 1, 22.25)
    INTO Statistics VALUES (82, 17, 5, 4, 12, 58, 1, 72.52)
    INTO Statistics VALUES (83, 17, 9, 1, 4, 8, 0, 8.85)
    INTO Statistics VALUES (84, 17, 12, 2, 6, 26, 9, 21.73)
    INTO Statistics VALUES (85, 17, 14, 0, 4, 64, 1, 57.87)
    INTO Statistics VALUES (86, 18, 1, 5, 14, 72, 3, 98.43)
    INTO Statistics VALUES (87, 18, 5, 5, 9, 45, 10, 58.66)
    INTO Statistics VALUES (88, 18, 9, 5, 16, 64, 17, 97.42)
    INTO Statistics VALUES (89, 18, 12, 5, 8, 14, 6, 33.71)
    INTO Statistics VALUES (90, 18, 14, 2, 15, 22, 14, 75.44)
    INTO Statistics VALUES (91, 19, 1, 5, 11, 63, 4, 97.62)
    INTO Statistics VALUES (92, 19, 5, 1, 13, 66, 0, 15.47)
    INTO Statistics VALUES (93, 19, 9, 0, 12, 46, 1, 67.42)
    INTO Statistics VALUES (94, 19, 12, 0, 7, 55, 6, 91.35)
    INTO Statistics VALUES (95, 19, 14, 2, 15, 73, 4, 47.28)
    INTO Statistics VALUES (96, 20, 1, 3, 10, 31, 8, 22.89)
    INTO Statistics VALUES (97, 20, 5, 2, 13, 79, 17, 69.2)
    INTO Statistics VALUES (98, 20, 9, 1, 16, 40, 10, 8.86)
    INTO Statistics VALUES (99, 20, 12, 0, 9, 20, 16, 46.17)
    INTO Statistics VALUES (100, 20, 14, 1, 5, 78, 15, 64.87)
    INTO Statistics VALUES (101, 21, 1, 4, 16, 76, 1, 27.47)
    INTO Statistics VALUES (102, 21, 5, 3, 6, 56, 10, 63.71)
    INTO Statistics VALUES (103, 21, 9, 4, 9, 25, 9, 99.51)
    INTO Statistics VALUES (104, 21, 12, 0, 16, 48, 21, 3.27)
    INTO Statistics VALUES (105, 21, 14, 5, 13, 9, 3, 16.21)
    INTO Statistics VALUES (106, 22, 1, 1, 9, 23, 6, 1.98)
    INTO Statistics VALUES (107, 22, 5, 3, 7, 34, 12, 61.01)
    INTO Statistics VALUES (108, 22, 9, 4, 7, 28, 4, 41.72)
    INTO Statistics VALUES (109, 22, 12, 1, 6, 26, 6, 81.54)
    INTO Statistics VALUES (110, 22, 14, 2, 5, 15, 1, 93.76)
    INTO Statistics VALUES (111, 23, 2, 3, 8, 29, 6, 20.17)
    INTO Statistics VALUES (112, 23, 4, 1, 5, 57, 16, 73.96)
    INTO Statistics VALUES (113, 23, 8, 1, 10, 13, 10, 43.95)
    INTO Statistics VALUES (114, 23, 11, 5, 10, 77, 2, 70.26)
    INTO Statistics VALUES (115, 23, 14, 1, 14, 75, 20, 52.06)
    INTO Statistics VALUES (116, 24, 2, 2, 4, 42, 6, 6.02)
    INTO Statistics VALUES (117, 24, 4, 2, 8, 67, 9, 78.11)
    INTO Statistics VALUES (118, 24, 8, 5, 14, 77, 21, 89.85)
    INTO Statistics VALUES (119, 24, 11, 1, 8, 24, 21, 39.75)
    INTO Statistics VALUES (120, 24, 14, 0, 6, 19, 9, 63.66)
    INTO Statistics VALUES (121, 25, 2, 5, 11, 16, 2, 69.38)
    INTO Statistics VALUES (122, 25, 4, 4, 8, 17, 16, 76.26)
    INTO Statistics VALUES (123, 25, 8, 5, 15, 60, 12, 17.5)
    INTO Statistics VALUES (124, 25, 11, 3, 10, 77, 3, 62.77)
    INTO Statistics VALUES (125, 25, 14, 3, 4, 7, 3, 79.11)
    INTO Statistics VALUES (126, 26, 2, 3, 9, 48, 10, 46.91)
    INTO Statistics VALUES (127, 26, 4, 2, 6, 24, 0, 40.22)
    INTO Statistics VALUES (128, 26, 8, 4, 11, 26, 3, 67.86)
    INTO Statistics VALUES (129, 26, 11, 3, 10, 46, 4, 94.09)
    INTO Statistics VALUES (130, 26, 14, 0, 5, 35, 12, 30.73)
    INTO Statistics VALUES (131, 27, 2, 2, 4, 21, 4, 96.31)
    INTO Statistics VALUES (132, 27, 4, 2, 6, 18, 5, 49.83)
    INTO Statistics VALUES (133, 27, 8, 2, 11, 74, 20, 12.82)
    INTO Statistics VALUES (134, 27, 11, 1, 8, 58, 13, 86.6)
    INTO Statistics VALUES (135, 27, 14, 0, 15, 73, 11, 43.74)
    INTO Statistics VALUES (136, 28, 2, 0, 14, 16, 2, 76.54)
    INTO Statistics VALUES (137, 28, 4, 1, 11, 49, 4, 88.69)
    INTO Statistics VALUES (138, 28, 8, 1, 7, 39, 4, 23.51)
    INTO Statistics VALUES (139, 28, 11, 5, 10, 9, 6, 32.16)
    INTO Statistics VALUES (140, 28, 14, 0, 13, 52, 16, 98.47)
    INTO Statistics VALUES (141, 29, 2, 0, 5, 36, 16, 41.57)
    INTO Statistics VALUES (142, 29, 4, 1, 14, 37, 10, 13.65)
    INTO Statistics VALUES (143, 29, 8, 3, 6, 45, 5, 30.29)
    INTO Statistics VALUES (144, 29, 11, 5, 8, 37, 9, 45.09)
    INTO Statistics VALUES (145, 29, 14, 4, 12, 55, 10, 42.08)
    INTO Statistics VALUES (146, 30, 2, 1, 13, 23, 14, 97.7)
    INTO Statistics VALUES (147, 30, 4, 3, 16, 75, 19, 96.91)
    INTO Statistics VALUES (148, 30, 8, 2, 5, 57, 2, 12.28)
    INTO Statistics VALUES (149, 30, 11, 0, 16, 76, 12, 51.42)
    INTO Statistics VALUES (150, 30, 14, 2, 16, 21, 8, 94.89)
    INTO Statistics VALUES (151, 31, 2, 3, 11, 51, 19, 20.17)
    INTO Statistics VALUES (152, 31, 4, 1, 12, 20, 12, 99.47)
    INTO Statistics VALUES (153, 31, 8, 2, 4, 77, 14, 12.79)
    INTO Statistics VALUES (154, 31, 11, 4, 12, 61, 11, 39.63)
    INTO Statistics VALUES (155, 31, 14, 0, 15, 20, 3, 46.3)
    INTO Statistics VALUES (156, 32, 2, 0, 16, 52, 18, 14.23)
    INTO Statistics VALUES (157, 32, 4, 2, 5, 14, 6, 88.83)
    INTO Statistics VALUES (158, 32, 8, 4, 7, 27, 17, 64.48)
    INTO Statistics VALUES (159, 32, 11, 5, 15, 58, 13, 22.55)
    INTO Statistics VALUES (160, 32, 14, 5, 13, 50, 20, 39.58)
    INTO Statistics VALUES (161, 33, 2, 5, 13, 53, 2, 53.19)
    INTO Statistics VALUES (162, 33, 4, 2, 4, 48, 13, 48.8)
    INTO Statistics VALUES (163, 33, 8, 1, 11, 55, 6, 44.97)
    INTO Statistics VALUES (164, 33, 11, 5, 10, 42, 19, 87.07)
    INTO Statistics VALUES (165, 33, 14, 4, 8, 37, 11, 75.38)
    INTO Statistics VALUES (166, 34, 2, 5, 10, 28, 5, 10.2)
    INTO Statistics VALUES (167, 34, 6, 3, 6, 14, 12, 62.61)
    INTO Statistics VALUES (168, 34, 7, 5, 10, 21, 0, 46.73)
    INTO Statistics VALUES (169, 34, 12, 4, 8, 44, 18, 97.5)
    INTO Statistics VALUES (170, 34, 15, 0, 2, 60, 17, 27.19)
    INTO Statistics VALUES (171, 35, 2, 2, 11, 52, 0, 59.28)
    INTO Statistics VALUES (172, 35, 6, 4, 16, 25, 12, 16.24)
    INTO Statistics VALUES (173, 35, 7, 5, 10, 46, 2, 78.47)
    INTO Statistics VALUES (174, 35, 12, 4, 9, 76, 6, 89.61)
    INTO Statistics VALUES (175, 35, 15, 2, 3, 60, 16, 88.61)
    INTO Statistics VALUES (176, 36, 2, 1, 6, 46, 21, 29.84)
    INTO Statistics VALUES (177, 36, 6, 0, 15, 48, 16, 82)
    INTO Statistics VALUES (178, 36, 7, 5, 8, 68, 7, 7.67)
    INTO Statistics VALUES (179, 36, 12, 4, 10, 78, 19, 80.92)
    INTO Statistics VALUES (180, 36, 15, 2, 8, 18, 15, 45.56)
    INTO Statistics VALUES (181, 37, 2, 4, 15, 67, 21, 61.99)
    INTO Statistics VALUES (182, 37, 6, 1, 13, 66, 14, 37.11)
    INTO Statistics VALUES (183, 37, 7, 4, 8, 37, 3, 39.22)
    INTO Statistics VALUES (184, 37, 12, 2, 3, 81, 10, 11.06)
    INTO Statistics VALUES (185, 37, 15, 1, 8, 75, 19, 42.49)
    INTO Statistics VALUES (186, 38, 2, 2, 8, 39, 10, 87.31)
    INTO Statistics VALUES (187, 38, 6, 4, 8, 32, 15, 94.28)
    INTO Statistics VALUES (188, 38, 7, 5, 14, 24, 9, 55.44)
    INTO Statistics VALUES (189, 38, 12, 4, 13, 68, 5, 15.19)
    INTO Statistics VALUES (190, 38, 15, 5, 8, 65, 5, 43.45)
    INTO Statistics VALUES (191, 39, 2, 1, 2, 19, 5, 30.49)
    INTO Statistics VALUES (192, 39, 6, 3, 4, 69, 16, 83.64)
    INTO Statistics VALUES (193, 39, 7, 1, 6, 49, 20, 99.86)
    INTO Statistics VALUES (194, 39, 12, 0, 10, 11, 5, 8.46)
    INTO Statistics VALUES (195, 39, 15, 4, 9, 49, 15, 53.51)
    INTO Statistics VALUES (196, 40, 2, 0, 15, 39, 11, 7.48)
    INTO Statistics VALUES (197, 40, 6, 2, 7, 46, 17, 44.25)
    INTO Statistics VALUES (198, 40, 7, 4, 16, 57, 7, 94.5)
    INTO Statistics VALUES (199, 40, 12, 2, 13, 63, 11, 47.98)
    INTO Statistics VALUES (200, 40, 15, 2, 4, 47, 6, 37.85)
    INTO Statistics VALUES (201, 41, 2, 3, 10, 24, 4, 10.37)
    INTO Statistics VALUES (202, 41, 6, 0, 8, 5, 0, 79.52)
    INTO Statistics VALUES (203, 41, 7, 4, 13, 76, 0, 50.17)
    INTO Statistics VALUES (204, 41, 12, 3, 16, 52, 11, 29.23)
    INTO Statistics VALUES (205, 41, 15, 3, 4, 78, 3, 25.05)
    INTO Statistics VALUES (206, 42, 2, 1, 11, 62, 14, 5.21)
    INTO Statistics VALUES (207, 42, 6, 3, 10, 25, 14, 39.66)
    INTO Statistics VALUES (208, 42, 7, 4, 10, 69, 12, 83.63)
    INTO Statistics VALUES (209, 42, 12, 2, 16, 14, 2, 86.64)
    INTO Statistics VALUES (210, 42, 15, 3, 7, 63, 13, 90.25)
    INTO Statistics VALUES (211, 43, 2, 4, 14, 66, 12, 63.05)
    INTO Statistics VALUES (212, 43, 6, 0, 15, 24, 14, 4.41)
    INTO Statistics VALUES (213, 43, 7, 2, 13, 66, 8, 82.83)
    INTO Statistics VALUES (214, 43, 12, 1, 12, 4, 3, 28.47)
    INTO Statistics VALUES (215, 43, 15, 2, 7, 39, 13, 0.38)
    INTO Statistics VALUES (216, 44, 2, 3, 8, 65, 4, 77.88)
    INTO Statistics VALUES (217, 44, 6, 1, 12, 39, 7, 60.85)
    INTO Statistics VALUES (218, 44, 7, 5, 9, 71, 17, 44.57)
    INTO Statistics VALUES (219, 44, 12, 3, 6, 45, 2, 53.21)
    INTO Statistics VALUES (220, 44, 15, 2, 6, 59, 7, 77.37)
    INTO Statistics VALUES (221, 45, 3, 1, 3, 42, 11, 38.1)
    INTO Statistics VALUES (222, 45, 5, 3, 4, 59, 12, 83.91)
    INTO Statistics VALUES (223, 45, 8, 0, 15, 37, 1, 0.14)
    INTO Statistics VALUES (224, 45, 10, 4, 8, 73, 5, 90.03)
    INTO Statistics VALUES (225, 45, 15, 2, 8, 19, 1, 73.79)
    INTO Statistics VALUES (226, 46, 3, 5, 15, 57, 21, 44.35)
    INTO Statistics VALUES (227, 46, 5, 1, 11, 77, 19, 17.53)
    INTO Statistics VALUES (228, 46, 8, 4, 12, 40, 8, 25.13)
    INTO Statistics VALUES (229, 46, 10, 0, 12, 46, 3, 82.03)
    INTO Statistics VALUES (230, 46, 15, 5, 16, 61, 18, 33.71)
    INTO Statistics VALUES (231, 47, 3, 3, 4, 31, 20, 63.15)
    INTO Statistics VALUES (232, 47, 5, 0, 12, 16, 5, 78.46)
    INTO Statistics VALUES (233, 47, 8, 2, 7, 74, 5, 71.04)
    INTO Statistics VALUES (234, 47, 10, 3, 13, 29, 14, 20.06)
    INTO Statistics VALUES (235, 47, 15, 2, 13, 55, 6, 91.41)
    INTO Statistics VALUES (236, 48, 3, 0, 14, 75, 5, 39.47)
    INTO Statistics VALUES (237, 48, 5, 5, 16, 18, 2, 79.64)
    INTO Statistics VALUES (238, 48, 8, 5, 11, 73, 11, 22.82)
    INTO Statistics VALUES (239, 48, 10, 3, 4, 63, 14, 25.64)
    INTO Statistics VALUES (240, 48, 15, 1, 14, 72, 4, 95.06)
    INTO Statistics VALUES (241, 49, 3, 3, 13, 61, 14, 34.83)
    INTO Statistics VALUES (242, 49, 5, 1, 3, 63, 8, 29.15)
    INTO Statistics VALUES (243, 49, 8, 4, 13, 74, 3, 77.42)
    INTO Statistics VALUES (244, 49, 10, 0, 15, 59, 6, 99.51)
    INTO Statistics VALUES (245, 49, 15, 2, 6, 51, 14, 9.63)
    INTO Statistics VALUES (246, 50, 3, 1, 10, 15, 6, 39.38)
    INTO Statistics VALUES (247, 50, 5, 2, 12, 77, 12, 19.2)
    INTO Statistics VALUES (248, 50, 8, 1, 7, 51, 7, 61.97)
    INTO Statistics VALUES (249, 50, 10, 0, 14, 37, 13, 83.12)
    INTO Statistics VALUES (250, 50, 15, 2, 12, 48, 11, 34.76)
    INTO Statistics VALUES (251, 51, 3, 4, 8, 37, 1, 17.92)
    INTO Statistics VALUES (252, 51, 5, 2, 12, 67, 5, 61.46)
    INTO Statistics VALUES (253, 51, 8, 4, 7, 45, 0, 3.16)
    INTO Statistics VALUES (254, 51, 10, 3, 14, 48, 9, 16.74)
    INTO Statistics VALUES (255, 51, 15, 4, 8, 48, 1, 18.56)
    INTO Statistics VALUES (256, 52, 3, 5, 9, 69, 15, 32.27)
    INTO Statistics VALUES (257, 52, 5, 4, 5, 19, 17, 62.39)
    INTO Statistics VALUES (258, 52, 8, 4, 16, 29, 13, 35.21)
    INTO Statistics VALUES (259, 52, 10, 4, 15, 20, 14, 84.71)
    INTO Statistics VALUES (260, 52, 15, 3, 6, 13, 1, 33.84)
    INTO Statistics VALUES (261, 53, 3, 3, 15, 63, 21, 80.05)
    INTO Statistics VALUES (262, 53, 5, 1, 14, 81, 15, 33.2)
    INTO Statistics VALUES (263, 53, 8, 2, 15, 15, 5, 31.69)
    INTO Statistics VALUES (264, 53, 10, 4, 12, 26, 8, 46.37)
    INTO Statistics VALUES (265, 53, 15, 0, 13, 56, 21, 10.69)
    INTO Statistics VALUES (266, 54, 3, 3, 7, 64, 4, 55.1)
    INTO Statistics VALUES (267, 54, 5, 2, 3, 43, 9, 4.31)
    INTO Statistics VALUES (268, 54, 8, 0, 1, 69, 15, 60.37)
    INTO Statistics VALUES (269, 54, 10, 3, 7, 31, 8, 47.7)
    INTO Statistics VALUES (270, 54, 15, 0, 2, 49, 21, 80.87)
    INTO Statistics VALUES (271, 55, 3, 2, 12, 25, 14, 26.21)
    INTO Statistics VALUES (272, 55, 5, 5, 13, 11, 3, 80.25)
    INTO Statistics VALUES (273, 55, 8, 3, 11, 38, 18, 24.86)
    INTO Statistics VALUES (274, 55, 10, 1, 4, 77, 0, 51.55)
    INTO Statistics VALUES (275, 55, 15, 0, 6, 68, 21, 19.3)
    INTO Statistics VALUES (276, 56, 3, 3, 14, 78, 11, 60.21)
    INTO Statistics VALUES (277, 56, 6, 2, 9, 62, 4, 55.3)
    INTO Statistics VALUES (278, 56, 9, 3, 6, 42, 2, 64.56)
    INTO Statistics VALUES (279, 56, 11, 0, 11, 42, 19, 10.47)
    INTO Statistics VALUES (280, 56, 13, 5, 6, 54, 2, 86.13)
    INTO Statistics VALUES (281, 57, 3, 2, 8, 81, 8, 94.1)
    INTO Statistics VALUES (282, 57, 6, 5, 15, 12, 5, 40.15)
    INTO Statistics VALUES (283, 57, 9, 5, 6, 51, 18, 36.32)
    INTO Statistics VALUES (284, 57, 11, 2, 8, 56, 6, 62.48)
    INTO Statistics VALUES (285, 57, 13, 0, 6, 57, 14, 19.2)
    INTO Statistics VALUES (286, 58, 3, 5, 8, 10, 2, 1.11)
    INTO Statistics VALUES (287, 58, 6, 0, 10, 19, 7, 51.92)
    INTO Statistics VALUES (288, 58, 9, 5, 14, 78, 3, 26.93)
    INTO Statistics VALUES (289, 58, 11, 4, 7, 28, 18, 25.01)
    INTO Statistics VALUES (290, 58, 13, 1, 12, 81, 13, 28.31)
    INTO Statistics VALUES (291, 59, 3, 5, 8, 32, 5, 79.14)
    INTO Statistics VALUES (292, 59, 6, 0, 15, 24, 3, 50.38)
    INTO Statistics VALUES (293, 59, 9, 2, 12, 17, 12, 53.72)
    INTO Statistics VALUES (294, 59, 11, 3, 8, 58, 9, 56.13)
    INTO Statistics VALUES (295, 59, 13, 0, 2, 80, 0, 86.22)
    INTO Statistics VALUES (296, 60, 3, 4, 10, 26, 16, 93.88)
    INTO Statistics VALUES (297, 60, 6, 1, 9, 33, 10, 19.24)
    INTO Statistics VALUES (298, 60, 9, 3, 8, 24, 7, 94.89)
    INTO Statistics VALUES (299, 60, 11, 2, 8, 57, 18, 14.39)
    INTO Statistics VALUES (300, 60, 13, 4, 15, 56, 15, 72.76)
    INTO Statistics VALUES (301, 61, 3, 0, 6, 21, 9, 41.8)
    INTO Statistics VALUES (302, 61, 6, 4, 12, 23, 8, 75.93)
    INTO Statistics VALUES (303, 61, 9, 2, 6, 54, 3, 25.41)
    INTO Statistics VALUES (304, 61, 11, 1, 6, 81, 6, 95.24)
    INTO Statistics VALUES (305, 61, 13, 0, 13, 71, 19, 16.22)
    INTO Statistics VALUES (306, 62, 3, 2, 14, 14, 4, 28.88)
    INTO Statistics VALUES (307, 62, 6, 0, 4, 14, 4, 2.82)
    INTO Statistics VALUES (308, 62, 9, 3, 6, 34, 21, 93.25)
    INTO Statistics VALUES (309, 62, 11, 4, 10, 26, 4, 59.64)
    INTO Statistics VALUES (310, 62, 13, 5, 11, 32, 16, 64.1)
    INTO Statistics VALUES (311, 63, 3, 1, 2, 44, 15, 44)
    INTO Statistics VALUES (312, 63, 6, 1, 13, 20, 17, 31.51)
    INTO Statistics VALUES (313, 63, 9, 1, 5, 58, 10, 57.2)
    INTO Statistics VALUES (314, 63, 11, 4, 5, 77, 13, 71.06)
    INTO Statistics VALUES (315, 63, 13, 2, 12, 73, 14, 0.55)
    INTO Statistics VALUES (316, 64, 3, 2, 13, 44, 1, 63.24)
    INTO Statistics VALUES (317, 64, 6, 4, 7, 33, 3, 76.47)
    INTO Statistics VALUES (318, 64, 9, 4, 15, 45, 8, 75.45)
    INTO Statistics VALUES (319, 64, 11, 4, 13, 72, 13, 80.56)
    INTO Statistics VALUES (320, 64, 13, 0, 1, 41, 1, 12.25)
    INTO Statistics VALUES (321, 65, 3, 2, 4, 24, 15, 50.56)
    INTO Statistics VALUES (322, 65, 6, 1, 2, 36, 0, 83.95)
    INTO Statistics VALUES (323, 65, 9, 0, 12, 10, 3, 71.63)
    INTO Statistics VALUES (324, 65, 11, 3, 16, 81, 7, 83.37)
    INTO Statistics VALUES (325, 65, 13, 0, 16, 79, 8, 6.98)
    INTO Statistics VALUES (326, 66, 3, 3, 6, 52, 5, 75.27)
    INTO Statistics VALUES (327, 66, 6, 2, 14, 49, 14, 50.97)
    INTO Statistics VALUES (328, 66, 9, 0, 12, 44, 13, 70.33)
    INTO Statistics VALUES (329, 66, 11, 0, 9, 46, 8, 56.79)
    INTO Statistics VALUES (330, 66, 13, 3, 16, 36, 9, 61.5)
SELECT * FROM dual;

INSERT ALL
    INTO Referee VALUES (1, 'Liam Taylor', '1991-03-18', 175, 69, 2361234567, 'liam.taylor@soccer.com', '567 Oak St, Vancouver', '2009-08-14', 1)
    INTO Referee VALUES (2, 'Ella Smith', '1996-08-22', 163, 61, 2362345678, 'ella.smith@soccer.com', '345 Elm St, Vancouver', '2017-05-25', 2)
    INTO Referee VALUES (3, 'Noah Johnson', '1989-12-05', 188, 87, 2363456789, 'noah.johnson@soccer.com', '678 Birch St, Vancouver', '2006-11-30', 3)
    INTO Referee VALUES (4, 'Mia Davis', '1993-04-30', 168, 68, 2364567890, 'mia.davis@soccer.com', '456 Cedar St, Vancouver', '2014-09-07', 4)
    INTO Referee VALUES (5, 'Oliver Anderson', '1980-06-14', 178, 81, 2365678901, 'oliver.anderson@soccer.com', '890 Pine St, Vancouver', '2000-04-18', 5)
SELECT * FROM dual;

INSERT ALL
    INTO Coach VALUES (1, 'Daniel Lee', '1985-04-15', 178, 80, 6048234567, 'daniel.lee@soccer.com', '567 Birch St, Vancouver', '2000-07-10', 'Vancouver Vipers', 'Head Coach')
    INTO Coach VALUES (2, 'Olivia Johnson', '1992-09-25', 168, 64, 7788345678, 'olivia.johnson@soccer.com', '890 Elm St, Vancouver', '2010-03-18', 'Vancouver Vipers', 'Assistant Coach')
    INTO Coach VALUES (3, 'William Smith', '1988-11-03', 182, 84, 6048456789, 'william.smith@soccer.com', '123 Cedar St, Vancouver', '2005-12-05', 'Richmond Thunder', 'Head Coach')
    INTO Coach VALUES (4, 'Sophia Brown', '1995-07-19', 170, 68, 7788567890, 'sophia.brown@soccer.com', '456 Fir St, Vancouver', '2018-02-14', 'Richmond Thunder', 'Assistant Coach')
    INTO Coach VALUES (5, 'James Anderson', '1982-03-12', 188, 88, 6048678901, 'james.anderson@soccer.com', '789 Pine St, Vancouver', '2002-09-22', 'Burnaby Warriors', 'Head Coach')
    INTO Coach VALUES (6, 'Simon Roach', '1998-05-29', 175, 64, 6045889120, 'simon.roach@soccer.com', '932 Red Oak St, Vancouver', '2015-06-30', 'Burnaby Warriors', 'Assistant Coach')
    INTO Coach VALUES (7, 'Madeline Bills', '1987-08-14', 168, 58, 7781029391, 'madeline.bills@soccer.com', '402 Ocean View Rd, Vancouver', '2004-04-03', 'Surrey Titans', 'Head Coach')
    INTO Coach VALUES (8, 'Rachel Chu', '1990-01-02', 170, 51, 7789203019, 'rachel.chu@soccer.com', '102 Panther Lane, Vancouver', '2009-11-12', 'Surrey Titans', 'Assistant Coach')
    INTO Coach VALUES (9, 'Oscar Rodriguez', '1986-12-08', 206, 101, 7780192939, 'oscar.rodriguez@soccer.com', '882 Parker Drive, Vancouver', '2007-07-27', 'Coquitlam Sharks', 'Head Coach')
    INTO Coach VALUES (10, 'Natalie Nguyen', '1994-04-23', 185, 81, 6047789102, 'natalie.nguyen@soccer.com', '721 Red Roof Way, Vancouver', '2013-01-19', 'Coquitlam Sharks', 'Assistant Coach')
    INTO Coach VALUES (11, 'Robert Barns', '1983-06-17', 178, 102, 6042102939, 'robert.barns@soccer.com', '900 Frankfurt Rd, Vancouver', '2001-10-09', 'Langley Bears', 'Head Coach')
    INTO Coach VALUES (12, 'Bill Bacon', '1997-10-30', 150, 71, 7781920392, 'bill.bacon@soccer.com', '562 Fox Den Lane, Vancouver', '2016-08-07', 'Langley Bears', 'Assistant Coach')
SELECT * FROM dual;

INSERT ALL
	INTO Coaches VALUES (1, 'Vancouver Vipers')
	INTO Coaches VALUES (2, 'Vancouver Vipers')
	INTO Coaches VALUES (3, 'Richmond Thunder')
	INTO Coaches VALUES (4, 'Richmond Thunder')
	INTO Coaches VALUES (5, 'Burnaby Warriors')
    INTO Coaches VALUES (6, 'Burnaby Warriors')
    INTO Coaches VALUES (7, 'Surrey Titans')
    INTO Coaches VALUES (8, 'Surrey Titans')
    INTO Coaches VALUES (9, 'Coquitlam Sharks')
    INTO Coaches VALUES (10, 'Coquitlam Sharks')
    INTO Coaches VALUES (11, 'Langley Bears')
    INTO Coaches VALUES (12, 'Langley Bears')
SELECT * FROM dual;

INSERT ALL
	INTO PlaysFor VALUES (1, 'Vancouver Vipers')
	INTO PlaysFor VALUES (2, 'Vancouver Vipers')
	INTO PlaysFor VALUES (3, 'Vancouver Vipers')
	INTO PlaysFor VALUES (4, 'Vancouver Vipers')
	INTO PlaysFor VALUES (5, 'Vancouver Vipers')
	INTO PlaysFor VALUES (6, 'Vancouver Vipers')
	INTO PlaysFor VALUES (7, 'Vancouver Vipers')
	INTO PlaysFor VALUES (8, 'Vancouver Vipers')
	INTO PlaysFor VALUES (9, 'Vancouver Vipers')
	INTO PlaysFor VALUES (10, 'Vancouver Vipers')
	INTO PlaysFor VALUES (11, 'Vancouver Vipers')
	INTO PlaysFor VALUES (12, 'Richmond Thunder')
	INTO PlaysFor VALUES (13, 'Richmond Thunder')
	INTO PlaysFor VALUES (14, 'Richmond Thunder')
	INTO PlaysFor VALUES (15, 'Richmond Thunder')
	INTO PlaysFor VALUES (16, 'Richmond Thunder')
	INTO PlaysFor VALUES (17, 'Richmond Thunder')
	INTO PlaysFor VALUES (18, 'Richmond Thunder')
	INTO PlaysFor VALUES (19, 'Richmond Thunder')
	INTO PlaysFor VALUES (20, 'Richmond Thunder')
	INTO PlaysFor VALUES (21, 'Richmond Thunder')
	INTO PlaysFor VALUES (22, 'Richmond Thunder')
	INTO PlaysFor VALUES (23, 'Burnaby Warriors')
	INTO PlaysFor VALUES (24, 'Burnaby Warriors')
	INTO PlaysFor VALUES (25, 'Burnaby Warriors')
	INTO PlaysFor VALUES (26, 'Burnaby Warriors')
	INTO PlaysFor VALUES (27, 'Burnaby Warriors')
	INTO PlaysFor VALUES (28, 'Burnaby Warriors')
	INTO PlaysFor VALUES (29, 'Burnaby Warriors')
	INTO PlaysFor VALUES (30, 'Burnaby Warriors')
	INTO PlaysFor VALUES (31, 'Burnaby Warriors')
	INTO PlaysFor VALUES (32, 'Burnaby Warriors')
	INTO PlaysFor VALUES (33, 'Burnaby Warriors')
	INTO PlaysFor VALUES (34, 'Surrey Titans')
	INTO PlaysFor VALUES (35, 'Surrey Titans')
	INTO PlaysFor VALUES (36, 'Surrey Titans')
	INTO PlaysFor VALUES (37, 'Surrey Titans')
	INTO PlaysFor VALUES (38, 'Surrey Titans')
	INTO PlaysFor VALUES (39, 'Surrey Titans')
	INTO PlaysFor VALUES (40, 'Surrey Titans')
	INTO PlaysFor VALUES (41, 'Surrey Titans')
	INTO PlaysFor VALUES (42, 'Surrey Titans')
	INTO PlaysFor VALUES (43, 'Surrey Titans')
	INTO PlaysFor VALUES (44, 'Surrey Titans')
	INTO PlaysFor VALUES (45, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (46, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (47, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (48, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (49, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (50, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (51, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (52, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (53, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (54, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (55, 'Coquitlam Sharks')
	INTO PlaysFor VALUES (56, 'Langley Bears')
	INTO PlaysFor VALUES (57, 'Langley Bears')
	INTO PlaysFor VALUES (58, 'Langley Bears')
	INTO PlaysFor VALUES (59, 'Langley Bears')
	INTO PlaysFor VALUES (60, 'Langley Bears')
	INTO PlaysFor VALUES (61, 'Langley Bears')
	INTO PlaysFor VALUES (62, 'Langley Bears')
	INTO PlaysFor VALUES (63, 'Langley Bears')
	INTO PlaysFor VALUES (64, 'Langley Bears')
	INTO PlaysFor VALUES (65, 'Langley Bears')
	INTO PlaysFor VALUES (66, 'Langley Bears')
SELECT * FROM dual;

INSERT ALL
	INTO GivenBy VALUES ('Adidas', 1)
	INTO GivenBy VALUES ('Coca-Cola', 2)
	INTO GivenBy VALUES ('Visa', 3)
	INTO GivenBy VALUES ('Adidas', 4)
	INTO GivenBy VALUES ('UBC', 5)
SELECT * FROM dual;

INSERT ALL
	INTO HasSponsor VALUES ('Vancouver Vipers', 'Adidas')
	INTO HasSponsor VALUES ('Richmond Thunder', 'Coca-Cola')
	INTO HasSponsor VALUES ('Burnaby Warriors', 'Visa')
	INTO HasSponsor VALUES ('Surrey Titans', 'Adidas')
	INTO HasSponsor VALUES ('Coquitlam Sharks', 'UBC')
SELECT * FROM dual;

INSERT ALL
	INTO LocatedIn VALUES (1, '5123 Main Street, Vancouver')
	INTO LocatedIn VALUES (2, '5789 Elm Road, Burnaby')
	INTO LocatedIn VALUES (3, '5234 Pine Street, Coquitlam')
	INTO LocatedIn VALUES (4, '5123 Main Street, Vancouver')
	INTO LocatedIn VALUES (5, '5456 Oak Avenue, Richmond')
	INTO LocatedIn VALUES (6, '5101 Maple Lane, Surrey')
	INTO LocatedIn VALUES (7, '5123 Main Street, Vancouver')
	INTO LocatedIn VALUES (8, '5234 Pine Street, Coquitlam')
	INTO LocatedIn VALUES (9, '1923 River Road, Langley')
	INTO LocatedIn VALUES (10, '5234 Pine Street, Coquitlam')
	INTO LocatedIn VALUES (11, '1923 River Road, Langley')
	INTO LocatedIn VALUES (12, '5101 Maple Lane, Surrey')
	INTO LocatedIn VALUES (13, '1923 River Road, Langley')
	INTO LocatedIn VALUES (14, '7212 Orange Crescent, Vancouver')
	INTO LocatedIn VALUES (15, '1182 History Street, Vancouver')
SELECT * FROM dual;

INSERT ALL
	INTO ParticipatesIn VALUES (1, 'Vancouver Vipers', 'Richmond Thunder')
	INTO ParticipatesIn VALUES (2, 'Burnaby Warriors', 'Surrey Titans')
	INTO ParticipatesIn VALUES (3, 'Coquitlam Sharks', 'Langley Bears')
	INTO ParticipatesIn VALUES (4, 'Vancouver Vipers', 'Burnaby Warriors')
	INTO ParticipatesIn VALUES (5, 'Richmond Thunder', 'Coquitlam Sharks')
	INTO ParticipatesIn VALUES (6, 'Surrey Titans', 'Langley Bears')
	INTO ParticipatesIn VALUES (7, 'Vancouver Vipers', 'Surrey Titans')
	INTO ParticipatesIn VALUES (8, 'Burnaby Warriors', 'Coquitlam Sharks')
	INTO ParticipatesIn VALUES (9, 'Richmond Thunder', 'Langley Bears')
	INTO ParticipatesIn VALUES (10, 'Vancouver Vipers', 'Coquitlam Sharks')
	INTO ParticipatesIn VALUES (11, 'Burnaby Warriors', 'Langley Bears')
	INTO ParticipatesIn VALUES (12, 'Richmond Thunder', 'Surrey Titans')
	INTO ParticipatesIn VALUES (13, 'Vancouver Vipers', 'Langley Bears')
	INTO ParticipatesIn VALUES (14, 'Richmond Thunder', 'Burnaby Warriors')
	INTO ParticipatesIn VALUES (15, 'Coquitlam Sharks', 'Surrey Titans')
SELECT * FROM dual;

INSERT ALL
    INTO WinsAward VALUES (1, 2, NULL)
    INTO WinsAward VALUES (2, 32, NULL)
    INTO WinsAward VALUES (3, 25, NULL)
    INTO WinsAward VALUES (4, NULL, 'Coquitlam Sharks')
    INTO WinsAward VALUES (5, NULL, 'Surrey Titans')
    INTO WinsAward VALUES (6, 2, NULL)
SELECT * FROM dual;

INSERT ALL
    INTO Referees VALUES (1, 1)
    INTO Referees VALUES (2, 1)
    INTO Referees VALUES (5, 2)
    INTO Referees VALUES (4, 2)
    INTO Referees VALUES (1, 3)
    INTO Referees VALUES (2, 3)
    INTO Referees VALUES (3, 4)
    INTO Referees VALUES (3, 5)
    INTO Referees VALUES (4, 6)
    INTO Referees VALUES (4, 7)
    INTO Referees VALUES (5, 7)
    INTO Referees VALUES (2, 8)
    INTO Referees VALUES (1, 8)
    INTO Referees VALUES (4, 8)
    INTO Referees VALUES (1, 9)
    INTO Referees VALUES (1, 10)
    INTO Referees VALUES (3, 11)
    INTO Referees VALUES (5, 12)
    INTO Referees VALUES (4, 13)
    INTO Referees VALUES (1, 13)
    INTO Referees VALUES (5, 14)
    INTO Referees VALUES (2, 15)
    INTO Referees VALUES (3, 15)
    INTO Referees VALUES (1, 15)
SELECT * FROM dual;
