
drop table if exists dict;
Create table dict (
  id serial,
  org VARCHAR collate "de_DE", 
  trans VARCHAR collate "de_DE", 
  pos VARCHAR collate "de_DE",
  lang_org VARCHAR collate "de_DE",
  lang_trans VARCHAR collate "de_DE",
  typ INT DEFAULT NULL,
  phrase_org VARCHAR collate "de_DE",
  phrase_trans VARCHAR collate "de_DE"
);

DROP TABLE IF EXISTS synon CASCADE;
CREATE TABLE synon (
  id SERIAL,
  word VARCHAR,
  image VARCHAR,
  synset VARCHAR[],
  pos VARCHAR,
  lang VARCHAR,
  lang_image VARCHAR,
  typ INT DEFAULT NULL,
  eq_class BIGINT,
  cnt SMALLINT,
  sound BOOLEAN DEFAULT FALSE
);
drop table if exists synon_1 cascade;
CREATE TABLE synon_1 (like synon);

DROP TABLE IF EXISTS homon cascade;
CREATE TABLE homon (
  id SERIAL,
  word VARCHAR,
  pos VARCHAR,
  lang VARCHAR,
  synon_id INT,
  sound BOOLEAN DEFAULT FALSE
);
drop table if exists homon_1 cascade;
CREATE TABLE homon_1 (like homon);
