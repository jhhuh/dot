{ lib, newScope, writeScriptBin, scripts ? {}, ... }@args:

let

  extra-scope = builtins.removeAttrs args [ "lib" "newScope" "writeScriptBin" "scripts" ];

  callPackage = newScope extra-scope;

  mk-scoped-string = text:
    let
      symbols =
        map
          (x: __elemAt x 0)
          (__filter
            __isList
            (__split "@@([^@]*)@@" text));
      f = args:
        let
          place-holders = map (s: "@@${s}@@") symbols;
          actual-values = map (s: (toString args.${s})) symbols;
        in
          __replaceStrings place-holders actual-values text;
      in
        {
          __functor = _: f;
          __functionArgs =
            __listToAttrs
              (map
                (name: { inherit name; value = false; })
                symbols);
        };

  chdir-flake-root = ''
     ################ find-flake-root ################

     find_flake_root() {
       while true; do
         if [[ -f "./flake.nix" ]]; then
           echo "$PWD"
           exit 0
         fi
         if [[ "$PWD" == "/" ]]; then
           echo "ERROR: Unable to find flake.nix" >&2
           exit 1
         fi
         cd ..
       done
     }

     FLAKE_ROOT="$(find_flake_root)"

     exit_code=$?
     (( exit_code != 0 )) && exit $exit_code
     unset exit_code

     cd $FLAKE_ROOT

     #################################################
  '';

  text-to-app = name: text:
    let
      script = writeScriptBin "${name}.sh" ''
        ${chdir-flake-root}
        ${text}
      '';
    in
      { type = "app"; program = "${script}/bin/${name}.sh"; };

  all-nix-app-names = __filter lib.isString (
    map
      (path:
        let
          matches = __match ".*/(.*).nix" (toString path);
        in
          if lib.isList matches && __length matches == 1 && __head matches != "default"
          then __head matches
          else null)
      (lib.filesystem.listFilesRecursive ./.));

  all-sh-app-names = __filter lib.isString (
    map
      (path:
        let
          matches = __match ".*/(.*).sh" (toString path);
        in
          if lib.isList matches
          then __head matches
          else null)
      (lib.filesystem.listFilesRecursive ./.));

  all-nix-apps = __mapAttrs text-to-app (__listToAttrs (
    map
      (name: {
        inherit name;
        value = callPackage (./. + "/${name}.nix") {};
      })
      all-nix-app-names));

  all-sh-apps = __mapAttrs text-to-app (__listToAttrs (
    map
      (name: {
        inherit name;
        value =
          callPackage
            (mk-scoped-string (__readFile (./. + "/${name}.sh")))
            {};
      })
      all-sh-app-names));

  all-oneliner-apps =
    __mapAttrs
      (name: value:
        text-to-app
          name
          (callPackage
            (mk-scoped-string value)
            {}))
      scripts;

in

all-sh-apps
// all-nix-apps
// all-oneliner-apps
