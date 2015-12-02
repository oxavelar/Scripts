#/bin/bash
#
# This script is used in order to build libretro-super
# retro in a portable Unix way.

CURR_DIR=$(realpath ${0%/*})
LIBRETRO_REPO="https://github.com/libretro/libretro-super"
LIBRETRO_PATH="$CURR_DIR/$(basename $LIBRETRO_REPO)/"
OUT_DIR="$LIBRETRO_PATH/dist/out/"

# Make sure we have libretro super and get inside
cd $CURR_DIR
git clone $LIBRETRO_REPO
cd "$LIBRETRO_PATH"

# Update the non core packages
git pull && cd retroarch && git pull && cd ..

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# x86_64 optimizations
export RARCHCFLAGS="${RARCHCFLAGS} --enable-sse --enable-sse2 --enable-cg --enable-libxml2"

# Update and build
$LIBRETRO_PATH/retroarch-build.sh
$LIBRETRO_PATH/libretro-fetch.sh
$LIBRETRO_PATH/libretro-build.sh

cd retroarch && make DESTDIR=$OUT_DIR install && cd ..
./libretro-install.sh $OUT_DIR

# Organize our files in a portable structure
mkdir -p "$OUT_DIR/cores-info"
mkdir -p "$OUT_DIR/cores"
mkdir -p "$OUT_DIR/shaders"
mkdir -p "$OUT_DIR/autoconf/"
find "$OUT_DIR" -iname *.info -exec mv -f \{\} "$OUT_DIR/cores-info/" \;
find "$OUT_DIR" -iname *.so -exec mv -f \{\} "$OUT_DIR/cores/" \;
mv -f "$OUT_DIR/usr/local/bin" "$OUT_DIR"
mv -f "$OUT_DIR/etc" "$OUT_DIR/config"
mv -f "$OUT_DIR/config/retroarch.cfg" "$OUT_DIR/config/retroarch.cfg.bak"
cp -r "$LIBRETRO_PATH/retroarch/media/shaders_cg" "$OUT_DIR/shaders/"

# Cleanup left-overs
rm -rf "$OUT_DIR/usr"

sync

