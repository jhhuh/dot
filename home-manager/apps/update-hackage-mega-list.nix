{ ghcWithAllPackages, jq }: ''
  cat <<EOF | ${jq}/bin/jq | tee ./hackage-mega-list.json
  ${__toJSON ghcWithAllPackages.all-package-names}
  EOF
''
