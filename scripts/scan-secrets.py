#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.detect-secrets

import json
import os
import sys

results = json.load(os.popen("detect-secrets scan"))["results"]

    
for (fn, res) in [(k, v) for (k, vs) in results.items() for v in vs]:
    print("***", fn, "***")
    n = res["line_number"]
    print(os.popen(f"sed -n '{n-3},{n-1}p' {fn}").read())
    print("\33[91m",os.popen(f"sed -n '{n}p' {fn}").read(), "\33[0m")
    print(os.popen(f"sed -n '{n+1},{n+3}p' {fn}").read())
