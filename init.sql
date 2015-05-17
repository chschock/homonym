
drop table if exists dict;
Create table dict (
  org VARCHAR, 
  trans VARCHAR, 
  pos VARCHAR,
  lang_org VARCHAR,
  lang_trans VARCHAR
);

DROP TABLE IF EXISTS synon CASCADE;
CREATE TABLE synon (
  id SERIAL,
  word VARCHAR,
  word_trans VARCHAR,
  synset VARCHAR[],
  pos VARCHAR,
  lang VARCHAR,
  lang_trans VARCHAR,
  cnt SMALLINT
);

DROP TABLE IF EXISTS homon;
CREATE TABLE homon (
  id SERIAL,
  word VARCHAR,
  pos VARCHAR,
  lang VARCHAR,
  synon_id INT
);

DROP TABLE IF EXISTS homon_group;
CREATE TABLE homon_group (
  word VARCHAR,
  pos VARCHAR,
  lang VARCHAR,
  synsets VARCHAR[][],
  ssinfos VARCHAR[]
);
