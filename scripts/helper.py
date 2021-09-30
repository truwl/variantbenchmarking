for vcf in ['B1S5A','WX8VK','CZA1Y','EIUT6','XC97E','XV7ZN','IA789','W607K']:
    print("""        if ~{{include{0}}}; then
         optvcfs="${{optvcfs}} {0}_~{{genome}}.vcf.gz"
         downloadList+=("gs://truwl-giab/submission_vcfs/{0}/{0}_~{{genome}}.vcf.gz")
        fi""".format(vcf))