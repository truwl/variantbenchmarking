#!/usr/bin/env python3

import sys
import json
import os

import argparse

# Usage: python structToTrueLines.py "{region_GRCh38_notinrefseq_cds: false, region_GRCh38_refseq_cds: true, region_GRCh38_HG001_PG2016_10_comphetindel10bp_slop50: true}" gs://truwl-giab/genome-stratifications/v2.0/GRCh38/GenomeSpecific lines


# Create the parser and add arguments
parser = argparse.ArgumentParser()
parser.add_argument(dest='regionHashFile', type=str, help="some region hash file containing {region_GRCh38_notinrefseq_cds: false, region_GRCh38_refseq_cds: true, region_GRCh38_BadPromoters: true}")
parser.add_argument(dest='bucketPath', type=str, help="some bucketPath like gs://truwl-giab/genome-stratifications/v2.0/GRCh38/GenomeSpecific")
parser.add_argument(dest='outputStyle', type=str, help="lines (region paths) or strattable (name\tregionPath)")

parser.add_argument('-quotedKeys', action="store_true", default=True)
args = parser.parse_args()

mydict = {}

regionHash = open(args.regionHashFile, 'r')

# if the keys aren't quoted make them
if args.quotedKeys == True:
    mydict = json.load(regionHash)
elif args.quotedKeys == False:
    mydict = json.load(regionHash.replace('{', '{"').replace(':', '":').replace(', ', ', "'))
else:
    print("need quoted keys arg")
    sys.exit(1)

filtered = [k for k, v in mydict.items() if (v == True or v == 'true')]

nodots = {'GIABv332': 'GIABv3.2.2', 'GIABv41': 'GIABv4.1', 'PG2016_10': 'PG2016-1.0', 'RTG_3773': 'RTG_37.7.3', 'v061': 'v0.6.1', 'HG002_GIAB_highconfidence': 'HG002_GRCh38_1_22_v4.2.1_benchmark_noinconsistent'}

for region in filtered:
    for nodot, dotty in nodots.items():
        region = region.replace(nodot, dotty)
    regionFile = region.replace('region_', '') + '.bed.gz'
    if args.outputStyle == 'lines':
        print(os.path.join(args.bucketPath, regionFile))
    elif args.outputStyle == 'strattable':
        # gs://truwl-giab/genome-stratifications/v2.0/GRCh38/FunctionalRegions/GRCh38_BadPromoters.bed.gz
        # this gets localized as /cromwell_root/truwl-giab/genome-stratifications/v2.0/GRCh38/FunctionalRegions/GRCh38_BadPromoters.bed.gz
        absPath = args.bucketPath.replace('gs://', '/cromwell_root/')
        print("{0}\t{1}".format(region, os.path.join(absPath, regionFile)))
    else:
        print("need format as lines or strattable")
        sys.exit(1)
