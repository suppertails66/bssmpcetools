
tempFontFile=".fontrender_temp"



function renderString() {
  printf "$2" > $tempFontFile
  
#  ./fontrender "font/12px_outline/" "$tempFontFile" "font/12px_outline/table.tbl" "$1.png"
  ./fontrender "font/12px/" "$tempFontFile" "font/12px/table.tbl" "$1.png"
}



make fontrender

#renderString render "Naoko Takeuchi, Kodansha, TV Asahi, Toei Animation"
renderString render "BANPRESTO 1994"
#renderString render "This is a SUPER CD-ROM2 disc. Please use it only on a version 3.00 SUPER CD-ROM2 system."


rm $tempFontFile