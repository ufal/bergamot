import os
import re
import sys

doc_regex = r'<doc[\w\s\W]+?</doc>'
p_regex = r'<p>[\w\W\s]+?</p>'

in_file = sys.argv[1]


