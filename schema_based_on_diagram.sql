CREATE DATABASE hospital_clinic;

CREATE TABLE patients (
  id INTEGER GENERATED ALWAYS AS IDENTITY ,
  name VARCHAR(255) NOT NULL ,
  date_of_birth DATE ,
  PRIMARY KEY (id)
);

CREATE TABLE invoices (
  id INTEGER GENERATED ALWAYS AS IDENTITY ,
  total_amount DECIMAL,
  generated_at TIMESTAMP,
  payed_at  TIMESTAMP,
  medical_history_id INTEGER, 
  PRIMARY KEY (id)
);

CREATE TABLE invoice_items (
  id INTEGER GENERATED ALWAYS AS IDENTITY ,
  unit_price DECIMAL,
  quantity INTEGER,
  total_price DECIMAL,
  invoice_id INTEGER,
  treatment_id INTEGER,
  PRIMARY KEY (id)
);

CREATE TABLE medical_histories (
  id INTEGER GENERATED ALWAYS AS IDENTITY ,
  admited_at TIMESTAMP,
  patient_id INTEGER,
  status VARCHAR(255),
  PRIMARY KEY (id)
);

CREATE TABLE treatments (
  id INTEGER GENERATED ALWAYS AS IDENTITY ,
  type VARCHAR(255),
  name VARCHAR(255),
  PRIMARY KEY (id)
);
  
