truncate dict;
insert into dict
select
    id, org, trans, pos, lang_org, lang_trans,
    t.typ_id as typ
from dict_complete d
inner join (
    select row_number() over (order by pos, lang_org, lang_trans) as typ_id, *
    from (
        select pos, lang_org, lang_trans, count(*)
        from dict_complete
        group by pos, lang_org, lang_trans
    ) sub
) t using (pos, lang_org, lang_trans);

-- remove sentences
delete from dict where org ~ '.*\S+ \S+ \S+ \S+ \S+ \S+.*[.!?]$';

-- language weighting by dictinary size
insert into lang_weight select lang_org, count(*) from dict group by lang_org order by 2;


create index on dict (org, trans);
analyze dict;


-- -- general heuristic for frequent pronouns

with pp_sub as (
    select lang_org, pp, cnt from (
        select distinct on (pp)
            count(*) over (partition by pp) cnt,
            *
        from (select
                unnest(regexp_matches(org,'\S+\.(?: ?\w+\.)?')) pp,
                *
            from dict
            ) sub
        where pp <> '' and pos = 'verb'
    ) sub2
    where cnt >= 5
    union
    select * from (values
        ('es', 'algn/algo', 0),
        ('es', 'a-algn/algo', 0),
        ('pt', 'alguém/algo', 0),
        ('es', 'algn', 0),
        ('es', 'algo', 0),
        ('pt', 'alguém', 0),
        ('pt', 'algo', 0)) as xxx
)
insert into pronoun (lang, pp, cnt)
select lang_org, pp, cnt from pp_sub
order by pp ~ '/' desc, length(pp) desc;


-- remove pronouns from dict

update dict set org = replace(replace(org, ' ' || pp, ''), pp || ' ', '')
from pronoun p
where p.id = (select id from pronoun
    where org like ('%' || pp || '%') and lang_org = lang order by id limit 1);

update dict set org = replace(replace(org, ' ' || pp, ''), pp || ' ', '')
from pronoun p
where p.id = (select id from pronoun
    where org like ('%' || pp || '%') and lang_org = lang order by id limit 1);

update dict set trans = replace(replace(trans, ' ' || pp, ''), pp || ' ', '')
from pronoun p
where p.id = (select id from pronoun
    where trans like ('%' || pp || '%') and lang_trans = lang order by id limit 1);

update dict set trans = replace(replace(trans, ' ' || pp, ''), pp || ' ', '')
from pronoun p
where p.id = (select id from pronoun
    where trans like ('%' || pp || '%') and lang_trans = lang order by id limit 1);


-- delete duplicate entries
with dups as (
    select distinct on (org, trans, pos, lang_org, lang_trans) *
    from dict
)
delete from dict where id not in (select id from dups);

-- efficient storage
drop table if exists dict_tmp;
create table dict_tmp as (select * from dict);
truncate dict;
insert into dict select * from dict_tmp;
analyze dict;


-- -- IMPORTANT query with heuristic for pronouns by word/word
-- select distinct on (cnt, pp)
--     sub.lang_org,
--     count(*) over (partition by pp) / weight cnt,
--     *
-- from (
--         select unnest(regexp_matches(org,'(\S+) ?/')) pp, * from dict union all
--         select unnest(regexp_matches(org,'/ ?(\S+)')) pp, * from dict
--     ) sub
-- inner join (select org, lang_org from dict where pos = 'pron' or pos = 'prep') pron
-- on sub.lang_org = pron.lang_org and sub.pp = pron.org
-- inner join lang_weight lw on sub.lang_org = lw.lang
-- where pos = 'verb' order by cnt desc;


-- with verbs as (
--     select distinct org as part
--     from dict
--     where (org ~ '^\w+(\s+\w+)?$' and (pos = 'verb' or pos = 'noun'))
--         and org not in (select org from dict where pos='prep' or pos = 'pron'))
-- select * from verbs;

-- select distinct on (cnt, id)
--     string_agg(verb, ' ') over (partition by id order by v_no) verbs,
--     count(*) over (partition by sub.id) cnt,
--     sub.*
--     from (
--         select *,
--             unnest(regexp_split_to_array(org,'\s+')) verb,
--             row_number() over (partition by id) v_no
--         from dict) sub join verbs on org = part
--     --where verb in (select * from verbs)
-- order by cnt desc;

-- queries with heuristic RE for pronouns by '%./%.'
-- select distinct on (substring(org,'[a-zA-Z]\w+\.')) substring(org,'[a-zA-Z]\w+\.'), * from dict where pos = 'verb' ;

-- queries with heuristic RE for pronouns by '%.'
-- select distinct on (cnt, pp) lang_org, count(*) over (partition by pp) cnt, count(*) over (partition by pp)::real / sub.norm rel_cnt, * from
-- (select substring(org,'[a-zA-Z]\w*\.(?: ?\w+\.)?') pp, count(*) over (partition by lang_org) norm, * from dict) sub where pp != '' and pos = 'verb' order by cnt desc;
