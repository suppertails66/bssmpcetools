
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
#   convert "$file" -trim +repage "$file"
}

mkdir -p rsrc/intro

renderString rsrc/intro/intrs_0 "I must...inform...Usagi...Tsukino...!"

# 38 slots needed...
# - 26 single = 0xA00 bytes each = 0x10400 bytes
# - 12 double = 0x1400 bytes each = 0xF000 bytes
# total = 0x1F400 bytes
# backmem slots 3 and 4 are open = 0xA000 bytes each = 0x14000 bytes.
# backmem slot 5 is open? = 0x8000 bytes (0x1C000 total)
# and backmem 0 is probably available? = 0xA000 = 0x26000 total?

# 5.51 = 330
renderStringLyric rsrc/intro/opsub00a "Saa ai no energy ima koso hitotsu ni shite"
renderStringLyric rsrc/intro/opsub00b "Come on now, unite the energy of love"

# 14.69 = 881
# end = 21.16 = 1269
renderStringLyric rsrc/intro/opsub01a "Mou ichido yume mite... "
renderStringLyric rsrc/intro/opsub01b "and we’ll achieve our dream..."

# 45.72 = 2743
# 2
renderStringLyric rsrc/intro/opsub02a "Sora ga abareteiru gin no tsuki no kagayaki no naka dareka"
# 2
renderStringLyric rsrc/intro/opsub02b "The heavens are raging...Within the shining light of the silver moon, someone is there,"

# 56.07 = 3364
renderStringLyric rsrc/intro/opsub03a "Aah hisonde iru wa"
renderStringLyric rsrc/intro/opsub03b "Ah! Lurking, hiding there."

# 59.50 = 3570
# 2
renderStringLyric rsrc/intro/opsub04a "Machi ni jaaku na beam suki na fuku mo kutsu mo hora dainashi yo"
# 2
renderStringLyric rsrc/intro/opsub04b "In the street, there’s an evil beam, and look! Our beloved uniforms and shoes are ruined!"

# 1.09.79 = 3600 + 587 = 4187
renderStringLyric rsrc/intro/opsub05a "Mou atama ni kichyau"
renderStringLyric rsrc/intro/opsub05b "Ooh...now we’re mad!"

# 1.13.06 = 3600 + 783 = 4383
renderStringLyric rsrc/intro/opsub06a "Youkai ni ghost matomete mendou michyau"
renderStringLyric rsrc/intro/opsub06b "We’ll take care of these apparitions and ghosts!"

# 1.19.87 = 3600 + 1192 = 4792
renderStringLyric rsrc/intro/opsub07a "Itsudatte ai to seigi wa makenai"
renderStringLyric rsrc/intro/opsub07b "No matter what, love and justice will not lose!"

# 1.28.58 = 3600 + 1714 = 5314
# 2
renderStringLyric rsrc/intro/opsub08a "Saa mae wo muite ima koso henshin meiku appu!"
# 2
renderStringLyric rsrc/intro/opsub08b "Come on, let’s go! Face forward, NOW! Transform, Make Up!"

# 1.35.50 = 3600 + 2130 = 5730
renderStringLyric rsrc/intro/opsub09a "Muun tiara akushon!"
renderStringLyric rsrc/intro/opsub09b "“Moon Tiara Action!”"

# 1.38.88 = 3600 + 2332 = 5932
renderStringLyric rsrc/intro/opsub10a "Chansu yo! Kuresento biimu!"
renderStringLyric rsrc/intro/opsub10b "“It’s our chance! Crescent Beam!”"

# 1.42.36 = 3600 + 2541 = 6141
renderStringLyric rsrc/intro/opsub11a "Saa ai no energy ima koso hitotsu ni shite"
renderStringLyric rsrc/intro/opsub11b "Come on now, unite the energy of our love!"

# 1.49.14 = 3600 + 2948 = 6548
renderStringLyric rsrc/intro/opsub12a "Nee konna kawaii ko wo kore ijou"
# 2
renderStringLyric rsrc/intro/opsub12b "Hey, we aren’t going to forgive the ones bullying these"

# 1.57.00 = 3600 + 3480 = 7080
# end = 2.02.75 = 7200 + 165 = 7365
renderStringLyric rsrc/intro/opsub13a "Ijimeru nante yurusanai"
renderStringLyric rsrc/intro/opsub13b "Cute kids this way, any longer!"

