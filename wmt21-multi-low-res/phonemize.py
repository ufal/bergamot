import sys
from phonemizer import phonemize

backend='espeak'
lang=sys.argv[1]
if lang=="en":
    lang="en-us"
elif lang=="fr":
    lang="fr-fr"

#for line in sys.stdin:
#    print(phonemize(line, language=lang, backend=backend))
#    try:
#        print(phonemize(line, language=lang, backend=backend))
#    except:
#        print("#ERROR")
chunk_size=1000
sentences=sys.stdin.readlines()
for i in range(0, len(sentences), chunk_size):
    chunk = sentences[i:i+chunk_size]
    print('\n'.join(phonemize(chunk, language=lang, backend=backend,njobs=24)))
