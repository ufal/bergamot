import os
import re
import sys

"""
References from wmt20 newstest are mixed up in a single file. This script creates separated files for each document in the references.
"""

base_path = '/home/aires/Desktop/test/sgm/newstest2020-encs-ref.cs.sgm' # Path to file containing docs.
ref = '/home/aires/Desktop/references' # Path to references folder.

# Read file.
with open(base_path, 'r') as r_file:

    w_file = None

    while True:
        line = r_file.readline()
        if not line:
            break

        if line.startswith("<doc"):
            # New document.
            # Close previous document.
            if w_file:
                w_file.close()
            # Find document name.
            s_line = line.split()
            docid = s_line[2]
            file_name = docid.split('"')[1]
            file_name = file_name + ".cs"
            file_path = os.path.join(ref, file_name)
            # Open write file.
            w_file = open(file_path, 'w')
        elif line.startswith("<seg"):
            text = line.split(">")[1].split("<")[0]
            w_file.write(f"{text}\n")