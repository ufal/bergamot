import os
import sys
import time

"""
References from wmt21 newstest are mixed up in a single file. This script must create separated files for each document in the references using a .tsv file containing the order of the documents in the references file.
"""

base_path = '/home/aires/personal_work_troja/style_transfer/doc_gender/data/wmt21/test-src/en-cs' # Path to folder containing files.
guide = '/home/aires/personal_work_troja/style_transfer/doc_gender/data/wmt21/test-src/en-cs/newstest2021.en-cs.tsv' # Path to .tsv
ref = '/home/aires/personal_work_troja/style_transfer/doc_gender/data/wmt21/test-src/en-cs/references/newstest2021.en-cs.ref.ref-A.cs' # Path to references.

with open(guide, 'r') as r_guide:

    _ = r_guide.readline() # Read header.
    r_ref = open(ref, 'r')

    previous = ''

    while True:
        # Read the next document to process.
        guide_line = r_guide.readline()

        if not guide_line:
            break

        # Take the doc path.
        ind, doc = guide_line.split('\t')
        doc = doc.strip()
        
        if doc != previous:
            
            if previous:
                w_ref.close()
                r_doc.close()

            previous = doc
            # Open doc.
            print(f'Reading : {doc}\n')
        
            doc_path = os.path.join(base_path, doc)
            # Setup the reference destination.
            ref_path = f'{doc_path}.cs'
            w_ref = open(ref_path, 'w')
            r_doc = open(doc_path, 'r') 

        # Read doc.
        d_line = r_doc.readline()
                
        r_line = r_ref.readline()

        if not r_line:
            print("Something's wrong! This line should exist.")
            sys.exit(1)

        w_ref.write(r_line)

