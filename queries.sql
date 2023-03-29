/*Queries that provide answers to the questions from all projects.*/
-- Find all animals whose name ends in "mon".
SELECT *
FROM animals
WHERE name LIKE '%mon';
-- List the name of all animals born between 2016 and 2019.
SELECT *
FROM animals
WHERE EXTRACT(
		YEAR
		FROM date_of_birth
	) BETWEEN 2016 AND 2019;
-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT *
FROM animals
WHERE neutered = true
	AND escape_attempts < 3;
-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth
FROM animals
WHERE name IN('Agumon', 'Pikachu');
-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name,
	escape_attempts
FROM animals
WHERE weight_kg > 10.5;
-- Find all animals that are neutered.
SELECT *
FROM animals
WHERE neutered = true;
-- Find all animals not named Gabumon.
SELECT *
FROM animals
WHERE name != 'Gabumon';
-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT *
FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- new Queries day 2
-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.
start transaction;
savepoint B1;
UPDATE animals
SET species = 'unspecified';
-- Verify that the species column was updated.
start transaction;
ROLLBACK to B1;
select *
from animals;
commit;

start transaction;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE'%mon';
commit;

-- Verify that the species column was updated.
start transaction;
UPDATE animals
SET species = 'pokemon'
WHERE species = '';
commit;
-- Verify that the species column was updated.

-- Inside a transaction delete all records in the animals table, then roll back the transaction. After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual

start transaction;
savepoint B3;
DELETE FROM animals;
-- Verify that the species column was updated.
start transaction;
ROLLBACK to B3;
commit;
