import sys
lens=[]
maxlen=0
too_long=0
if len(sys.argv)==2:
	maxlen=int(sys.argv[1])
for line in sys.stdin:
	lens.append(len(line.split(" ")))
	if len(line.split(" ")) > maxlen:
		too_long+=1
		
print(sorted(lens,reverse=True)[:10])
print("avg len: {}".format(sum(lens)/len(lens)))
if maxlen !=0:
	print("Lines longer than {}: {} ({}%)".format(maxlen,too_long, (too_long/len(lens))*100))
try:
	import plotille
	print(plotille.hist(lens))
except ImportError:
	print("No plotille")
