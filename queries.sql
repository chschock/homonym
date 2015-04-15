
Create table dict (
  org VARCHAR, 
  trans VARCHAR, 
  --lang_org SMALLINT, 
  --lang_trans SMALLINT,
  pos SMALLINT,
  concept SMALLINT
);

Create table synon (
  word VARCHAR, 
  syn VARCHAR, 
  lang SMALLINT
);


INSERT INTO synon 
SELECT d1.org, array_agg(d2.org), d1.lang, d2.pos, count(*) cnt
FROM dict d1, dict d2 
GROUP BY d1.org
WHERE d1.trans = d2.trans AND cnt > 1
  AND d1.org != d2.org AND d1.pos = d2.pos 
  --AND d1.lang_org = d2.lang_org AND d1.lang_trans = d2.lang_trans


CREATE TABLE homon_candidate AS (

WITH synon_dict AS (
SELECT org, trans || array_agg(syn) AS syn_arr 
FROM dict JOIN synon
ON trans = word
GROUP BY org, trans)
 
SELECT a.org, a.syn_arr, b.syn_arr
FROM synon_dict a JOIN synon_dict b
ON a.org = b.org
WHERE NOT (a.syn_arr && b.syn_arr)
)


