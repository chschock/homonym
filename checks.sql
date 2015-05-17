-- find not symmetric entries
select l.*, count(*) cnt 
from dict l inner join dict r 
on l.org = r.trans and l.trans = r.org and l.pos=r.pos
where l.lang_org = r.lang_trans and l.lang_trans = r.lang_org
group by l.org, l.trans, l.pos, l.lang_org, l.lang_trans
order by cnt desc;

-- find double entries
select org, trans, pos, lang_org, lang_trans, count(*) cnt
from dict
group by org, trans, pos, lang_org, lang_trans
having count(*) > 1
order by cnt desc;