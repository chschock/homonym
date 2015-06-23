
TRUNCATE synon;

INSERT INTO synon
SELECT
    d1.id
  , d1.org      as word
  , d1.trans    as image
  , ARRAY(select distinct unnest(array_agg(d2.org)) ORDER BY 1) as synset
  , d1.pos
  , d1.lang_org     as lang
  , d1.lang_trans   as lang_image
  , d1.typ
  , hashtext(array_to_string(
      ARRAY(select distinct unnest(array_agg(d2.org)||d1.org) ORDER BY 1),
      ',')) eq_class
  , count(*) cnt
  , NULL
FROM dict d1, dict d2
WHERE d1.trans = d2.trans
  AND d1.org != d2.org
  AND d1.typ = d2.typ
GROUP BY
    d1.id
  , d1.org
  , d1.trans
  , d1.typ
  , d1.pos
  , d1.lang_org
  , d1.lang_trans
--HAVING count(*) > 1 -- might filter wrong soutions due to weak dictionary
;

-- words with many eq classes define a clear meaning
--select  count(*) over (partition by eq_class, typ, image) c, * from synon order by c desc;

ANALYZE synon;

