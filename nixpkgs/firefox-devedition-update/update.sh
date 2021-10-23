#!/usr/bin/env nix-shell
#!nix-shell -i bash -p stdenv xidel gnupg
#!/nix/store/jdi2v7ir1sr6vp7pc5x0nhb6lpcmg6xg-bash-4.4-p23/bin/bash
PATH=/nix/store/lr96h3dlny8aiba9p3rmxcxfda0ijj08-coreutils-8.32/bin:/nix/store/4nf4ih03fcq7gk08spjzxvwph1vyx1kr-gnused-4.8/bin:/nix/store/3v5i98i92j0f3lbb7d58kvf8nxnhw7s7-gnugrep-3.6/bin:/nix/store/vgj078ynmmbh4agdrj6iy6n63h07fmxq-xidel-0.9.6/bin:/nix/store/m287y71wwzcv6sy0ir113nbrh8zym4dd-curl-7.74.0-bin/bin:/nix/store/afhs46mg5cn8ckf8hw5nf95kgg4sqbll-gnupg-2.2.27/bin
set -eux
pushd .

HOME=`mktemp -d`
export GNUPGHOME=`mktemp -d`

gpg --import /nix/store/rp5vgjkyz6naiga5fl7sfs9gzr6a78kh-mozilla.asc

tmpfile=`mktemp`
url=http://archive.mozilla.org/pub/devedition/releases/

# retriving latest released version
#  - extracts all links from the $url
#  - removes . and ..
#  - this line remove everything not starting with a number
#  - this line sorts everything with semver in mind
#  - we remove lines that are mentioning funnelcake
#  - this line removes beta version if we are looking for final release
#    versions or removes release versions if we are looking for beta
#    versions
# - this line pick up latest release
version=`xidel -s $url --extract "//a" | \
         sed s"/.$//" | \
         grep "^[0-9]" | \
         sort --version-sort | \
         grep -v "funnelcake" | \
         grep -e "b\([[:digit:]]\|[[:digit:]][[:digit:]]\)$" |  \
         tail -1`

curl --silent -o $HOME/shasums "$url$version/SHA256SUMS"
curl --silent -o $HOME/shasums.asc "$url$version/SHA256SUMS.asc"
gpgv --keyring=$GNUPGHOME/pubring.kbx $HOME/shasums.asc $HOME/shasums

# this is a list of sha256 and tarballs for both arches
# Upstream files contains python repr strings like b'somehash', hence the sed dance
shasums=`cat $HOME/shasums | sed -E s/"b'([a-f0-9]{64})'?(.*)"/'\1\2'/ | grep tar.bz2`

cat > $tmpfile <<EOF
{
  version = "$version";
  sources = [
EOF
for arch in linux-x86_64 linux-i686; do
  # retriving a list of all tarballs for each arch
  #  - only select tarballs for current arch
  #  - only select tarballs for current version
  #  - rename space with colon so that for loop doesnt
  #  - inteprets sha and path as 2 lines
  for line in `echo "$shasums" | \
               grep $arch | \
               grep "firefox-$version.tar.bz2$" | \
               tr " " ":"`; do
    # create an entry for every locale
    cat >> $tmpfile <<EOF
    { url = "$url$version/`echo $line | cut -d":" -f3`";
      locale = "`echo $line | cut -d":" -f3 | sed "s/$arch\///" | sed "s/\/.*//"`";
      arch = "$arch";
      sha256 = "`echo $line | cut -d":" -f1`";
    }
EOF
  done
done
cat >> $tmpfile <<EOF
    ];
}
EOF

mv $tmpfile devedition_sources.nix

popd
