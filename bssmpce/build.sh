
echo "*******************************************************************************"
echo "Setting up environment..."
echo "*******************************************************************************"

set -o errexit

BASE_PWD=$PWD
PATH=".:$PATH"
INROM="bssm_24.iso"
OUTROM="bssm_24_build.iso"
WLADX="./wla-dx/binaries/wla-huc6280"
WLALINK="./wla-dx/binaries/wlalink"

if [ ! -e "$INROM" ]; then
  echo "Error: input file $INROM does not exist"
  exit 1
fi;

# honorifics flag.
# 0 to disable, nonzero to enable
HONORIFICS_FLAG=0

# --honorifics = honorifics on
# --nohonorifics (or empty) = honorifics off
HONORIFICS=--nohonorifics
if [ ! $HONORIFICS_FLAG == 0 ]
then
  HONORIFICS=--honorifics
fi

# feature settings -- set to 0 to disable certain build steps (usually for testing)
DO_BUILDFONT=1
DO_BUILDSCRIPTS=1
DO_APPLYASM=1
DO_BUILDDISC=1

mkdir -p log
mkdir -p out

echo "********************************************************************************"
echo "Building project tools..."
echo "********************************************************************************"

make blackt
make libpce
make

if [ ! -f $WLADX ]; then
  
  echo "********************************************************************************"
  echo "Building WLA-DX..."
  echo "********************************************************************************"
  
  cd wla-dx
    cmake -G "Unix Makefiles" .
    make
  cd $BASE_PWD
  
fi

if [ ! -e "rawfiles" ]; then
  
  echo "********************************************************************************"
  echo "Extracting game files..."
  echo "********************************************************************************"
  
  mkdir -p "rawfiles"
  ./filerip "$INROM" "rawfiles/"
  
fi;

echo "*******************************************************************************"
echo "Copying binaries..."
echo "*******************************************************************************"

