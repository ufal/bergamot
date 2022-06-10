import os
import sys

# Create train and test splits.

in_file = sys.argv[1]

test_size = 0.01

# Check the number of lines.
n_lines = sum(1 for x in open(in_file, 'r').readlines())

test_lines = int(n_lines * test_size)

out_train = in_file + '.train'
out_test = in_file + '.test'

os.system(f'tail -n {test_lines} {in_file} > {out_test}')

train_lines = n_lines - test_lines

os.system(f'head -n {train_lines} {in_file} > {out_train}')
