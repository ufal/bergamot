import sys
from phonemizer import phonemize

backend='espeak'
lang=sys.argv[1]
if lang=="en":
    lang="en-us"
elif lang=="fr":
    lang="fr-fr"
for line in sys.stdin:
#    print(phonemize(line, language=lang, backend=backend))
    try:
        print(phonemize(line, language=lang, backend=backend))
    except:
        print("#ERROR")

