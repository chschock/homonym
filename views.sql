
DROP VIEW IF EXISTS v_homon_base cascade;
CREATE VIEW v_homon_base AS (
  SELECT 
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
  FROM homon h JOIN synon s 
  ON synon_id = s.id
  ORDER BY h.word, h.lang, h.pos, s.lang_image, s.lang, s.eq_class, s.cnt desc
);

create view v_homon_e as (
  select distinct on (word, pos, lang, lang_trans, lang_image, eq_class)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word
  from v_homon_base 
  ORDER BY word, pos, lang, lang_trans, lang_image, eq_class, sound desc, syn_sound desc, cnt desc, synon_id
);

create view v_homon_1 as (
  select distinct on (word, pos, lang, lang_trans, lang_image, trans)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word
  from v_homon_base 
  ORDER BY word, pos, lang, lang_trans, lang_image, trans, sound desc, syn_sound desc, cnt desc, synon_id
);

create view v_homon as (
  select distinct on (word, pos, lang, lang_trans, lang_image, trans)
    pos, left(word, 16) word_abbr, lang_graph, meaning, word
  from (
    select distinct on (word, pos, lang, lang_trans, lang_image, eq_class) * 
    from v_homon_base
    ) sub
  ORDER BY word, pos, lang, lang_trans, lang_image, trans, sound desc, syn_sound desc, cnt desc, synon_id
);

create view v_homon_top AS (
  SELECT --distinct on (s.word)
      pos
    , left(word, 16) word
    , lang || '>' || lang_trans lg
    , count(distinct trans) cnt
    , array(select distinct unnest(array_agg(meaning || ' (' || lang_image || ')')) order by 1) trans
  FROM (
      select distinct on (word, pos, lang, lang_trans, trans) * -- dropped lang_image for 
      from (
        select distinct on (word, pos, lang, lang_trans, eq_class) * -- fairer counting of meanings
        from v_homon_base
        ) sub2 
      ) sub
  GROUP BY word, lang, pos, lang_trans 
  ORDER BY cnt desc, word, lang, pos, lang_trans
);

