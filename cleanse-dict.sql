
-- delete duplicate entries
with dups as (
    select distinct on (org, trans, pos, lang_org, lang_trans) *
    from dict
)
delete from dict where id not in (select id from dups);