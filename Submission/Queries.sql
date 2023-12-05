## 1 - Queries to show the tables, triggers, and constraints.
show tables;
show triggers;
select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA="cirque" ORDER BY TABLE_NAME;

## 2 - Basic Retrieval Query - Select names and citizenship of all musicians.
SELECT first_name, last_name, citizenship FROM PERFORMER WHERE performer_type="Musician";

## 3 - Retrieval with ordered results - All performers ordered by birth date - oldest first.
SELECT first_name, last_name, birthdate FROM PERFORMER ORDER BY birthdate ASC;

## 4 - Nested retrieval - Performers who performed Alegria in 2023:
SELECT first_name, last_name, performer_type FROM PERFORMER WHERE performer_id IN (
	SELECT performer_id FROM CREW WHERE (production_name="Alegria" AND production_year = 2023));

## 5 - Retrieval with JOIN - List of aerialist equipment which needs to be shiped to Edmonton for show dates in 2024. 

SELECT A.equipment, V.name, V.street, V.city, S.production_name, S.schedule_date FROM 
AERIAL_EQUIPMENT AS A JOIN
CREW AS C ON C.performer_id = A.aerialist_id
JOIN SCHEDULE AS S ON C.production_name = S.production_name AND C.production_year=S.production_year
JOIN VENUE AS V ON V.venue_id=S.venue_id
WHERE V.city="Edmonton" AND S.production_year=2024;

## 6 - Update with triggers - Update performer type - see TRIGGER changes propagate to performer, musician, instrument, and aerialist.
SELECT * from performer;
SELECT * from musician;
SELECT * from instrument;

UPDATE PERFORMER SET performer_type="Aerialist" WHERE performer_id=1;

SELECT * FROM PERFORMER;
SELECT * FROM MUSICIAN;
SELECT * FROM INSTRUMENT;
SELECT * FROM AERIALIST;

## 7 - Delete with triggers - Delete production 'Alegria - 2024'. See CASCADE changes propagate to Schedule and Crew. 
SELECT * FROM SCHEDULE;
SELECT * FROM CREW;

DELETE FROM PRODUCTION WHERE name="Alegria" AND year=2024;

SELECT * FROM SCHEDULE ORDER BY production_name ASC;
SELECT * FROM CREW ORDER BY production_year DESC;