import os
import sys

in_file = sys.argv[1]

with open(in_file, 'r') as r_file:
    c_lines = 0
    g_dist = 0
    while True:
        line = r_file.readline()
        if not line:
            break
        c_lines = c_lines + 1
        s_line = line.split()

        g_factor = 0
        l_line = len(s_line)

        for elem in s_line:
            factor = elem[-1]

            if factor == '1' or factor == '2':
                g_factor = g_factor + 1

        l_dist = g_factor/l_line
        g_dist = g_dist + l_dist
    print(g_dist/c_lines)
