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