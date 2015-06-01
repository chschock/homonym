
truncate synon_1;
insert into synon_1
select *
from synon s
where (word, pos, lang) not in (select word, pos, lang from homon);

truncate homon_1;
INSERT INTO homon_1
select homon.* 
from homon inner join synon_1 s on synon_id = s.id; 
