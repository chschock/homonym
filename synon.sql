
TRUNCATE synon;

INSERT INTO synon (word, word_trans, synset, pos, lang, lang_trans, eq_class, cnt)
SELECT
    d1.org
  , d1.trans
  , ARRAY(select distinct unnest(array_agg(d2.org)) ORDER BY 1)
  , d1.pos
  , d1.lang_org
  , d1.lang_trans
  , hashtext(array_to_string(
      ARRAY(select distinct unnest(array_agg(d2.org)||d1.org) ORDER BY 1),
      ',')) eq_class
  , count(*) cnt
FROM dict d1, dict d2 
WHERE d1.trans = d2.trans 
  AND d1.org != d2.org 
  AND d1.pos = d2.pos
  AND d1.lang_org = d2.lang_org 
  AND d1.lang_trans = d2.lang_trans
GROUP BY 
    d1.org 
  , d1.trans 
  , d1.pos 
  , d1.lang_org 
  , d1.lang_trans
--HAVING count(*) > 1 -- might filter wrong soutions due to weak dictionary
;
