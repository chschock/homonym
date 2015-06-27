drop table if exists color;
create table color (lang varchar, color varchar);
insert into color values
    ('de','121,224,209'),
    ('en','242,162,168'),
    ('es','207,223,107'),
    ('pt','150,222,155'),
    ('fr','220,183,224'),
    ('it','225,186,108'),
    ('tr','157,204,228');

-- rgb(145,186,109)
-- rgb(149,111,173)
-- rgb(159,88,70)
drop view if exists v_homon_sel;
create view v_homon_sel as (select * from v_homon
    where pos ='noun' and lang_graph not like 'de>en%' and lang_graph not like 'en>de%'
);

drop table if exists edge;
create table edge as(
    select
        h.id as source,
        h.synon_id as target,
        '145,186,109'::varchar as color,
        1::real as weight,
        1 as directed
    from v_homon_sel inner join homon h using (id)
);

update edge t1
set directed = false, color = '159,88,70'
from edge t2
where t1.source = t2.target and t1.target = t2.source;

delete
from edge t1
where
    exists (select * from edge t2 where t2.source = t1.target and t2.target = t1.source and t1.source > t2.source);

drop table if exists node;
create table node as(
    select
        h.id,
        h.word as label,
        h.lang as class,
        color
    from v_homon_sel
    inner join homon h using (id)
    inner join color c on h.lang = c.lang
);
insert into node
    select
        id,
        word,
        lang,
        color
    from (
        select id, word, lang from synon where id in (
            select target from edge where target not in (
                select source from edge))
        ) foo
    inner join color c using (lang);

