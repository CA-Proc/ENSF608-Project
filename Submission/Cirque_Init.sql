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

INSERT INTO VENUE (name, capacity, street, city, province, transit)
VALUES ("Scotiabank Saddledome", 17200, "555 Saddledome Rise SE", "Calgary", "AB", true),
	("Sir Arthur Currie Barracks", 2700, "4225 Crowchild Trail SW", "Calgary", "AB", false),
    ("Rogers Place Arena", 24300, "10220 104 Ave NW", "Edmonton", "AB", true);

INSERT INTO PRODUCTION (name, year, sponsor, producer)
VALUES ("Alegria", 2024, "Westjet Ltd", "Martin Dignard"),
	("Kooza", 2024, "Loblaw Group", "Emile Dupont"),
    ("Alegria", 2023, "Royal Bank of Canada", "Martin Dignard"),
    ("Kooza", 2023, "Scotiabank", "Emile Dupont");
    
INSERT INTO PERFORMER_TYPE (performer_type)
VALUES ("Aerialist"),
	("Musician"),
    ("Entertainer");

delimiter $$
CREATE TRIGGER insert_performer_type
AFTER INSERT
	ON PERFORMER 
	FOR EACH ROW
	BEGIN
		IF NEW.performer_type="Musician" THEN
			INSERT INTO MUSICIAN (musician_id)
				VALUES (NEW.performer_id);
		ELSEIF NEW.performer_type="Aerialist" THEN
			INSERT INTO AERIALIST (aerialist_id)
				VALUES (NEW.performer_id);
		ELSEIF NEW.performer_type="Entertainer" THEN
			INSERT INTO ENTERTAINER (entertainer_id)
				VALUES (NEW.performer_id);
		END IF;
END$$
delimiter ;
    
INSERT INTO PERFORMER (first_name, last_name, citizenship, birthdate, diet, performer_type)
VALUES ("Andre", "Simard", "Canada", '1975-02-09', null, "Musician"),
("Jean-Michel", "Caron", "Canada", '1988-12-21', null, "Aerialist"),
("Jacques", "Boucher", "France", '1986-01-25', "Vegetarian", "Entertainer"),
("Dominic", "Champagne", "Belgium", '2001-08-18', "Celiac", "Musician"),
("Chantal", "Tremblay", "United States", '1999-05-01', null, "Aerialist"),
("Marie-Chantale", "Vallaincourt", "Canada", '1982-11-11', null, "Aerialist"),
("Elena", "Lev", "Russia", '1981-04-02', null, "Entertainer"),
("Barri", "Griffiths", "United Kingdom", '1982-02-08', null, "Musician");

UPDATE PERFORMER SET understudy=8 WHERE performer_id=1;
UPDATE PERFORMER SET understudy=5 WHERE performer_id=2;

INSERT INTO AERIAL_EQUIPMENT (aerialist_id, equipment)
VALUES (2, "Rings"),
		(2, "Silks"),
		(5, "Silks"),
		(6, "Rings"),
        (6, "Silks");

INSERT INTO INSTRUMENT (musician_id, instrument)
VALUES (1, "Drums"),
		(1, "Flute"),
        (4, "Harp"),
        (8, "Lyre");

UPDATE ENTERTAINER SET act="Juggling" WHERE entertainer_id=3;
UPDATE ENTERTAINER SET act="Singing" WHERE entertainer_id=7;

INSERT INTO EMERGENCY_CONTACT (performer_id, first_name, last_name, phone, relationship)
VALUES 	(1, "Rachel", "Simard", "1-403-555-0001", "Spouse"),
		(2, "Lucille", "Caron", "1-403-892-1700", "Spouse"),
        (3, "Emille", "Boucher", "1-403-888-1500", "Spouse"),
        (4, "Guy", "Champagne", "1-403-920-9090", "Father"),
        (5, "Michael", "Tremblay", "1-890-225-1590", "Spouse"),
        (6, "Eva", "Vallaincourt", "1-250-550-9295", "Daughter"),
        (7, "Ivan", "Donetz", "1-555-555-2929", "Friend"),
        (8, "Susan", "Griffiths", "1-520-205-5550", "Spouse");

INSERT INTO MEDICATION (performer_id, medication) 
VALUES 	(2, "Ibuprofin - 2x500mg daily"), 
		(5, "Arithromycin - 1x30mg daily"),
        (7, "Insulin - 10ml as needed");

INSERT INTO CREW (production_name, production_year, performer_id)
VALUES 	("Alegria", 2023, 1),
		("Alegria", 2023, 2),
        ("Alegria", 2023, 3),
        ("Kooza", 2023, 4),
        ("Kooza", 2023, 6), 
        ("Kooza", 2023, 7),
        ("Alegria", 2024, 1),
        ("Alegria", 2024, 2),
        ("Alegria", 2024, 3),
        ("Alegria", 2024, 5),
        ("Alegria", 2024, 8), 
        ("Kooza", 2024, 4),
        ("Kooza", 2024, 6),
        ("Kooza", 2024, 7);

INSERT INTO SCHEDULE (venue_id, production_name, production_year, schedule_date, location)
VALUES 	(1, "Alegria", 2023, '2023-06-15', "Main Stage"),
		(1, "Alegria", 2023, '2023-06-16', "Main Stage"),
        (1, "Kooza", 2023, '2023-08-20', "Main Stage"),
        (1, "Kooza", 2023, '2023-08-21', "Main Stage"),
        (1, "Alegria", 2024, '2024-06-15', "BMO Center - Lower Hall"),
        (1, "Alegria", 2024, '2024-06-16', "BMO Center - Lower Hall"),
        (1, "Kooza", 2024, '2024-08-20', "Main Stage"),
        (1, "Kooza", 2024, '2024-08-21', "Main Stage"),
        (2, "Alegria", 2023, '2023-07-10', "Tent"),
        (2, "Alegria", 2023, '2023-07-11', "Tent"),
        (2, "Alegria", 2024, '2024-07-15', "Tent"),
        (2, "Alegria", 2024, '2024-07-16', "Tent"),
        (3, "Kooza", 2024, '2024-08-27', "Hall C Floor"),
        (3, "Kooza", 2024, '2024-08-28', "Hall C Floor");

UPDATE AERIALIST SET sport="Dance" WHERE aerialist_id=2 OR aerialist_id=6;
UPDATE AERIALIST SET sport="Trapeze" WHERE aerialist_id=5;


delimiter $$
CREATE TRIGGER update_performer_type
BEFORE UPDATE
	ON PERFORMER 
	FOR EACH ROW
    BEGIN
		IF NOT(NEW.performer_type <=> OLD.performer_type) THEN
			IF OLD.performer_type="Musician" THEN
				DELETE FROM MUSICIAN WHERE musician_id=NEW.performer_id;
			ELSEIF OLD.performer_type="Aerialist" THEN
				DELETE FROM AERIALIST WHERE aerialist_id=NEW.performer_id;
			ELSEIF OLD.performer_type="Entertainer" THEN
				DELETE FROM ENTERTAINER WHERE entertainer_id=NEW.performer_id;
			END IF;
            
			IF NEW.performer_type="Musician" THEN
				INSERT INTO MUSICIAN (musician_id)
					VALUES (NEW.performer_id);
			ELSEIF NEW.performer_type="Aerialist" THEN
				INSERT INTO AERIALIST (aerialist_id)
					VALUES (NEW.performer_id);
			ELSEIF NEW.performer_type="Entertainer" THEN
				INSERT INTO ENTERTAINER (entertainer_id)
					VALUES (NEW.performer_id);
			END IF;
		END IF;
	END$$
delimiter ;	
    

    

    