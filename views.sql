drop view if exists v_dict cascade;
create view v_dict as (
  select left(org, 30) org, left(trans, 30) trans, pos, lang_org as fr, lang_trans as to, phrase_org, phrase_trans
  from dict
  order by org, pos, lang_org, lang_trans
);

drop view if exists v_homon_base cascade;
create view v_homon_base as (
  select
      h.*
    , h.lang || '>' || s.lang || '<' || s.lang_image || ' (' || left(s.image, 16) || ')' lang_graph
    , case when h.sound then '* ' else '  ' end ||
      case when s.sound then '* ' else '  ' end ||
      s.word || ': ' || array_to_string(s.synset, ', ') meaning
    -- , right(
    --         string_agg(array_to_string(s.synset, ', '), ' / ')
    --           over (partition by s.word, s.lang, h.pos order by s.cnt desc, s.id),
    --         - length(s.word || ': ' || array_to_string(s.synset, ', ')) - 3
    --         ) synsets
    , s.eq_class
    , s.cnt
    , s.word trans
    , s.lang lang_trans
    , s.lang_image
    , s.sound syn_sound
--    , case when (s.word, s.lang, s.pos) in (select word, lang, pos from homon)
  from homon h join synon s
  on synon_id = s.id
  order by h.word, h.lang, h.pos, s.lang_image, s.lang, s.eq_class, s.cnt desc
);

create view v_homon_e as (
  select distinct on (word, typ, lang_image, eq_class)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word, trans
  from v_homon_base
  order by word, typ, lang_image, eq_class, sound desc, syn_sound desc, cnt desc, synon_id
);

create view v_homon_1 as (
  select distinct on (word, typ, lang_image, trans)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word, trans
  from v_homon_base
  order by word, typ, lang_image, trans, sound desc, syn_sound desc, cnt desc, synon_id
);

create view v_homon as (
  select distinct on (word, typ, lang_image, trans)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word, trans
  from (
    select distinct on (word, typ, lang_image, eq_class) *
    from v_homon_base
    ) sub
  order by word, typ, lang_image, trans, sound desc, syn_sound desc, cnt desc, synon_id
);

create view v_homon_top as (
  select --distinct on (s.word)
      pos
    , left(word, 16) word
    , lang || '>' || lang_trans lg
    , count(distinct trans) cnt
    , array(select distinct unnest(array_agg(meaning || ' (' || lang_image || ')')) order by 1) trans
  from (
      select distinct on (word, pos, lang, lang_trans, trans) * -- dropped lang_image for
      from (
        select distinct on (word, pos, lang, lang_trans, eq_class) * -- fairer counting of meanings
        from v_homon_base
        ) sub2
      ) sub
  group by word, lang, pos, lang_trans
  order by cnt desc, word, lang, pos, lang_trans
);

