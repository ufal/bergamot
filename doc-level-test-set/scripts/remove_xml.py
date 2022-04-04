import os
import sys
import xml.etree.ElementTree as ET

in_folder = sys.argv[1]

# Check files in folder.
f_files = os.listdir(in_folder)

# Run over files.
for fi in f_files:
   
    # Create a folder for the lang pair.
    if fi[-3:] != 'xml':
        continue

    print(fi)
    print(fi.split('.'))
    lang_pair = fi.split('.')[-2]
    lang_pair_folder = os.path.join(in_folder, lang_pair)
    if not os.path.isdir(lang_pair_folder):
        os.mkdir(lang_pair_folder)

    file_path = os.path.join(in_folder, fi)

    xml_file = ET.parse(file_path)
    root = xml_file.getroot()

    # Create a foder for each file.
    for doc in root:
        # Find <doc> and create a file for it.
        doc_id = doc.attrib['id']
        doc_folder = os.path.join(lang_pair_folder, doc_id)
        w_doc = open(doc_folder, 'w')

        for src in doc:
            for p in src:
                # Look for <p> tags.
                for seg in p:
                    # Look for segments.
                    t = seg.text
                    w_doc.write(t + '\n')
        w_doc.close()
