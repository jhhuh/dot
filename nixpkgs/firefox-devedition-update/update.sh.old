PATH=/nix/store/920k63py2w97xpfyb5ps9l6wbidvzfjz-coreutils-8.29/bin:/nix/store/wkgszaq2dkc4asapcbx6ypd7xdnzad9f-gnused-4.4/bin:/nix/store/iywd02hbirf506q740z0v6zyrvsa9gcf-gnugrep-3.1/bin:/nix/store/5g9903wnmcl0dypdm8vz1shd2nl8ngvi-xidel-0.9.6/bin:/nix/store/icysmbg4xcfzwd0xn98g9xn15hii7ffx-curl-7.59.0-bin/bin:/nix/store/mnkl2vmb4yf08jjs5masmz5d1qb5dqiv-gnupg-2.2.8/bin
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
