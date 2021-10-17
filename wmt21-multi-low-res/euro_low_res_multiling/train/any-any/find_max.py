import sys
n=0
b=0
max_n=0
max_b=0
max_bleu=0
for line in sys.stdin:
    if line.startswith("beam"):
        b=line.split(" ")[1]
    if line.startswith("len norm"):
        n=line.split(" ")[2]
    if line.startswith("BLEU+case.mixed+numrefs.1+smooth.exp+tok.13a+version.1.5.1 = "):
        bleu=float(line.split(" ")[2])
        if bleu>max_bleu:
            max_bleu=bleu
            max_n=n
            max_b=b
print(max_n)
print(max_b)
print(max_bleu)
