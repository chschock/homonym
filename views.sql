
DROP VIEW IF EXISTS v_homon_base cascade;
CREATE VIEW v_homon_base AS (
  SELECT 
      h.pos
    , h.word
    , h.lang || '>' || s.lang || '<' || s.lang_image || ' (' || left(s.image, 16) || ')' lang_graph
    , synon_id
    , s.word || ': ' || array_to_string(s.synset, ', ') meaning
    -- , right(
    --         string_agg(array_to_string(s.synset, ', '), ' / ') 
    --           over (partition by s.word, s.lang, h.pos order by s.cnt desc, s.id),
    --         - length(s.word || ': ' || array_to_string(s.synset, ', ')) - 3
    --         ) synsets
    , s.eq_class
    , s.cnt
    , s.word trans
    , h.lang
    , s.lang lang_trans
    , s.lang_image
--    , case when (s.word, s.lang, s.pos) in (select word, lang, pos from homon)
  FROM homon h JOIN synon s 
  ON synon_id = s.id
  ORDER BY h.word, h.lang, h.pos, s.lang_image, s.lang, s.eq_class, s.cnt desc
);

create view v_homon_e as (
  select distinct on (word, pos, lang, lang_trans, lang_image, eq_class)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word
  from v_homon_base 
  ORDER BY word, pos, lang, lang_trans, lang_image, eq_class, cnt desc
);

create view v_homon_1 as (
  select distinct on (word, pos, lang, lang_trans, lang_image, trans)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word
  from v_homon_base 
  ORDER BY word, pos, lang, lang_trans, lang_image, trans, cnt desc, synon_id
);

create view v_homon as (
  select distinct on (word, pos, lang, lang_trans, lang_image, trans)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word
  from (
    select distinct on (word, pos, lang, lang_trans, lang_image, eq_class) * 
    from v_homon_base
    ) sub
  ORDER BY word, pos, lang, lang_trans, lang_image, trans, cnt desc, synon_id
);

create view v_homon_top AS (
  SELECT --distinct on (s.word)
      pos
    , left(word, 16) word
    , lang || '>' || lang_trans lg
    , count(distinct trans) cnt
    , array(select distinct unnest(array_agg(meaning || ' (' || lang_image || ')')) order by 1) trans
  FROM (
      select distinct on (word, pos, lang, lang_trans, trans) * -- dropped lang_image for 
      from (
        select distinct on (word, pos, lang, lang_trans, eq_class) * -- fairer counting of meanings
        from v_homon_base
        ) sub2 
      ) sub
  GROUP BY word, lang, pos, lang_trans 
  ORDER BY cnt desc, word, lang, pos, lang_trans
);


-- drop view if exists synon_1 cascade;
-- create view synon_1 as (
--   select distinct on (word, pos, lang) *
--   from synon s
--   order by word, pos, lang, cnt desc
-- );

-- drop view if exists v_homon_top cascade;
-- create view v_homon_top AS (
--   SELECT --distinct on (s.word)
--       h.pos
--     , h.lang || '>' || s.lang lg
--     , h.word
--     , count(distinct s.word) cnt
--     , array(select distinct unnest(array_agg(s.word)) order by 1) trans
--   FROM homon h JOIN synon s ON synon_id = s.id
--   GROUP BY h.word, h.lang, h.pos, s.lang 
--   ORDER BY cnt desc, h.word, h.lang, h.pos, s.lang
-- );


-- truncate homon_1;
-- INSERT INTO homon_1
-- SELECT h.* 
-- from homon h 
-- inner join synon s ON synon_id = s.id
-- where (s.word, s.pos, s.lang) in (select word, pos, lang from homon group by word, pos, lang);


-- DROP VIEW IF EXISTS v_homon_1 cascade;
-- CREATE VIEW v_homon_1 AS (
--   SELECT DISTINCT ON (h.word, h.lang, h.pos, s.lang_image, s.lang, s.eq_class) 
--       h.pos
--     , left(h.word, 16) word
--     , h.lang || '>' || s.lang || '<' || s.lang_image || ' (' || left(s.image, 16) || ')' lang_graph
--     , s.word || ': ' || array_to_string(s.synset, ', ') translation_meaning
--   FROM homon_1 h JOIN synon s ON synon_id = s.id
--   ORDER BY h.word, h.lang, h.pos, s.lang_image, s.lang, s.eq_class, s.cnt desc
-- );


