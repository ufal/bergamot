import sys
i=1743
best_score=-100000
best_sentence=""
first=True
for lines in sys.stdin:
    line,score=lines.split('\t')
    tabs=line.split('|||')
    if first:
        i=int(tabs[0])
        first=False
    if int(tabs[0])!=i:
        i=int(tabs[0])
        print(best_sentence)
        best_score=-10000
        best_sentence=tabs[1]
    if float(score)>float(best_score):
        best_sentence=tabs[1]
        best_score=score

print(best_sentence)

