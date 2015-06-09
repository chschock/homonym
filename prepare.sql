
-- delete duplicate entries
with dups as (
    select distinct on (org, trans, pos, lang_org, lang_trans) *
    from dict
)
delete from dict where id not in (select id from dups);

update dict d set typ = sub.hashtext
    from (select pos, lang_org, lang_trans, 
        hashtext(pos||lang_org||lang_trans) 
        from dict group by pos, lang_org, lang_trans) sub
    where d.pos = sub.pos 
      and d.lang_org = sub.lang_org 
      and d.lang_trans = sub.lang_trans;

create index on dict (org, trans);

analyze dict;
