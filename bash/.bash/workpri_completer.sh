#have todo &&
_workpri() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMMANDS="""
	delay
	do
	edit
	editall
	editstate
	edittwenty
	editvelocities
	hourcheck
	hourgraph
	undo
	unvacation
	vacation
    """


    #OPTS="-@ -@@ -+ -d -f -h -p -P -a -n -t -v -vv -V"

    if [ $COMP_CWORD -le 1 ]
    then
	completions="$COMMANDS"
    else
	completions=$( workpri lsj )
    fi

    COMPREPLY=( $( compgen -W "$completions" -- $cur ))
    return 0
}
#[ -n "${have:-}" ] && complete -F _todo $filename todo

complete -F _workpri workpri
complete -F _workpri -o default wp
