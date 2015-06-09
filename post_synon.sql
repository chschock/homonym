UPDATE synon s1 SET sound = True 
FROM synon s2
WHERE s1.image != s2.image 
  AND s1.word = s2.word 
  AND s1.typ = s2.typ
  AND s1.synset && s2.synset;


-- UPDATE synon s1 SET sound = True 
-- FROM synon s2 
-- INNER JOIN dict d
-- WHERE d.trans = s1.word
--   AND d.trans = s2.word
--   AND d.pos = s1.pos
--   AND d.pos = s2.pos
--   AND d.lang
--   AND s1.image = s2.image 
--   AND s1.word != s2.word 
--   AND s1.pos = s2.pos
--   AND s1.lang = s2.lang
--   AND s1.lang_image = s2.lang_image
--   AND s1.synset && s2.synset;
