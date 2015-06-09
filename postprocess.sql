
-- UPDATE homon h SET sound = TRUE 
-- FROM synon s 
-- WHERE h.synon_id = s.id AND (s.image, s.lang_image, s.pos, s.word, s.lang) not in 
-- (select h.word, h.lang, h.pos, s.word, s.lang from homon h join synon s on h.synon_id = s.id); 

UPDATE homon h SET sound = TRUE 
FROM synon s, dict d, synon s2 
WHERE h.synon_id = s.id
  AND d.org = h.word
  AND d.pos = h.pos
  AND d.lang_org = h.lang
  AND d.lang_trans = s.lang
  AND d.trans = s2.word
  AND s.image = s2.image 
  AND s.word != s2.word 
  AND s.typ = s2.typ
  AND array[s2.word] && s.synset;

--TRUNCATE synon_1;
INSERT INTO synon_1 
SELECT * FROM synon;

--TRUNCATE homon_1;
INSERT INTO homon_1 
SELECT h.* FROM homon h JOIN synon s ON h.synon_id = s.id 
WHERE (s.image, s.lang_image, s.pos, s.word, s.lang) not in 
(select h.word, h.lang, h.pos, s.word, s.lang 
    from homon h join synon s on h.synon_id = s.id and h.sound = True); 

