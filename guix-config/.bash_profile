if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

setxkbmap -option ctrl:nocaps
export LSP_USE_PLISTS=true
