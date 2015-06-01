

init:
	psql homonym -f init.sql

load: init
	./cc2csv.py ../data/de-fr.cc ../data/fr-de.cc ../data/de-es.cc ../data/es-de.cc ../data/pt-de.cc ../data/de-pt.cc ../data/en-es.cc ../data/es-en.cc ../data/en-fr.cc ../data/fr-en.cc ../data/en-pt.cc ../data/pt-en.cc > /dev/null
	#./cc2csv.py ../data/de-fr.cc ../data/fr-de.cc ../data/de-es.cc ../data/es-de.cc ../data/pt-de.cc ../data/de-pt.cc ../data/en-es.cc ../data/es-en.cc ../data/en-fr.cc ../data/fr-en.cc ../data/en-pt.cc ../data/pt-en.cc ../data/tr-en.cc ../data/en-tr.cc ../data/de-tr.cc ../data/tr-de.cc> /dev/null

cleanse:
	psql homonym -f views.sql
	
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


