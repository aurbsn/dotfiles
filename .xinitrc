# Set the background/wallpaper!

feh --bg-center ~/pic/haskell-pattern.png &

# Icon tray!

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
    --expand true --width 28 --transparent true --alpha 1 --tint 0x002b36 --height 16 &

# Hide the obnoxious rodent!

unclutter &

# Disable capslock.

setxkbmap -option ctrl:nocaps

# Load Xdefaults

xrdb -merge .Xdefaults

# Launch XMonad!

exec xmonad
