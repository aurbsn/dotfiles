local ret_status="%(?:%{$fg_bold[cyan]%}- :%{$fg_bold[yellow]%}X )"
PROMPT='${ret_status} %{$fg[blue]%}%c%{$reset_color%} $(git_prompt_info)%{$fg[red]%}$ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}git:(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%})"