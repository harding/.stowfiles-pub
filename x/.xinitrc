## Contact: Dave Harding <dave@dtrt.org>

. $HOME/.bash/env

_my_glxgears() {
      sh -c "sleep $1; rm ~/.xbug; killall glxgears" &
      glxgears || {
              if [ -f ~/.xbug ]
              then
                      echo "glxgears failed.  Try again." > /dev/stderr
                      exit 1
              fi
              }
}

exec >> tmp/startx.log 2>&1
## Print date for log
echo ----------------------------------------
date
echo $PATH

#if [ $USER == dah ]
#then
#   if ! pgrep -u harding startx
#   then
#	echo "You should startx for harding first."
#	echo "Press enter to continue or C-c to stop."
#	read
#    fi
#fi 

## Start dbus
## test for an existing bus daemon, just to be safe
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    ## if not found, launch a new one
    eval `dbus-launch --sh-syntax --exit-with-session`
    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi

HOSTNAME=$( hostname )

eval $(gpg-agent --daemon)

case $HOSTNAME in
    callisto)
    #xrandr --output VGA-0 --left-of DVI-0
    #_my_glxgears 5
    #_my_glxgears 10
    #_my_glxgears 20
    #_my_glxgears 35

    #  touch ~/.xbug
    if [ ! -f $HOME/.ati-fix ]
    then
	echo "ati-fix not run for this session.  Dying."
	# exit 1
    fi

    WM=/usr/bin/awesome
    ;;

    ziggy)
    WM=/usr/local/bin/notion
    ;;

    pi)
    WM=/usr/local/bin/notion
    ;;

    phobos)
      xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1
      WM=/usr/bin/awesome
      #WM=/usr/bin/xmonad
    ;;

    *)
    WM=xterm
    ;;
esac


# Write out ssh-agent vars
keychain
. $HOME/.keychain/`hostname`-sh


#/usr/bin/ion & wmpid=$!
# exec ssh-agent bash -c "ssh-add </dev/null && /usr/bin/ion3" & wmpid=$!

####################
## WINDOW MANAGER ##
####################
## Start Window Manager and put pid into $wmpid
$WM & wmpid=$!
#/usr/bin/awesome & wmpid=$!

#Forcibly read the .Xresources (Bug in rxvt?)
/usr/bin/xrdb .Xresources

## Change keyboard settings
/usr/bin/xmodmap ~/.Xmodmaprc

## Give the window manager a moment to start before launching apps
sleep 2

## Application docker
#xmessage -file .plan || xmessage "No Plan!" &
#stalonetray &

## Workrave RSI prevention software
#gconftool --type int -s /apps/workrave/timers/micro_pause/limit 380
#gconftool --type int -s /apps/workrave/timers/micro_pause/auto_reset 15
#gconftool --type int -s /apps/workrave/timers/micro_pause/snooze 120

#gconftool --type int -s /apps/workrave/timers/rest_break/limit 1800
#gconftool --type int -s /apps/workrave/timers/rest_break/auto_reset 180
#gconftool --type int -s /apps/workrave/timers/rest_break/snooze 120
#workrave & 

## Background
#/usr/bin/xplanet -origin moon -wait 1800 -transparency &

#Remove the mouse after 5s of non-movement (Thanks Marty!)
# /usr/X11R6/bin/unclutter& #netbsd
#/usr/bin/unclutter & #debian

## Start Quintuple agent to hold secrets.
#/usr/bin/killall q-agent
# /usr/bin/q-agent --fork &

## Start kuvert (needs q-agent)
#/usr/bin/kuvert -k # kill any already running kuvert
#/usr/bin/kuvert -b &

## Watch some status info
#aterm -e watch --no-title -n 60 status &

## Share the love; use bittorrent
#aterm -e rtorrent &

## For Screen Drawing
#gromit &

## Notify me when I use the thinkpad mute
#notify-mute &

## Notify me when I don't have a timer running
#notify-no-timer &

## Screensaver
#xscreensaver &

## Notify when the song changes
#mpd-report-new-song &

## Keep projects list in background
# conky &

## Start Uzbl's cookie daemon
# .config/uzbl/bin/cookie_daemon.py &

## Make sure numlock is enabled
# numlockx on &

## Start Red Note Book
# rednotebook &

## Disable screen blanking for xautolock below
#xset -dpms
#xset s off

## Program to run after n minutes idle
## xautolock -time 30 -locker dahsusp -detectsleep &

## For Encrypted Files
#cryptkeeper &

## Set background
#awsetbg -l > awsetbg.log 2>&1

## Update manager
#update-notifier &

## Put computer to sleep after set time
#dahautolock &

## Sync clipboards
autocutsel & 
autocutsel -selection PRIMARY &

## Start notification daemon
/usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd &

## Computer-specific startup programs
case $HOSTNAME in
    callisto)
	synergyc pi
    ;;

    ziggy)
	xmodmap /home/harding/var/git/dot/dvorak.xmodmap
    ;;

    pi)
	synergys &

	xautolock -detectsleep -time 5 -locker /home/harding/bin/dhpiscreenblank &
	stalonetray --grow-gravity W &
	#autocutsel -s PRIMARY &
	/usr/lib/notification-daemon/notification-daemon &
    ;;
    phobos)
        : xrandr --output LVDS1 --auto --output HDMI1 --auto --left-of LVDS1
    ;;
esac




## Run after changing to Dvorak keyboard layout
env
ssh-add < /dev/null


## Keybindings
xbindkeys &

{ sleep 5 && notify-send -t 30000 'Reminder' "Did you start on vt 1?" ; } &

#/usr/pkg/bin/ion & wmpid=$!
# HANG POINT - wait for window manager to exit
#wait $wmpid
wait "$wmpid"
#wait
