{ haskellPackages, callPackage, hackage-mini-mega-200 }:

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

  mega-200 = __filter (n: ! __elem n black-list) hackage-mini-mega-200;

in

haskellPackages.ghcWithPackages (hp: map (n: hp.${n}) mega-200)
# error: 1 dependencies of derivation '/nix/store/a5icq5rxj5kqn3nx9894aa4n3izri87d-spatial-math-0.5.0.1
# error: 1 dependencies of derivation '/nix/store/zch0rdb7w2674a2q0dhk3qldq3dqvr47-certificate-1.3.9
# error: 1 dependencies of derivation '/nix/store/w3p976pfic92755dx7nx872hydwhm97b-morley-prelude-0.5.2
# error: 1 dependencies of derivation '/nix/store/50pbsqj36ahvw29ahvgxcs1ybihn7pb9-wire-streams-0.1.1.0
# error: 1 dependencies of derivation '/nix/store/3siy16sa0sakjq74r0ww2cvlrkkx9p3s-crypto-sodium-0.0.5.0
# error: 1 dependencies of derivation '/nix/store/za4hh2pr6admsfihhn1lhaav1g4i0q0i-box-socket-0.4.1
# error: 1 dependencies of derivation '/nix/store/7d8x9h7fmb9xsiyjgzh7l3gglrwcfp5d-find-clumpiness-0.2.3.2
# error: 1 dependencies of derivation '/nix/store/aasgc7slisl0hmswj5mi9b855dk8dm11-free-functors-1.2.1
# error: 2 dependencies of derivation '/nix/store/skax9d6shbc75iplnaicjrnqr5rpkafj-web-rep-0.10.1
# error: 1 dependencies of derivation '/nix/store/p0lvcsmhcmgzr7kjx3wah8r2idgdf55f-free-game-1.2
# error: 1 dependencies of derivation '/nix/store/hkn7z8j8apv4531vljmhcprkchac325x-amazonka-test-1.6.1
# error: 2 dependencies of derivation '/nix/store/x02kl3c829mcy8dzjcsaha4nmk7sv15q-amazonka-kinesis-1.6.1
# error: 2 dependencies of derivation '/nix/store/k2wrrr7lakr1c0kpb8pl6i1yacxgmkyf-amazonka-s3-1.6.1
# error: 3 dependencies of derivation '/nix/store/l8imn0f7y8ksw0kaspq4rq5rw3m7hw1g-serverless-haskell-0.12.6
# error: 2 dependencies of derivation '/nix/store/dlk2vcmchyz9334fnsn4yrl3h9n3l9fs-cryptocipher-0.6.2
# error: 1 dependencies of derivation '/nix/store/k31dlys9hz27n0nd72rcnm183n3ax5j0-crypto-pubkey-0.2.8
# error: 2 dependencies of derivation '/nix/store/xjv80ravv9g3hfh2ac02l5y5wv303rgq-tls-extra-0.6.6
# error: 1 dependencies of derivation '/nix/store/i71k67jw1bjlwndagb1dpqqic90ylqbn-attoparsec-enumerator-0.3.4
# error: 1 dependencies of derivation '/nix/store/vs4pap6gybwr2vcgvvmcw03lpa0yh24a-blaze-builder-enumerator-0.2.1.0
# error: 1 dependencies of derivation '/nix/store/pc72gnad4qd6i82hc60vwmgdw9n8iniz-zlib-enum-0.2.3.1
# error: 7 dependencies of derivation '/nix/store/jqpazs9wfb7s7w78svjpxih9wh0ypfj1-http-enumerator-0.7.3.3
# error: 1 dependencies of derivation '/nix/store/xqvs6v6wnc2xm8n0hlbf2lmz149li7gq-haskoin-store-0.65.9
# error: 1 dependencies of derivation '/nix/store/0hby4zq3ir521kdd7d9n7nkpvnnawj8h-diagrams-haddock-0.4.1.1
# error: 1 dependencies of derivation '/nix/store/1j45hs4b7br57kpg8av6dzkkpp2dyshk-egison-pattern-src-th-mode-0.2.1.2
# error: 2 dependencies of derivation '/nix/store/sjp3lnrnm8hm7m4ibjdl1s4xd39c1cvy-sweet-egison-0.1.1.3
# error: 1 dependencies of derivation '/nix/store/j17rlnanq5cs6yg93mvmivh96ny06j8i-egison-4.1.3
# error: 1 dependencies of derivation '/nix/store/4i6sqxrvm2qrw41125iksr24q9r8gq97-ekg-0.4.0.15
# error: 1 dependencies of derivation '/nix/store/grhni7k6p18xh418krb8j7056m39p8n5-elliptic-curve-0.3.0
# error: 2 dependencies of derivation '/nix/store/z55vn8g3cw7aj93wz8fvl1w2b0mqz8nl-pairing-1.1.0
# error: 5 dependencies of derivation '/nix/store/602356pjq3cw8p1xmjv6ja1xzvl2f5bm-morley-1.19.1
# error: 2 dependencies of derivation '/nix/store/abnknh29x3hdyshx4m8gs4h9vvlgla7q-lorentz-0.15.1
# error: 1 dependencies of derivation '/nix/store/iby6bk9zm1xdgldrmfcsgcf7iki1y095-haddock-2.23.1
# error: 1 dependencies of derivation '/nix/store/ymmc6llglm5liq7b3qnjnmhkf1mxciai-haddock-2.27.0
# error: 4 dependencies of derivation '/nix/store/7hkca3f7l6d1rdfaqq7mdrf9jmgnxdn4-hierarchical-spectral-clustering-0.5.0.1

