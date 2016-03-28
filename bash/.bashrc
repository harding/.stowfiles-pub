## DAH ~/.bashrc currently used in multiple Debian and Ubuntu environments
## Contact: Dave Harding <harda@gnuisance.net>

#if [ -f /etc/nologin ]
#then
#    ## Prevent me from ^Cing the startup process
#    trap exit INT
#
#    ## Print nice message
#    echo "/etc/nologin set; you may not log in."
#
#    ## Wait forever
#    read
#
#    ## Exit if I press return
#    exit 1
#fi

# set -x

# Determine hostname.  Use hostname command first since it's a standard,
# but then extract contents of /etc/hostname in case this is a chroot and
# the hostname hasn't been changed.
export HOSTNAME=$( hostname -s )
if [ -s /etc/hostname ]
then
    export HOSTNAME=$( sed -n 's/\..*//;1p' /etc/hostname )
fi


###############
## Variables ##
###############

	##########################
	#-> Internal Variables <-#
	##########################

	## Debugging info ($DEBUG used by bash autocompletion)
	# rm ~/.bash/$$.debug"
	# MYDEBUG="cat >> ~/.bash/$$.debug"
	alias MYDEBUG="cat > /dev/null"

	## Shell Vars
	HISTSIZE=100000
	HISTFILE=~/.bash_history
	SAVEHIST=100000

	## Set Prompt
	#PROMPT_COMMAND="\${T:+sleep 3}"
	#PS1='\h:'\$?\$T':\w\$ '
        function _xps1() {
	    PS1='\[\033]0;[\j jobs] $BASH_COMMAND\007\]'$HOSTNAME':'\$?\$T':\w\$ '
	    PS1='\[\033]0;[\j jobs] IDLE \007\]'$HOSTNAME':'\$?\$T':\w\$ '
	    PS1='\[\033]0;\w \007\]'$HOSTNAME':'\$?\$T':\w\$ '
        }

        function _noxps1() {
	    PS1=$HOSTNAME':'\$?\$T':\w\$ '
        }

	if [ "${DISPLAY:-}" ]
	then
            _xps1
	else
	    _noxps1
	fi

	##########################
	#-> Exported Variables <-#
	##########################

	#-+-+-+-+-+-+-+-+-+-+-+-+#
	#-> Favourite Programs <-#
	#-+-+-+-+-+-+-+-+-+-+-+-+#

	export PAGER='/usr/bin/less'

	if [ -x /home/harding/bin/dheditor ]
	then
		export EDITOR=dheditor
		#alias vi='/usr/bin/nvi'
	else
		export EDITOR=vi
		#echo "Install nvi" | $MYDEBUG
	fi

	#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#
	#-> Single-Program Variables <-#
	#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-#

	## For Quintuple Agent -- (hack)
	export AGENT_SOCKET='/tmp/quintuple-agent-1000.0/agent-socket'
	## For git per git-config(1) 2009-08-29
	export EMAIL="dave@dtrt.org"

###############
## FUNCTIONS ##
###############

	#-+-+-+-+-+-+-+-+-+-+-+-+#
	#-> Bash Functionality <-#
	#-+-+-+-+-+-+-+-+-+-+-+-+#
	## Source functions to change the xterm titles for certain commands
	#if [ -f ~/.bash/xtitle ]
	#then
	#	. $HOME/.bash/xtitle
	#else
	#	echo "Install bash/xtitle" | $MYDEBUG
	#fi

	## Enable bash auto-completion
	if [ -f /etc/bash_completion ]
	then
		. /etc/bash_completion
	else
		echo "Install /etc/bash_completion" | $MYDEBUG
	fi

	alias km="keep-mtime"

	function editvc() {
		vorbiscomment -l "$1" > "$1.comment"
		nvi "$1.comment"
		vorbiscomment -w -c "$1.comment" "$1"
		rm "$1.comment"
		}

#############
## ALIASES ##
#############

	#-+-+-+-+-+-+-+-+-+-+-#
	#-> Dumb Me Aliases <-#
	#-+-+-+-+-+-+-+-+-+-+-#
	alias suod=sl
	alias :w=sl

