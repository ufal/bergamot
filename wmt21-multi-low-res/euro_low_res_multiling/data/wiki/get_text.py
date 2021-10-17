from wiki_dump_reader import Cleaner, iterate
import sys
fn=sys.argv[1]
cleaner = Cleaner()
for title, text in iterate(fn):
    text = cleaner.clean_text(text)
    cleaned_text, links = cleaner.build_links(text)
    #if len(cleaned_text.split(' '))>6:
    print(cleaned_text)
