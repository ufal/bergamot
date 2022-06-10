import os
import sys
from process_annotation import check_token

"""
    Remove UDPipe annotation.
"""

in_file = sys.argv[1]
out_file = sys.argv[2]

with open(in_file, 'r') as r_file, open(out_file, 'w') as w_file:

    while True:
        line = r_file.readline()
        if not line:
            break

        out_sent = ''

        for token in line.split():
            tok_dic = check_token(token)
            out_sent = out_sent + tok_dic['token']  + ' '

        w_file.write(out_sent[:-1] + '\n')

