#!/usr/bin/python3

import psycopg2
import sys
import os
import re
import csv

# Init and try to connect
os.system('psql homonym -f init.sql')
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

		for d in reader:
			data = ['', '', '']
			data[0:len(d)] = [strip(d[i]) for i in range(len(d))]
			print(data)
			pos_arr = data[2].split(' ')
			for p in pos_arr:
				exstr = cur.mogrify("INSERT INTO dict VALUES (%s,%s,%s,%s,%s)",
									(data[0], data[1], p, lang_org, lang_trans))
				cur.execute(exstr)
				print(exstr)

		conn.commit()
		cur.close()

for arg in sys.argv[1:]:
	m = re.match('.*/(\w+)-(\w+)\.cc', arg)
	load_dict(m.group(1), m.group(2), arg)

conn.close()

os.system('psql homonym -f synon.sql')
os.system('psql homonym -f homon.sql')
