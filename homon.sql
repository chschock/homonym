
truncate homon;

insert into homon (word, pos, lang, synon_id)
-- dictionary translation org to array of word and all its synonyms
with synon_dict as (
  select
        dict.org
      , dict.pos
      , dict.lang_org
      , dict.typ
      , synon.synset  || synon.word synset -- less results
      , synon.lang syn_lang
      , synon.id synon_id
  from dict join synon on
    dict.trans = synon.word and
    dict.pos = synon.pos and
    dict.lang_trans = synon.lang
)
select distinct
      a.org
    , a.pos
    , a.lang_org
    , a.synon_id
from synon_dict a join synon_dict b on
  a.org = b.org and
  a.typ = b.typ
where
  not (a.synset && b.synset)
order by a.org, a.lang_org, a.pos;

create index on homon (synon_id, sound);

analyze homon;