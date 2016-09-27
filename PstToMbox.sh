#!/bin/bash
mkdir outlook
readpst  -o  outlook  -r "$1"
find outlook -type d | tac | grep -v '^outlook$' | xargs -d '\n' -I{} mv {} {}.sbd
mv outlook outlook.sbd
find outlook.sbd -type d | xargs -d '\n' -I{} echo '"{}/mbox"' | xargs -L 1 touch
find outlook.sbd -name mbox -type f | xargs -d '\n' -I{} echo '"{}" "{}"' | sed -e 's/\.sbd\/mbox"$/"/' | xargs -L 1 mv
find outlook.sbd -empty -type d | xargs -d '\n' rmdir
rm -rf "outlook.sbd/`ls outlook.sbd | xargs -d '\n' -I{} echo '{}' | grep -v sbd`"
mv outlook.sbd/*.sbd outlook.sbd/temp
mv outlook.sbd/temp/* outlook.sbd/.
rm -rf outlook.sbd/temp
cp -R outlook.sbd outlook "`zenity --file-selection --directory --title="Directory of Thunderbird's local folders"`"
zenity --info --text="Done"
