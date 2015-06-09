
TRUNCATE homon;

INSERT INTO homon (word, pos, lang, synon_id)
-- dictionary translation org to array of word and all its synonyms
WITH synon_dict AS (
  SELECT 
        dict.org
      , dict.pos
      , dict.lang_org
      , dict.typ
      , synon.synset  || synon.word synset -- less results
      , synon.lang syn_lang
      , synon.id synon_id
  FROM dict JOIN synon ON 
    dict.trans = synon.word AND 
    dict.pos = synon.pos AND 
    dict.lang_trans = synon.lang
)
SELECT DISTINCT
      a.org
    , a.pos
    , a.lang_org
    , a.synon_id
FROM synon_dict a JOIN synon_dict b ON 
  a.org = b.org AND 
  a.typ = b.typ 
WHERE 
  NOT (a.synset && b.synset)
ORDER BY a.org, a.lang_org, a.pos;

ANALYZE homon;