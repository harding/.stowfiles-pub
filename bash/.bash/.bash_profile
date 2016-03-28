# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

#exec 2> ~/bash-debug
#set -xv

umask 022

keychain 2> /dev/null

## Start signify, the random .signature generator:
#if [ ! $(pgrep signify > /dev/null) ]
#then
#	signify --fifo=$HOME/.signature &
#fi

## include .bashrc if it exists
if [ -f ~/.bashrc ]
then
	. ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
#if [ -d ~/bin ] ; then
#    PATH=~/bin:"${PATH}"
#fi

# do the same with MANPATH
#if [ -d ~/man ]; then
#    MANPATH=~/man:"${MANPATH}"
#fi

