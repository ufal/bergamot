import os
import sys

txt_in = sys.argv[1]
template_file = sys.argv[2]

with open(template_file,"r") as template, open(txt_in, 'r') as txt:
    for line in template:
        if line.isspace():
            print(txt.readline(),end='')
        else:
            print(line,end='')