#!/bin/dash
# Autoscroll (Full)

enableverticalscroll=1
enablehorizontalscroll=1
enableclickscroll=0
clickdelay=0.1 #The grace period for you to release the middle mouse button to activate clickscrolling before it assumes you're holding it down (in seconds), it is inadvisable to set this setting much higher than this.
paddingtop=70 #The closest the cursor can go (in pixels) to the top of your screen before being stopped. May need to be optimized based on your screen resolution.
paddingbot=60 #The closest your cursor can go (in pixels) to the bottom of before being stopped. May need to be optimized based on your screen resolution.

middlemousebutton=2
mousescrollup=4
mousescrolldown=5
mousescrollleft=6
mousescrollright=7

## Danger below :D

#disable middle mouse paste for the duration of the script - send to background and grab its pid. N flag isn't used here as xsel goes to background by default.
xsel -fi </dev/null

filename=`basename "$0"` #Required for autoscroll
#echo -n | xsel -n -i

eval $(xdotool getmouselocation --shell)
starty=$Y
startx=$X
toggle=$middlemousebutton
firstloop=1
locked=0

#A horrible hack to find the device ID of your mouse and screen height which are required to create the workaround to prevent accidental tab and toolbar scrolling.
devcount=$(xinput | sed '/keyboard/d' | sed '/Virtual/d'| wc -l)
for i in $(seq 1 $devcount)
do
    mouseid=$(xinput | sed '/keyboard/d' | sed '/Virtual/d'|cut -d '=' -f2 | cut -d '[' -f1 | head -n $i | tail -1)
    buffer=$(xinput --list $mouseid | grep -i -m 1 "Button state:" | grep -o "[$middlemousebutton]\+")
    if [ "$buffer" = "$middlemousebutton" ]
    then
        break
    fi
done
screenheight=$(( $(xrandr | grep -m1 '*' | awk '{ print $1 }' | cut -d 'x' -f2) - $paddingbot ))

if [ "$(pidof -x $filename | wc -w)" -gt "2" ]
then
    xinput set-prop $mouseid "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
    pkill autoscroll #Disables autoscrolling on second click when clickscrolling is enabled.
fi

    if [ $firstloop = 1 ]
    then
        sleep $clickdelay
        firstloop=0
        toggle=$(xinput --list "Virtual core pointer" | grep -i -m 1 "Button state:" | grep -o "[$middlemousebutton]\+")
    fi


while [ "$toggle" = "$middlemousebutton" ]
do
    #ensure we're still blocking and nothing else has decided to use xsel
    xsel -fi </dev/null
    eval $(xdotool getmouselocation --shell)
    curry=$Y
    currx=$X

    if [ $curry -lt $paddingtop ] #Prevent accidental browsertab scroll
    then
    newy=$(( $paddingtop - $curry ))
    xinput set-prop $mouseid "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 100000
    xdotool mousemove_relative 0 $newy
    elif [ $curry -gt $screenheight ] #Prevent accidental taskbar scroll
    then
    newy=$(( $screenheight - $curry ))
    xinput set-prop $mouseid "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 100000
    xdotool mousemove_relative 0 $newy
    fi

    if [ $enableverticalscroll -eq 1 ]
    then
        if [ $curry -gt $starty ]
        then
            speedy=$(expr $curry / 100 - $starty / 100)
            if [ $speedy -gt 0 ]
            then
                xdotool click --repeat $speedy --delay 1 $mousescrolldown
            fi
        else
            speedy=$(expr $curry / 100  - $starty / 100  | sed 's:-::')
            if [ $speedy -gt 0 ]
            then
                xdotool click --repeat $speedy --delay 1 $mousescrollup
            fi
        fi
    fi

    if [ $enablehorizontalscroll -eq 1 ]
    then
        if [ $currx -gt $startx ]
        then
            speedx=$(expr $currx / 100 - $startx / 100)
            if [ $speedx -gt 0 ]
            then
                xdotool click --repeat $speedx --delay 1 $mousescrollright
            fi
        else
            speedx=$(expr $currx / 100  - $startx / 100  | sed 's:-::')
            if [ $speedx -gt 0 ]
            then
                xdotool click --repeat $speedx --delay 1 $mousescrollleft
            fi
        fi
    fi

    if [ $enableclickscroll -eq 1 ] && [ -z $(xinput --list "Virtual core pointer" | grep -i -m 1 "Button state:" | grep -o "[$middlemousebutton]\+") ]
    then
        if [ $(xinput --query-state $mouseid | grep 'button\[' | sort | grep -c down) -gt 0 ] #Enables mouse buttons other than middle mouse to stop clickscrolls.
        then
            xinput set-prop $mouseid "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
            xsel -fic
            exit
        fi
    else
        enableclickscroll=0
        toggle=$(xinput --list "Virtual core pointer" | grep -i -m 1 "Button state:" | grep -o "[$middlemousebutton]\+")
    fi
    sleep 0.02
done
xinput set-prop $mouseid "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
#clear xsel and pack it up until next middle mouse click
xsel -fic
