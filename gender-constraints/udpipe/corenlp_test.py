import  sys
import corenlp

text = "John wrote a simple sentence that he parse with Stanford CoreNLP."
text1 = "The developer argued with the designer because she did not like the design."

with corenlp.CoreNLPClient(annotators="tokenize ssplit pos lemma ner depparse dcoref".split()) as client:
    ann = client.annotate(text1)

print(ann)
print(type(ann))

if type(ann) == dict:
    print(ann.keys())

sentence = ann.sentence[0]

sys.exit(0)
assert corenlp.to_text(sentence) == text, "Should return the same text"

print(sentence.text)

token = sentence.token[0]
print(token.lemma)

sys.exit(0)

pattern = '([ner: PERSON]+) /wrote/ /an?/ []{0,3} /sentence|article/'
matches = client.tokensregex(text, pattern)

assert len(matches["sentences"]) == 1

sys.exit(0)

matches["sentences"][1]["0"]["text"] == "John wrote a simple sentence"
matches["sentences"][1]["0"]["1"]["text"] == "Chris"

pattern = '{word:wrote} >nsubj {}=subject >dobj {}=object'
matches = client.semgrex(text, pattern)

assert len(matches["sentences"]) == 1

assert matches["sentences"][0]["length"] == 1

matches["sentences"][1]["0"]["text"] == "wrote"

matches["sentences"][1]["0"]["$subject"]["text"] == "John"
matches["sentences"][1]["0"]["$object"]["text"] == "sentence"
