#!/usr/bin/env python3

import sys
import json
import os

s=sys.argv[1]
bucketPath= sys.argv[2]
quotedKeys = sys.argv[3]

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
    print(os.path.join(bucketPath,l))
