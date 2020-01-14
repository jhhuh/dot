#!/usr/bin/env nix-shell
#!nix-shell -i bash -p stdenv xidel gnupg
#!/nix/store/cinw572b38aln37glr0zb8lxwrgaffl4-bash-4.4-p23/bin/bash
PATH=/nix/store/d9s1kq1bnwqgxwcvv4zrc36ysnxg8gv7-coreutils-8.30/bin:/nix/store/x1khw8x0465xhkv6w31af75syyyxc65j-gnused-4.7/bin:/nix/store/wnjv27b3j6jfdl0968xpcymlc7chpqil-gnugrep-3.3/bin:/nix/store/dbmzwxc6z5nsgqibadvzyr4w1ndrnbnk-xidel-0.9.6/bin:/nix/store/yb6s1k41s7sydr6q3nzmayhvbkzhydvf-curl-7.64.0-bin/bin:/nix/store/kfhb1dzcx80nvgfdj29v5s45j0zrinq8-gnupg-2.2.13/bin
set -eux
pushd .

HOME=`mktemp -d`
cat /nix/store/3bv14sgrx5wp39krx3pk5wcxi8anybv5-firefox.key | gpg --import

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

curl --silent -o $HOME/shasums "$url$version/SHA512SUMS"
curl --silent -o $HOME/shasums.asc "$url$version/SHA512SUMS.asc"
gpgv --keyring=$HOME/.gnupg/pubring.kbx $HOME/shasums.asc $HOME/shasums

# this is a list of sha512 and tarballs for both arches
shasums=`cat $HOME/shasums`

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
      sha512 = "`echo $line | cut -d":" -f1`";
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
