{ callPackage, jq, parallel, hackage-mega-list }:

let

  hackage-broken = callPackage ../hackage-broken.nix {};

  black-list = __fromJSON (__readFile hackage-broken);

  names = __filter (n: ! __elem n black-list) hackage-mega-list;

in

''
  function gen_names () {
    cat <<EOF | ${jq}/bin/jq .[]
  ${__toJSON names}
  EOF
  }

  function build () {
    local jobid="$1"
    local name="$2"
    (nix build -L .#pkgs.haskellPackages."$name" 2>&1 | xargs -I {} echo -e "\033[0;31m[$jobid: $name]\033[0m {}") || (echo "$name" >> ./hackage-blacklist-candidates.txt)
  }

  export -f build

  gen_names | ${parallel}/bin/parallel build {#} {}
''
