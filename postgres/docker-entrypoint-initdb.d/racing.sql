-- Create the schema that we'll use to populate data and watch the effect in the binlog
CREATE SCHEMA racing;
SET search_path TO racing;

-- Create and populate our products using a single insert with many rows
CREATE TABLE affaires (
  id SERIAL NOT NULL PRIMARY KEY,
  libelle VARCHAR(255),
  finalite VARCHAR(512),
  canalEntree VARCHAR(255),
  descriptif VARCHAR(512),
  etude VARCHAR(32),
  realisation VARCHAR(32),
  centre VARCHAR(32)
);
ALTER TABLE affaires REPLICA IDENTITY FULL;
