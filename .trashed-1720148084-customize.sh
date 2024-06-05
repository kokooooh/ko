#!/sbin/sh

#####################################
#     Android Emoji Changer
#                By
# Khun Htetz Naing(t.me/HtetzNaing)
#####################################

FONT_DIR=$MODPATH/system/fonts
DEF_FONT='NotoColorEmoji.ttf'
TARGET_FONTS='SamsungColorEmoji.ttf AndroidEmoji-htc.ttf ColorUniEmoji.ttf DcmColorEmoji.ttf CombinedColorEmoji.ttf HTC_ColorEmoji.ttf LGNotoColorEmoji.ttf NotoColorEmojiLegacy.ttf'

# 1 for delete /data/fonts/files
ANDROID12_REPLACE=0
# 1 for normal mode
SMART_MODE=1

replace_app_emojis(){
    BASE_DIR="$1"
    SUB_DIR="$2"
    FILE_NAME="$3"
    NAME="$4"

    ui_print "[!] Check $NAME 📱"

    if [ -d "$BASE_DIR" ]; then
        DIR="$BASE_DIR/$SUB_DIR"
        PATH="$DIR/$FILE_NAME"
        #Delete directory
        rm -rf $DIR
        # Create directory
        mkdir -p $DIR
        # Copy emoji to target file
        if cp "$FONT_DIR/$DEF_FONT" "$PATH"; then
            set_perm_recursive "$PATH" 0 0 0755 700
            ui_print "[-] Replacing $NAME Emojis ✅"
        else
            ui_print "[x] Replacing $NAME Emojis ❎"
        fi
    fi
}

# Replace facebook & messenger emojis
fb_msg_emoji() {
    MSG_DIR="/data/data/com.facebook.orca"
    FB_DIR="/data/data/com.facebook.katana"
    EMOJI_DIR="app_ras_blobs"
    EMOJI_NAME="FacebookEmoji.ttf"

    replace_app_emojis $MSG_DIR $EMOJI_DIR $EMOJI_NAME "Messenger"
    replace_app_emojis $FB_DIR $EMOJI_DIR $EMOJI_NAME "Facebook"
}

gb_emoji(){
    GB_FONTS_DIR="/data/data/com.google.android.gms/files/fonts/opentype"
    ui_print "[!] Check GBoard Emojis ⌨️"
    if cd "$GB_FONTS_DIR"
        then
        for file in * ; do
            if [ "${file##Noto_Color_Emoji_Compat*.}" = "ttf" ]; then
                if cp "$FONT_DIR/$DEF_FONT" "./$file"
                then
                    set_perm_recursive "$file" 0 0 0755 700
                    ui_print "[-] Replacing GBoard Emojis ✅"
                else
                    ui_print "[x] Replacing GBoard Emojis ❎"
                fi
            fi
        done
    fi
}

# Replace System Emoji
system_emoji(){
    ui_print "[-] Replacing $DEF_FONT ✅"
    for i in $TARGET_FONTS ; do
        if [ -f "/system/fonts/$i" ]; then
          if cp "$FONT_DIR/$DEF_FONT" "$FONT_DIR/$i"
          then
              ui_print "[-] Replacing $i ✅"
          else
            ui_print "[x] Replacing $i ❎"
          fi
        fi
    done
}

#Source: https://www.xda-developers.com/google-prepares-decouple-new-emojis-android-system-updates/
android12_replace_method(){
  DATA_FONT_DIR="/data/fonts/files"
  for dir in "$DATA_FONT_DIR"/*/ ; do
    if cd "$dir"
    then
      for file in * ; do
        if [ "${file##*.}" = "ttf" ]; then
          if cp "$FONT_DIR/$DEF_FONT" "$file"
          then
            ui_print "[-] Replacing $file ✅"
          else
            ui_print "[x] Replacing $file ❎"
          fi
        fi
      done
    fi
  done
}

android12_delete_method(){
  DATA_FONT_DIR="/data/fonts/files"
  for dir in "$DATA_FONT_DIR"/*/ ; do
    if rm -rf "$dir"
    then
      ui_print "[-] Delete $dir ✅"
    else
      ui_print "[x] Delete $dir ❎"
    fi
  done
}

# Android 12
android12(){
    if [ "$API" -ge 31 ]; then
        ui_print ""
        ui_print " ℹ️ Android 12+ ✅"
        ui_print "******************"
        DATA_FONT_DIR="/data/fonts/files"
        if [ -d "$DATA_FONT_DIR" ]; then
            ui_print "[!] Checking [$DATA_FONT_DIR] ✅"
            if [ "$ANDROID12_REPLACE" = 0 ]; then
                ui_print "*****************"
                ui_print " Replace method❗ "
                ui_print "*****************"
                android12_replace_method
            else
                ui_print "****************"
                ui_print " Delete method❗ "
                ui_print "****************"
                android12_delete_method
            fi
        fi
    fi
}

#Replace system fonts
ui_print ""
if [ "$SMART_MODE" = 0 ]; then
    ui_print "******************"
    ui_print " ℹ️ Smart mode 🥷 "
    ui_print "******************"
    system_emoji
else
    ui_print "*******************"
    ui_print " ℹ️ Normal mode 🤓 "
    ui_print "*******************"
fi

#If emoji also replace facebook & messenger
fb_msg_emoji

#Replace GBoard Emoji
gb_emoji

#If Android 12 >=
android12