#/bin/bash
#
# This script is used in order to build libretro-super
# retro in a portable Unix way.

CURR_DIR=$(realpath ${0%/*})
OUT_DIR="$CURR_DIR/dist/out/"

# x86_64 optimizations
export RARCHCFLAGS="${RARCHCFLAGS} --enable-sse --enable-sse2 --enable-cg --enable-libxml2"

# Update the non core packages
git pull && cd retroarch && git pull && cd ..

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"
$CURR_DIR/libretro-fetch.sh
$CURR_DIR/retroarch-build.sh
$CURR_DIR/libretro-build.sh

cd retroarch && make DESTDIR=$OUT_DIR install && cd ..
./libretro-install.sh $OUT_DIR

# Organize our files in a portable structure
mkdir -p "$OUT_DIR/cores-info"
mkdir -p "$OUT_DIR/cores"
find "$OUT_DIR" -iname *.info -exec mv -f \{\} "$OUT_DIR/cores-info/" \;
find "$OUT_DIR" -iname *.so -exec mv -f \{\} "$OUT_DIR/cores/" \;
mv -f "$OUT_DIR/usr/local/bin" "$OUT_DIR"
mv -f "$OUT_DIR/etc" "$OUT_DIR/config"
mv -f "$OUT_DIR/config/retroarch.cfg" "$OUT_DIR/config/retroarch.cfg.bak"

# Cleanup left-overs
rm -rf "$OUT_DIR/usr"

sync

