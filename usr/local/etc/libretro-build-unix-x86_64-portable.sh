#/bin/bash
#
# This script is used in order to build libretro-super
# retro in a portable Unix way.
#
# Requirements:
# sudo apt-get install nvidia-cg-dev libusb-dev libv4l-dev libopenvg1-mesa libopenal-dev libxml2-dev libudev-dev
#


CURR_DIR=$(realpath ${0%/*})
LIBRETRO_REPO="https://github.com/libretro/libretro-super"
LIBRETRO_PATH="$CURR_DIR/$(basename $LIBRETRO_REPO)/"
OUT_DIR="$CURR_DIR/retroarch/"

# Make sure we have libretro super and get inside
cd $CURR_DIR
git clone $LIBRETRO_REPO
# Update the packages
cd "$LIBRETRO_PATH" && git gc && git pull
cd $LIBRETRO_PATH/retroarch && git gc && git pull


cd "$LIBRETRO_PATH"
rm -rf $(realpath "$OUT_DIR")
mkdir -p $(realpath "$OUT_DIR")

# x86_64 optimizations
export RARCHCFLAGS="${RARCHCFLAGS} --enable-sse --enable-sse2 --enable-cg --enable-libxml2"

# Build retroarch
"$LIBRETRO_PATH/retroarch-build.sh"
cd "$LIBRETRO_PATH/retroarch" && make DESTDIR="$OUT_DIR/tmp" install && cd ..

# Build libretro cores
"$LIBRETRO_PATH/libretro-fetch.sh"
"$LIBRETRO_PATH/libretro-build.sh"
"$LIBRETRO_PATH/libretro-install.sh" "$OUT_DIR"

# Organize our files in a portable structure
mkdir -p "$OUT_DIR/bin" "$OUT_DIR/cores-info" "$OUT_DIR/cores-info" "$OUT_DIR/cores" "$OUT_DIR/shaders" "$OUT_DIR/lib" "$OUT_DIR/autoconf/" "$OUT_DIR/downloads/" "$OUT_DIR/system/" "$OUT_DIR/screenshots/" "$OUT_DIR/assets/" "$OUT_DIR/overlay/" "$OUT_DIR/saves/" "$OUT_DIR/roms/" "$OUT_DIR/remap/" "$OUT_DIR/cheats/"
mv -f "$OUT_DIR/tmp/usr/local/bin/*" "$OUT_DIR/bin"
mv -f "$OUT_DIR/tmp/etc" "$OUT_DIR/config"
mv -f "$OUT_DIR/config/retroarch.cfg" "$OUT_DIR/config/retroarch.cfg.bak"
find "$OUT_DIR" -iname *.info -exec mv -f \{\} "$OUT_DIR/cores-info/" 2> /dev/null \;
find "$OUT_DIR" -iname *.so -exec mv -f \{\} "$OUT_DIR/cores/" 2> /dev/null \;
# Moving prebuilts
cp -r "$LIBRETRO_PATH/retroarch/media/shaders_cg" "$OUT_DIR/shaders/"
cp -r "$LIBRETRO_PATH/retroarch/media/autoconfig/*" "$OUT_DIR/autoconf/joypad"
cp -r "$LIBRETRO_PATH/retroarch/media/libretrodb/cht/*" "$OUT_DIR/autoconf/cheats"

# Cleanup left-overs
rm -rf "$OUT_DIR/tmp"
find "$OUT_DIR" -type d -name ".git" -exec rm -rf \{\} \;

# Zip for distribution
zip -r "$OUT_DIR/retroarch-x86_64.zip" "$OUT_DIR"

# Convert shaders
"$LIBRETRO_PATH/retroarch/tools/cg2glsl.py" "$OUT_DIR/shaders/shaders_cg" "$OUT_DIR/shaders/shaders_glsl"

sync

exit 0
