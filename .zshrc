# Prompts
autoload -Uz colors && colors
autoload -Uz promptinit && promptinit
PROMPT="%n@%{$fg_bold[cyan]%}%m%{$reset_color%}> "
RPROMPT="%{$fg[green]%}%~ %{$fg[yellow]%}[%W %*]%{$reset_color%}"

# Aliases
alias 'ls'='ls --color'
alias 'l'='ls'
alias 'la'='ls -a'
