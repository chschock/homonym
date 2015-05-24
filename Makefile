

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

transform: cleanse synon homon

all: load transform views