#############
## ACTIONS ##
#############

	## Checks
	# screen sessions
	if [ -x /usr/bin/screen -a -z "$WARNONSCREEN" ]
	then
		screen -q -ls
		if [ "$?" -ge 10 -a "$TERM" != screen ]
		then
			: #echo "There is a screen session running"
		fi
	else
		echo "Install screen" | $MYDEBUG
	fi

	## On Exit
	function _exit()
	{
		if [ -x /usr/bin/sudo ]
		then
			: # sudo -k
		else
			echo "Install sudo" | $MYDEBUG
		fi
	}
	trap _exit 0

function use() {
	. "$HOME/lib/bash/$1"
	}

###############
## REFERENCE ##
###############

BASH_ENVIRONMENT_SETTINGS=~/.bash/env
if [ -f $BASH_ENVIRONMENT_SETTINGS ]
then
    . $BASH_ENVIRONMENT_SETTINGS
    export BASH_ENV=$BASH_ENVIRONMENT_SETTINGS
fi

_is_shell_interactive() {
    if [ $TERM == dumb ]
    then
	return 1
    else
	return 0
    fi
}

## # Stuff to do if we have a todo list on this computer
## if [ -f .todo.cfg ]
## then
##     TODO_DIR="$HOME/var/git/todo"
##     # Your todo/done/report.txt locations
##     export TODO_FILE="$TODO_DIR/$(date +%Y-%m-%d).txt"
##     DONE_FILE="$TODO_DIR/done.txt"
##     SOMEDAY_FILE="$TODO_DIR/someday.txt"
##     REPORT_FILE="$TODO_DIR/report.txt"
##     TMP_FILE="$TODO_DIR/todo.tmp"
##
##     #alias t="todo.sh -a -+ -@ -P"
##     #te() { vi ${1:++}$1 $TODO_FILE ; }
##     #alias td="nvi $DONE_FILE"
##     #alias tes="nvi $SOMEDAY_FILE"
##     #alias tbe="birdseye.py $TODO_FILE $DONE_FILE"
##     if [ -f .bash/todo_completer.sh ]
##     then
## 	. .bash/todo_completer.sh
##     fi
##     #complete -F _todo_sh -o default t
##     #_is_shell_interactive && validate-projects || T=":FIX TODO ERRORS"
##
##     alias remedit.todo="$EDITOR var/unison/doc/remind/todo_schedule.remind"
## fi

alias editcron="$EDITOR ~/etc/cron/$USER/$HOSTNAME && loadcron"
alias editanacron="$EDITOR ~/etc/anacron/$USER/$HOSTNAME"

## Keep this section near end to avoid changing titles a million times
## during bash startup.
case $TERM in
     rxvt|xterm|rxvt-unicode|screen)
	## functrace "exports" the DEBUG trap below. This seems like a
	## good idea until your simple shell scripts start taking
	## forever to run.
	#set -o functrace

	## The DEBUG trap is run before every command.
	#
	## BASH_COMMAND contains the name of the program to be run.
	#trap 'echo -ne "\e]0;$BASH_COMMAND\007"' DEBUG
     ;;
esac

if [ -x /usr/bin/wcd.exec ]
then
    wd() {
	if [ "${1:-}" ]
	then
	    wcd.exec -z 50 "$@"
	else
	    wcd.exec -z 50 =
	fi

	. $HOME/bin/wcd.go
	wcd_stack=$HOME/.stack.wcd
	#sort -u $wcd_stack | sponge $wcd_stack

	if [ -f ._todo ]
	then
	    echo "TODO"
	    cat ._todo
	    sleep .5
	    read
	fi

    }
fi

## LOCAL BASHRC ##
LOCALRC=$HOME/.bash/${HOSTNAME}rc
if [ -f $LOCALRC ]
then
	. $LOCALRC
fi

## My version of t (todo.sh) wraps long lines before piping to less
t() { COLUMNS=$COLUMNS command t "$@" ; }

## Always start in my home directory
cd

set +x

if [ -d $HOME/.rvm ]
then
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

export LESS=-i

## Workaround for https://github.com/mobile-shell/mosh/issues/178 2015-10-31
if [ "${SSH_CONNECTION:-nil}" != nil -a ${TERM:-nil} == xterm ]
then
  export TERM=rxvt-unicode
fi
