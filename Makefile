
P=../data

init:
	psql homonym -f init.sql

load: init
	./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc > /dev/null
	./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc  $P/de-en.cc $P/en-de.cc > /dev/null
	#./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc $P/tr-en.cc $P/en-tr.cc $P/de-tr.cc $P/tr-de.cc> /dev/null

cleanse:
	psql homonym -f cleanse-dict.sql
	
synon: 
	psql homonym -f synon.sql

homon:
	psql homonym -f homon.sql

postprocess:
	psql homonym -f postprocess.sql

views:
	psql homonym -f views.sql
views1:
	sed -e 's/ homon / homon_1 /g' views.sql | \
	sed -e 's/ synon / synon_1 /g' | \
	sed -e 's/ v_/ v1_/g' | psql homonym

transform: cleanse synon homon postprocess

all: load transform views


