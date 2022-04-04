import os
import sys
import pickle

# Constants.
files_path = '../data/wmt21/test-src/en-cs/ner'
out_file = '../data/wmt21/test-src/en-cs/ner/person_names.pkl'


def process_ner(ner_line: str) -> str:
    # Find tags.
    person_name = ''

    # ner_line example: John Paul lives in the USA.\tJohn Paul/PERSON\tUSA/GPE

    line = ner_line.strip()
    s_line = line.split('\t')
    ls_line = len(s_line)

    if ls_line < 2:
        return person_name
    else:
        # s_line example: ["John Paul lives in the USA.", "John Paul/PERSON", "USA/GPE"]
        tags = s_line[1:]
        # tags example: ["John Paul/PERSON", "USA/GPE"]

    if tags == '\n':
        return person_name

    # Manipulate tags.
    # tags example: "John/PERSON USA/GPE"
    for t in tags:
        ts = t.split('/')
        if len(ts) > 2:
            tag = ts[-1]
            text = '/'.join(ts[:-1])
        elif len(ts) < 2:
            continue
        else:
            text, tag = ts[0], ts[1]

        if 'PERSON' in tag:
            person_name += text

            
    return person_name

person_names = dict()

# Read files.
for f in os.listdir(files_path):
    person_names[f] = dict()
    # Ignore folders.
    f_path = os.path.join(files_path, f)
    if os.path.isdir(f_path) or f.endswith('.pkl'):
        continue
    print(f_path) 
    # Read lines.
    line_counter = 0
    with open(f_path, 'r') as r_file:
        while True:
            line = r_file.readline()
            if not line:
                break
            
            # Check if it has PERSON.
            l_line = line.split('\t')
            if len(l_line) < 2:
                continue
            else:
                tags = l_line[2:]
            print(tags)
            for tag in tags:
                if 'PERSON' in tag:
                    # Identify PERSON name and position.
                    print("Found PERSON")
                    person_name = process_ner(line)
                    if person_name:
                        if person_name in person_names[f]:
                            person_names[f][person_name].append(line_counter)
                        else:
                            person_names[f][person_name] = [line_counter]

            line_counter = line_counter + 1


# Save to Pickle.
out_write = open(out_file, 'wb')
print(person_names)
pickle.dump(person_names, out_write)
out_write.close()
