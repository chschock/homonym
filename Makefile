
P=../data

CLIENT=date && psql homonym

init:
	$(CLIENT) -f init.sql

load: init
	#./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc > /dev/null
	./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc $P/de-en.cc $P/en-de.cc > /dev/null
	#./cc2csv.py $P/de-fr.cc $P/fr-de.cc $P/de-es.cc $P/es-de.cc $P/pt-de.cc $P/de-pt.cc $P/en-es.cc $P/es-en.cc $P/en-fr.cc $P/fr-en.cc $P/en-pt.cc $P/pt-en.cc $P/tr-en.cc $P/en-tr.cc $P/de-tr.cc $P/tr-de.cc $P/de-en.cc $P/en-de.cc > /dev/null

prepare:
	$(CLIENT) -f prepare.sql

synon:
	$(CLIENT) -f synon.sql

post-synon:
	$(CLIENT) -f post_synon.sql

homon:
	$(CLIENT) -f homon.sql

post-homon:
	$(CLIENT) -f post_homon.sql

views:
	$(CLIENT) -f views.sql

views1:
	sed -e 's/ homon / homon_1 /g' views.sql | \
	sed -e 's/ synon / synon_1 /g' | \
	sed -e 's/ v_/ v1_/g' | psql homonym

transform: prepare synon post-synon homon post-homon

graph:
	$(CLIENT) -f create_graph.sql
	$(CLIENT) -c "copy edge to stdout with (format csv, delimiter ',');" > edge.csv
	$(CLIENT) -c "copy node to stdout with (format csv, delimiter ',', force_quote (label));" > node.csv
	echo 'nodedef>name VARCHAR,label VARCHAR,class VARCHAR,color VARCHAR' > homonym.gdf
	cat node.csv >> homonym.gdf
	echo 'edgedef>node1 VARCHAR,node2 VARCHAR,color VARCHAR,weight DOUBLE,directed BOOLEAN' >> homonym.gdf
	cat edge.csv >> homonym.gdf


all: load transform views views1 graph


