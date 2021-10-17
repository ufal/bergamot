import sys
for line in sys.stdin:
    if len(line.split(' '))>6:
        print(line.strip())

