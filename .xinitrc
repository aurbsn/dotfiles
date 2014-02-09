# Start ssh-agent

eval $(ssh-agent)

# Start dropboxd

dropboxd &

# Hide the obnoxious rodent!

unclutter &

# Disable capslock.

setxkbmap -option ctrl:nocaps

# Merge Xdefaults

xrdb -merge ~/.Xdefaults

# Set up screens

~/.screenlayout/layout.sh

# Launch XMonad!

exec xmonad
