-- delete duplicate entries
with dups as (
select *
from dict
group by org, trans, pos, lang_org, lang_trans
having count(*) > 1
)
delete from dict using dups where (dict.*) = (dups.*);