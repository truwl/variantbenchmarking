#!/usr/bin/env python3

import sys
import json

s=sys.argv[1]
quotedKeys = sys.argv[2]

mydict = {}

#if the keys aren't quoted make them
if quotedKeys == 'true':
    mydict = json.loads(s)
elif quotedKeys == 'false':
    mydict = json.loads(s.replace('{','{"').replace(':','":').replace(', ',', "'))
else:
    print("need quoted keys arg")
    sys.exit(1)
filtered = [k for k, v in mydict.items() if v]

for l in filtered:
    print(l)
