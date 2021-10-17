import sys,re
for line in sys.stdin:
    print(re.sub('\s+',' ',' '.join(list(line))))
        
