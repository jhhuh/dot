{ nix, writeScriptBin, vscode-utils, version ? "0.22.1" }:

let

   publisher="znck";

   name="grammarly";
   url =
     (vscode-utils.fetchVsixFromVscodeMarketplace {
       inherit version publisher name; }).url;
in

''
  sha256=$(${nix}/bin/nix-prefetch-url --unpack ${url})

  cat <<EOF > ./pkgs/grammarly-ls/grammarly-ext.nix
  { fetchzip }:
  fetchzip {
    url = "${url}";
    sha256 = "$sha256";
    extension = "zip";
    stripRoot = false;
  }
  EOF
''
