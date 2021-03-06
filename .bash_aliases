# system/workflow specific
alias 'syss'='systemctl suspend'
alias 'sysp'='systemctl poweroff'
alias 'sysh'='systemctl hibernate'
alias 'sysr'='systemctl reboot'
alias 'nvym'='vym ~/Templates/VymTemplate.vym &'
alias 'vpn'='expressvpn connect'
alias 'vpnx'='expressvpn disconnect'
alias 't'='alacritty &'
alias 'udd'='alacritty --class dropdown &'
alias 'ufe'='alacritty --class file_explorer -e ranger &'
alias 'v'='nvim'
alias 'r'='ranger'
alias 'f'='fzf'
alias 'ra'='ranger ~/Videos/Anime'
alias 'rd'='ranger ~/Downloads'
alias 'rj'='ranger ~/Documents/Job\ Hunting'
alias 'rv'='ranger ~/Videos'
alias 'music'='ranger ~/Music'
alias 'red'='redshift &'
alias 'redx'='redshift -x'
alias 'pac'='sudo pacman'
# remove binaries in current directories
alias 'rm_binaries'='find . ! -name "*.*"  -delete'

# Quick change configs
alias 'vim_config'='nvim ~/.config/nvim/'
alias 'vim_init'='nvim ~/.config/nvim/init.vim'
alias 'urxvt_config'='nvim ~/.Xresources'
alias 'i3_config'='nvim ~/.config/i3/'
alias 'bash_config'='nvim ~/.bashrc'
alias 'alias_config'='nvim ~/.bash_aliases'
alias 'functions_config'='nvim ~/.bash_functions'

# keyboard mappings
alias 'usk'='setxkbmap us'
alias 'dvk'='setxkbmap dvorak'

# weather lookup
alias 'wtr'='curl wttr.in/pemulwuy'

# Dual screen set up
alias 'aus'='pacmd set-card-profile 0 "output:hdmi-surround-extra1"'
alias 'aul'='pacmd set-card-profile 0 "output:analog-stereo"'
alias 'm1'='xrandr --output eDP-1 --auto --primary --output HDMI-1 --off '
alias 'm2'='xrandr --output HDMI-1 --auto --primary --output eDP-1 --off '
alias 'm3'='xrandr --output eDP-1 --auto --primary --output HDMI-1 --right-of eDP-1 '
# Quick switch between desktop setup (with external keyboard) and laptop setup
alias 'laptop'='xrandr --output eDP-1 --auto --primary --output HDMI-1 --off; pulseaudio -k; setxkbmap dvorak; setxkbmap -option "ctrl:nocaps"; i3-msg restart'
alias 'desktop'='xrandr --output HDMI-1 --auto --primary --output eDP-1 --off; pacmd set-card-profile 0 "output:analog-stereo"; setxkbmap -option; setxkbmap us; i3-msg restart'
alias 'family'='xrandr --output HDMI-1 --auto --primary --output eDP-1 --off; pacmd set-card-profile 0 "output:hdmi-surround-extra1"'
# uni specific
alias 'unissh'='ssh z3463557@cse.unsw.edu.au'
alias 'unisftp'='sftp z3463557@cse.unsw.edu.au'

# Applications
alias 'libre'='libreoffice &' 

# Projects
alias 'website'='cd ~/website'
