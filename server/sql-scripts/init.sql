drop table COACH;
drop table REFEREE;
drop table STATISTICS;
drop table SHOTDETAILS;
drop table PASSDETAILS;
drop table AWARDS;
drop table SPONSOR;
drop table EVENT;
drop table INJURY;
drop table ATHLETE;
drop table PERSON;
drop table AGEDETAILS;
drop table EXPERIENCEDETAILS;
drop table TEAM;
drop table VENUE;
drop table POSITIONDETAILS;
drop table PLAYSFOR;
drop table COACHES;
drop table PARTICIPATESIN;
drop table LOCATEDIN;
drop table HASSPONSOR;
drop table GIVENBY;
drop table WINSAWARD;

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

-- CREATE TABLE Person(
-- 	person_id int,
-- 	name varchar(100),
-- 	birthdate date,
-- 	height float,
-- 	weight float,
-- 	phone_number int UNIQUE,
-- 	email varchar(100) UNIQUE,
-- 	address varchar(100),
-- 	date_started date,
-- 	PRIMARY KEY(person_id),
-- 	FOREIGN KEY(birthdate) REFERENCES AgeDetails(birthdate)
-- 		ON DELETE CASCADE,
-- 		/* ON UPDATE CASCADE, not supported will impl another way */
-- 	FOREIGN KEY (date_started) REFERENCES ExperienceDetails(date_started)
-- 		ON DELETE CASCADE
-- 		/* ON UPDATE CASCADE not supported will impl another way */
-- );

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

