
tempFontFile=".fontrender_temp"



function renderString() {
  printf "$2" > $tempFontFile
  
  ./fontrender "font/12px_outline/" "$tempFontFile" "font/12px_outline/table.tbl" "$1.png"
}



make fontrender

# time = 4.15 = 249 frames
renderString rsrc/punish_subs/0_text "I don't know who you're supposed to be, but let that man go!"
# 8.62 = 517 frames
renderString rsrc/punish_subs/1_text "(Here they come...)"
# 9.53 = 571
renderString rsrc/punish_subs/2_text "The sailor-suited Pretty Soldier of Love and JusticeÅ\Sailor Moon!"
# 15.21 = 913
renderString rsrc/punish_subs/3_text "LikewiseÅ\Sailor Mercury!"
# 18.00 = 1080
renderString rsrc/punish_subs/4_text "Sailor Mars!"
# 19.64 = 1178
renderString rsrc/punish_subs/5_text "Sailor Jupiter!"
# 21.43 = 1286 (end = 22.46 = 1348)
renderString rsrc/punish_subs/6_text "Sailor Venus!"
# 23.44 = 1406
renderString rsrc/punish_subs/7_text "In the name of the moon..."
# 25.56 = 1534 (end = 26.51 = 1591)
renderString rsrc/punish_subs/8_text "We'll punish you!"
# renderString test "Mercury Star Power!"


rm $tempFontFile