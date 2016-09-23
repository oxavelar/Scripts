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

export LIBRETRO_DEVELOPER=0
export DEBUG=0
export CFLAGS="-O2 -msse -msse2 -msse3 -mssse3 -mfpmath=sse -ftree-vectorize -march=core2 -mtune=broadwell -fomit-frame-pointer -flto -pipe"
export CXXFLAGS="$CFLAGS"
export ASFLAGS="$CFLAGS"


function prerequisites()
{
    # Make sure we have libretro super and get inside
    cd $CURR_DIR
    git clone $LIBRETRO_REPO
    # Update the packages
    cd "$LIBRETRO_PATH" && git gc && git clean -dfx && git reset --hard && git pull
    cd $LIBRETRO_PATH/retroarch && git gc && git clean -dfx && git reset --hard && git pull

    cd "$LIBRETRO_PATH"
    rm -rf $(realpath "$OUT_DIR")
    mkdir -p $(realpath "$OUT_DIR")

    "$LIBRETRO_PATH/libretro-fetch.sh"
}

function build_retroarch()
{
    # Build retroarch
    cd "$LIBRETRO_PATH/retroarch"
    make -j32 clean
    # x86_64 optimizations
    #./configure --help || exit 0
    ./configure --enable-sse --enable-opengl --enable-opengles3 --enable-vulkan --enable-cg --disable-v4l2 --enable-libxml2 --disable-ffmpeg --disable-sdl2 --disable-sdl --disable-kms --disable-cheevos --disable-imageviewer --disable-parport --disable-langextra --disable-libretrodb || exit -127
    time make -f Makefile -j16 || exit -99
    make DESTDIR="$OUT_DIR/tmp" install
    cd ..
}

function build_libretro()
{
    "$LIBRETRO_PATH/libretro-build.sh"
}

function install_libretro()
{
    "$LIBRETRO_PATH/libretro-install.sh" "$OUT_DIR"

    # Organize our files in a portable structure
    mkdir -p "$OUT_DIR/bin" "$OUT_DIR/cores-info" "$OUT_DIR/cores-info" "$OUT_DIR/cores" "$OUT_DIR/shaders" "$OUT_DIR/lib" "$OUT_DIR/autoconf/" "$OUT_DIR/downloads/" "$OUT_DIR/system/" "$OUT_DIR/screenshots/" "$OUT_DIR/assets/" "$OUT_DIR/overlay/" "$OUT_DIR/saves/" "$OUT_DIR/roms/" "$OUT_DIR/remap/" "$OUT_DIR/cheats/"
    cp -av "$OUT_DIR/tmp/usr/local/bin/." "$OUT_DIR/bin"
    cp -av "$OUT_DIR/tmp/etc/." "$OUT_DIR/config"
    mv -vf "$OUT_DIR/config/retroarch.cfg" "$OUT_DIR/config/retroarch.cfg.bak"
    find "$OUT_DIR" -name "*.info" -exec mv -f \{\} "$OUT_DIR/cores-info/" 2> /dev/null \;
    find "$OUT_DIR" -name "*.so" -exec mv -f \{\} "$OUT_DIR/cores/" 2> /dev/null \;

    # Moving prebuilts
    cp -av "$LIBRETRO_PATH/retroarch/media/shaders_cg" "$OUT_DIR/shaders"
    cp -av "$LIBRETRO_PATH/retroarch/media/autoconfig" "$OUT_DIR/autoconf/joypad"
    cp -av "$LIBRETRO_PATH/retroarch/media/libretrodb/cht/." "$OUT_DIR/cheats"

    # Cleanup left-overs and any .git files for distribution
    rm -rf "$OUT_DIR/tmp"
    ( find "$OUT_DIR" -type d -name ".git" \
      && find . -name ".gitignore" \
      && find . -name ".gitmodules" ) | xargs rm -rf
}

function extras_libretro()
{
    # Convert shaders
    "$LIBRETRO_PATH/retroarch/tools/cg2glsl.py" "$OUT_DIR/shaders/shaders_cg" "$OUT_DIR/shaders/shaders_glsl"
    
    # Zip for distribution
    zip -rq "$OUT_DIR/retroarch-x86_64.zip" "$OUT_DIR"
}


# The main sequence of steps now go here ...
prerequisites
build_retroarch
build_libretro
install_libretro
extras_libretro
sync
exit 0