# oh, the rest of this is only in the full version, which was apparently only
# released as a single and isn't actually in the game.
# space problem solved!!

# # 2
# renderStringLyric rsrc/intro/opsub14a "Donna tsurai toki mo naite sore de sunjaeba ii keredo"
# # 2
# renderStringLyric rsrc/intro/opsub14b "Whenever times get hard, we cry and wish that this was completely over, but"
# 
# renderStringLyric rsrc/intro/opsub15a "Mou nigetakunai wa"
# renderStringLyric rsrc/intro/opsub15b "We don’t want to avoid it any more!"
# 
# renderStringLyric rsrc/intro/opsub16a "Akuryo ni monster matomete mendou michyau"
# # 2
# renderStringLyric rsrc/intro/opsub16b "We’ll take care of these evil spirits and monsters!"
# 
# renderStringLyric rsrc/intro/opsub17a "Koishiteru otomegokoro wa makenai"
# renderStringLyric rsrc/intro/opsub17b "The hearts of girls in love won’t lose!"
# 
# # 2
# renderStringLyric rsrc/intro/opsub18a "Saa kakugo kimete ima koso henshin meiku appu!"
# # 2
# renderStringLyric rsrc/intro/opsub18b "Come on! Prepare yourselves, get ready, NOW! Transform, Make Up!"
# 
# renderStringLyric rsrc/intro/opsub19a "Shuupuriimu sandaa! Shabon supuree!"
# renderStringLyric rsrc/intro/opsub19b "“Supreme Thunder!” “Bubble Spray!”"
# renderStringLyric rsrc/intro/opsub20a "Faiyaa souru!"
# renderStringLyric rsrc/intro/opsub20b "“Fire SOUL!”"
# 
# renderStringLyric rsrc/intro/opsub21a "Saa koi no energy ima koso hitotsu ni shite"
# renderStringLyric rsrc/intro/opsub21b "Let’s go! Unite our energy from being in love!"
# 
# renderStringLyric rsrc/intro/opsub22a "Nee konda kawaii ko wo kore ijou"
# renderStringLyric rsrc/intro/opsub22b "Yep, we’re going to punish those who"
# 
# renderStringLyric rsrc/intro/opsub23a "Nakaseru nante oshioki yo"
# renderStringLyric rsrc/intro/opsub23b "Make these cute kids cry this way!"
# 
# # DUPE
# # # 2
# # renderStringLyric rsrc/intro/opsub24a "Saa mae wo muite ima koso henshin meiku appu!"
# # renderStringLyric rsrc/intro/opsub24b "Come on, let’s go! Face forward, NOW! Transform, Make Up!"
# 
# renderStringLyric rsrc/intro/opsub25a "Muun tiara akushon! Takkuru!"
# renderStringLyric rsrc/intro/opsub25b "“Moon Tiara Action!” “Tackle!”"
# 
# renderStringLyric rsrc/intro/opsub26a "Akuryo taisan!"
# renderStringLyric rsrc/intro/opsub26b "“Evil Spirits, BEGONE!”"
# 
# # DUPE
# # renderStringLyric rsrc/intro/opsub27a "Saa ai no energy ima koso hitotsu ni shite"
# # renderStringLyric rsrc/intro/opsub27b "Come on! Unite the energy of our love, NOW!"
# 
# # DUPE
# # renderStringLyric rsrc/intro/opsub28a "Nee konna kawaii ko wo kore ijou"
# # # 2
# # renderStringLyric rsrc/intro/opsub28b "Hey, we aren’t going to forgive the ones bullying these"
# 
# # DUPE
# # renderStringLyric rsrc/intro/opsub29a "Ijimeru nante yurusanai"
# # renderStringLyric rsrc/intro/opsub29b "Cute kids this way, any longer!"
# 
# # renderStringLyric rsrc/intro/opsub30a ""
# # renderStringLyric rsrc/intro/opsub30b ""
# # 
# # renderStringLyric rsrc/intro/opsub31a ""
# # renderStringLyric rsrc/intro/opsub31b ""
# # 
# # renderStringLyric rsrc/intro/opsub32a ""
# # renderStringLyric rsrc/intro/opsub32b ""
# 
# # renderString rsrc/intro/opsubend " "


rm $tempFontFile