
tempFontFile=".fontrender_temp"

set -o errexit

function renderString() {
  echo "Rendering text: '$2'"
  printf "$2" > $tempFontFile
  
  ./spritesubtitlerender "$tempFontFile" "$1.png"
}

# function renderStringAlt() {
#   echo "Rendering text with alt format: '$2'"
#   printf "$2" > $tempFontFile
#   
#   ./spritesubtitlerender "$tempFontFile" "$1.png" --altformat
# }



make spritesubtitlerender

mkdir -p rsrc/carderror

# 1.25 = 75
renderString rsrc/carderror/map00 "Thanks for waiting!\nPretty Soldier Sailor Moon is finally on the PC-Engine!"
# 8.81 = 528
renderString rsrc/carderror/map01 "A group of men wearing ominous masks\nappear out of nowhere."
# 11.76 = 705
renderString rsrc/carderror/map02 "They're after the Illusionary Silver Crystal\nin order to resurrect the Dark Kingdom."
# 16.58 = 994
renderString rsrc/carderror/map03 "Two individuals hold the key to this mystery:\nPast Wiseman and Death Phantom...But who are they?"
# 21.45 = 1287
renderString rsrc/carderror/map04 "Ten warriors will fight through the streets of Juban!"
# 24.61 = 1476
renderString rsrc/carderror/map05 "And don't forget about me."
# 27.18 = 1630
renderString rsrc/carderror/map06 "A masterfully-crafted original storyÅ\ \na moving tale filled with love and tears."
# 31.98 = 1918
renderString rsrc/carderror/map07 "PC-Engine Super CD-ROM2 Pretty Soldier Sailor Moon!"
# 39.28 = 2356
# end = 41.94 = 2516
renderString rsrc/carderror/map08 "Play it on your Super System Card!"

rm $tempFontFile