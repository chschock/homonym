
drop table if exists dict;
Create table dict (
  org VARCHAR, 
  trans VARCHAR, 
  pos VARCHAR,
  lang_org VARCHAR,
  lang_trans VARCHAR
);

DROP TABLE IF EXISTS synon;
CREATE TABLE synon (
  word VARCHAR,
  synset VARCHAR[],
  pos VARCHAR,
  lang VARCHAR,
  cnt SMALLINT
);

DROP TABLE IF EXISTS homon;
CREATE TABLE homon (
  word VARCHAR,
  pos VARCHAR,
  lang VARCHAR,
  synset1 VARCHAR[],
  synset2 VARCHAR[]
);
