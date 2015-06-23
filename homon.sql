
truncate homon;

insert into homon (id, word, pos, lang, typ, synon_id)
-- dictionary translation org to array of word and all its synonyms
with synon_dict as (
  select
        dict.id
      , dict.org
      , dict.pos
      , dict.lang_org
      , dict.typ
      , synon.synset  || synon.word synset -- less results
      , synon.typ syn_typ
      , synon.id synon_id
  from dict join synon on
    dict.trans = synon.word and
    dict.pos = synon.pos and
    dict.lang_trans = synon.lang
)
select distinct
      a.id
    , a.org       as word
    , a.pos
    , a.lang_org  as lang
    , a.typ
    , a.synon_id
from synon_dict a join synon_dict b on
  a.id != b.id and        -- optimization
  a.org = b.org and
  a.typ = b.typ and
  a.syn_typ = b.syn_typ   -- optimization
where
  not (a.synset && b.synset)
order by word, lang, a.pos;

analyze homon;