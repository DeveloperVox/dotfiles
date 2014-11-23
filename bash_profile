[[ -r ~/.bashrc ]] && . ~/.bashrc

source /usr/local/etc/bash_completion.d/password-store
source ~/.bash_secrets

alias ls='ls -alG'
alias ll='ls -hl'
alias flushdns='sudo dscacheutil -flushcache'
alias ec='/usr/local/bin/emacsclient -n'
alias E="SUDO_EDITOR=\"emacsclient\" sudo -e"

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PATH=/usr/local/git/bin:/Users/raam/bin:$PATH
export EDITOR=/usr/local/bin/emacs
export MAMP_PHP=/Applications/MAMP/bin/php/php5.4.10/bin
export PATH="$MAMP_PHP:$PATH"

#if [ -f ~/bin/wp-completion.bash ]; then
#        source ~/bin/wp-completion.bash
#fi
if [ -f ~/bin/pass.bash-completion ]; then
        source ~/bin/pass.bash-completion
fi

prompt_command () {
if [ -f ~/bin/.git-completion.sh ]; then
        source ~/bin/.git-completion.sh
fi
if [ -f ~/bin/.git-prompt.sh ]; then
        source ~/bin/.git-prompt.sh
fi
    local LOAD=`uptime|awk '{min=NF-2;print $min}'`
    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local BCYAN="\[\033[1;36m\]"
    local BLUE="\[\033[0;34m\]"
    local GRAY="\[\033[0;37m\]"
    local DKGRAY="\[\033[1;30m\]"
    local WHITE="\[\033[1;37m\]"
    local RED="\[\033[0;31m\]"
    # return color to Terminal setting for text color
    local DEFAULT="\[\033[0;39m\]"
    # set the titlebar to the current path
    local TITLEBAR='\[\e]2;`pwd`\a'
    export PS1="\[${TITLEBAR}\]${GREEN}[${DEFAULT}\W/${RED}$(__git_ps1)${GREEN}] $ ${DEFAULT}"
    # Keep it simple if running in emacs.
    case "$TERM" in
      eterm-color)
        PROMPT_COMMAND=
        PS1="\u@\h:\W$ "
    esac
}
PROMPT_COMMAND=prompt_command
 
pwdtail () { #returns the last 2 fields of the working directory
    pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}
