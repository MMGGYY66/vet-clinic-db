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
WHERE name LIKE '%mon';
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
-- Delete all animals born after Jan 1st, 2022.
-- Create a savepoint for the transaction.
start transaction;
savepoint B4;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
-- Update all animals' weight to be their weight multiplied by -1.
start transaction;
UPDATE animals
SET weight_kg = weight_kg * -1;
-- Rollback to the savepoint
start transaction;
ROLLBACK to B4;
commit;
-- Update all animals' weights that are negative to be their weight multiplied by -1.
start transaction;
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
commit;
-- Write queries to answer the following questions:
-- How many animals are there?
SELECT COUNT(name)
FROM animals;
-- 11 animals
-- How many animals have never tried to escape?
SELECT COUNT(escape_attempts)
FROM animals
WHERE escape_attempts <= 0;
-- THE ANSWER IS 2
-- What is the average weight of animals?
SELECT AVG(weight_kg)
FROM animals;
-- the average weight IS 16.1363636363636364
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered,
    SUM(escape_attempts) total_attempts
FROM animals
GROUP BY neutered;
-- neutered 24 or not neutered 4
-- What is the minimum and maximum weight of each type of animal?
SELECT species,
    MIN(weight_kg) AS min_weight,
    MAX(weight_kg) max_weight
FROM animals
GROUP BY species;
-- species | min_weight | max_weight
---------+------------+------------
-- pokemon |         11 |         22
-- digimon |        5.7 |         45
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species,
    AVG(escape_attempts) AS av_escape_attempts
FROM animals
WHERE EXTRACT(
        YEAR
        FROM date_of_birth
    ) BETWEEN 1990 AND 2000
GROUP BY species;
--  species | av_escape_attempts
---------+--------------------
-- pokemon | 3.0000000000000000
-------------------------------------------
-------------------------------------------
-- Day 3 update -------
-- Write queries (using JOIN) to answer the following questions:
-- 1. What animals belong to Melody Pond?
SELECT name AS name_of_animal,
    full_name AS owner_full_name
FROM animals
    JOIN owners ON animals.owner_id = owners.id
WHERE full_name = 'Melody Pond';
-- Answer:
-- name_of_animal | owner_full_name
------------------+-----------------
-- Blossom        | Melody Pond
-- Squirtle       | Melody Pond
-- Charmander     | Melody Pond
-- (3 rows)
-- 2. List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name AS pokemons_only
FROM animals
    JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';
-- Answer:
-- pokemons_only
---------------
-- Pikachu
-- Blossom
-- Ditto
-- Squirtle
-- Charmander
--  (5 rows)
-- 3. List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name AS owner_full_name,
    name AS name_of_animal
FROM owners
    LEFT JOIN animals ON animals.owner_id = owners.id;
-- Answer:
-- owner_full_name | name_of_animal
-----------------+----------------
--Sam Smith       | Agumon
--Jennifer Orwell | Pikachu
--Jennifer Orwell | Gabumon
--Bob             | Plantmon
--Bob             | Devimon
--Melody Pond     | Charmander
--Melody Pond     | Squirtle
--Melody Pond     | Blossom
--Dean Winchester | Angemon
--Dean Winchester | Boarmon
--Jodie Whittaker |
--(11 rows)
-- 4. How many animals are there per species?
SELECT species.name AS name_of_species,
    COUNT(species_id) AS how_many_species
FROM species
    JOIN animals ON animals.species_id = species.id
GROUP BY species.name;
-- Answer:
--name_of_species | how_many_species
-----------------+------------------
--Pokemon         |                5
--Digimon         |                6
--(2 rows)
-- 5. List all Digimon owned by Jennifer Orwell.
SELECT name AS all_Digimons,
    full_name AS owner_full_name
FROM animals
    JOIN owners ON animals.owner_id = owners.id
WHERE full_name = 'Jennifer Orwell'
    AND name LIKE '%mon';
-- Answer:
--  all_digimons | owner_full_name
--------------+-----------------
-- Gabumon      | Jennifer Orwell
-- (1 row)
-- 6. List all animals owned by Dean Winchester that haven't tried to escape.
SELECT name AS name_of_animal,
    full_name AS owner_full_name
FROM animals
    JOIN owners ON animals.owner_id = owners.id
WHERE full_name = 'Dean Winchester'
    AND escape_attempts = 0;
-- Answer:
--  name_of_animal | owner_full_name
----------------+-----------------
--(0 rows)
-- 7. Who owns the most animals?
SELECT full_name AS owner_full_name,
    COUNT(owner_id) AS biggest_number_of_animals_owned
FROM animals
    JOIN owners ON animals.owner_id = owners.id
GROUP BY full_name
ORDER BY biggest_number_of_animals_owned DESC
LIMIT 1;
-- Answer:
-- owner_full_name | biggest_number_of_animals_owned
-----------------+---------------------------------
-- Melody Pond     |                 3
-- (1 row)
----------------------------------------------------------
----------------------------------------------------------
-- Day 4 ---- Write queries to answer the following:
--1. Who was the last animal seen by William Tatcher?
SELECT animals.name AS "last seen by William Tatcher"
FROM animals
    JOIN visits ON animals.id = visits.animals_id
    JOIN vets ON vets.id = visits.vets_id
WHERE vets.name = 'William Tatcher'
ORDER BY date_of_visit DESC
LIMIT 1;
-- Answer:
 --last seen by William Tatcher
------------------------------
 --Blossom
--(1 row)

--2. How many different animals did Stephanie Mendez see?
--3. List all vets and their specialties, including vets with no specialties.
--4. List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
--5. What animal has the most visits to vets?
--6. Who was Maisy Smith's first visit?
--7. Details for most recent visit: animal information, vet information, and date of visit.
--8. How many visits were with a vet that did not specialize in that animal's species?
--9. What specialty should Maisy Smith consider getting? Look for the species she gets the most.