import os
import sys

xml_in = sys.argv[1]

if not xml_in.endswith('.xml'):
    sys.exit("Use an xml file.")

basename, _ = os.path.splitext(xml_in)

with open(f"{basename}.snt","w") as text, open(f"{basename}_template.xml","w") as template, open(xml_in, 'r') as xml:
    for line in xml:
        if line.startswith("<"):
            template.write(line)
        else:
            text.write(line)
            template.write('\n')