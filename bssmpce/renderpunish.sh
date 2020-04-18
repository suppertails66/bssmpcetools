
tempFontFile=".fontrender_temp"



# function renderString() {
#   printf "$2" > $tempFontFile
#   
#   ./fontrender "font/12px_outline/" "$tempFontFile" "font/12px_outline/table.tbl" "$1.png"
# }

function outlineSolidPixels() {
  convert "$1" \( +clone -channel A -morphology EdgeOut Square:1 -negate -threshold 15% -negate +channel +level-colors \#111111 \) -compose DstOver -composite "$2"
}

function renderString() {
  echo "Rendering text: '$2'"
  printf "$2" > $tempFontFile
  
  file=$1.png
  fontname=Liberation-Sans-Narrow-Bold
  text=$2
  
  convert -background none -font $fontname -density 72 -pointsize 13 -fill white -gravity North -size 224x caption:"$text" $file
  
  outlineSolidPixels "$file" "$file"
  
  convert "$file" \( +clone -channel A -negate -threshold 0 -negate +channel +level-colors \#111111 \) -compose DstOver -composite "$file"
  
  convert -size 256x32 xc: -alpha transparent "$file" -channel A -threshold 50% -dither none -remap "rsrc/punish_subs/remap.png" -gravity center -geometry +0+0 -composite "$file"
  
  convert "rsrc/punish_subs/base.png" "$file" -gravity NorthWest -geometry +0+0 -composite "$file"
}

# function renderStringAlt() {
#   echo "Rendering text with alt method: '$2'"
#   printf "$2" > $tempFontFile
#   
#   file=$1.png
#   fontname=Liberation-Sans-Narrow-Bold
#   text=$2
#   
#   convert -background none -font $fontname -density 72 -pointsize 13 -fill white -gravity North -size 256x caption:"$text" $file
#   
#   outlineSolidPixels "$file" "$file"
#   
#   convert -size 256x32 xc: -alpha transparent "$file" -gravity center -geometry +0+0 -composite "$file"
# }



make fontrender

# time = 4.15 = 249 frames
renderString rsrc/punish_subs/0 "I don't know who you're supposed to be, but let that man go!"
# 8.62 = 517 frames
renderString rsrc/punish_subs/1 "(Here they come...)"
# 9.53 = 571
renderString rsrc/punish_subs/2 "The sailor-suited Pretty Soldier of Love and Justice—Sailor Moon!"
# 15.21 = 913
renderString rsrc/punish_subs/3 "Likewise—Sailor Mercury!"
# 18.00 = 1080
renderString rsrc/punish_subs/4 "Sailor Mars!"
# 19.64 = 1178
renderString rsrc/punish_subs/5 "Sailor Jupiter!"
# 21.43 = 1286 (end = 22.46 = 1348)
renderString rsrc/punish_subs/6 "Sailor Venus!"
# 23.44 = 1406
renderString rsrc/punish_subs/7 "In the name of the moon..."
# 25.56 = 1534 (end = 26.51 = 1591)
renderString rsrc/punish_subs/8 "We'll punish you!"


rm $tempFontFile