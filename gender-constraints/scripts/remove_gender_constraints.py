import os
import sys

"""
    Given a file containing sentences followed by the gender of the subject, return only the sentence.
    E.g.:
    Input: The nurse must arrive on time.  Masc
    Output: The nurse must arrive on time.
"""

input_file = sys.argv[1]
out_file = sys.argv[2]

with open(out_file, 'w') as w_file:
    with open(input_file, 'r') as r_file:
        while True:
            line = r_file.readline()
            if not line:
                break
            elems = line.split('\t')
            if len(elems) == 2:
                sent, constraint = elems
                constraint = constraint.strip()
                if constraint == 'Neut':
                    continue
            else:
                sent = elems[0].strip()

            w_file.write(f'{sent}\n')

