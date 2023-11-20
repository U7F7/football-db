-- drop relational tables first
drop table PARTICIPATESIN;
drop table LOCATEDIN;
drop table HASSPONSOR;
drop table GIVENBY;
drop table WINSAWARD;
drop table PLAYSFOR;
drop table COACHES;
drop table REFEREES;
drop table RECORDSGAME;

-- drop entities (order may matter for PK/FKs)
drop table COACH;
drop table REFEREE;
drop table STATISTICS;
drop table AWARDS;
drop table SPONSOR;
drop table GAME;
drop table INJURY;
drop table ATHLETE;
drop table TEAM;
drop table VENUE;

-- drop DETAILS last
drop table AGEDETAILS;
drop table EXPERIENCEDETAILS;
drop table POSITIONDETAILS;
drop table SHOTDETAILS;
drop table PASSDETAILS;


/* Entities */

CREATE TABLE AgeDetails(
	birthdate date,
	age int,
	PRIMARY KEY(birthdate)
);

CREATE TABLE ExperienceDetails(
	date_started date,
	years_experience int,
    PRIMARY KEY(date_started)
);

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
	person_id int NOT NULL,
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
	FOREIGN KEY(birthdate) REFERENCES AgeDetails(birthdate)
		ON DELETE CASCADE,
		/* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY (date_started) REFERENCES ExperienceDetails(date_started)
		ON DELETE CASCADE,
		/* ON UPDATE CASCADE not supported will impl another way */
	FOREIGN KEY(current_team) REFERENCES Team(team_name),
--         ON DELETE NO ACTION, /* must point team to another team first*/ no required
		/* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY(jersey_num) REFERENCES PositionDetails(jersey_num)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE, not supported will impl another way */
);

CREATE TABLE Coach(
	person_id int NOT NULL,
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
    FOREIGN KEY(birthdate) REFERENCES AgeDetails(birthdate)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY (date_started) REFERENCES ExperienceDetails(date_started)
		ON DELETE CASCADE,
		/* ON UPDATE CASCADE not supported will impl another way */
	FOREIGN KEY(current_team) REFERENCES Team(team_name)
--         ON DELETE NO ACTION /* must point team to another team first*/ // not required
		/* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE ShotDetails(
	goals int,
	shots_taken int,
	shot_accuracy float,
	PRIMARY KEY(goals, shots_taken)
);

CREATE TABLE PassDetails(
	passes_attempted int,
	turnovers int,
	passing_percent float,
	PRIMARY KEY(passes_attempted, turnovers)
);

CREATE TABLE Referee(
	person_id int NOT NULL,
	name varchar(100),
	birthdate date,
	height float,
	weight float,
	phone_number int UNIQUE,
	email varchar(100) UNIQUE,
	address varchar(100),
	date_started date,
	certification_level int,
    PRIMARY KEY(person_id),
    FOREIGN KEY(birthdate) REFERENCES AgeDetails(birthdate)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY (date_started) REFERENCES ExperienceDetails(date_started)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE not supported will impl another way */
);

