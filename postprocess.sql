
UPDATE homon h SET sound = TRUE 
FROM synon s 
WHERE h.synon_id = s.id AND (s.image, s.lang_image, s.pos, s.word, s.lang) not in 
(select h.word, h.lang, h.pos, s.word, s.lang from homon h join synon s on h.synon_id = s.id); 


-- truncate synon_1;
-- insert into synon_1
-- select *
-- from synon s;
-- --where (word, pos, lang) not in (select word, pos, lang from homon);

-- truncate homon_1;
-- INSERT INTO homon_1
-- select homon.* 
-- from homon inner join synon_1 s on synon_id = s.id
-- where (s.image, s.lang_image, s.pos, s.lang) not in 
-- (select h.word, h.lang, h.pos, s.lang from homon h join synon s on h.synon_id = s.id); 
