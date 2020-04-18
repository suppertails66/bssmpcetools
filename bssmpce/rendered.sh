
tempFontFile=".fontrender_temp"

set -o errexit

# make spritesubtitlerender
# 
# function renderString() {
#   echo "Rendering text: '$2'"
#   printf "$2" > $tempFontFile
#   
#   ./spritesubtitlerender "$tempFontFile" "$1.png"
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
#   convert -background none -font $fontname -density 72 -pointsize 13 -fill white -gravity North -size 224x caption:"$text" -channel A -negate -threshold 75% -negate $file
  convert -background none -font $fontname -density 72 -pointsize 13 -fill white -gravity North -size 224x caption:"$text" $file
  
  outlineSolidPixels "$file" "$file"
  
  convert "$file" \( +clone -channel A -negate -threshold 0 -negate +channel +level-colors \#111111 \) -compose DstOver -composite "$file"
  convert -size 256x32 xc: -alpha transparent "$file" -gravity center -geometry +0+0 -composite "$file"
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

function renderStringLyric() {
  echo "Rendering text: '$2'"
  printf "$2" > $tempFontFile
  
  file=$1.png
  fontname=Liberation-Sans-Narrow-Bold
  text=$2
  convert -background none -font $fontname -density 72 -pointsize 12 -fill white -gravity North -size 224x caption:"$text" $file
  
  outlineSolidPixels "$file" "$file"
  
  convert "$file" \( +clone -channel A -negate -threshold 0 -negate +channel +level-colors \#111111 \) -compose DstOver -composite "$file"
 convert -size 256x32 xc: -alpha transparent "$file" -gravity center -geometry +0+0 -composite "$file"
  convert "$file" -trim +repage "$file"
}

mkdir -p rsrc/ed

# 38 slots needed...
# - 26 single = 0xA00 bytes each = 0x10400 bytes
# - 12 double = 0x1400 bytes each = 0xF000 bytes
# total = 0x1F400 bytes
# backmem slots 3 and 4 are open = 0xA000 bytes each = 0x14000 bytes.
# backmem slot 5 is open? = 0x8000 bytes (0x1C000 total)
# and backmem 0 is probably available? = 0xA000 = 0x26000 total?

# 19.95 = 1197
renderStringLyric rsrc/ed/edsub00a "Koraekirezu koboreta namida"
renderStringLyric rsrc/ed/edsub00b "Not able to endure it longer, my tears flowed,"

# 27.29 = 1637
renderStringLyric rsrc/ed/edsub01a "Kotoba mo mitsukaranai mama"
renderStringLyric rsrc/ed/edsub01b "And I still can’t even find the words..."

# 33.83 = 2029
renderStringLyric rsrc/ed/edsub02a "Mou ii no ii no soba ni iru wa"
renderStringLyric rsrc/ed/edsub02b "It’s all right, all right, we’re here with you now,"

# 40.46 = 2427
renderStringLyric rsrc/ed/edsub03a "Tooi kako mo tsurai uso mo minna wasurete"
renderStringLyric rsrc/ed/edsub03b "Forget all about the distant past, and all the bitter lies."

# 47.37 = 2842
renderStringLyric rsrc/ed/edsub04a "Marui hitomi kagayakaseta yume miteta"
renderStringLyric rsrc/ed/edsub04b "You had a dream that made your round eyes sparkle,"

# 54.13 = 3247
renderStringLyric rsrc/ed/edsub05a "Ano koro no anata wo omoidasu made"
renderStringLyric rsrc/ed/edsub05b "And, until you remember how to be your old self,"

# 1:01.29 = 3600 + 77 = 3677
# end = 1:08.07 = 3600 + 484 = 4084
renderStringLyric rsrc/ed/edsub06a "Daite ageru..."
renderStringLyric rsrc/ed/edsub06b "We’ll hold you in our arms..."

# 1:10.60 = 3600 + 636 = 4236
renderStringLyric rsrc/ed/edsub07a "Onaji hoshi ni umare onaji toki wo ikite"
renderStringLyric rsrc/ed/edsub07b "Born to the same world, living in the same time,"

# 1:24.13 = 3600 + 1447 = 5047
renderStringLyric rsrc/ed/edsub08a "Meguriaeta koto ni motto sunao ni naritai"
renderStringLyric rsrc/ed/edsub08b "having been able to meet, I want us to be closer."

# 1:37.64 = 3600 + 2258 = 5858
renderStringLyric rsrc/ed/edsub09a "Onaji umi wo mitsume onaji nami wo kiite"
renderStringLyric rsrc/ed/edsub09b "Gazing at the same sea, listening to the same waves,"

# 1:51.16 = 3600 + 3096 = 6696
# end = 2:00.68 = 7200 + 40 = 7240
# 2:01.32 = 7200 + 79 = 7279
# end = 2:12.59 = 7200 + 755 = 7955
renderStringLyric rsrc/ed/edsub10a "Umarekawaru kokoro shinjite mitai..."
renderStringLyric rsrc/ed/edsub10b "I want to try and believe our hearts will be reborn..."


rm $tempFontFile