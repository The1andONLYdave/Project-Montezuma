#convert tmx to various csv maps for my game
#just copy n paste from tiled-export to tmx (or different format) the csv(check preferences if you got base64 or other)part into 1.csv and run this bat file
#bash windows
#and gawk 3.1.6 for windows
"C:\Program Files (x86)\GnuWin32\bin\gawk" -f practice.awk 1.csv > mapCSV_Group1_Map1.csv
"C:\Program Files (x86)\GnuWin32\bin\gawk" -f ladder.awk 1.csv > mapCSV_Group1_Ladders.csv
"C:\Program Files (x86)\GnuWin32\bin\gawk" -f background.awk 1.csv > mapCSV_Group1_Map1back.csv
