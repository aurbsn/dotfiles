# Start ssh-agent

eval $(ssh-agent)

# Start dropboxd

dropboxd &

# Hide the obnoxious rodent!

unclutter &

# Disable capslock.

setxkbmap -option ctrl:nocaps

# Set screens
~/.screenlayout/layout.sh

# Merge Xdefaults

xrdb -merge ~/.Xdefaults

# Launch XMonad!

exec xmonad
