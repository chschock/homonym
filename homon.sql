
TRUNCATE homon;

INSERT INTO homon (word, pos, lang, synon_id)
-- dictionary translation org to array of word and all its synonyms
WITH synon_dict AS (
  SELECT 
        dict.org
      , dict.pos
      , dict.lang_org
      , synon.synset || synon.word synset
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
  a.pos = b.pos AND 
  a.lang_org = b.lang_org AND 
  a.syn_lang = b.syn_lang 
WHERE 
  NOT (a.synset && b.synset)
ORDER BY a.org, a.lang_org, a.pos;

DROP VIEW IF EXISTS v_homon;
CREATE VIEW v_homon AS (
  SELECT 
      homon.pos
    , homon.lang lg
    , synon.lang || '->' || synon.lang_trans || ' (' || left(synon.word_trans, 16) || ')' syninfo
    , homon.word
    , synon.word || ': ' || array_to_string(synon.synset, ', ') translation_meaning
  FROM homon JOIN synon ON synon_id = synon.id
  ORDER BY homon.word, homon.lang, homon.pos, synon.lang_trans, synon.lang
);