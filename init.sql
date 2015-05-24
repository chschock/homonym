
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
  image VARCHAR,
  synset VARCHAR[],
  pos VARCHAR,
  lang VARCHAR,
  lang_image VARCHAR,
  eq_class BIGINT,
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

DROP TABLE IF EXISTS homon_1;
CREATE TABLE homon_1 (like homon);
