import os
import sys

# Select WinoMT sentences where the gender is associated with the subject.

# Define input and output.
in_file = sys.argv[1]
out_file = sys.argv[2]

# Read file.
with open(out_file, 'w') as w_file:
    with open(in_file, 'r') as r_file:

        while True:
            line = r_file.readline()

            if not line:
                break

            elems = line.split('\t')
            # Select index and sentence.
            index = elems[1]
            
            # Save sentences with index below 3.
            if int(index) < 3:
                # Save sentence.
                w_file.write(f'{line}')

