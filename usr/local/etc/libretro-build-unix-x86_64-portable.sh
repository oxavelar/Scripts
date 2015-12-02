#/bin/bash
#
# This script is used in order to build libretro-super
# retro in a portable Unix way.

CURR_DIR=$(realpath ${0%/*})
LIBRETRO_REPO="https://github.com/libretro/libretro-super"
LIBRETRO_PATH="$CURR_DIR/$(basename $LIBRETRO_REPO)/"
OUT_DIR="$CURR_DIR/libretro-portable-out/"

# Make sure we have libretro super and get inside
cd $CURR_DIR
git clone $LIBRETRO_REPO
# Update the packages
cd "$LIBRETRO_PATH" && git pull
cd $LIBRETRO_PATH/retroarch && git pull && 


cd $LIBRETRO_PATH
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# x86_64 optimizations
export RARCHCFLAGS="${RARCHCFLAGS} --enable-sse --enable-sse2 --enable-cg --enable-libxml2"

# Build retroarch
$LIBRETRO_PATH/retroarch-build.sh
cd $LIBRETRO_PATH/retroarch && make DESTDIR=$OUT_DIR install && cd ..

# Build libretro cores
$LIBRETRO_PATH/libretro-fetch.sh
$LIBRETRO_PATH/libretro-build.sh
$LIBRETRO_PATH/libretro-install.sh $OUT_DIR

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
find "$OUT_DIR" -type d -name ".git" -exec rm -rf \{\} \;

sync

