
# for file in rawfiles/*.bin; do
#   cmp "$file" "unusedfiles/545127"
#   if [ "$?" -eq "0" ]; then
#     break
#   fi
# done

function outlineSolidPixels() {
  convert "$1" \( +clone -channel A -morphology EdgeOut Diamond:1 -negate -threshold 15% -negate +channel +level-colors \#000024 \) -compose DstOver -composite "$2"
}

function outlineSolidPixels2() {
  convert "$1" \( +clone -channel A -morphology EdgeOut Diamond:1 -negate -threshold 15% -negate +channel +level-colors \#FFFFFF \) -compose DstOver -composite "$2"
}

outlineSolidPixels "title_outline.png" "title_outline2.png"
outlineSolidPixels2 "title_outline2.png" "title_outline2.png"

# outlineSolidPixels "e57_grp_bg.png" "e57_grp_bg.png"