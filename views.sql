
DROP VIEW IF EXISTS v_homon;
CREATE VIEW v_homon AS (
  SELECT DISTINCT ON (homon.word, homon.lang, homon.pos, synon.lang_trans, synon.lang, synon.eq_class) 
      homon.pos
    , left(homon.word, 16) word
    , homon.lang || '>' || synon.lang || '<' || synon.lang_trans || ' (' || left(synon.word_trans, 16) || ')' lang_graph
    , synon.word || ': ' || array_to_string(synon.synset, ', ') translation_meaning
  FROM homon JOIN synon ON synon_id = synon.id
  ORDER BY homon.word, homon.lang, homon.pos, synon.lang_trans, synon.lang, synon.eq_class, synon.cnt desc
);

drop view if exists v_homon_top;
create view v_homon_top AS (
  SELECT --distinct on (synon.word)
      homon.pos
    , homon.lang || '>' || synon.lang lg
    , homon.word
    , count(distinct synon.word) cnt
    , array(select distinct unnest(array_agg(synon.word)) order by 1) trans
  FROM homon JOIN synon ON synon_id = synon.id
  GROUP BY homon.word, homon.lang, homon.pos, synon.lang 
  ORDER BY cnt desc, homon.word, homon.lang, homon.pos, synon.lang
);
