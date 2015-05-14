
TRUNCATE synon;

INSERT INTO synon 
SELECT 
    d1.org
  , array_agg(d2.org)
  --, array_agg(d2.trans)
  , d1.pos
  , d1.lang_org
  --, d1.lang_trans
  , count(*) cnt
FROM dict d1, dict d2 
WHERE d1.trans = d2.trans 
  AND d1.org != d2.org 
  AND d1.pos = d2.pos
  AND d1.lang_org = d2.lang_org 
  AND d1.lang_trans = d2.lang_trans
GROUP BY 
    d1.org 
  --, d2.trans 
  , d1.pos 
  , d1.lang_org 
  --, d1.lang_trans
HAVING count(*) > 1;

