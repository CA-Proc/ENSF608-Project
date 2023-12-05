DROP DATABASE IF EXISTS CIRQUE;
CREATE DATABASE CIRQUE;
USE CIRQUE;

CREATE TABLE PERFORMER_TYPE(
	performer_type varchar(25) NOT NULL,
	primary key (performer_type)
);

CREATE TABLE PERFORMER(
	performer_id int NOT NULL AUTO_INCREMENT,
    first_name varchar(30),
    last_name varchar(30),
    citizenship varchar(30),
    birthdate date,
    diet varchar (200),
    understudy int,
    performer_type varchar(25) NOT NULL,
    primary key (performer_id),
    foreign key (performer_type) references PERFORMER_TYPE(performer_type),
    foreign key (understudy) references PERFORMER(performer_id) ON DELETE SET NULL
);

CREATE TABLE MEDICATION(
	performer_id int NOT NULL,
    medication varchar(60) NOT NULL,
    primary key (performer_id, medication),
    foreign key (performer_id) references PERFORMER(performer_id) ON DELETE CASCADE
);

CREATE TABLE EMERGENCY_CONTACT(
	performer_id int NOT NULL,
    first_name varchar(30),
    last_name varchar(30),
    phone varchar(15) NOT NULL,
    relationship varchar(20),
    primary key (performer_id),
    foreign key (performer_id) references PERFORMER(performer_id) ON DELETE CASCADE
);

CREATE TABLE MUSICIAN(
	musician_id int NOT NULL,
    primary key (musician_id),
    foreign key (musician_id) references PERFORMER(performer_id) ON DELETE CASCADE
);

CREATE TABLE ENTERTAINER(
	entertainer_id int NOT NULL,
    act varchar(30),
    primary key (entertainer_id),
    foreign key (entertainer_id) references PERFORMER(performer_id) ON DELETE CASCADE
);

CREATE TABLE AERIALIST(
	aerialist_id int NOT NULL,
    sport varchar(30),
    primary key (aerialist_id),
    foreign key(aerialist_id) references PERFORMER(performer_id) ON DELETE CASCADE
);

CREATE TABLE INSTRUMENT(
	musician_id int,
    instrument varchar(30),
    primary key (musician_id, instrument),
    foreign key (musician_id) references MUSICIAN(musician_id) ON DELETE CASCADE
);
	
CREATE TABLE AERIAL_EQUIPMENT(
	aerialist_id int,
    equipment varchar(30),
    primary key (aerialist_id, equipment),
    foreign key (aerialist_id) references AERIALIST(aerialist_id) ON DELETE CASCADE
);

CREATE TABLE PRODUCTION(
	name varchar(60),
    year int,
    sponsor varchar(90),
    producer varchar(90),
    primary key (name, year)
);

CREATE TABLE VENUE(
	venue_id int NOT NULL AUTO_INCREMENT,
    name varchar(60),
    capacity int,
    street varchar(60),
    city varchar(30), 
    province varchar(30),
    transit boolean,
    primary key (venue_id)
);

CREATE TABLE SCHEDULE(
	venue_id int,
    production_name varchar(60),
    production_year int,
    schedule_date date,
    location varchar(30),
    primary key (venue_id, production_name, production_year, schedule_date),
    foreign key (venue_id) references VENUE(venue_id),
    foreign key (production_name, production_year) references PRODUCTION(name,year)  ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE CREW(
	production_name varchar(60),
    production_year int,
    performer_id int,
    primary key (production_name, production_year, performer_id),
    foreign key (production_name, production_year) references PRODUCTION(name,year) ON UPDATE CASCADE ON DELETE CASCADE,
    foreign key (performer_id) references PERFORMER(performer_id)
);



    

    