
TRUNCATE homon;

INSERT INTO homon
-- dictionary translation org to array of word and all its synonyms
WITH synon_dict AS (
  SELECT 
        dict.org
      , dict.pos
      , dict.lang_org
      , synon.synset || synon.word synset
      , synon.lang syn_lang
      , synon.lang || '->' || synon.lang_trans || ' (' || synon.word_trans || ')' info
  FROM dict JOIN synon ON 
    dict.trans = synon.word AND 
    dict.pos = synon.pos AND 
    dict.lang_trans = synon.lang
)
SELECT 
      a.org
    , a.pos
    , a.lang_org
    , a.synset synset1
    , b.synset synset2
    , a.info
    , b.info
FROM synon_dict a JOIN synon_dict b ON 
  a.org = b.org AND 
  a.pos = b.pos AND 
  a.lang_org = b.lang_org AND 
  a.syn_lang = b.syn_lang AND
  -- a.dic = b.dic AND
  a.synset > b.synset
WHERE 
  NOT (a.synset && b.synset);
