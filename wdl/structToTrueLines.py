#!/usr/bin/env python3

import sys
import json

s=sys.argv[1]
quotedKeys = True

mydict = {}

#if the keys aren't quoted make them
if quotedKeys:
    mydict = json.loads(s)
else:
    mydict = json.loads(s.replace('{','{"').replace(':','":').replace(', ',', "'))

filtered = [k for k, v in mydict.items() if v]

print("test line")
for l in filtered:
    print(l)
