/* Database schema to keep the structure of entire database. */
CREATE TABLE animals (
  id int primary key GENERATED ALWAYS AS IDENTITY,
  name varchar(100),
  date_of_birth date,
  escape_attempts int,
  neutered boolean,
  weight_kg decimal,
);
ALTER TABLE animals
ADD species varchar(100);
-- Day 3 --- Vet clinic database: query multiple tables
-- create owners table
CREATE TABLE owners (
  id int primary key GENERATED ALWAYS AS IDENTITY,
  full_name varchar(255),
  age int
);
-- create species table
CREATE TABLE species (
  id int primary key GENERATED ALWAYS AS IDENTITY,
  name varchar(255)
);
-- Modify animals table:
-- Remove column species
ALTER TABLE animals DROP COLUMN species;
-- Add species_id column to animals table
ALTER TABLE animals
ADD species_id INT;
ALTER TABLE animals
ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species (id) ON DELETE CASCADE;
-- Add owner_id column to animals table
ALTER TABLE animals
ADD owner_id INT;
ALTER TABLE animals
ADD CONSTRAINT fk_owners FOREIGN KEY (owner_id) REFERENCES owners (id) ON DELETE CASCADE;
----------------------------------------------------------
----------------------------------------------------------
-- Day 4 project —- 
-- create vets table
CREATE TABLE vets (
  id int primary key GENERATED ALWAYS AS IDENTITY,
  name varchar(255),
  age integer,
  date_of_graduation date
);
-- Create a "join table" called specializations to handle a many-to-many relationship between the tables species and vets
CREATE TABLE specializations(
  specializations_id SERIAL PRIMARY KEY,
  species_id INTEGER REFERENCES species(id),
  vets_id INTEGER REFERENCES vets(id)
);
-- Create a join table called visits to handle a many-to-many relationship between the tables animals and vets
CREATE TABLE visits(
  visit_id SERIAL PRIMARY KEY,
  animals_id INTEGER REFERENCES animals (id),
  vets_id INTEGER REFERENCES vets(id),
  date_of_visit DATE
);

/* Performance Audit week 2 Module 4*/
CREATE INDEX animal_id_desc ON visits(animals_id DESC);

CREATE INDEX vet_id_desc ON visits(vets_id DESC);

CREATE INDEX emails_desc ON owners(email DESC);
