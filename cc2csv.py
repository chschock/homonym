#!/usr/bin/python3

import psycopg2
import sys
import subprocess
import re
import csv

def echo(bytes): print(bytes.decode('UTF-8'))

# Init and try to connect
# echo(subprocess.check_output('psql homonym -f init.sql', shell=True))

try:
	conn = psycopg2.connect("dbname='homonym' user='chris' host='localhost' password=''")
except:
	print("I am unable to connect to the database")
	exit()

def strip(arg):
	strip_br = re.sub('[\(\[\{<].*?[\)\]\}>]', '', arg)
	return re.sub(' +', ' ', strip_br.strip())[:50]

def load_dict(lang_org, lang_trans, fn):
	with open(fn) as fp:
		cur = conn.cursor()
		reader = csv.reader(
			filter(lambda row:(row.strip()+'$')[0]!='#', fp),
			delimiter='\t',
			quoting=csv.QUOTE_NONE)

		skip_cnt = 0
		for d in reader:
			data = ['', '', '']
			data[0:len(d)] = [strip(d[i]) for i in range(len(d))]
			#print(data)
			pos_arr = data[2].split(' ')
			if data[0] and data[1]:
				for p in pos_arr:
					exstr = cur.mogrify("""INSERT INTO dict 
						(org, trans, pos, lang_org, lang_trans, phrase_org, phrase_trans)
						VALUES (%s,%s,%s,%s,%s,%s,%s)""",
						(data[0], data[1], p, lang_org, lang_trans, d[0], d[1]))
					cur.execute(exstr)
			else:
				skip_cnt = skip_cnt + 1
				#print('skipped line: "%s"' % d)

		conn.commit()
		cur.close()
	print('skipped %d lines because of empty strings' % skip_cnt)

for arg in sys.argv[1:]:
	m = re.match('.*/(\w+)-(\w+)\.cc', arg)
	sys.stderr.write("loading dic %s -> %s\n" % (m.group(1), m.group(2)))
	load_dict(m.group(1), m.group(2), arg)


# sys.stderr.write("indexing dict\n")
# cur = conn.cursor()
# # cur.execute("CREATE INDEX ON dict (trans, pos, lang_trans);")
# cur.execute("CREATE INDEX ON dict (trans);")
# # cur.execute("CREATE INDEX ON dict (trans, pos, lang_org, lang_trans)")
# conn.commit()
# cur.close()
conn.close()

# print("cleansing dict\n")
# echo(subprocess.check_output('psql homonym -f cleanse-dict.sql', shell=True))
# print("calculating synonyms\n")
# echo(subprocess.check_output('psql homonym -f synon.sql', shell=True))
# print("calculating homonyms\n")
# echo(subprocess.check_output('psql homonym -f homon.sql', shell=True))
