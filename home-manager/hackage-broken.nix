{ runCommand, jq, candidates-txt ? ./hackage-blacklist-candidates.txt }:

runCommand "hackage-broken.json" { buildInputs = [ jq ]; } ''
  cat ${candidates-txt} | uniq | jq '[., inputs]' > $out
''
