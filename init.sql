
drop table if exists dict;
Create table dict (
  org VARCHAR collate "de_DE", 
  trans VARCHAR collate "de_DE", 
  pos VARCHAR collate "de_DE",
  lang_org VARCHAR collate "de_DE",
  lang_trans VARCHAR collate "de_DE"
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
  eq_class BIGINT,
  cnt SMALLINT
);
drop table if exists synon_1;
CREATE TABLE synon_1 (like synon);

DROP TABLE IF EXISTS homon cascade;
CREATE TABLE homon (
  id SERIAL,
  word VARCHAR,
  pos VARCHAR,
  lang VARCHAR,
  synon_id INT
);
drop table if exists homon_1;
CREATE TABLE homon_1 (like homon);