mkdir -p out/base
cp base/* out/base

if [ ! $DO_BUILDFONT == 0 ]
then

  echo "*******************************************************************************"
  echo "Building font..."
  echo "*******************************************************************************"

#   mkdir -p out/font
#   fontbuild "font/sheet.png" "font/index.txt" "out/font/font.bin" "out/font/fontwidth.bin"

  mkdir -p out/font
  fontbuild "font/12px/" "out/font/font.bin" "out/font/fontwidth.bin"

fi

echo "*******************************************************************************"
echo "Building bitmaps..."
echo "*******************************************************************************"

mkdir -p out/grp
mkdir -p out/maps
mkdir -p out/pal
mkdir -p out/bitmaps
mkdir -p out/packs

stdBitmapPaletteStr="0/1-15 1/1-15 2/1-15 3/1-15 4/1-15 5/1-15 6/1-15 7/1-15"
expandedBitmapPaletteStr="0/1-15 1/1-15 2/1-15 3/1-15 4/1-15 5/1-15 6/1-15 7/1-15 11/1-15 12/1-15"
#fullBitmapPaletteStr="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"
#fullBitmapPaletteStr="0/1-15 1/1-15 2/1-15 3/1-15 4/1-15 5/1-15 6/1-15 7/1-15 8/1-15 9/1-15 10/1-15 11/1-15 12/1-15 13/1-15 14/1-15 15/1-15"
ingamePaletteBlacklistStr="8 9 10 11 12 13 14 15"

mkdir -p out/bitmaps

./bitmap_maker "rsrc/title/title.png" "$expandedBitmapPaletteStr" "out/bitmaps/title.bin" -p "rawfiles/49C57F.bin"
./bitmap_maker "rsrc/title/title_b.png" "$expandedBitmapPaletteStr" "out/bitmaps/title_b.bin" -p "rawfiles/49F220.bin"
./bitmap_maker "rsrc/title/title_b_jp.png" "$expandedBitmapPaletteStr" "out/bitmaps/title_b_jp.bin" -p "rawfiles/49F220.bin"
./bitmap_maker "rsrc/char_select/sel0.png" "11 12 13 14 15" "out/bitmaps/sel0.bin" -p "rawfiles/35C011.bin"

./bitmap_maker "rsrc/gfx/e57_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e57" -p "rawfiles/5557B1.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e58_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e58" -p "rawfiles/5558B2.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e59_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e59" -p "rawfiles/5559B3.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e76_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e76" -p "rawfiles/5776B2.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e76a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e76a" -p "rawfiles/5763F5.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e76b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e76b" -p "rawfiles/5764F6.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e76c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e76c" -p "rawfiles/5765F7.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e78_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e78" -p "rawfiles/5778B4.bin" -a "$ingamePaletteBlacklistStr"
#./bitmap_maker "rsrc/gfx/e78a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e78a" -p "rawfiles/5781F5.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e78a_grp.png" "0/0-0" "out/bitmaps/e78a" -p "rawfiles/5781F5.bin" -a "$ingamePaletteBlacklistStr"
# ./bitmap_maker "rsrc/gfx/e78b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e78b" -p "rawfiles/5782F6.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e78b_grp.png" "0/0-0" "out/bitmaps/e78b" -p "rawfiles/5782F6.bin" -a "$ingamePaletteBlacklistStr"
# ./bitmap_maker "rsrc/gfx/e78c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e78c" -p "rawfiles/5783F7.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e78c_grp.png" "0/0-0" "out/bitmaps/e78c" -p "rawfiles/5783F7.bin" -a "$ingamePaletteBlacklistStr"
# ./bitmap_maker "rsrc/gfx/e78d_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e78d" -p "rawfiles/5784F8.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e78d_grp.png" "0/0-0" "out/bitmaps/e78d" -p "rawfiles/5784F8.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e116b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e116b" -p "rawfiles/51621F.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e169f_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e169f" -p "rawfiles/51962B.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e269_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e269" -p "rawfiles/5269E6.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e310_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e310" -p "rawfiles/5310D9.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e518_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e518" -p "rawfiles/5518E3.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e518a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e518a" -p "rawfiles/558124.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e519_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e519" -p "rawfiles/5519E4.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e519a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e519a" -p "rawfiles/559125.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e521_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e521" -p "rawfiles/5521DD.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e521a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e521a" -p "rawfiles/55111E.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e522_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e522" -p "rawfiles/5522DE.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e522a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e522a" -p "rawfiles/55211F.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e522b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e522b" -p "rawfiles/552220.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e522c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e522c" -p "rawfiles/552321.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e613_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613" -p "rawfiles/5613DF.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613a" -p "rawfiles/563120.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613b" -p "rawfiles/563221.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613c" -p "rawfiles/563322.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613d_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613d" -p "rawfiles/563423.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613e_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613e" -p "rawfiles/563524.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613f_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613f" -p "rawfiles/563625.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613g_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613g" -p "rawfiles/563726.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613h_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613h" -p "rawfiles/563827.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e613i_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e613i" -p "rawfiles/563928.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e615a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e615a" -p "rawfiles/565122.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e615b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e615b" -p "rawfiles/565223.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e615c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e615c" -p "rawfiles/565324.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e615d_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e615d" -p "rawfiles/565425.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e615e_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e615e" -p "rawfiles/565526.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e717_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e717" -p "rawfiles/5717E4.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e717a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e717a" -p "rawfiles/577125.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e717b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e717b" -p "rawfiles/577226.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e717c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e717c" -p "rawfiles/577327.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e718_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e718" -p "rawfiles/5718E5.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e718a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e718a" -p "rawfiles/578126.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e718b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e718b" -p "rawfiles/578227.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e718c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e718c" -p "rawfiles/578328.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e718d_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e718d" -p "rawfiles/578429.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e718e_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e718e" -p "rawfiles/57852A.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e835_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e835" -p "rawfiles/5835E5.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e835a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e835a" -p "rawfiles/585126.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e835b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e835b" -p "rawfiles/585227.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e835c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e835c" -p "rawfiles/585328.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e835d_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e835d" -p "rawfiles/585429.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e836p_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e836p" -p "rawfiles/586036.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e844b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e844b" -p "rawfiles/584227.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e855_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e855" -p "rawfiles/5855E7.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e876_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e876" -p "rawfiles/5876EA.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e910_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910" -p "rawfiles/5910DF.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910a" -p "rawfiles/590120.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910b" -p "rawfiles/590221.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910c" -p "rawfiles/590322.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910d_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910d" -p "rawfiles/590423.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910e_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910e" -p "rawfiles/590524.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910f_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910f" -p "rawfiles/590625.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910g_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910g" -p "rawfiles/590726.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910h_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910h" -p "rawfiles/590827.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e910i_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e910i" -p "rawfiles/590928.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e953a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e953a" -p "rawfiles/593127.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e1013_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1013" -p "rawfiles/51130A.bin" -a "$ingamePaletteBlacklistStr"

./bitmap_maker "rsrc/gfx/e1118_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1118" -p "rawfiles/511810.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e1118a_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1118a" -p "rawfiles/518151.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e1118b_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1118b" -p "rawfiles/518252.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e1118c_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1118c" -p "rawfiles/518353.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e1118d_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1118d" -p "rawfiles/518454.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e1118e_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1118e" -p "rawfiles/518555.bin" -a "$ingamePaletteBlacklistStr"
./bitmap_maker "rsrc/gfx/e1118f_grp.png" "$stdBitmapPaletteStr" "out/bitmaps/e1118f" -p "rawfiles/518656.bin" -a "$ingamePaletteBlacklistStr"

echo "*******************************************************************************"
echo "Building graphics..."
echo "*******************************************************************************"

cp rsrc_raw/pal/* out/pal

for file in tilemappers/*.txt; do
  ./tilemapper_pce "$file"
done;

./datpatch "out/pal/carderror.pal" "out/pal/carderror.pal" "out/pal/carderror.pal" 0 0 0x200

# e485 = punish group shot
cp "rawfiles/5485E6.bin" "out/bitmaps/e485"
./bitmapcolorconv "out/pal/punish.pal" "out/pal/punish_5bit.pal"
./datpatch "out/bitmaps/e485" "out/bitmaps/e485" "out/pal/punish_5bit.pal" 0x4

cat out/maps/punish_subs_base.bin out/maps/punish_subs_0.bin out/maps/punish_subs_1.bin out/maps/punish_subs_2.bin out/maps/punish_subs_3.bin out/maps/punish_subs_4.bin out/maps/punish_subs_5.bin out/maps/punish_subs_6.bin out/maps/punish_subs_7.bin out/maps/punish_subs_8.bin > out/maps/punish.bin

# cp "rawfiles/49C57F.bin" "out/bitmaps/title.heb"
# ./bitmapcolorconv "out/pal/title_flash.pal" "out/pal/title_flash_5bit.pal"
# ./datpatch "out/bitmaps/title.heb" "out/bitmaps/title.heb" "out/pal/title_flash_5bit.pal" 0x4
if [ ! $HONORIFICS_FLAG == 0 ]; then
  ./bitmapcolorconv "out/pal/title_flash_jp.pal" "out/pal/title_flash_5bit_jp.pal"
  ./datpatch "out/bitmaps/title.bin" "out/bitmaps/title.bin" "out/pal/title_flash_5bit_jp.pal" 0x4
  cat out/maps/title_flash_jp.bin out/grp/title_flash_jp.bin > out/packs/title_flash_jp.bin
else
  ./bitmapcolorconv "out/pal/title_flash.pal" "out/pal/title_flash_5bit.pal"
  ./datpatch "out/bitmaps/title.bin" "out/bitmaps/title.bin" "out/pal/title_flash_5bit.pal" 0x4
  cat out/maps/title_flash.bin out/grp/title_flash.bin > out/packs/title_flash.bin
fi

mkdir -p out/ending_scroll_packs
cat rsrc_raw/pal/ending_mercury_scroll_bg.pal out/maps/ending_mercury_scroll.bin > out/ending_scroll_packs/mercury.bin
cat rsrc_raw/pal/ending_jupiter_scroll_bg.pal out/maps/ending_jupiter_scroll.bin > out/ending_scroll_packs/jupiter.bin
cat rsrc_raw/pal/ending_venus_scroll_bg.pal out/maps/ending_venus_scroll.bin > out/ending_scroll_packs/venus.bin
cat rsrc_raw/pal/ending_naru_scroll_bg.pal out/maps/ending_naru_scroll.bin > out/ending_scroll_packs/naru.bin

# ./spriteundmp_pce rsrc/title_menu/newgame.png out/grp/newgame.bin
# ./spriteundmp_pce rsrc/title_menu/continue.png out/grp/continue.bin
# ./spriteundmp_pce rsrc/title_menu/file1.png out/grp/file1.bin
# ./spriteundmp_pce rsrc/title_menu/file2.png out/grp/file2.bin

./spriteundmp_pce rsrc/title_menu/all.png out/grp/all.bin -p rsrc_raw/pal/title_menu.pal

# cat rsrc_raw/pal/title_menu.pal out/grp/newgame.bin out/grp/continue.bin out/grp/file1.bin  out/grp/file2.bin > out/packs/savefont.bin
cat rsrc_raw/pal/title_menu.pal out/grp/all.bin > out/packs/savefont.bin

./grpundmp_pce rsrc/oikake/town_bg.png 0x400 out/grp/oikake_town_bg.bin

echo "*******************************************************************************"
echo "Building sprite subtitles..."
echo "*******************************************************************************"

mkdir -p out/spritesubs

# mkdir -p out/spritesubs/ending
# for file in rsrc/ending/*.png; do
#   dest=out/spritesubs/ending/$(basename $file .png).bin
#   ./spriteblockmaker "$file" "$dest"
# done
# 
# mkdir -p out/spritesubs/intro
# for file in rsrc/intro/*.png; do
#   dest=out/spritesubs/intro/$(basename $file .png).bin
#   ./spriteblockmaker "$file" "$dest"
# done

for folder in {rsrc/ending,rsrc/intro}; do
  foldername=$(basename $folder)
  destfolder=out/spritesubs/$foldername
  mkdir -p destfolder
  
  for file in $folder/*.png; do
    echo $file
    dest=$destfolder/$(basename $file .png).bin
    ./spriteblockmaker "$file" "$dest"
  done
done

mkdir -p out/spritesubs/op
for i in `seq -w 0 13`; do
  ./spriteblockmaker_lyric "rsrc/intro/opsub${i}b.png" "rsrc/intro/opsub${i}a.png" "out/spritesubs/op/opsub${i}.bin"
done

cat out/spritesubs/op/opsub00.bin out/spritesubs/op/opsub01.bin out/spritesubs/op/opsub02.bin out/spritesubs/op/opsub03.bin > out/spritesubs/op/opsub_p0.bin

cat out/spritesubs/op/opsub04.bin out/spritesubs/op/opsub05.bin out/spritesubs/op/opsub06.bin out/spritesubs/op/opsub07.bin > out/spritesubs/op/opsub_p1.bin

cat out/spritesubs/op/opsub08.bin out/spritesubs/op/opsub09.bin out/spritesubs/op/opsub10.bin out/spritesubs/op/opsub11.bin > out/spritesubs/op/opsub_p2.bin

cat out/spritesubs/op/opsub12.bin out/spritesubs/op/opsub13.bin > out/spritesubs/op/opsub_p3.bin

#./spriteblockmaker_lyric rsrc/intro/opsub00b.png rsrc/intro/opsub00a.png

mkdir -p out/spritesubs/ed
for i in `seq -w 0 10`; do
  ./spriteblockmaker_ed "rsrc/ed/edsub${i}b.png" "rsrc/ed/edsub${i}a.png" "out/spritesubs/ed/edsub${i}.bin"
done

#cat out/spritesubs/ed/edsub00.bin out/spritesubs/ed/edsub01.bin out/spritesubs/ed/edsub02.bin out/spritesubs/ed/edsub03.bin out/spritesubs/ed/edsub04.bin out/spritesubs/ed/edsub05.bin out/spritesubs/ed/edsub06.bin out/spritesubs/ed/edsub07.bin out/spritesubs/ed/edsub08.bin out/spritesubs/ed/edsub09.bin out/spritesubs/ed/edsub10.bin > out/spritesubs/ed/edsub_p0.bin

./spritepalmaker out/spritesubs/ed/palette.pal

cat out/spritesubs/ed/palette.pal out/spritesubs/ed/edsub00.bin out/spritesubs/ed/edsub01.bin out/spritesubs/ed/edsub02.bin > out/spritesubs/ed/edsub_p0.bin

cat out/spritesubs/ed/edsub03.bin out/spritesubs/ed/edsub04.bin out/spritesubs/ed/edsub05.bin out/spritesubs/ed/edsub06.bin > out/spritesubs/ed/edsub_p1.bin

cat out/spritesubs/ed/edsub07.bin out/spritesubs/ed/edsub08.bin out/spritesubs/ed/edsub09.bin out/spritesubs/ed/edsub10.bin > out/spritesubs/ed/edsub_p2.bin

if [ ! $DO_BUILDSCRIPTS == 0 ]
then

  echo "*******************************************************************************"
  echo "Building scripts..."
  echo "*******************************************************************************"
  
  # staff2 is now used for the button-code credits roll, which needs
  # to return rather than freezing at the end so we can do the new
  # unused content bonus presentation.
  # copy over staff messages to staff2 so they're kept at parity.
#  cp messages/trans/staff.csv messages/trans/staff2.csv

  mkdir -p out/scripts
  for file in scripts/trans/*; do
    echo "$file"
#     scriptasm "$file" "font/table.tbl" "font/index.txt" "messages/common/common_sjis.csv" "messages/trans/$(basename $file .mes).csv" "out/scripts/$(basename $file .mes).mes"
    scriptasm "$file" "font/12px/table.tbl" "font/12px/" "messages/common/common_sjis.csv" "messages/trans/$(basename $file .mes).csv" "out/scripts/$(basename $file .mes).mes" ${HONORIFICS}
  done

  cp buildscr/discscript.txt out/discscript.txt
  #for file in out/scripts/*; do
  #  echo "setsrc \"$(basename $file .mes).mes\" \"$file\"" | cat "out/discscript.txt" - > "out/discscript2.txt"
  #  mv out/discscript2.txt out/discscript.txt
  #done

fi

if [ ! $DO_APPLYASM == 0 ]
then

  echo "********************************************************************************"
  echo "Applying ASM patches..."
  echo "********************************************************************************"

  mkdir -p "out/base"
  cp "base/bssm_boot_1000.bin" "asm/bssm_boot_1000.bin"
  cp "base/bssm_carderror_52000.bin" "asm/bssm_carderror_52000.bin"
  
  ./padfile "asm/bssm_carderror_52000.bin" 0xB000 "asm/bssm_carderror_52000.bin"

  cd asm
    # apply hacks
    ../$WLADX -I ".." -o "boot.o" "boot.s"
    ../$WLALINK -v linkfile bssm_boot_1000_build.bin
    
    ../$WLADX -I ".." -o "boot2.o" "boot2.s"
    ../$WLALINK -v linkfile2 bssm_carderror_52000_build.bin
  cd $BASE_PWD

  mv -f "asm/bssm_boot_1000_build.bin" "out/base/bssm_boot_1000.bin"
  mv -f "asm/bssm_carderror_52000_build.bin" "out/base/bssm_carderror_52000.bin"
  rm "asm/bssm_boot_1000.bin"
  rm "asm/bssm_carderror_52000.bin"
  rm asm/*.o

fi

if [ ! $DO_BUILDDISC == 0 ]
then

  echo "*******************************************************************************"
  echo "Building disc..."
  echo "*******************************************************************************"

  discbuild base/bssm_fileindex_29000.bin rawfiles/ buildscr/discscript.txt "$OUTROM" ${HONORIFICS} > log/discbuildlog.txt

fi

echo "*******************************************************************************"
echo "Success!"
echo "Output file:" $OUTROM
echo "*******************************************************************************"
