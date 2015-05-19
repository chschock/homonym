
DROP VIEW IF EXISTS v_homon cascade;
CREATE VIEW v_homon AS (
  SELECT DISTINCT ON (h.word, h.lang, h.pos, s.lang_trans, s.lang, s.eq_class) 
      h.pos
    , left(h.word, 16) word
    , h.lang || '>' || s.lang || '<' || s.lang_trans || ' (' || left(s.word_trans, 16) || ')' lang_graph
    , s.word || ': ' || array_to_string(s.synset, ', ') translation_meaning
  FROM homon h JOIN synon s ON synon_id = s.id
  ORDER BY h.word, h.lang, h.pos, s.lang_trans, s.lang, s.eq_class, s.cnt desc
);

-- INSERT INTO homon_1
-- SELECT h.* 
-- from homon h 
-- inner join synon s ON synon_id = s.id
-- inner join homon h1 on h1.word = s.word and h1.pos = s.pos and h1.lang = s.lang
-- ORDER BY h.word, h.lang, h.pos, s.lang_trans, s.lang, s.eq_class, s.cnt desc;

-- DROP VIEW IF EXISTS v_homon_1 cascade;
-- CREATE VIEW v_homon_1 AS (
--   SELECT DISTINCT ON (h.word, h.lang, h.pos, s.lang_trans, s.lang, s.eq_class) 
--       h.pos
--     , left(h.word, 16) word
--     , h.lang || '>' || s.lang || '<' || s.lang_trans || ' (' || left(s.word_trans, 16) || ')' lang_graph
--     , s.word || ': ' || array_to_string(s.synset, ', ') translation_meaning
--   FROM homon_1 h JOIN synon s ON synon_id = s.id
--   ORDER BY h.word, h.lang, h.pos, s.lang_trans, s.lang, s.eq_class, s.cnt desc
-- );

drop view if exists v_homon_top cascade;
create view v_homon_top AS (
  SELECT --distinct on (s.word)
      h.pos
    , h.lang || '>' || s.lang lg
    , h.word
    , count(distinct s.word) cnt
    , array(select distinct unnest(array_agg(s.word)) order by 1) trans
  FROM homon h JOIN synon s ON synon_id = s.id
  GROUP BY h.word, h.lang, h.pos, s.lang 
  ORDER BY cnt desc, h.word, h.lang, h.pos, s.lang
);
