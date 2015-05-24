
truncate synon_1;
insert into synon_1
select *
from synon s
where (word, pos, lang) not in (select word, pos, lang from homon);

truncate homon_1;
INSERT INTO homon_1
select homon.* 
from homon inner join synon_1 s on synon_id = s.id; 


-- inner join 
-- (select
--     array(select distinct array_agg(unnest(synset)) order by 1) synset,
--     word, pos, lang
-- from synon
-- group by word, pos, lang
-- ) s_1 ON s.word = s_1.word and s.pos = s_1.pos and s.lang = s_1.lang
-- window w as (order by cnt desc);


    -- (array_agg(id))[0] id,
    -- (array_agg(word_trans))[0] word_trans,
    -- (array_agg(lang_trans))[0] lang_trans,
