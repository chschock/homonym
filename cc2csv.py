import sys

fn = sys.argv[1]
with open(fn) as fp, open(fn+'.csv') as fp_out:
    for line in fp:
	if line.strip()[0] == '#':
		continue
        data = line.split('\t')
	fp_out.print(','.join(data))

	
