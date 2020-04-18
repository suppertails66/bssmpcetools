
tempFontFile=".fontrender_temp"

set -o errexit

function outlineSolidPixels() {
  convert "$1" \( +clone -channel A -morphology EdgeOut Square:1 -negate -threshold 15% -negate +channel +level-colors \#111111 \) -compose DstOver -composite "$2"
}

function renderString() {
  echo "Rendering text: '$2'"
  printf "$2" > $tempFontFile
  
  file=$1.png
#  fontname=DejaVu-Sans-Condensed-Bold
#   fontname=Nimbus-Sans-L-Bold-Condensed
  fontname=Liberation-Sans-Narrow-Bold
#  xoffset=$3
#  yoffset=$4
  text=$2
  # fontsize is optional
#   fontsize=$3
#   if [ "$fontsize" == "" ]; then
#     fontsize=14
#   fi

#  convert -size 256x32 xc: -alpha transparent "$file"
  
#  convert $file -font $fontname -pointsize $fontsize -fill white -gravity Center -draw "text 0,0 '$text'" $file
  
#  convert $file -font $fontname -density 72 -pointsize 14 -fill white -gravity Center -annotate +0-1 "$text" $file
  convert -background none -font $fontname -density 72 -pointsize 13 -fill white -gravity North -size 224x caption:"$text" $file
  
  outlineSolidPixels "$file" "$file"
  
  convert "$file" \( +clone -channel A -negate -threshold 0 -negate +channel +level-colors \#111111 \) -compose DstOver -composite "$file"
  convert -size 256x32 xc: -alpha transparent "$file" -gravity center -geometry +0+0 -composite "$file"
}

function renderStringAlt() {
  echo "Rendering text with alt method: '$2'"
  printf "$2" > $tempFontFile
  
  file=$1.png
  fontname=Liberation-Sans-Narrow-Bold
  text=$2
  
  convert -background none -font $fontname -density 72 -pointsize 13 -fill white -gravity North -size 256x caption:"$text" $file
  
  outlineSolidPixels "$file" "$file"
  
  convert "$file" \( +clone -channel A -negate -threshold 0 -negate +channel +level-colors \#111111 \) -compose DstOver -composite "$file"
  convert -size 256x32 xc: -alpha transparent "$file" -gravity center -geometry +0+0 -composite "$file"
}

# function renderString() {
#   echo "Rendering text: '$2'"
#   printf "$2" > $tempFontFile
#   
#   ./spritesubtitlerender "$tempFontFile" "$1.png"
# }

# function renderStringAlt() {
#   echo "Rendering text with alt format: '$2'"
#   printf "$2" > $tempFontFile
#   
#   ./spritesubtitlerender "$tempFontFile" "$1.png" --altformat
# }



make spritesubtitlerender

# # time = 4.15 = 249 frames
# renderString rsrc/punish_subs/0_text "I don't know who you're supposed to be, but let that man go!"
# # 8.62 = 517 frames
# renderString rsrc/punish_subs/1_text "(Here they come...)"
# # 9.53 = 571
# renderString rsrc/punish_subs/2_text "The sailor-suited Pretty Soldier of Love and Justice—Sailor Moon!"
# # 15.21 = 913
# renderString rsrc/punish_subs/3_text "Likewise—Sailor Mercury!"
# # 18.00 = 1080
# renderString rsrc/punish_subs/4_text "Sailor Mars!"
# # 19.64 = 1178
# renderString rsrc/punish_subs/5_text "Sailor Jupiter!"
# # 21.43 = 1286 (end = 22.46 = 1348)
# renderString rsrc/punish_subs/6_text "Sailor Venus!"
# # 23.44 = 1406
# renderString rsrc/punish_subs/7_text "In the name of the moon..."
# # 25.56 = 1534 (end = 26.51 = 1591)
# renderString rsrc/punish_subs/8_text "We'll punish you!"

#rm -f -r rsrc/ending
mkdir -p rsrc/ending

# renderString rsrc/ending/s1_0 "Mercury Star Power!\nTest"
# exit

# renderString rsrc/ending/s0_0 "Impossible! This can't be happen—"
# renderString rsrc/ending/s1_0 "Mercury Star Power!"
# renderString rsrc/ending/s2_0 "Mars Star Power!"
# renderString rsrc/ending/s3_0 "Jupiter Star Power!"
# renderString rsrc/ending/s4_0 "Venus Star Power!"
# renderString rsrc/ending/s5_0 "Moon Crystal Power!"
# renderString rsrc/ending/s6_0 "Is there no way you can return\nto your former selves...?"
# renderString rsrc/ending/s7_0 "Master...\nI'm glad we were able to see you once more."
# renderString rsrc/ending/s7_1 "Now we no longer have any regrets in this era..."
# renderString rsrc/ending/s7_2 "I hope you can forgive us for the way we acted."
# renderString rsrc/ending/s7_3 "May the two of you live in happiness."
# renderString rsrc/ending/s8_0 "What are you looking at?\nJust finish me off already!"
# renderString rsrc/ending/s9_0_0 "Without that gem,"
# renderString rsrc/ending/s9_0_1 "I won't be able to come back to life again."
# renderString rsrc/ending/s9_1 "There's no better place for me\nthan the world of the dead."
# renderString rsrc/ending/s10_0 "What are you waiting for?!"
# renderString rsrc/ending/s11_0_0 "Stop it!"
# renderString rsrc/ending/s11_0_1 "Why would you say something so sad?"
# renderString rsrc/ending/s11_0_2 "Isn't this enough?"
# renderString rsrc/ending/s11_0_3 "Let's just forget about the past,\nabout all this fighting..."
# renderString rsrc/ending/s11_0_4 "...Forget about all that."
# renderString rsrc/ending/s12_0_0 "I know! How about we become friends?"
# renderString rsrc/ending/s12_0_1 "After all, we're the same.\nWe both loved the same man."
# #renderString rsrc/ending/s12_0_2 "We both loved the same man."
# renderString rsrc/ending/s13_0 "Eek!"
# renderString rsrc/ending/s14_0_0 "Don't you dare! You want to be {friends}?"
# renderString rsrc/ending/s14_0_1 "Don't you know who I am?!\nI am the ruler of the Dark Kingdom,"
# renderString rsrc/ending/s14_0_2 "QUEEN—"
# renderString rsrc/ending/s15_0 "Queen Beryl?!"
# renderString rsrc/ending/s16_0_0 "I have no idea where you get that kindness from..."
# renderString rsrc/ending/s16_0_1 "You were always like that."
# renderString rsrc/ending/s16_1 "I...I was always afraid of that kindness."
# renderString rsrc/ending/s17_0 "I was afraid of what would happen\nif Endymion were to witness that kindness."
# #renderString rsrc/ending/s17_0_1 ""
# renderString rsrc/ending/s17_1_0 "I was afraid...that I'd forgive you,\nif I were to stay by your side..."
# renderString rsrc/ending/s17_1_1 "Afrai..."
# renderString rsrc/ending/s18_0_0 "Queen Beryl?!...Queen Beryl!"
# #renderString rsrc/ending/s18_0_1 ""
# renderString rsrc/ending/s19_0_0 "O Silver Crystal, hear my wish."
# renderString rsrc/ending/s19_0_1 "Let these people reincarnate, like us."
# renderString rsrc/ending/s19_0_2 "Let them live in a peaceful world,\nfree from strife..."
# renderString rsrc/ending/s20_0a "Sorry! Were you waiting long, Naru-chan?"
# renderString rsrc/ending/s20_0b "Sorry! Were you waiting long, Naru?"
# renderString rsrc/ending/s21_0 "You're late, Usagi! What were you doing?"
# renderString rsrc/ending/s21_1_0 "Sorry, sorry."
# renderString rsrc/ending/s21_1_1 "I got caught by Haruna. You know how that goes."
# renderString rsrc/ending/s21_2 "Well, YOU'LL be carrying the flowers, then."
# renderString rsrc/ending/s21_3a "Doyeh! Why do I have to bring flowers to Umino?!"
# renderString rsrc/ending/s21_3b "Doyeh! Why do I have to bring flowers to Gurio?!"
# renderString rsrc/ending/s22_0 "I'm just kidding."
# renderString rsrc/ending/s22_1 "You are?"
# renderString rsrc/ending/s22_2 "But we're splitting the cost!"
# renderString rsrc/ending/s22_3a "Ehhh? But I'm almost out of\npocket money for this month!"
# renderString rsrc/ending/s22_3b "Buuuh? But I'm almost out of\npocket money for this month!"
# renderString rsrc/ending/s22_4 "No buts! I'll get mad if you don't pay up!"
# #renderString rsrc/ending/s22_4_1 ""
# renderString rsrc/ending/s22_5a "Hey! W-Wait up, Naru-chan!"
# renderString rsrc/ending/s22_5b "Hey! W-Wait up, Naru!"
# renderString rsrc/ending/s23_0a "But why do I have to visit Umino too, anyway?"
# renderString rsrc/ending/s23_0b "But why do I have to visit Gurio too, anyway?"
# renderString rsrc/ending/s23_1_0 "Well, I, uhmm..."
# renderString rsrc/ending/s23_1_1 "It's the first time I've gone to his house, and..."
# renderString rsrc/ending/s24_0 "Ohh, so it's because you'd feel\nhelpless without me, huh?"
# renderString rsrc/ending/s25_0 "Are you sure, though? Won't I get in the way?"
# renderString rsrc/ending/s26_0a "Naru-chan! You came to see me?\nI'm so happy!"
# renderString rsrc/ending/s26_0b "My sweet Naru! You came to see me?\nI'm so happy!"
# renderString rsrc/ending/s27_0a "Oh, Umino-kun, of course I'd come!"
# renderString rsrc/ending/s27_0b "Oh, dear Gurio, of course I'd come!"
# renderString rsrc/ending/s28_0_0 "Between two lovers, no words are needed."
# renderString rsrc/ending/s28_0_1a "As they gaze into each other's eyes,\nUmino and Naru-chan—"
# renderString rsrc/ending/s28_0_1b "As they gaze into each other's eyes,\nGurio and Naru—"
# renderString rsrc/ending/s29_0_0 "Cut it out, Usagi! What's THAT supposed to be?!"
# #renderString rsrc/ending/s29_0_1 ""
# renderString rsrc/ending/s29_0_1a "I told you, there's nothing between me and Umino!"
# renderString rsrc/ending/s29_0_1b "I told you, there's nothing between me and Gurio!"
# renderString rsrc/ending/s30_0 "I'm glad to see she's doing well."
# renderString rsrc/ending/s30_1 "In the end, we never did figure out\nwho or what Death Phantom really was."
# #renderString rsrc/ending/s30_1_1 ""
# renderString rsrc/ending/s30_2 "At any rate, now the battle against\nthe Dark Kingdom is truly over."
# #renderString rsrc/ending/s30_2_1 ""
# renderString rsrc/ending/s30_3 "Now Queen Beryl, Nephrite, and everyone else\nwill be able to live lives free from conflict."
# #renderString rsrc/ending/s30_3_1 ""
# renderString rsrc/ending/s30_4 "I hope so, too."
# renderString rsrc/ending/s31_0 "I guess Usagi really is the Princess."
# renderString rsrc/ending/s31_1 "What brought this on, Artemis?"
# renderString rsrc/ending/s32_0_0 "Well, it's just that..."
# renderString rsrc/ending/s32_0_1 "Even though Queen Beryl was her sworn enemy,\nshe still felt sad for her, even cried for her."
# #renderString rsrc/ending/s32_0_2 ""
# renderString rsrc/ending/s32_0_2 "You wouldn't think that little body of hers\ncould hide so much love energy."
# #renderString rsrc/ending/s32_0_3 ""
# renderString rsrc/ending/s33_0a "Naru-chan! Ahh, Naru-chan!"
# renderString rsrc/ending/s33_0b "Naru! Ahh, my lovely Naru!"
# renderString rsrc/ending/s33_1 "USAGI!"
# renderString rsrc/ending/s34_0 "...Are you sure about that?"
# renderString rsrc/ending/s35_0 "...Well..."
# renderString rsrc/ending/s36_0a "What matters is that Naru-chan and Umino\nare getting along well now."
# renderString rsrc/ending/s36_0b "What matters is that Naru and Gurio\nare getting along well now."
# #renderString rsrc/ending/s36_1 ""
# renderString rsrc/ending/s37_0 "Like the saying goes,\n{After a storm comes a calm}."
# renderString rsrc/ending/s38_0a "Minako-chan."
# renderString rsrc/ending/s38_0b "Minako."
# renderString rsrc/ending/s39_0a "Eh? A-Ami-chan, did I get that wrong?"
# renderString rsrc/ending/s39_0b "Huh? A-Ami, did I get that wrong?"
# renderString rsrc/ending/s40_0 "...No, it's correct."
# renderString rsrc/ending/s40_1 "Ohhhhh."
# renderString rsrc/ending/s40_2a "Ehh? Oh wow!"
# renderString rsrc/ending/s40_2b "Huh? Oh wow!"
# renderString rsrc/ending/s41_0_0a "Umino-kun, no! We can't kiss yet!"
# renderString rsrc/ending/s41_0_0b "My dear Gurio, no! We can't kiss yet!"
# renderString rsrc/ending/s41_0_1 "We're still in middle school!"
# renderString rsrc/ending/s42_0a "Naru-chan tries to hold him back."
# renderString rsrc/ending/s42_0b "Naru tries to hold him back."
# renderString rsrc/ending/s43_0 "But her maiden arms cannot stop a virile young man."
# renderString rsrc/ending/s44_0 "Usagi! Will you cut it out already?!"
# renderString rsrc/ending/s45_0a "Naru-chan! You are my sun!"
# renderString rsrc/ending/s45_0b "O fair Naru! You are my sun!"
# renderString rsrc/ending/s46_0 "YOU STOP RIGHT THERE!"
# renderString rsrc/ending/s47_0 "How passionate!"
# renderString rsrc/ending/s48_0 "USAGI!"

renderString rsrc/ending/s0_0 "Impossible! This can't be happen—"
renderString rsrc/ending/s1_0 "Mercury Star Power!"
renderString rsrc/ending/s2_0 "Mars Star Power!"
renderString rsrc/ending/s3_0 "Jupiter Star Power!"
renderString rsrc/ending/s4_0 "Venus Star Power!"
renderString rsrc/ending/s5_0 "Moon Crystal Power!"
renderString rsrc/ending/s6_0 "Is there no way you can return to your former selves...?"
renderString rsrc/ending/s7_0 "Master...I'm glad we were able to see you once more."
renderString rsrc/ending/s7_1 "Now we no longer have any regrets in this era..."
renderString rsrc/ending/s7_2 "I hope you can forgive us for the way we acted."
renderString rsrc/ending/s7_3 "May the two of you live in happiness."
renderString rsrc/ending/s8_0 "What are you looking at? Just finish me off already!"
renderString rsrc/ending/s9_0_0 "Without that gem,"
renderString rsrc/ending/s9_0_1 "I won't be able to come back to life again."
renderString rsrc/ending/s9_1 "There's no better place for me than the world of the dead."
renderString rsrc/ending/s10_0 "What are you waiting for?!"
renderString rsrc/ending/s11_0_0 "Stop it!"
renderString rsrc/ending/s11_0_1 "Why would you say something so sad?"
renderString rsrc/ending/s11_0_2 "Isn't this enough?"
renderString rsrc/ending/s11_0_3 "Let's just forget about the past, about all this fighting..."
renderString rsrc/ending/s11_0_4 "...Forget about all that."
renderString rsrc/ending/s12_0_0 "I know! How about we become friends?"
renderString rsrc/ending/s12_0_1 "After all, we're the same. We both loved the same man."
#renderString rsrc/ending/s12_0_2 "We both loved the same man."
renderString rsrc/ending/s13_0 "Eek!"
renderString rsrc/ending/s14_0_0 "Don't you dare! You want to be “friends”?"
renderString rsrc/ending/s14_0_1 "Don't you know who I am?! I am the ruler of the Dark Kingdom,"
renderString rsrc/ending/s14_0_2 "QUEEN—"
renderString rsrc/ending/s15_0 "Queen Beryl?!"
renderString rsrc/ending/s16_0_0 "I have no idea where you get that kindness from..."
renderString rsrc/ending/s16_0_1 "You were always like that."
renderString rsrc/ending/s16_1 "I...I was always afraid of that kindness."
renderString rsrc/ending/s17_0 "I was afraid of what would happen if Endymion were to witness that kindness."
#renderString rsrc/ending/s17_0_1 ""
renderString rsrc/ending/s17_1_0 "I was afraid...that I'd forgive you, if I were to stay by your side..."
renderString rsrc/ending/s17_1_1 "Afrai..."
renderString rsrc/ending/s18_0_0 "Queen Beryl?!...Queen Beryl!"
#renderString rsrc/ending/s18_0_1 ""
renderString rsrc/ending/s19_0_0 "O Silver Crystal, hear my wish."
renderString rsrc/ending/s19_0_1 "Let these people reincarnate, like us."
renderString rsrc/ending/s19_0_2 "Let them live in a peaceful world, free from strife..."
renderString rsrc/ending/s20_0a "Sorry! Were you waiting long, Naru-chan?"
renderString rsrc/ending/s20_0b "Sorry! Were you waiting long, Naru?"
renderString rsrc/ending/s21_0 "You're late, Usagi! What were you doing?"
renderString rsrc/ending/s21_1_0 "Sorry, sorry."
renderString rsrc/ending/s21_1_1 "I got caught by Haruna. You know how that goes."
renderString rsrc/ending/s21_2 "Well, YOU'LL be carrying the flowers, then."
renderString rsrc/ending/s21_3a "Doyeh! Why do I have to bring flowers to Umino?!"
renderString rsrc/ending/s21_3b "Doyeh! Why do I have to bring flowers to Umino?!"
renderString rsrc/ending/s22_0 "I'm just kidding."
renderString rsrc/ending/s22_1 "You are?"
renderString rsrc/ending/s22_2 "But we're splitting the cost!"
renderString rsrc/ending/s22_3a "Ehhh? But I'm almost out of pocket money for this month!"
renderString rsrc/ending/s22_3b "Buuuh? But I'm almost out of pocket money for this month!"
renderString rsrc/ending/s22_4 "No buts! I'll get mad if you don't pay up!"
#renderString rsrc/ending/s22_4_1 ""
renderString rsrc/ending/s22_5a "Hey! W-Wait up, Naru-chan!"
renderString rsrc/ending/s22_5b "Hey! W-Wait up, Naru!"
renderString rsrc/ending/s23_0a "But why do I have to visit Umino too, anyway?"
renderString rsrc/ending/s23_0b "But why do I have to visit Umino too, anyway?"
renderString rsrc/ending/s23_1_0 "Well, I, uhmm..."
renderString rsrc/ending/s23_1_1 "It's the first time I've been to his house, and..."
renderString rsrc/ending/s24_0 "Ohh, so it's because you'd feel helpless without me, huh?"
renderString rsrc/ending/s25_0 "Are you sure, though? Won't I get in the way?"
renderString rsrc/ending/s26_0a "Naru-chan! You came to see me? I'm so happy!"
renderString rsrc/ending/s26_0b "My sweet Naru! You came to see me? I'm so happy!"
renderString rsrc/ending/s27_0a "Oh, Umino-kun, of course I'd come!"
renderString rsrc/ending/s27_0b "Oh, dear Umino, of course I'd come!"
renderString rsrc/ending/s28_0_0 "Between two lovers, no words are needed."
renderString rsrc/ending/s28_0_1a "As they gaze into each other's eyes, Umino and Naru-chan—"
renderString rsrc/ending/s28_0_1b "As they gaze into each other's eyes, Umino and Naru—"
renderString rsrc/ending/s29_0_0 "Cut it out, Usagi! What's THAT supposed to be?!"
#renderString rsrc/ending/s29_0_1 ""
renderString rsrc/ending/s29_0_1a "I told you, there's nothing between me and Umino!"
renderString rsrc/ending/s29_0_1b "I told you, there's nothing between me and Umino!"
renderString rsrc/ending/s30_0 "I'm glad to see she's doing well."
renderString rsrc/ending/s30_1 "In the end, we never did figure out who or what Death Phantom really was."
#renderString rsrc/ending/s30_1_1 ""
renderString rsrc/ending/s30_2 "At any rate, now the battle against the Dark Kingdom is truly over."
#renderString rsrc/ending/s30_2_1 ""
renderStringAlt rsrc/ending/s30_3 "Now Queen Beryl, Nephrite, and everyone else will be able to live lives free from conflict."
#renderString rsrc/ending/s30_3_1 ""
renderString rsrc/ending/s30_4 "I hope so, too."
renderString rsrc/ending/s31_0 "I guess Usagi really is the Princess."
renderString rsrc/ending/s31_1 "What brings this on, Artemis?"
renderString rsrc/ending/s32_0_0 "Well, it's just that..."
renderStringAlt rsrc/ending/s32_0_1 "Even though Queen Beryl was her sworn enemy, she still felt sad for her, even cried for her."
#renderString rsrc/ending/s32_0_2 ""
renderString rsrc/ending/s32_0_2 "You wouldn't think that little body of hers could hide so much love energy."
#renderString rsrc/ending/s32_0_3 ""
renderString rsrc/ending/s33_0a "Naru-chan! Ahh, Naru-chan!"
renderString rsrc/ending/s33_0b "Naru! Ahh, my lovely Naru!"
renderString rsrc/ending/s33_1 "USAGI!"
renderString rsrc/ending/s34_0 "...Are you sure about that?"
renderString rsrc/ending/s35_0 "...Well..."
renderString rsrc/ending/s36_0a "What matters is that Naru-chan and Umino are getting along well now."
renderString rsrc/ending/s36_0b "What matters is that Naru and Umino are getting along well now."
#renderString rsrc/ending/s36_1 ""
renderString rsrc/ending/s37_0 "Like the saying goes, “After a storm comes a calm”."
renderString rsrc/ending/s38_0a "Minako-chan."
renderString rsrc/ending/s38_0b "Minako."
renderString rsrc/ending/s39_0a "Eh? A-Ami-chan, did I get that wrong?"
renderString rsrc/ending/s39_0b "Huh? A-Ami, did I get that wrong?"
renderString rsrc/ending/s40_0 "...No, it's correct."
renderString rsrc/ending/s40_1 "Ohhhhh."
renderString rsrc/ending/s40_2a "Ehh? Oh wow!"
renderString rsrc/ending/s40_2b "Huh? Oh wow!"
renderString rsrc/ending/s41_0_0a "Umino-kun, no! We can't kiss yet!"
renderString rsrc/ending/s41_0_0b "My dear Umino, no! We can't kiss yet!"
renderString rsrc/ending/s41_0_1 "We're still in middle school!"
renderString rsrc/ending/s42_0a "Naru-chan tries to hold him back."
renderString rsrc/ending/s42_0b "Naru tries to hold him back."
renderString rsrc/ending/s43_0 "But her maiden arms cannot stop a virile young man."
renderString rsrc/ending/s44_0 "Usagi! Will you cut it out already?!"
renderString rsrc/ending/s45_0a "Naru-chan! You are my sun!"
renderString rsrc/ending/s45_0b "O fair Naru! You are my sun!"
renderString rsrc/ending/s46_0 "HOLD IT!"
renderString rsrc/ending/s47_0 "How passionate!"
renderString rsrc/ending/s48_0 "USAGI!"


rm $tempFontFile