CREATE TABLE Statistics(
	stats_id int,
	person_id int UNIQUE NOT NULL,
	goals int,
	shots_taken int,
	games_played int,
	passes_attempted int,
	turnovers int,
	possession_percent float,
	PRIMARY KEY(stats_id),
	FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
		ON DELETE CASCADE,
		/* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY(goals, shots_taken) REFERENCES ShotDetails(goals, shots_taken)
		ON DELETE CASCADE,
		/* ON UPDATE CASCADE, not supported will impl another way */
	FOREIGN KEY(passes_attempted, turnovers) REFERENCES PassDetails(passes_attempted, turnovers)
		ON DELETE CASCADE
		/* ON UPDATE CASCADE, not supported will impl another way */
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

CREATE TABLE Game(
	game_id int,
	game_name varchar(100),
	game_data date,
	PRIMARY KEY(game_id)
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
    FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
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

CREATE TABLE RecordsGame(
    person_id int,
    stats_id int,
    game_id int,
    PRIMARY KEY (person_id, stats_id, game_id),
    FOREIGN KEY(person_id) REFERENCES Athlete(person_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(stats_id) REFERENCES Statistics(stats_id)
        ON DELETE CASCADE,
        /* ON UPDATE CASCADE not supported will impl another way */
    FOREIGN KEY(game_id) REFERENCES Game(game_id)
        ON DELETE CASCADE
        /* ON UPDATE CASCADE not supported will impl another way */
);

/* INSERTS */


INSERT ALL
    INTO AgeDetails VALUES ('1985-04-15', 38)
	INTO AgeDetails VALUES ('1992-09-25', 31)
	INTO AgeDetails VALUES ('1988-11-03', 34)
	INTO AgeDetails VALUES ('1995-07-19', 28)
	INTO AgeDetails VALUES ('1982-03-12', 41)
	INTO AgeDetails VALUES ('1998-05-29', 25)
	INTO AgeDetails VALUES ('1987-08-14', 36)
	INTO AgeDetails VALUES ('1990-01-02', 33)
	INTO AgeDetails VALUES ('1986-12-08', 36)
	INTO AgeDetails VALUES ('1994-04-23', 29)
	INTO AgeDetails VALUES ('1983-06-17', 40)
	INTO AgeDetails VALUES ('1997-10-30', 25)
    -- coach ends
	INTO AgeDetails VALUES ('1981-12-27', 41)
	INTO AgeDetails VALUES ('1999-02-10', 24)
	INTO AgeDetails VALUES ('1984-07-07', 39)
	INTO AgeDetails VALUES ('1991-03-18', 32)
	INTO AgeDetails VALUES ('1996-08-22', 27)
    -- ref ends
	INTO AgeDetails VALUES ('1989-12-05', 33)
	INTO AgeDetails VALUES ('1993-04-30', 30)
	INTO AgeDetails VALUES ('1980-06-14', 43)
    INTO AgeDetails VALUES ('1987-02-09', 36)
	INTO AgeDetails VALUES ('1993-09-12', 30)
	INTO AgeDetails VALUES ('1985-11-20', 37)
	INTO AgeDetails VALUES ('1991-07-06', 32)
	INTO AgeDetails VALUES ('1988-03-19', 34)
	INTO AgeDetails VALUES ('1996-05-02', 27)
	INTO AgeDetails VALUES ('1982-07-16', 41)
	INTO AgeDetails VALUES ('1998-11-25', 24)
	INTO AgeDetails VALUES ('1981-01-03', 42)
	INTO AgeDetails VALUES ('1994-06-28', 29)
	INTO AgeDetails VALUES ('1989-08-11', 33)
	INTO AgeDetails VALUES ('1995-12-14', 27)
	INTO AgeDetails VALUES ('1984-02-28', 39)
	INTO AgeDetails VALUES ('1990-04-10', 33)
	INTO AgeDetails VALUES ('1986-10-21', 36)
	INTO AgeDetails VALUES ('1992-02-03', 31)
	INTO AgeDetails VALUES ('1983-08-26', 40)
	INTO AgeDetails VALUES ('1997-01-09', 26)
	INTO AgeDetails VALUES ('1980-12-23', 42)
    INTO AgeDetails VALUES ('1986-04-17', 36)
	INTO AgeDetails VALUES ('1992-09-15', 31)
	INTO AgeDetails VALUES ('1988-11-23', 34)
	INTO AgeDetails VALUES ('1995-07-09', 28)
	INTO AgeDetails VALUES ('1982-03-26', 41)
	INTO AgeDetails VALUES ('1998-06-12', 25)
	INTO AgeDetails VALUES ('1987-08-28', 36)
	INTO AgeDetails VALUES ('1990-02-15', 33)
	INTO AgeDetails VALUES ('1986-12-21', 36)
	INTO AgeDetails VALUES ('1994-05-06', 29)
	INTO AgeDetails VALUES ('1983-07-01', 40)
	INTO AgeDetails VALUES ('1997-11-13', 25)
	INTO AgeDetails VALUES ('1981-01-27', 42)
	INTO AgeDetails VALUES ('1999-03-10', 24)
	INTO AgeDetails VALUES ('1984-07-21', 39)
	INTO AgeDetails VALUES ('1991-04-03', 32)
	INTO AgeDetails VALUES ('1996-09-17', 27)
	INTO AgeDetails VALUES ('1989-12-30', 33)
	INTO AgeDetails VALUES ('1993-05-15', 30)
	INTO AgeDetails VALUES ('1980-07-29', 43)
    INTO AgeDetails VALUES ('1987-02-27', 36)
	INTO AgeDetails VALUES ('1993-09-20', 30)
	INTO AgeDetails VALUES ('1985-11-18', 37)
	INTO AgeDetails VALUES ('1991-07-12', 32)
	INTO AgeDetails VALUES ('1988-03-25', 34)
	INTO AgeDetails VALUES ('1996-05-18', 27)
	INTO AgeDetails VALUES ('1982-07-26', 41)
	INTO AgeDetails VALUES ('1998-11-27', 24)
	INTO AgeDetails VALUES ('1981-01-09', 42)
	INTO AgeDetails VALUES ('1994-07-27', 29)
	INTO AgeDetails VALUES ('1989-09-15', 33)
	INTO AgeDetails VALUES ('1995-11-18', 27)
	INTO AgeDetails VALUES ('1984-03-30', 39)
	INTO AgeDetails VALUES ('1990-07-17', 33)
	INTO AgeDetails VALUES ('1986-09-02', 36)
	INTO AgeDetails VALUES ('1992-02-04', 31)
	INTO AgeDetails VALUES ('1983-08-23', 40)
	INTO AgeDetails VALUES ('1997-01-19', 26)
	INTO AgeDetails VALUES ('1980-12-03', 42)
    INTO AgeDetails VALUES ('1986-04-15', 36)
	INTO AgeDetails VALUES ('1992-09-30', 31)
	INTO AgeDetails VALUES ('1988-11-07', 34)
	INTO AgeDetails VALUES ('1995-07-12', 28)
	INTO AgeDetails VALUES ('1982-03-06', 41)
SELECT * FROM dual;

INSERT ALL
	INTO ExperienceDetails VALUES ('2000-07-10', 23)
	INTO ExperienceDetails VALUES ('2010-03-18', 13)
	INTO ExperienceDetails VALUES ('2005-12-05', 17)
	INTO ExperienceDetails VALUES ('2018-02-14', 5)
	INTO ExperienceDetails VALUES ('2002-09-22', 21)
	INTO ExperienceDetails VALUES ('2015-06-30', 8)
	INTO ExperienceDetails VALUES ('2004-04-03', 19)
	INTO ExperienceDetails VALUES ('2009-11-12', 13)
	INTO ExperienceDetails VALUES ('2007-07-27', 16)
	INTO ExperienceDetails VALUES ('2013-01-19', 10)
	INTO ExperienceDetails VALUES ('2001-10-09', 22)
	INTO ExperienceDetails VALUES ('2016-08-07', 7)
    -- coach ends
	INTO ExperienceDetails VALUES ('2003-05-14', 20)
	INTO ExperienceDetails VALUES ('2019-12-21', 3)
	INTO ExperienceDetails VALUES ('2006-02-16', 17)
	INTO ExperienceDetails VALUES ('2009-08-14', 14)
	INTO ExperienceDetails VALUES ('2017-05-25', 6)
    -- ref ends
	INTO ExperienceDetails VALUES ('2006-11-30', 16)
	INTO ExperienceDetails VALUES ('2014-09-07', 9)
	INTO ExperienceDetails VALUES ('2000-04-18', 23)
	INTO ExperienceDetails VALUES ('2010-10-10', 13)
	INTO ExperienceDetails VALUES ('2011-03-18', 12)
	INTO ExperienceDetails VALUES ('2005-02-05', 18)
	INTO ExperienceDetails VALUES ('2018-08-14', 5)
	INTO ExperienceDetails VALUES ('2002-12-22', 20)
	INTO ExperienceDetails VALUES ('2015-12-30', 7)
	INTO ExperienceDetails VALUES ('2004-06-03', 19)
	INTO ExperienceDetails VALUES ('2009-07-12', 14)
	INTO ExperienceDetails VALUES ('2007-09-27', 16)
	INTO ExperienceDetails VALUES ('2013-04-19', 10)
	INTO ExperienceDetails VALUES ('2001-08-09', 22)
	INTO ExperienceDetails VALUES ('2016-01-07', 7)
	INTO ExperienceDetails VALUES ('2003-09-14', 20)
	INTO ExperienceDetails VALUES ('2019-02-21', 3)
	INTO ExperienceDetails VALUES ('2006-07-16', 16)
	INTO ExperienceDetails VALUES ('2009-05-14', 14)
	INTO ExperienceDetails VALUES ('2017-08-25', 6)
	INTO ExperienceDetails VALUES ('2006-04-30', 16)
	INTO ExperienceDetails VALUES ('2014-11-07', 9)
	INTO ExperienceDetails VALUES ('2000-11-18', 22)
	INTO ExperienceDetails VALUES ('2008-10-01', 15)
	INTO ExperienceDetails VALUES ('2012-06-12', 11)
	INTO ExperienceDetails VALUES ('2005-08-23', 17)
	INTO ExperienceDetails VALUES ('2017-04-05', 6)
	INTO ExperienceDetails VALUES ('2003-02-14', 20)
	INTO ExperienceDetails VALUES ('2014-10-30', 9)
	INTO ExperienceDetails VALUES ('2009-03-01', 14)
	INTO ExperienceDetails VALUES ('2006-09-20', 16)
	INTO ExperienceDetails VALUES ('2010-12-10', 12)
	INTO ExperienceDetails VALUES ('2001-01-15', 22)
	INTO ExperienceDetails VALUES ('2015-07-17', 8)
    INTO ExperienceDetails VALUES ('2004-11-08', 18)
	INTO ExperienceDetails VALUES ('2018-06-25', 5)
	INTO ExperienceDetails VALUES ('2007-03-03', 16)
	INTO ExperienceDetails VALUES ('2012-08-14', 11)
	INTO ExperienceDetails VALUES ('2002-05-20', 21)
	INTO ExperienceDetails VALUES ('2016-04-09', 7)
	INTO ExperienceDetails VALUES ('2008-01-12', 15)
	INTO ExperienceDetails VALUES ('2011-09-27', 12)
	INTO ExperienceDetails VALUES ('2005-06-22', 17)
	INTO ExperienceDetails VALUES ('2017-01-05', 6)
	INTO ExperienceDetails VALUES ('2003-12-14', 20)
	INTO ExperienceDetails VALUES ('2014-07-30', 9)
	INTO ExperienceDetails VALUES ('2009-05-01', 14)
	INTO ExperienceDetails VALUES ('2006-10-20', 16)
	INTO ExperienceDetails VALUES ('2011-01-10', 12)
	INTO ExperienceDetails VALUES ('2001-02-15', 22)
	INTO ExperienceDetails VALUES ('2015-08-17', 8)
	INTO ExperienceDetails VALUES ('2004-12-08', 18)
	INTO ExperienceDetails VALUES ('2018-07-25', 5)
	INTO ExperienceDetails VALUES ('2007-04-03', 16)
	INTO ExperienceDetails VALUES ('2012-09-14', 11)
	INTO ExperienceDetails VALUES ('2002-06-20', 21)
	INTO ExperienceDetails VALUES ('2016-05-09', 7)
	INTO ExperienceDetails VALUES ('2008-02-12', 15)
	INTO ExperienceDetails VALUES ('2011-10-27', 12)
	INTO ExperienceDetails VALUES ('2005-07-22', 17)
	INTO ExperienceDetails VALUES ('2017-02-05', 6)
	INTO ExperienceDetails VALUES ('2004-01-14', 20)
	INTO ExperienceDetails VALUES ('2015-07-30', 8)
	INTO ExperienceDetails VALUES ('2010-05-01', 14)
	INTO ExperienceDetails VALUES ('2006-11-20', 16)
	INTO ExperienceDetails VALUES ('2011-02-10', 12)
SELECT * FROM dual;

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
SELECT * FROM dual;

INSERT ALL
	INTO ShotDetails VALUES (1, 2, 1/2)
	INTO ShotDetails VALUES (3, 4, 3/4)
	INTO ShotDetails VALUES (2, 6, 2/6)
	INTO ShotDetails VALUES (1, 4, 1/4)
	INTO ShotDetails VALUES (2, 8, 2/8)
	INTO ShotDetails VALUES (1, 10, 1/10)
	INTO ShotDetails VALUES (0, 4, 0/4)
	INTO ShotDetails VALUES (0, 6, 0/4)
SELECT * FROM dual;

INSERT ALL
	INTO PassDetails VALUES (50, 10, 1-10/50)
	INTO PassDetails VALUES (51, 11, 1-11/51)
	INTO PassDetails VALUES (52, 12, 1-12/52)
	INTO PassDetails VALUES (60, 15, 1-15/60)
	INTO PassDetails VALUES (60, 18, 1-18/60)
	INTO PassDetails VALUES (62, 12, 1-12/62)
	INTO PassDetails VALUES (60, 16, 1-16/60)
	INTO PassDetails VALUES (65, 15, 1-15/65)
	INTO PassDetails VALUES (69, 16, 1-16/69)
	INTO PassDetails VALUES (67, 13, 1-13/67)
SELECT * FROM dual;

INSERT ALL
	INTO Venue VALUES ('5123 Main Street, Vancouver', 'Benz Stadium', 10000)
	INTO Venue VALUES ('5456 Oak Avenue, Vancouver', 'Mountain View Stadium', 20000)
	INTO Venue VALUES ('5789 Elm Road, Vancouver', 'Evergreen Arena', 15000)
	INTO Venue VALUES ('5101 Maple Lane, Vancouver', 'Harbor View Stadium', 5000)
	INTO Venue VALUES ('5234 Pine Street, Vancouver', 'Sea View Arena', 34500)
    INTO Venue VALUES ('1923 River Road, Vancouver', 'Waterways Stadium', 17000)
    INTO Venue VALUES ('7212 Orange Crescent, Vancouver', 'Natural Neon Arena', 7500)
    INTO Venue VALUES ('1182 History Street, Vancouver', 'Old Books Building', 800)
SELECT * FROM dual;

INSERT ALL
	INTO Team VALUES ('Vancouver Vipers', 'John Wong', '5123 Main Street, Vancouver')
	INTO Team VALUES ('Vancouver Thunder', 'Emily Johnson', '5456 Oak Avenue, Vancouver')
	INTO Team VALUES ('Vancouver Warriors', 'Michael Brown', '5789 Elm Road, Vancouver')
	INTO Team VALUES ('Vancouver Titans', 'Sarah Lee', '5101 Maple Lane, Vancouver')
	INTO Team VALUES ('Vancouver Sharks', 'Robert Davis', '5234 Pine Street, Vancouver')
    INTO Team VALUES ('Vancouver Bears', 'Chris Huk', '1923 River Road, Vancouver')
SELECT * FROM dual;

INSERT ALL
    INTO Athlete VALUES (1, 'John Doe', '1985-04-15', 5.10, 170.5, 6041234567, 'john.doe@soccer.com', '123 Main St, Vancouver', '2000-07-10', 1, 'Vancouver Vipers', 60000)
	INTO Athlete VALUES (2, 'Jane Smith', '1992-09-25', 5.6, 140.2, 7782345678, 'jane.smith@soccer.com', '456 Oak St, Vancouver', '2010-03-18', 2, 'Vancouver Vipers', 70000)
	INTO Athlete VALUES (3, 'Mike Johnson', '1988-11-03', 6.0, 185.0, 6043456789, 'mike.johnson@soccer.com', '789 Elm St, Vancouver', '2005-12-05', 3, 'Vancouver Thunder', 80000)
	INTO Athlete VALUES (4, 'Sarah Lee', '1995-07-19', 5.7, 150.8, 7784567890, 'sarah.lee@soccer.com', '234 Birch St, Vancouver', '2018-02-14', 4, 'Vancouver Thunder', 90000)
	INTO Athlete VALUES (5, 'David Brown', '1982-03-12', 5.9, 175.3, 6045678901, 'david.brown@soccer.com', '567 Cedar St, Vancouver', '2002-09-22', 5, 'Vancouver Warriors', 100000)
	INTO Athlete VALUES (6, 'Emily White', '1998-05-29', 5.4, 130.1, 7786789012, 'emily.white@soccer.com', '890 Fir St, Vancouver', '2015-06-30', 6, 'Vancouver Warriors', 110000)
	INTO Athlete VALUES (7, 'Chris Anderson', '1987-08-14', 6.1, 190.6, 6047890123, 'chris.anderson@soccer.com', '123 Maple St, Vancouver', '2004-04-03', 7, 'Vancouver Titans', 120000)
	INTO Athlete VALUES (8, 'Laura Taylor', '1990-01-02', 5.8, 160.0, 7788901234, 'laura.taylor@soccer.com', '456 Pine St, Vancouver', '2009-11-12', 8, 'Vancouver Titans', 130000)
	INTO Athlete VALUES (9, 'Mark Wilson', '1986-12-08', 5.11, 180.4, 6049012345, 'mark.wilson@soccer.com', '789 Spruce St, Vancouver', '2007-07-27', 9, 'Vancouver Sharks', 140000)
	INTO Athlete VALUES (10, 'Ava Martin', '1994-04-23', 5.5, 145.9, 7780123456, 'ava.martin@soccer.com', '234 Oak St, Vancouver', '2013-01-19', 10, 'Vancouver Sharks', 150000)
SELECT * FROM dual;

INSERT ALL
	INTO Injury VALUES ('Arm', '2022-04-20', 0, 1)
	INTO Injury VALUES ('ACL', '2023-10-15', 1, 2)
	INTO Injury VALUES ('Leg', '2022-09-21', 0, 3)
	INTO Injury VALUES ('Head', '2021-10-30', 1, 4)
	INTO Injury VALUES ('Finger', '2022-01-22', 0, 5)
SELECT * FROM dual;

INSERT ALL
	INTO Game VALUES (1, 'Vancouver Vipers vs. Vancouver Thunder', '2022-01-28')
	INTO Game VALUES (2, 'Vancouver Warriors vs. Vancouver Titans', '2022-02-01')
	INTO Game VALUES (3, 'Vancouver Sharks vs. Vancouver Bears', '2022-06-02')
	INTO Game VALUES (4, 'Vancouver Vipers vs. Vancouver Warriors','2022-08-15')
	INTO Game VALUES (5, 'Vancouver Thunder vs. Vancouver Sharks', '2022-10-01')
	INTO Game VALUES (6, 'Vancouver Titans vs. Vancouver Bears', '2022-11-27')
	INTO Game VALUES (7, 'Vancouver Vipers vs. Vancouver Titans', '2022-12-18')
	INTO Game VALUES (8, 'Vancouver Warriors vs. Vancouver Sharks', '2023-02-05')
	INTO Game VALUES (9, 'Vancouver Thunder vs. Vancouver Bears', '2023-02-17')
	INTO Game VALUES (10, 'Vancouver Vipers vs. Vancouver Sharks', '2023-03-13')
	INTO Game VALUES (11, 'Vancouver Warriors vs. Vancouver Bears', '2023-05-24')
	INTO Game VALUES (12, 'Vancouver Thunder vs. Vancouver Titans', '2023-08-16')
	INTO Game VALUES (13, 'Vancouver Vipers vs. Vancouver Bears', '2023-09-01')
	INTO Game VALUES (14, 'Vancouver Thunder vs. Vancouver Warriors', '2023-09-08')
	INTO Game VALUES (15, 'Vancouver Sharks vs. Vancouver Titans', '2023-11-19')
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
SELECT * FROM dual;

INSERT ALL
	INTO Statistics VALUES (1, 1, 1, 2, 3, 50, 10, 40.0)
	INTO Statistics VALUES (2, 2, 3, 4, 3, 51, 11, 50.0)
	INTO Statistics VALUES (3, 3, 2, 6, 3, 52, 12, 45.0)
	INTO Statistics VALUES (4, 4, 1, 2, 3, 60, 15, 47.0)
	INTO Statistics VALUES (5, 5, 1, 2, 3, 60, 18, 40.1)
	INTO Statistics VALUES (6, 6, 1, 4, 3, 62, 12, 60.0)
	INTO Statistics VALUES (7, 7, 2, 8, 3, 60, 16, 65.0)
	INTO Statistics VALUES (8, 8, 1, 10, 3, 65, 15, 42.0)
	INTO Statistics VALUES (9, 9, 0, 4, 3, 69, 16, 41.0)
	INTO Statistics VALUES (10, 10, 0, 6, 3, 67, 13, 48.0)
SELECT * FROM dual;

INSERT ALL
	INTO Referee VALUES (1, 'Liam Taylor', '1991-03-18', 5.9, 168.7, 2361234567, 'liam.taylor@soccer.com', '567 Oak St, Vancouver', '2009-08-14', 1)
	INTO Referee VALUES (2, 'Ella Smith', '1996-08-22', 5.4, 135.2, 2362345678, 'ella.smith@soccer.com', '345 Elm St, Vancouver', '2017-05-25', 2)
	INTO Referee VALUES (3, 'Noah Johnson', '1989-12-05', 6.2, 190.8, 2363456789, 'noah.johnson@soccer.com', '678 Birch St, Vancouver', '2006-11-30', 3)
	INTO Referee VALUES (4, 'Mia Davis', '1993-04-30', 5.6, 150.3, 2364567890, 'mia.davis@soccer.com', '456 Cedar St, Vancouver', '2014-09-07', 4)
	INTO Referee VALUES (5, 'Oliver Anderson', '1980-06-14', 5.10, 178.2, 2365678901, 'oliver.anderson@soccer.com', '890 Pine St, Vancouver', '2000-04-18', 5)
SELECT * FROM dual;

INSERT ALL
    INTO Coach VALUES (1, 'Daniel Lee', '1985-04-15', 5.10, 175.2, 6048234567, 'daniel.lee@soccer.com', '567 Birch St, Vancouver', '2000-07-10', 'Vancouver Vipers', 'Head Coach')
	INTO Coach VALUES (2, 'Olivia Johnson', '1992-09-25', 5.6, 140.8, 7788345678, 'olivia.johnson@soccer.com', '890 Elm St, Vancouver', '2010-03-18', 'Vancouver Vipers', 'Assistant Coach')
	INTO Coach VALUES (3, 'William Smith', '1988-11-03', 5.11, 185.6, 6048456789, 'william.smith@soccer.com', '123 Cedar St, Vancouver', '2005-12-05', 'Vancouver Thunder', 'Head Coach')
	INTO Coach VALUES (4, 'Sophia Brown', '1995-07-19', 5.7, 150.1, 7788567890, 'sophia.brown@soccer.com', '456 Fir St, Vancouver', '2018-02-14', 'Vancouver Thunder', 'Assistant Coach')
	INTO Coach VALUES (5, 'James Anderson', '1982-03-12', 6.2, 195.0, 6048678901, 'james.anderson@soccer.com', '789 Pine St, Vancouver', '2002-09-22', 'Vancouver Warriors', 'Head Coach')
    INTO Coach VALUES (6, 'Simon Roach', '1998-05-29', 5.9, 140.5, 6045889120, 'simon.roach@soccer.com', '932 Red Oak St, Vancouver', '2015-06-30', 'Vancouver Warriors', 'Assistant Coach')
    INTO Coach VALUES (7, 'Madeline Bills', '1987-08-14', 5.6, 127.8, 7781029391, 'madeline.bills@soccer.com', '402 Ocean View Rd, Vancouver', '2004-04-03', 'Vancouver Titans', 'Head Coach')
    INTO Coach VALUES (8, 'Rachel Chu', '1990-01-02', 5.7, 112.0, 7789203019, 'rachel.chu@soccer.com', '102 Panther Lane, Vancouver', '2009-11-12', 'Vancouver Titans', 'Assistant Coach')
    INTO Coach VALUES (9, 'Oscar Rodriguez', '1986-12-08', 6.8, 223.7, 7780192939, 'oscar.rodriguez@soccer.com', '882 Parker Drive, Vancouver', '2007-07-27', 'Vancouver Sharks', 'Head Coach')
    INTO Coach VALUES (10, 'Natalie Nguyen', '1994-04-23', 6.1, 179.2, 6047789102, 'natalie.nguyen@soccer.com', '721 Red Roof Way, Vancouver', '2013-01-19', 'Vancouver Sharks', 'Assistant Coach')
    INTO Coach VALUES (11, 'Robert Barns', '1983-06-17', 5.10, 225.3, 6042102939, 'robert.barns@soccer.com', '900 Frankfurt Rd, Vancouver', '2001-10-09', 'Vancouver Bears', 'Head Coach')
    INTO Coach VALUES (12, 'Bill Bacon', '1997-10-30', 4.11, 155.3, 7781920392, 'bill.bacon@soccer.com', '562 Fox Den Lane, Vancouver', '2016-08-07', 'Vancouver Bears', 'Assistant Coach')
SELECT * FROM dual;

INSERT ALL
	INTO Coaches VALUES (1, 'Vancouver Vipers')
	INTO Coaches VALUES (2, 'Vancouver Thunder')
	INTO Coaches VALUES (3, 'Vancouver Warriors')
	INTO Coaches VALUES (4, 'Vancouver Titans')
	INTO Coaches VALUES (5, 'Vancouver Sharks')
SELECT * FROM dual;

INSERT ALL
	INTO PlaysFor VALUES (1, 'Vancouver Vipers')
	INTO PlaysFor VALUES (2, 'Vancouver Thunder')
	INTO PlaysFor VALUES (3, 'Vancouver Warriors')
	INTO PlaysFor VALUES (4, 'Vancouver Titans')
	INTO PlaysFor VALUES (5, 'Vancouver Sharks')
	INTO PlaysFor VALUES (6, 'Vancouver Vipers')
	INTO PlaysFor VALUES (7, 'Vancouver Thunder')
	INTO PlaysFor VALUES (8, 'Vancouver Warriors')
	INTO PlaysFor VALUES (9, 'Vancouver Titans')
	INTO PlaysFor VALUES (10, 'Vancouver Sharks')
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
	INTO HasSponsor VALUES ('Vancouver Thunder', 'Coca-Cola')
	INTO HasSponsor VALUES ('Vancouver Warriors', 'Visa')
	INTO HasSponsor VALUES ('Vancouver Titans', 'Adidas')
	INTO HasSponsor VALUES ('Vancouver Sharks', 'UBC')
SELECT * FROM dual;

INSERT ALL
	INTO LocatedIn VALUES (1, '5234 Pine Street, Vancouver')
	INTO LocatedIn VALUES (2, '5789 Elm Road, Vancouver')
	INTO LocatedIn VALUES (3, '5234 Pine Street, Vancouver')
	INTO LocatedIn VALUES (4, '5101 Maple Lane, Vancouver')
	INTO LocatedIn VALUES (5, '5456 Oak Avenue, Vancouver')
SELECT * FROM dual;

INSERT ALL
	INTO ParticipatesIn VALUES (1, 'Vancouver Vipers', 'Vancouver Thunder')
	INTO ParticipatesIn VALUES (2, 'Vancouver Warriors', 'Vancouver Titans')
	INTO ParticipatesIn VALUES (3, 'Vancouver Sharks', 'Vancouver Bears')
	INTO ParticipatesIn VALUES (4, 'Vancouver Vipers', 'Vancouver Warriors')
	INTO ParticipatesIn VALUES (5, 'Vancouver Thunder', 'Vancouver Sharks')
	INTO ParticipatesIn VALUES (6, 'Vancouver Titans', 'Vancouver Bears')
	INTO ParticipatesIn VALUES (7, 'Vancouver Vipers', 'Vancouver Titans')
	INTO ParticipatesIn VALUES (8, 'Vancouver Warriors', 'Vancouver Sharks')
	INTO ParticipatesIn VALUES (9, 'Vancouver Thunder', 'Vancouver Bears')
	INTO ParticipatesIn VALUES (10, 'Vancouver Vipers', 'Vancouver Sharks')
	INTO ParticipatesIn VALUES (11, 'Vancouver Warriors', 'Vancouver Bears')
	INTO ParticipatesIn VALUES (12, 'Vancouver Thunder', 'Vancouver Titans')
	INTO ParticipatesIn VALUES (13, 'Vancouver Vipers', 'Vancouver Bears')
	INTO ParticipatesIn VALUES (14, 'Vancouver Thunder', 'Vancouver Warriors')
	INTO ParticipatesIn VALUES (15, 'Vancouver Sharks', 'Vancouver Titans')
SELECT * FROM dual;

INSERT ALL
	INTO WinsAward VALUES (1, 2, 'Vancouver Vipers')
	INTO WinsAward VALUES (2, 6, 'Vancouver Warriors')
	INTO WinsAward VALUES (3, 6, 'Vancouver Warriors')
	INTO WinsAward VALUES (4, 1, 'Vancouver Vipers')
	INTO WinsAward VALUES (5, 8, 'Vancouver Titans')
SELECT * FROM dual;

INSERT ALL
    INTO Referees VALUES (1, 2)
    INTO Referees VALUES (2, 2)
    INTO Referees VALUES (5, 1)
    INTO Referees VALUES (4, 5)
    INTO Referees VALUES (1, 3)
SELECT * FROM dual;

INSERT ALL
    INTO RecordsGame VALUES (1, 1, 1)
    INTO RecordsGame VALUES (4, 4, 1)
    INTO RecordsGame VALUES (3, 3, 4)
    INTO RecordsGame VALUES (3, 3, 3)
    INTO RecordsGame VALUES (5, 5, 3)
SELECT * FROM dual;

