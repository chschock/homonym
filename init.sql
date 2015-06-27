drop schema if exists public cascade;
create schema public;

create table dict_complete (
  id serial primary key,
  org varchar collate "de_DE",
  trans varchar collate "de_DE",
  pos varchar collate "de_DE",
  lang_org varchar collate "de_DE",
  lang_trans varchar collate "de_DE",
  typ int default null,
  phrase_org varchar collate "de_DE",
  phrase_trans varchar collate "de_DE"
);

create table dict (like dict_complete);

create table lang_weight (
lang    varchar,
weight  real
);

create table pronoun (
  id serial,
  lang varchar,
  pp varchar,
  cnt int
);

create table synon (
  id int primary key,
  word varchar,
  image varchar,
  synset varchar[],
  pos varchar,
  lang varchar,
  lang_image varchar,
  typ int default null,
  eq_class bigint,
  cnt smallint,
  sound boolean default false
);
create table synon_1 (like synon);

create table homon (
  id int,
  word varchar,
  pos varchar,
  lang varchar,
  typ int,
  synon_id int,
  sound boolean default false
);
create index on homon (id);
create table homon_1 (like homon);

create or replace function sizes (out tablename name, out size text, out external_size text ) as $$
SELECT
   relname as "Table",
   pg_size_pretty(pg_total_relation_size(relid)) As "Size",
   pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) as "External Size"
   FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;
$$ language sql;