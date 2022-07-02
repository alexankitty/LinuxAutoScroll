# LinuxAutoScroll
Simple script stolen and modified to enable autoscroll and middle mouse paste blocking
I've made a few simple edits to block pasting from within the script instead of using sxhkd to modify copy and paste hotkeys to do it.
The click scroll is untested, use at your own risk.

# Requirements
- xsel
- libinput
- sxhkd
- xdotool
- dash (Optional: if you want a faster interpreter for the autoscroll)

# Installation
Under arch run ```sudo pacman -S xsel libinput sxhkd xdotool```
Other distros, use your package manager of choice with the respective packages listed above.

Clone this repo with ```git clone https://github.com/alexankitty/LinuxAutoScroll```
Run install.sh (be sure to look over the script in case anything needs to change for your specific config as I'm making assumptions)
Change the autoscroll.sh script to #!/bin/bash if you don't have/want dash.

# Modifications
All of these edits are made in autoscroll.sh
If you want the scrolling to take longer to start, change the clickdelay, I found 0.1 to be the best for me, but the script suggested 0.2 instead.

If you want click scrolling set that variable to 1. This is untested. It should theoretically work as we're blocking via xsel but it's not functionality I'm interested in.

Be sure to set the paddingtop and paddingbot variables in accordance to your titlebar and taskbar needs as well. The script will push and lock the mouse above those places.

# Thank you
These changes would not have been possible without the original work I stole from here https://unix.stackexchange.com/questions/472398/can-i-make-middle-mouse-scrolling-on-linux-behave-more-like-autoscrolling-on-win
Thanks to both Cestarian and Azerothian.
