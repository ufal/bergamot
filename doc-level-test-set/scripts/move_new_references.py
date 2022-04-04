import os
import shutil
import sys


in_folder = '/home/aires/Documents/repositories/gender-constraints/doc_gender/data/wmt21/test_en-cs/ner/corefs/corrected'
base_ref_path = '/home/aires/Desktop/references'
out_ref_path = '/home/aires/Desktop/new_references'#'/home/aires/Documents/repositories/gender-constraints/doc_gender/data/wmt21/test_en-cs/references'

# List files.
tsuite_files = os.listdir(in_folder)

for t_file in tsuite_files:

    t_file_path = os.path.join(in_folder, t_file)
    
    if os.path.isdir(t_file_path):
        continue

    # Get file name.
    file_name = '.'.join('-'.join(t_file.split('-')[3:]).split('.')[:-2]) + '.cs'

    base_file_path = os.path.join(base_ref_path, file_name)
    out_file_path = os.path.join(out_ref_path, file_name)

    if os.path.isfile(base_file_path):
        shutil.copyfile(base_file_path, out_file_path)
    else:
        print(f"Could not find file: {base_file_path}\nFile Name: {file_name}\nt_file: {t_file}")