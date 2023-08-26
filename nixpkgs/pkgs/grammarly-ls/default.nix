{ fetchzip, stdenvNoCC, nodejs-16_x }:

let

  # Take the pre-built grammarly language server from VSCode marketplace
  grammarly-ext = import ./grammarly-ext.nix { inherit fetchzip; };

in

stdenvNoCC.mkDerivation {
  name = "grammarly-ls";
  buildPhase = ''
      mkdir -p $out/bin

      cp -r ${grammarly-ext}/extension/dist/server $out/server
      cat <<EOF > $out/bin/grammarly-ls
      #! ${nodejs-16_x}/bin/node

      require('../server/index.node.js')
      EOF

      chmod +x $out/bin/grammarly-ls
    '';
  phases = [ "buildPhase" ];
}