CREATE TABLE Event(
	event_id int,
	event_name varchar(100),
	event_data date,
	PRIMARY KEY(event_id)
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

/* Relationship Tables that were necessary */
CREATE TABLE PlaysFor(
	person_id int,
	team_name varchar(100),
	PRIMARY KEY(person_id, team_name)
);

CREATE TABLE Coaches(
	person_id int,
	team_name varchar(100),
	PRIMARY KEY(person_id, team_name)
);

CREATE TABLE ParticipatesIn(
	team_name varchar(100),
	event_id int,
	PRIMARY KEY(team_name, event_id)
);

CREATE TABLE LocatedIn(
	event_id int,
	venue_address varchar(100),
	PRIMARY KEY(event_id, venue_address)
);

CREATE TABLE HasSponsor(
	team_name varchar(100),
	sponsor_name varchar(100),
	PRIMARY KEY(team_name, sponsor_name)
);

CREATE TABLE GivenBy(
	sponsor_name varchar(100),
	award_id int,
	PRIMARY KEY(sponsor_name, award_id)
);

CREATE TABLE WinsAward(
	award_id int,
	person_id int,
	team_name varchar(100),
	PRIMARY KEY(award_id),
	UNIQUE(person_id, team_name)
);

-- INSERTS

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
	INTO AgeDetails VALUES ('1981-12-27', 41)
	INTO AgeDetails VALUES ('1999-02-10', 24)
	INTO AgeDetails VALUES ('1984-07-07', 39)
	INTO AgeDetails VALUES ('1991-03-18', 32)
	INTO AgeDetails VALUES ('1996-08-22', 27)
	INTO AgeDetails VALUES ('1989-12-05', 33)
	INTO AgeDetails VALUES ('1993-04-30', 30)
	INTO AgeDetails VALUES ('1980-06-14', 43)
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
	INTO ExperienceDetails VALUES ('2003-05-14', 20)
	INTO ExperienceDetails VALUES ('2019-12-21', 3)
	INTO ExperienceDetails VALUES ('2006-02-16', 17)
	INTO ExperienceDetails VALUES ('2009-08-14', 14)
	INTO ExperienceDetails VALUES ('2017-05-25', 6)
	INTO ExperienceDetails VALUES ('2006-11-30', 16)
	INTO ExperienceDetails VALUES ('2014-09-07', 9)
	INTO ExperienceDetails VALUES ('2000-04-18', 23)
SELECT * FROM dual;

-- INSERT ALL
-- 	/* Athletes for Team - each team two players for now*/
-- 	INTO Person	VALUES (1, 'John Doe', '1985-04-15', 5.10, 170.5, 6041234567, 'john.doe@soccer.com', '123 Main St, Vancouver', '2000-07-10')
-- 	INTO Person	VALUES (2, 'Jane Smith', '1992-09-25', 5.6, 140.2, 7782345678, 'jane.smith@soccer.com', '456 Oak St, Vancouver', '2010-03-18')
-- 	INTO Person	VALUES (3, 'Mike Johnson', '1988-11-03', 6.0, 185.0, 6043456789, 'mike.johnson@soccer.com', '789 Elm St, Vancouver', '2005-12-05')
-- 	INTO Person	VALUES (4, 'Sarah Lee', '1995-07-19', 5.7, 150.8, 7784567890, 'sarah.lee@soccer.com', '234 Birch St, Vancouver', '2018-02-14')
-- 	INTO Person	VALUES (5, 'David Brown', '1982-03-12', 5.9, 175.3, 6045678901, 'david.brown@soccer.com', '567 Cedar St, Vancouver', '2002-09-22')
-- 	INTO Person	VALUES (6, 'Emily White', '1998-05-29', 5.4, 130.1, 7786789012, 'emily.white@soccer.com', '890 Fir St, Vancouver', '2015-06-30')
-- 	INTO Person	VALUES (7, 'Chris Anderson', '1987-08-14', 6.1, 190.6, 6047890123, 'chris.anderson@soccer.com', '123 Maple St, Vancouver', '2004-04-03')
-- 	INTO Person	VALUES (8, 'Laura Taylor', '1990-01-02', 5.8, 160.0, 7788901234, 'laura.taylor@soccer.com', '456 Pine St, Vancouver', '2009-11-12')
-- 	INTO Person	VALUES (9, 'Mark Wilson', '1986-12-08', 5.11, 180.4, 6049012345, 'mark.wilson@soccer.com', '789 Spruce St, Vancouver', '2007-07-27')
-- 	INTO Person	VALUES (10, 'Ava Martin', '1994-04-23', 5.5, 145.9, 7780123456, 'ava.martin@soccer.com', '234 Oak St, Vancouver', '2013-01-19')
-- 	/* Coaches*/
-- 	INTO Person	VALUES (11, 'Daniel Lee', '1983-06-17', 5.10, 175.2, 6048234567, 'daniel.lee@soccer.com', '567 Birch St, Vancouver', '2001-10-09')
-- 	INTO Person	VALUES (12, 'Olivia Johnson', '1997-10-30', 5.6, 140.8, 7788345678, 'olivia.johnson@soccer.com', '890 Elm St, Vancouver', '2016-08-07')
-- 	INTO Person	VALUES (13, 'William Smith', '1981-12-27', 5.11, 185.6, 6048456789, 'william.smith@soccer.com', '123 Cedar St, Vancouver', '2003-05-14')
-- 	INTO Person	VALUES (14, 'Sophia Brown', '1999-02-10', 5.7, 150.1, 7788567890, 'sophia.brown@soccer.com', '456 Fir St, Vancouver', '2019-12-21')
-- 	INTO Person	VALUES (15, 'James Anderson', '1984-07-07', 6.2, 195.0, 6048678901, 'james.anderson@soccer.com', '789 Pine St, Vancouver', '2006-02-16')
-- 	/* Referees */
-- 	INTO Person	VALUES (16, 'Liam Taylor', '1991-03-18', 5.9, 168.7, 2361234567, 'liam.taylor@soccer.com', '567 Oak St, Vancouver', '2009-08-14')
-- 	INTO Person	VALUES (17, 'Ella Smith', '1996-08-22', 5.4, 135.2, 2362345678, 'ella.smith@soccer.com', '345 Elm St, Vancouver', '2017-05-25')
-- 	INTO Person	VALUES (18, 'Noah Johnson', '1989-12-05', 6.2, 190.8, 2363456789, 'noah.johnson@soccer.com', '678 Birch St, Vancouver', '2006-11-30')
-- 	INTO Person	VALUES (19, 'Mia Davis', '1993-04-30', 5.6, 150.3, 2364567890, 'mia.davis@soccer.com', '456 Cedar St, Vancouver', '2014-09-07')
-- 	INTO Person	VALUES (20, 'Oliver Anderson', '1980-06-14', 5.10, 178.2, 2365678901, 'oliver.anderson@soccer.com', '890 Pine St, Vancouver', '2000-04-18')
-- SELECT * FROM dual;

INSERT ALL
	INTO Venue VALUES ('5123 Main Street, Vancouver', 'Benz Stadium', 10000)
	INTO Venue VALUES ('5456 Oak Avenue, Vancouver', 'Mountainview Stadium', 20000)
	INTO Venue VALUES ('5789 Elm Road, Vancouver', 'Evergreen Arena', 15000)
	INTO Venue VALUES ('5101 Maple Lane, Vancouver', 'Harborview Stadium', 5000)
	INTO Venue VALUES ('5234 Pine Street, Vancouver', 'Seaview Arena', 34500)
SELECT * FROM dual;

INSERT ALL
	INTO Team VALUES ('Vancouver Vipers', 'John Wong', '5123 Main Street, Vancouver')
	INTO Team VALUES ('Vancouver Thunder', 'Emily Johnson', '5456 Oak Avenue, Vancouver')
	INTO Team VALUES ('Vancouver Warriors', 'Michael Brown', '5789 Elm Road, Vancouver')
	INTO Team VALUES ('Vancouver Titans', 'Sarah Lee', '5101 Maple Lane, Vancouver')
	INTO Team VALUES ('Vancouver Sharks', 'Robert Davis', '5234 Pine Street, Vancouver')
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
    INTO Coach	VALUES (11, 'Daniel Lee', '1983-06-17', 5.10, 175.2, 6048234567, 'daniel.lee@soccer.com', '567 Birch St, Vancouver', '2001-10-09', 'Vancouver Vipers', 'Assistant Coach')
	INTO Coach	VALUES (12, 'Olivia Johnson', '1997-10-30', 5.6, 140.8, 7788345678, 'olivia.johnson@soccer.com', '890 Elm St, Vancouver', '2016-08-07', 'Vancouver Thunder', 'Assistant Coach')
	INTO Coach	VALUES (13, 'William Smith', '1981-12-27', 5.11, 185.6, 6048456789, 'william.smith@soccer.com', '123 Cedar St, Vancouver', '2003-05-14', 'Vancouver Warriors', 'Head Coach')
	INTO Coach	VALUES (14, 'Sophia Brown', '1999-02-10', 5.7, 150.1, 7788567890, 'sophia.brown@soccer.com', '456 Fir St, Vancouver', '2019-12-21', 'Vancouver Titans', 'Head Coach')
	INTO Coach	VALUES (15, 'James Anderson', '1984-07-07', 6.2, 195.0, 6048678901, 'james.anderson@soccer.com', '789 Pine St, Vancouver', '2006-02-16', 'Vancouver Sharks', 'Assistant Coach')
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
	INTO Referee VALUES (16, 'Liam Taylor', '1991-03-18', 5.9, 168.7, 2361234567, 'liam.taylor@soccer.com', '567 Oak St, Vancouver', '2009-08-14', 1)
	INTO Referee VALUES (17, 'Ella Smith', '1996-08-22', 5.4, 135.2, 2362345678, 'ella.smith@soccer.com', '345 Elm St, Vancouver', '2017-05-25', 2)
	INTO Referee VALUES (18, 'Noah Johnson', '1989-12-05', 6.2, 190.8, 2363456789, 'noah.johnson@soccer.com', '678 Birch St, Vancouver', '2006-11-30', 3)
	INTO Referee VALUES (19, 'Mia Davis', '1993-04-30', 5.6, 150.3, 2364567890, 'mia.davis@soccer.com', '456 Cedar St, Vancouver', '2014-09-07', 4)
	INTO Referee VALUES (20, 'Oliver Anderson', '1980-06-14', 5.10, 178.2, 2365678901, 'oliver.anderson@soccer.com', '890 Pine St, Vancouver', '2000-04-18', 5)
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
	INTO Awards VALUES (1, 2023, 'Offensive Player of the Year')
	INTO Awards VALUES (2, 2023, 'Defensive Player of the Year')
	INTO Awards VALUES (3, 2022, 'Offensive Player of the Year')
	INTO Awards VALUES (4, 2022, 'Team of the Year')
	INTO Awards VALUES (5, 2023, 'Team of the Year')
SELECT * FROM dual;

INSERT ALL
	INTO Sponsor VALUES ('Coca-Cola', 'sponsor@coca-colacompany.com', 50000)
	INTO Sponsor VALUES ('Adidas', 'sponsor@adidas.com', 40000)
	INTO Sponsor VALUES ('Visa', 'sponsor@visa.ca', 60000)
	INTO Sponsor VALUES ('UBC', 'sponsor@ubc.ca', 2000)
	INTO Sponsor VALUES ('Hyundai', 'sponsor@hyundaimotorgroup.com', 80000)
SELECT * FROM dual;



INSERT ALL
	INTO Event VALUES (1, 'Vancouver Warriors vs. Vancouver Sharks', '2022-01-28')
	INTO Event VALUES (2, 'Coca-Cola Fundraiser Special', '2021-02-01')
	INTO Event VALUES (3, 'Vancouver Sharks vs. Vancouver Titans', '2022-06-02')
	INTO Event VALUES (4, 'Vancouver Vipers vs. Vancouver Titans','2023-08-15')
	INTO Event VALUES (5, 'Vancouver Thunder Practice Game', '2022-10-27')
SELECT * FROM dual;

INSERT ALL
	INTO Injury VALUES ('Arm', '2022-04-20', 0, 1)
	INTO Injury VALUES ('ACL', '2023-10-15', 1, 2)
	INTO Injury VALUES ('Leg', '2022-09-21', 0, 3)
	INTO Injury VALUES ('Head', '2021-10-30', 1, 4)
	INTO Injury VALUES ('Finger', '2022-01-22', 0, 5)
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
	INTO Coaches VALUES (1, 'Vancouver Vipers')
	INTO Coaches VALUES (2, 'Vancouver Thunder')
	INTO Coaches VALUES (3, 'Vancouver Warriors')
	INTO Coaches VALUES (4, 'Vancouver Titans')
	INTO Coaches VALUES (5, 'Vancouver Sharks')
SELECT * FROM dual;

INSERT ALL
	INTO ParticipatesIn VALUES ('Vancouver Warriors', 1)
	INTO ParticipatesIn VALUES ('Vancouver Sharks', 1)
	INTO ParticipatesIn VALUES ('Vancouver Titans', 3)
	INTO ParticipatesIn VALUES ('Vancouver Sharks', 3)
	INTO ParticipatesIn VALUES ('Vancouver Vipers', 4)
	INTO ParticipatesIn VALUES ('Vancouver Titans', 4)
	INTO ParticipatesIn VALUES ('Vancouver Thunder', 5)
SELECT * FROM dual;

INSERT ALL
	INTO LocatedIn VALUES (1, '5234 Pine Street, Vancouver')
	INTO LocatedIn VALUES (2, '5789 Elm Road, Vancouver')
	INTO LocatedIn VALUES (3, '5234 Pine Street, Vancouver')
	INTO LocatedIn VALUES (4, '5101 Maple Lane, Vancouver')
	INTO LocatedIn VALUES (5, '5456 Oak Avenue, Vancouver')
SELECT * FROM dual;

INSERT ALL
	INTO HasSponsor VALUES ('Vancouver Vipers', 'Adidas')
	INTO HasSponsor VALUES ('Vancouver Thunder', 'Coca-Cola')
	INTO HasSponsor VALUES ('Vancouver Warriors', 'Visa')
	INTO HasSponsor VALUES ('Vancouver Titans', 'Adidas')
	INTO HasSponsor VALUES ('Vancouver Sharks', 'UBC')
SELECT * FROM dual;

INSERT ALL
	INTO GivenBy VALUES ('Adidas', 1)
	INTO GivenBy VALUES ('Coca-Cola', 2)
	INTO GivenBy VALUES ('Visa', 3)
	INTO GivenBy VALUES ('Adidas', 4)
	INTO GivenBy VALUES ('UBC', 5)
SELECT * FROM dual;

INSERT ALL
	INTO WinsAward VALUES (1, 2, NULL)
	INTO WinsAward VALUES (2, 14, NULL)
	INTO WinsAward VALUES (3, NULL, 'Vancouver Warriors')
	INTO WinsAward VALUES (4, NULL, 'Vancouver Vipers')
	INTO WinsAward VALUES (5, 8, NULL)
SELECT * FROM dual;

