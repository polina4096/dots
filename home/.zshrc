# History
HISTFILE=~/.local/zsh_history
HISTSIZE=100
SAVEHIST=10000

# I don't like beeps
unsetopt beep

# Ctrl + {Left, Right}
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Useful aliases
alias ls="exa -l --group-directories-first"
alias zsnaps="zfs list -t snapshot | grep -vE \"(legacy)|(8K)\""
alias zls="zfs list | grep -vE \"(legacy)\""

# Shell prompt
PROMPT='Полина %F{12}%~%f %F{yellow}✝%f '

# Interactive xbps-install tui
xs () 
{
    xpkg -a | fzf -m --preview 'xq {1}' --preview-window=right:66%:wrap | xargs -ro xi
}