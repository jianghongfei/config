# Set up the prompt

autoload -Uz promptinit
promptinit
prompt walters

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit


# alias

alias ls='ls -F --color=auto' 
alias ll='ls -lh'
alias grep='grep --color=auto' 

# end alias


