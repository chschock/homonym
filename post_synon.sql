update synon s1 set sound = true 
from synon s2
where s1.image != s2.image 
  and s1.word = s2.word 
  and s1.typ = s2.typ
  and s1.synset && s2.synset;

-- count equivavelnce classes as quality marker
-- select  count(*) over (partition by eq_class, typ, image) c, * from synon order by c desc;

-- update synon s1 set sound = true 
-- from synon s2 
-- inner join dict d
-- where d.trans = s1.word
--   and d.trans = s2.word
--   and d.pos = s1.pos
--   and d.pos = s2.pos
--   and d.lang
--   and s1.image = s2.image 
--   and s1.word != s2.word 
--   and s1.pos = s2.pos
--   and s1.lang = s2.lang
--   and s1.lang_image = s2.lang_image
--   and s1.synset && s2.synset;
