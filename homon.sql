
INSERT INTO homon
-- dictionary translation org to array of word and all its synonyms
WITH synon_dict AS (
  SELECT org, dict.pos, lang_org, synset
  FROM dict JOIN synon
  ON trans = word AND dict.pos = synon.pos AND lang_trans = synon.lang
)
SELECT a.org, a.pos, a.lang_org, a.synset synset1, b.synset synset2
FROM synon_dict a JOIN synon_dict b
ON a.org = b.org AND a.pos = b.pos AND a.lang_org = b.lang_org
WHERE NOT (a.synset && b.synset);
