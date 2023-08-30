{ haskellPackages, callPackage, hackage-mini-mega-2000 }:

let

  hackage-broken = callPackage ./hackage-broken.nix {};

  black-list = (__fromJSON (__readFile hackage-broken))
               ++ [
                 "foundation_0_0_28"
                 "directory_1_3_8_1"
                 "filepath_1_4_100_3"
                 "ghc-lib-parser_8_10_7_20220219"
                 "mmorph_1_1_3"
                 "hslua_2_3_0"
                 "hspec_2_7_10"
                 "ghc-lib-parser-ex_8_10_0_24"
                 "criterion_1_6_0_0"
                 "fourmolu_0_10_1_0"
                 "fourmolu_0_3_0_0"
                 "ghc-exactprint_0_6_4"
                 "ghc-exactprint_1_6_1_1"
                 "ghc-exactprint_1_7_0_0"
                 "ghc-lib-parser-ex_9_4_0_0"
                 "ghc-lib-parser-ex_9_6_0_0"
                 "haddock-library_1_7_0"
                 "hlint_3_2_8"
                 "hlint_3_5"
                 "hslua-typing_0_1_0"
                 "hspec-discover_2_7_10"
                 "http-api-data_0_5_1"
                 "network_2_6_3_1"
                 "optparse-applicative_0_15_1_0"
                 "ormolu_0_1_4_1"
                 "ormolu_0_2_0_0"
                 "ormolu_0_5_3_0"
                 "ormolu_0_6_0_1"
                 "lsp_1_4_0_0"
                 "pandoc_3_1_2"
                 "semialign_1_3"
                 "semigroupoids_6_0_0_1"
                 "strict_0_5"
                 "stylish-haskell_0_13_0_0"
                 "stylish-haskell_0_14_4_0"
                 "tasty-hedgehog_1_4_0_1"
                 "these_1_2"
                 "unix_2_8_1_1"
                 "warp_3_3_25"
                 "warp-tls_3_3_6"
               ];

  mega-2000 = __filter (n: ! __elem n black-list) hackage-mini-mega-2000;

in

haskellPackages.ghcWithPackages (hp: map (n: hp.${n}) mega-2000)

