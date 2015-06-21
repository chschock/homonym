
P=../data

CLIENT=date && psql homonym -f

init:
	$(CLIENT) init.sql

load: init
	#./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc > /dev/null
	./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc  $P/de-en.cc $P/en-de.cc > /dev/null
	#./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc $P/tr-en.cc $P/en-tr.cc $P/de-tr.cc $P/tr-de.cc> /dev/null

prepare:
	$(CLIENT) prepare.sql

synon:
	$(CLIENT) synon.sql

post-synon:
	$(CLIENT) post_synon.sql

homon:
	$(CLIENT) homon.sql

post-homon:
	$(CLIENT) post_homon.sql

views:
	$(CLIENT) views.sql

views1:
	sed -e 's/ homon / homon_1 /g' views.sql | \
	sed -e 's/ synon / synon_1 /g' | \
	sed -e 's/ v_/ v1_/g' | psql homonym

transform: prepare synon post-synon homon
#post-homon

all: load transform views views1