# error: builder for '/nix/store/54jf0cdp6r0iq8bv3glp0298lmgaibi6-TypeCompose-0.9.14.drv' failed with exit code 1;
# error: builder for '/nix/store/lvkxhxzrgz8mav7pazbhgjxbsmzc86g9-animalcase-0.1.0.2.drv' failed with exit code 1;
# error: builder for '/nix/store/1b7qf3szfp7fp06a33azhscfq4g9ffah-OddWord-1.0.2.0.drv' failed with exit code 1;
# error: builder for '/nix/store/fbppn3xkiagv6cyc7c5xwsh6hnjsds47-asn1-data-0.7.2.drv' failed with exit code 1;
# error: builder for '/nix/store/k98yhwgr238fk7a740cacdq03ml4w6yr-binary-bits-0.5.drv' failed with exit code 1;
# error: builder for '/nix/store/sx7ly6dc5rpp3ix5vsvag50k7yskpsbk-binary-parsers-0.2.4.0.drv' failed with exit code 1;
# error: builder for '/nix/store/bs4m4nv5amjkiqhvwk1a7k5y31s1jka7-NaCl-0.0.5.0.drv' failed with exit code 1;
# error: builder for '/nix/store/6gcy2f9r68b1z1228ipknhpsamrznz2d-code-builder-0.1.3.drv' failed with exit code 1;
# error: builder for '/nix/store/a96jrzm3jsbh2b6d692hrhibwj9firb4-BiobaseNewick-0.0.0.2.drv' failed with exit code 1;
# error: builder for '/nix/store/5jqj8x8v8sxrpbf486g27h078d3sgl89-aeson-utils-0.3.0.2.drv' failed with exit code 1;
# error: builder for '/nix/store/7qhb04ik21hbfa6vykq2xss9pg2pzqv5-box-0.9.1.drv' failed with exit code 1;
# error: builder for '/nix/store/pjqi42iqjd5nhpqrm2bjpzgq6agz0skc-derive-lifted-instances-0.2.2.drv' failed with exit code 1;
# error: builder for '/nix/store/rb4977ij00i4jdxiwbb81nc0482ddhs6-amazonka-core-1.6.1.drv' failed with exit code 1;
# HSet> src/Data/HSet/Types.hs:18:10: error:
# error: builder for '/nix/store/cvs647fckmzzi51g0vlfd4lbyqkbrdja-HSet-0.0.1.drv' failed with exit code 1;
#        > src/Data/HSet/Types.hs:18:10: error:
# error: builder for '/nix/store/gpxyp6w7axwm26lgs0xi2sl6wr16glji-dependent-map-0.2.4.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/pk9xdf2s0bl99zcihkamy7lyvyfczr36-pred-set-0.0.1.drv' failed to build
# JuicyPixels-util> Codec/Picture/RGBA8.hs:80:86: error:
# error: builder for '/nix/store/pszrljr7b120m2c36hhzqmblf9hsii6v-JuicyPixels-util-0.2.drv' failed with exit code 1;
#        > Codec/Picture/RGBA8.hs:80:86: error:
# cipher-blowfish> Crypto/Cipher/Blowfish/Primitive.hs:53:32: error:
# cipher-blowfish>                       $ "internal error: Crypto.Cipher.Blowfish:keyFromByteString"
# error: builder for '/nix/store/k8n6113x0snsgzx2rjb99i2a2h7v0ixc-cipher-blowfish-0.0.3.drv' failed with exit code 1;
#        >                       $ "internal error: Crypto.Cipher.Blowfish:keyFromByteString"
# error: builder for '/nix/store/hsqpagmgmg8xicds8iwdw9m129nygmvc-dhall-1.29.0.drv' failed with exit code 1;
# error: builder for '/nix/store/jpyqkvpv40dihqap009kc65m00afgp68-dhall-1.38.1.drv' failed with exit code 1;
# cipher-des> Crypto/Cipher/DES/Serialization.hs:24:49: error:
# error: builder for '/nix/store/rwq4xmfbzmvn111xrjqk2n55ms0f69ln-cipher-des-0.0.6.drv' failed with exit code 1;
#        > Crypto/Cipher/DES/Serialization.hs:24:49: error:
# crypto-numbers> Crypto/Number/Prime.hs:82:6: error:
# crypto-numbers> Crypto/Number/Prime.hs:92:10: error:
# error: builder for '/nix/store/1dbcrp39y3i6ihk4rdxyc16bh6a1m0g1-crypto-numbers-0.2.7.drv' failed with exit code 1;
#        > Crypto/Number/Prime.hs:92:10: error:
# error: builder for '/nix/store/0hwv5r1hn8rwz2g7kidswwy95c7ya416-dunai-0.11.0.drv' failed with exit code 1;
# error: builder for '/nix/store/kxzc5kzqk08bi0p3fsdxqx2vh6rwxz5b-enumerator-0.4.20.drv' failed with exit code 1;
# error: builder for '/nix/store/0f5k8lhhmw7xazngjad5rbwwvdca0p8p-ekg-statsd-0.2.5.0.drv' failed with exit code 1;
# error: builder for '/nix/store/qcm4snm41l7wfjfk399yaf84hw7c72xb-diagrams-builder-0.8.0.5.drv' failed with exit code 1;
# error: builder for '/nix/store/xgvdxc30v44b7c1928rdgy0hqxmc3sr7-diagrams-lib-1.4.5.3.drv' failed with exit code 1;
# error: builder for '/nix/store/n1i5yr9nb12gp1k41kk1igglgcvq9p9w-egison-pattern-src-0.2.1.2.drv' failed with exit code 1;
# error: builder for '/nix/store/qsdflpgxiwj5gn3hn5jq49rj39xwajr7-dhall-1.42.0.drv' failed with exit code 1;
# error: builder for '/nix/store/hhrglsn5yag0hjhmv8v5siak15ybh2ga-generic-xmlpickler-0.1.0.6.drv' failed with exit code 1;
# error: builder for '/nix/store/q513qk3msdmcqp195493d2dbhb6035pb-dhall-bash-1.0.41.drv' failed with exit code 1;
# error: builder for '/nix/store/0n6s6ly8fl0bnn78c6qxj30z6azgrqbn-dhall-json-1.7.12.drv' failed with exit code 1;
# error: builder for '/nix/store/3aw5sxvvgh5qrwh3psp375qwz6yqgcm7-ekg-json-0.1.0.6.drv' failed with exit code 1;
# djinn-ghc> src/Djinn/GHC.hs:13:1: error:
# djinn-ghc> src/Djinn/GHC.hs:14:1: error:
# djinn-ghc> src/Djinn/GHC.hs:16:1: error:
# djinn-ghc> src/Djinn/GHC.hs:17:1: error:
# djinn-ghc> src/Djinn/GHC.hs:18:1: error:
# error: builder for '/nix/store/g3al6dy8l8m2x4b3c6vh603q22gfza0i-galois-field-1.0.2.drv' failed with exit code 1;
# error: builder for '/nix/store/lfki473j8ml8y307gpm5inpbdfivc8i5-djinn-ghc-0.0.2.3.drv' failed with exit code 1;
#        > src/Djinn/GHC.hs:18:1: error:
# gray-code> Codec/Binary/Gray_props.hs:4:1: error:
# error: builder for '/nix/store/8g44ip86i4kk1adi5yzr2vfsypb676hz-eventlog2html-0.10.0.drv' failed with exit code 1;
# error: builder for '/nix/store/2k7ds13351riafbl3yhrnvkxs8pv2i48-gray-code-0.3.1.drv' failed with exit code 1;
#        > Codec/Binary/Gray_props.hs:4:1: error:
# error: 1 dependencies of derivation '/nix/store/8qk4gkf9vqyz6hdfxhvahndp5xi6m4jn-moo-1.2.drv' failed to build
# error: builder for '/nix/store/rqxhr2dvzb2bqv6w0zzhnrpgzqjv4q4q-ghc-9.6.1.drv' failed with exit code 1;
# error: builder for '/nix/store/h8py1l4jcggjhhbj4irv4mwyvi1ghjm2-ghc-boot-9.6.1.drv' failed with exit code 1;
# error: builder for '/nix/store/al75fjr29brd5sv3gnq21svpabd17v67-ghc-lib-8.10.7.20220219.drv' failed with exit code 1;
# cabal-helper> src/CabalHelper/Runtime/Compat.hs:36:5: error:
# error: builder for '/nix/store/2kfpd8nywn8hd4ixzqfdnlis1w0fqllm-ghc-lib-9.4.5.20230430.drv' failed with exit code 1;
# error: builder for '/nix/store/7zy5nsrk0fm4y495ixxr0k6qwpdadm60-ghc-lib-9.6.1.20230312.drv' failed with exit code 1;
# error: builder for '/nix/store/ljz2jhnyqk2g9k22fkrih7bsvh5gs6ga-ghc-syb-utils-0.3.0.0.drv' failed with exit code 1;
# error: builder for '/nix/store/wgq1zxf7cl89mjwvnm71g2s1xvinqids-ghcid-0.8.8.drv' failed with exit code 1;
# error: builder for '/nix/store/0h2bmknjxwqdxy1kzxjyjmqlwlg4ymnd-headed-megaparsec-0.2.1.2.drv' failed with exit code 1;
# error: builder for '/nix/store/gbr625rxxkbi0l2ffi7b3hq0kprfpzf3-haddock-api-2.27.0.drv' failed with exit code 1;
# error: builder for '/nix/store/b4mr8jx2mw3kncccahy3r9p015xpmnva-hinotify-0.3.9.drv' failed with exit code 1;
# error: builder for '/nix/store/2ng48gv3nmmyphk4dgv3nh7zs1rds81r-hjsmin-0.2.1.drv' failed with exit code 1;
# error: builder for '/nix/store/glnhc5hd8ylj86s0pw9i492q684508f1-haskell-lsp-types-0.24.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/rbxyhg9brwrvg4im2mdfk7gfqclgp69h-haskell-lsp-0.24.0.0.drv' failed to build
# error: builder for '/nix/store/v6807j7zdqf14rr8c5jac3k1g7rmbxr4-gi-graphene-1.0.7.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/dqa5mmkykcnw4zf3v99m71qrdxwpj4py-gi-gsk-4.0.7.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/ffx3pkngqbdzb7zpwcvrz3r0j83mspyh-gi-gtk-4.0.8.drv' failed to build
# error: builder for '/nix/store/8n1a3rghc5pmvybyfvspinhpawf5smxr-gi-javascriptcore-6.0.3.drv' failed with exit code 1;
# error: builder for '/nix/store/kbpyi2j5x1yw4yr30ya1v2qamx374xq6-hmatrix-svdlibc-0.5.0.1.drv' failed with exit code 1;
# error: builder for '/nix/store/vwm0kr5p9f8m8mh80c7fx3001l1c7d13-ghc-bignum-1.3.drv' failed with exit code 1;
# error: builder for '/nix/store/759bd9pnfibniaw86hwj66yv49brlkhw-hs-rqlite-0.1.2.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/y0vamxckh80yl1ddqfz0s69wsh9khhj7-quickcheck-state-machine-0.7.2.drv' failed to build
# error: builder for '/nix/store/b56zc3zih2mpsnqm7nxrsbm25w293b4q-hoauth2-2.8.0.drv' failed with exit code 1;
# error: builder for '/nix/store/3pjxydmfd343z6y6562l42q6lcb8cdpj-hledger-ui-1.29.2.drv' failed with exit code 1;
# error: builder for '/nix/store/9z2sjgaqm6h6q69w36jgl8inb7x9sxhv-hruby-0.5.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/95zfbap2j8sg0x7hfi0xa65615iln1dl-language-puppet-1.4.6.5.drv' failed to build
# differential> src/Plot.hs:38:5: error:
# differential> src/Utility.hs:48:5: error:
# error: builder for '/nix/store/ia02mlqfrqy94xmx1ilj2x66qvxldpsa-differential-0.2.0.1.drv' failed with exit code 1;
# error: builder for '/nix/store/47dkyjxq4q9bs71w0y4ra4rniidl9jic-hledger-web-1.29.2.drv' failed with exit code 1;
# error: builder for '/nix/store/ny0nnlxi53xmzd6cl6gzdmg32601k5y6-hslua-module-path-1.1.0.drv' failed with exit code 1;
# error: builder for '/nix/store/xplxzs5ji9jzigl2ygh0pzcyn0m2w352-hslua-module-system-1.1.0.1.drv' failed with exit code 1;
# error: builder for '/nix/store/bpxcdhg3sxsidsbrvrb3z0kihgmzx5z1-hslua-core-2.3.1.drv' failed with exit code 1;
# error: builder for '/nix/store/5qfjqirjp2ig8pnrdbispd56vqc0rxix-hslua-module-doclayout-1.1.0.drv' failed with exit code 1;
# error: builder for '/nix/store/wk4jampzp8b39ryrnp97kiyh7fc45brq-hslua-repl-0.1.1.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/f54q9gad0r159z9v2snsc3025m8ynm5z-hslua-cli-1.4.1.drv' failed to build
# error: builder for '/nix/store/5z074d2x0770l41v6m2xpv31z5dlrzz1-gi-gdkx11-4.0.7.drv' failed with exit code 1;
# error: builder for '/nix/store/kasl4h6yma6kah0vqbnrvp75knarv013-hslua-module-version-1.1.0.drv' failed with exit code 1;
# error: builder for '/nix/store/pkgpqwcia6f8aa93bkx9f1dbsxpf7ama-hslua-module-text-1.1.0.1.drv' failed with exit code 1;
# error: builder for '/nix/store/264ac67ifvr6gsrdfp95frykv16zjl54-hslua-typing-0.1.0.drv' failed with exit code 1;
# error: builder for '/nix/store/mv2qhhl5sdzp8k7s582rfdl9aghfnn53-hspec-api-2.11.0.1.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/4cw3z187v0j5pr5zx01disnz1l0i1iw5-hslua-module-zip-1.1.0.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/8cy6iszv0dqwj2nb9rfm06znvyli0185-hslua-objectorientation-2.3.0.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/qi4v73aldfbgim3s1q1jjc4v6mw2mmv4-hslua-packaging-2.3.0.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/lwx6q43m5rvr1nc54nv09585r1wd0aah-pandoc-lua-engine-0.2.drv' failed to build
# error: builder for '/nix/store/64fmz4ygminhk804l2blmnzj5p6cvppa-hxt-pickle-utils-0.1.0.3.drv' failed with exit code 1;
# error: builder for '/nix/store/x0fk5mbi9swc4r6mmx9fqkk2v1rwhbyk-hspec-smallcheck-0.5.3.drv' failed with exit code 1;
# error: builder for '/nix/store/pqkqk1ir1k2a9gdlfjy5ij4gr277jhyp-iteratee-0.8.9.6.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/slra1n7qsk3dj0hzjkdj0r7i3l98xdvj-iteratee-compress-0.3.3.1.drv' failed to build
# error: builder for '/nix/store/9bs5w8r0jck6aqcph0rgbz9zvx5jc1rl-kind-generics-th-0.2.3.0.drv' failed with exit code 1;
# error: builder for '/nix/store/3xjx07j2slwvgk774dba7lmwghidbhsa-json-alt-1.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/sb1yp222w1hx3ii8907s5nfmismshv4r-json-autotype-3.1.2.drv' failed to build
# error: builder for '/nix/store/ghrpxa3vm5crhi9ifrh9r00gr3db6y99-json-schema-0.7.4.2.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/i03kk545n258fdjnp6phws85qxrvfdy1-rest-stringmap-0.2.0.7.drv' failed to build
# error: 3 dependencies of derivation '/nix/store/sgcg0mp8phpz9s7i6lfqxxq6d7cs6laa-rest-types-1.14.1.2.drv' failed to build
# error: 3 dependencies of derivation '/nix/store/49j080sf09wmhb1aa5x6b2xh5ry4sqp5-rest-client-0.5.2.3.drv' failed to build
# error: 5 dependencies of derivation '/nix/store/zp99kxbhdfgdvkqmyy6nl44fk9pglq8x-rest-core-0.39.0.2.drv' failed to build
# error: 3 dependencies of derivation '/nix/store/86g13qjk269ps5xzk5nzg1chhsmd46i4-rest-gen-0.20.0.3.drv' failed to build
# error: builder for '/nix/store/h1fjk0vkdhqy4acdhh8i4dyphg7xlaqz-jsonrpc-tinyclient-1.0.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/ir12vk2f1kagngcziqpsr808xb0z95f1-web3-provider-1.0.0.0.drv' failed to build
# error: builder for '/nix/store/dx451p0n444bybvp82sc145lv46lr7db-lattices-2.2.drv' failed with exit code 1;
# error: builder for '/nix/store/sfmib7cm8kvi3l73zidl1fr88zjmafd4-linear-generics-0.2.2.drv' failed with exit code 1;
# error: builder for '/nix/store/vr06k8792y2q1fp2n75ar8pkmjbbl7fx-llvm-extra-0.10.1.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/zgg7b0j2p62s9fimmv44g9rvyj0chpq2-llvm-dsl-0.0.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/0pb7drbcgwj02c1fwvbzwwgq8h9vlwzn-synthesizer-llvm-0.9.drv' failed to build
# error: builder for '/nix/store/3mgqwby3f6jw0yfag96pzyrp2v2jal08-microlens-ghc-0.4.14.1.drv' failed with exit code 1;
# error: builder for '/nix/store/1r64p48fn2ryyljbckvkc1z7gbkx03y1-mmsyn2-0.3.2.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/ckxm8vdk8swf2m539wcl43f95fc484qx-ukrainian-phonetics-basic-0.4.1.0.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/pb61mc6sq50qadb9lkvq7ar82i4bp1n7-mmsyn6ukr-0.9.0.0.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/qmckvxq49qqr6zcnhfm7zsflg2615akp-mmsyn7s-0.9.1.0.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/jgr43z0546hv61576qcmcy9rlrmyhi37-mmsyn7ukr-0.17.0.0.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/7wb1s7ipfakg56snhybsq7556swrbvq2-uniqueness-periods-0.2.0.0.drv' failed to build
# error: builder for '/nix/store/6nhvrha24d3bz1zlb5xmgm3fmfd77303-microlens-platform-0.4.3.3.drv' failed with exit code 1;
# error: builder for '/nix/store/c7rcy53i2ifxnn9ns331i6w58i05r4fb-mmsyn7ukr-common-0.2.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/nk0kk4mkb8c9af114z0w0cpch4g06pbd-mmsyn7l-0.9.1.0.drv' failed to build
# error: 6 dependencies of derivation '/nix/store/7j02b68rm5wpc5s8f5bcqg56g88cwniw-dobutokO2-0.43.0.0.drv' failed to build
# error: builder for '/nix/store/n681ias8hkyfk79ybl33p5xd31630hq8-pandoc-lua-marshal-0.2.2.drv' failed with exit code 1;
# error: builder for '/nix/store/f9r9zvwnf81b8fxgnd3f3wlw16f79va2-path-0.9.0.drv' failed with exit code 1;
# error: builder for '/nix/store/zg5dw97pcp1p35yc6qkmz78bi3q6q3sj-mega-sdist-0.4.3.0.drv' failed with exit code 1;
# error: builder for '/nix/store/020f4wnf37rnn5wnx44nsxg8c9b999pp-persistent-qq-2.12.0.5.drv' failed with exit code 1;
# error: builder for '/nix/store/qipmlxm6ynx5bfv66yl75hk3nsrvmv90-pantry-0.5.2.1.drv' failed with exit code 1;
# error: builder for '/nix/store/dnc1y8w5yvsr5bai4qhi4b4kzh85vd6n-pandoc-server-0.1.drv' failed with exit code 1;
# error: 3 dependencies of derivation '/nix/store/z34brq0wjzxjrkg0i372c5a80cbpbx4h-pandoc-cli-0.1.1.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/wismb26fx9b1j72skcygqgwn1iv9dlv7-pandoc-crossref-0.3.15.2.drv' failed to build
# error: builder for '/nix/store/gbcyydrc3zc1jqx66jyx3n3nk20nl470-persistent-test-2.13.1.3.drv' failed with exit code 1;
# error: builder for '/nix/store/6p79bc8vhq79a9wynwvd3xp67xad1739-pandoc-plot-1.6.2.drv' failed with exit code 1;
# error: builder for '/nix/store/b7r7pzg3i7i646p94rd3is168cr6id57-polysemy-resume-0.7.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/15g7q39wvwbqqfza5sxff760byqk2fss-polysemy-conc-0.12.1.0.drv' failed to build
# data-diverse> test/Data/Diverse/ManySpec.hs:308:24: error:
# error: builder for '/nix/store/1k4lhjhndwnvnqiyc6lg9d0vryzjq858-rebase-1.20.drv' failed with exit code 1;
# error: builder for '/nix/store/fhp4hzh5sghrqymw13mnqyd1kxyr1x5j-ptr-poker-0.1.2.13.drv' failed with exit code 1;
# error: builder for '/nix/store/qrwhaxk98z0mxbxrjch8mh466yvhbavi-relude-0.7.0.0.drv' failed with exit code 1;
# error: builder for '/nix/store/0j6p4mv5nwj18msfb0bsdcgzbds1l2v5-resolv-0.1.1.2.drv' failed with exit code 1;
# error: builder for '/nix/store/bq2f1hfa46ybbix8h9l6bi4638l1z1r2-cabal-helper-1.1.0.0.drv' failed with exit code 1;
# error: 3 dependencies of derivation '/nix/store/1ym9s3amc7bpcvfpmb8lnl00j212rrag-ghc-mod-5.8.0.0.drv' failed to build
# error: builder for '/nix/store/n1ad083xxs099lg602zz9sx6hn32z9m6-reflex-0.9.0.0.drv' failed with exit code 1;
# error: builder for '/nix/store/cimfsjbbkblpnm02q7waw785s114146d-rerebase-1.20.drv' failed with exit code 1;
# error: builder for '/nix/store/hfiy867bad05brddgn6gnwnazl06hdn0-retrie-1.1.0.0.drv' failed with exit code 1;
# error: builder for '/nix/store/78sk4ly3ffsnsipcnhqs4hh8jczwq0jc-rope-utf16-splay-0.4.0.0.drv' failed with exit code 1;
# ploterific> src/Ploterific/Plot/Plot.hs:25:21: error:
# error: builder for '/nix/store/2wgcil1rhar3hsp2r9m94znv76xjg6bf-scale-1.0.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/nk14pp9fkmp99rqi21mmw1g8g8yiidfq-memory-hexstring-1.0.0.0.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/c5qb735yxc9y27agggf0igjmbdz5dmqh-web3-bignum-1.0.0.0.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/c20hii44gaa249qh1y8zmv7av634bkyc-web3-crypto-1.0.0.0.drv' failed to build
# error: 6 dependencies of derivation '/nix/store/ij13h8zijimzycw880imfcc87zh371fl-web3-polkadot-1.0.0.0.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/009icwsqylk9lfdsbs7yrwfh46ykffjl-web3-solidity-1.0.0.0.drv' failed to build
# error: 4 dependencies of derivation '/nix/store/dnaxvqaj79dxy26nfz71cz82rdc0sagx-web3-ethereum-1.0.0.0.drv' failed to build
# error: 3 dependencies of derivation '/nix/store/k00jn74zxl7ffix3494inzmxc0kgbclv-web3-1.0.0.0.drv' failed to build
# error: builder for '/nix/store/d3ix0nx348nbmxrc97abdl5fj65q2cmk-singletons-th-3.2.drv' failed with exit code 1;
# error: builder for '/nix/store/3d635bvkg09a3h0psgasypf68vhrbnp5-singletons-base-3.2.drv' failed with exit code 1;
# error: builder for '/nix/store/ar79zlxilw3sbkn741wxw7rsmzq4im48-ploterific-0.2.1.4.drv' failed with exit code 1;
#        > src/Ploterific/Plot/Plot.hs:25:21: error:
# pretty> tests/TestStructures.hs:51:56: error:
# error: builder for '/nix/store/db082pd8zmj18gv7zw10r0hwbblf5i6g-strict-base-types-0.8.drv' failed with exit code 1;
# error: builder for '/nix/store/pwym294vwmshi2iw0hl139qcgcmii9s5-pretty-1.1.3.6.drv' failed with exit code 1;
# error: builder for '/nix/store/92rwxyrh4ri50c8mpgpb23c9a3h3cmyq-streaming-cassava-0.2.0.0.drv' failed with exit code 1;
# error: builder for '/nix/store/1l8a1a1fla8p9cv7gzl1qslzzk603s80-stripe-core-2.6.2.drv' failed with exit code 1;
# error: builder for '/nix/store/6gdmqylqk9xbg7243pz1jv8yhcm5i7ry-tasty-hslua-1.1.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/gq9p26k05yvxd36p58kz26gpl3pkx3vd-stripe-tests-2.6.2.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/4zqq7jsw9z5spf29hj1l81lkp6pdglf3-stripe-http-client-2.6.2.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/ibhkq2aq7qqxjf7nnmcbzwsfrp7qjgyp-stripe-haskell-2.6.2.drv' failed to build
# error: builder for '/nix/store/mcn2j8dpz7xrpdwkc6l3ynrbsyn22nzm-tasty-hspec-1.1.6.drv' failed with exit code 1;
# error: builder for '/nix/store/1c28ai6vzqn1z659lr2vwxv7vbcavfqy-tasty-hspec-1.2.0.4.drv' failed with exit code 1;
# error: builder for '/nix/store/7pqysfqamr4zxngaawr1wb9lfqqnpj75-tasty-lua-1.1.0.drv' failed with exit code 1;
# error: builder for '/nix/store/nvacpkychgr7ww0mqv72xjl75f5mgkx2-tasty-inspection-testing-0.2.drv' failed with exit code 1;
# protocol-buffers> Text/ProtocolBuffers/Get.hs:81:76: error:
# error: builder for '/nix/store/jrj3sj83bczzsdlg6f9pwr3ni5xfdllw-stack-2.9.3.drv' failed with exit code 1;
# error: builder for '/nix/store/rsvd8b2qiiwd10imj34i80zhrlsb5r40-template-haskell-2.20.0.0.drv' failed with exit code 1;
# error: builder for '/nix/store/c98y2nwwzlfvw60hkbn57w3a7b14i14g-th-desugar-1.15.drv' failed with exit code 1;
# error: builder for '/nix/store/03qa4y6z0pkl1gcfgvq61gdxwk59z1r4-these-lens-1.0.1.3.drv' failed with exit code 1;
# error: builder for '/nix/store/l31jsqim2zxv39fgk73q6bg2pk2izdjq-tidal-1.9.4.drv' failed with exit code 1;
# error: builder for '/nix/store/pqc4x170d0ffq3glfpay1dmsnxp75qj3-trial-tomland-0.0.0.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/dfp25hhr9ig80ijhzndwkvvkvrqlfylp-stan-0.0.1.0.drv' failed to build
# pantry> src/Pantry/Types.hs:134:66: error:
# pantry> src/Pantry/Types.hs:134:91: error:
# error: builder for '/nix/store/653z14rpzf4cg4pz7qgnjys2pr502zr9-data-diverse-4.7.0.0.drv' failed with exit code 1;
#        > test/Data/Diverse/ManySpec.hs:308:24: error:
# error: 1 dependencies of derivation '/nix/store/b530kidynsbq0yxjrnp8zqac52zq0fpz-parameterized-0.5.0.0.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/4pbiqpmxnvmhpz7m30s8cs0jmwqn51l5-proto3-wire-1.4.0.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/dkixhjh2d817qx3b6frpvwdh72xadbmp-proto3-suite-0.5.1.drv' failed to build
# error: builder for '/nix/store/amq3588pds8cw1737j9xmrjw6p6qln1p-pantry-0.8.2.2.drv' failed with exit code 1;
#        > src/Pantry/Types.hs:134:91: error:
# error: builder for '/nix/store/7z4dk5wwly7h8cifndfc6vj0y958azhj-word24-2.0.1.drv' failed with exit code 1;
# error: 3 dependencies of derivation '/nix/store/hqyddl2iyfaam32m7n5mbnb341xndglx-mysql-haskell-0.8.4.3.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/r60agz8a77whpdzgg7kb053b8waqkqj4-rtcm-0.2.39.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/0wij55kc1cr4dgh1cavdc7abb2cszsqq-gnss-converters-0.3.52.drv' failed to build
# error: builder for '/nix/store/3ccdfvbw3gjhnmng7pypfx6rqdqh6f74-rank1dynamic-0.4.1.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/pp510q0md18wlwg2991q6jiyziyf9iwn-distributed-static-0.3.9.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/0c38dnviwqfq2sgsalrx4y1mfisvla9j-distributed-process-0.7.4.drv' failed to build
# error: builder for '/nix/store/sgdwdmzhj4nqrrxb9yh4017vvr0xsjiz-yesod-routes-1.2.0.7.drv' failed with exit code 1;
# error: 4 dependencies of derivation '/nix/store/x31l3mpbva56jyqz6ywdpmww4mb0g569-yesod-platform-1.2.13.3.drv' failed to build
# ui-command> UI/Command/Doc.hs:110:36: error:
# error: builder for '/nix/store/lcj2yiw20wpljrxxkb7s5fi08yy9qvfl-ui-command-0.5.4.drv' failed with exit code 1;
# error: 3 dependencies of derivation '/nix/store/cpvjqkb3mghpkv8l9lcly5afsq6ybp54-zoom-cache-1.2.1.6.drv' failed to build
# error: builder for '/nix/store/x6k8xgsrbspwdnm437z2nh8mlrs35mnl-weeder-2.3.1.drv' failed with exit code 1;
# error: builder for '/nix/store/qjdam4s5hd5c7q2ij457y0xyczy77qpd-weeder-2.2.0.drv' failed with exit code 1;
# error: builder for '/nix/store/mk4vq19kgj7ggymhzyk26gqr28ahsm51-what4-1.4.drv' failed with exit code 1;
# clustering> tests/Test/Utils.hs:14:20: error:
# error: builder for '/nix/store/zi7kk41yj7rhk1ka1y5fm9a5g3nhxl49-clustering-0.4.1.drv' failed with exit code 1;
# error: 2 dependencies of derivation '/nix/store/9j3ybmjv50lznipmmyy9s4vnj8s9ra46-spectral-clustering-0.3.2.2.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/ln7rj9vkp72wwwwfli8443ba3wsc26cv-modularity-0.2.1.1.drv' failed to build
# error: builder for '/nix/store/bzsb6gzgbpfyqdbkrjwl8r07inmf92jv-protocol-buffers-2.4.17.drv' failed with exit code 1;
#        > Text/ProtocolBuffers/Get.hs:81:76: error:
# error: 1 dependencies of derivation '/nix/store/1ww0hm62ndf0cw5fmzymlp7wjhsx7cz1-protocol-buffers-descriptor-2.4.17.drv' failed to build
# error: 2 dependencies of derivation '/nix/store/9s31fw6sa13k9ncdxylc9qv8lfcyjzr7-hprotoc-2.4.17.drv' failed to build
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:61:10: error:
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:81:13: error:
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:87:25: error:
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:90:23: error:
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:94:8: error:
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:139:58: error:
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:166:19: error:
# llvm-general-pure> src/LLVM/General/Internal/PrettyPrint.hs:192:18: error:
# error: builder for '/nix/store/n34y2502jba2aasnfc9jg6sw6vvkkdkv-llvm-general-pure-3.5.1.0.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/zy8lnaz979vwfpgjqkhw85bp51nyzw50-llvm-general-3.5.1.2.drv' failed to build
# error: builder for '/nix/store/qyxmp4x2lbw5vbl3q352yysngr7l92ck-shelly-1.12.1.drv' failed with exit code 1;
# error: builder for '/nix/store/s4i45r89nc2y4f9fw4a9g10nn0yzcqvl-rest-rewrite-0.4.1.drv' failed with exit code 1;
# error: 1 dependencies of derivation '/nix/store/4asnpwkpm4g7q4rfqlxzzwfv507znp2p-liquid-fixpoint-0.9.0.2.1.drv' failed to build
# error: 1 dependencies of derivation '/nix/store/05d2p4kpa40riw3jkp8k1plx6bcwjrla-liquidhaskell-0.9.0.2.1.drv' failed to build
