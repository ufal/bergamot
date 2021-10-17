import sys
langs=['ca','it','fr','oc','en','es','ro','pt']
#threshold=0.1





langs=['__label__'+l for l in langs]
outfile=sys.argv[1]
with open('%s.langid_clean.src'%(outfile),'w') as srcClean,  open('%s.langid_clean.tgt'%(outfile),'w') as tgtClean,  open('%s.langid_bad'%(outfile),'w') as bad:
    for line in sys.stdin:
        tabs=line.strip().split('\t')
        if len(tabs)!=4:
            print ("BAD: %s" %line)
            continue
        
        if any(s in tabs[2] for s in langs) and any(t in tabs[3] for t in langs):
            srcClean.write(tabs[0]+'\n')
            tgtClean.write(tabs[1]+'\n')
        else:
            bad.write(line)

