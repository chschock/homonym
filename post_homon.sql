
-- update homon h set sound = true
-- from synon s
-- where h.synon_id = s.id and (s.image, s.lang_image, s.pos, s.word, s.lang) not in
-- (select h.word, h.lang, h.pos, s.word, s.lang from homon h join synon s on h.synon_id = s.id);

update homon h set sound = true
from synon s, dict d, synon s2
where h.synon_id = s.id
  and d.org = h.word
  and d.pos = h.pos
  and d.lang_org = h.lang
  and d.lang_trans = s.lang
  and d.trans = s2.word
  and s.image = s2.image
  and s.word != s2.word
  and s.typ = s2.typ
  and array[s2.word] && s.synset;

truncate synon_1;
insert into synon_1
select * from synon;

truncate homon_1;
insert into homon_1
select h.* from homon h join synon s on h.synon_id = s.id
where (s.image, s.lang_image, s.pos, s.word, s.lang) not in
(select h.word, h.lang, h.pos, s.word, s.lang
    from homon h join synon s on h.synon_id = s.id and h.sound = true);

