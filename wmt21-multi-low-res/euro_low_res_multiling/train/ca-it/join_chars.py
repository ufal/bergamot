import sys
for line in sys.stdin:
    print(''.join(line.split()).replace('▁',' '))
