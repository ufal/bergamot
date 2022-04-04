import os
import sys

mode = sys.argv[1]
in_file = sys.argv[2]
out_file = f'{in_file}.{mode}'
WINDOW = 6
SEP = '<sep>'
FOLDER = True


def all_input(in_file, out_file):

    context = []

    with open(in_file, 'r') as r_file, open(out_file, 'w') as w_file: 

        while True:
            line = r_file.readline()

            if not line:
                break
            elif line == '\n':
                continue

            line = line.strip()

            # Create context.
            t_context = ' '.join(context)
            # Prepare output line.
            out_line = f'{t_context} {SEP} {line}\n'
    
            # Write to file.
            w_file.write(out_line)

            # Update context.
            l_context = len(context)
            if l_context == WINDOW:
                context.pop(0)
                context.append(line)
            elif l_context < WINDOW:
                context.append(line)
            else:
                raise("CONTEXT TOO BIG.")
                sys.exit(1)


def previous(in_file, out_file):

    with open(in_file, 'r') as r_file, open(out_file, 'w') as w_file:
        
        prev = ''
        
        while True:
            line = r_file.readline()

            if not line:
                break
            line = line.strip()

            out_line = f'{prev} {SEP} {line}\n'

            w_file.write(out_line)

            prev = line


if FOLDER:
    files = os.listdir(in_file)

    for f in files:
        if f.endswith('.ner') or f.endswith('.all') or f.endswith('.previous') or f.endswith('.cs'):
            continue

        f_path = os.path.join(in_file, f)
        
        if os.path.isdir(f_path):
            continue
        
        out_file = f'{f_path}.{mode}'
    
        if mode == 'all':
            all_input(f_path, out_file)

        elif mode == 'previous':
            previous(f_path, out_file)

else:

    out_file = f'{in_file}.{mode}'

    if mode == 'all':
        all_input(in_file, out_file)

    elif mode == 'previous':
        previous(in_file, out_file)
           
