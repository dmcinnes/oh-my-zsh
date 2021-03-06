# # Translated from http://gist.github.com/31934
# autoload -U colors
# colors
# setopt prompt_subst

parse_git_branch() {
  # git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="On branch ([[:alnum:]/_-]*)"
  nobranch_pattern="HEAD detached at"
  remote_pattern="Your branch is ([^ ]*)"
  diverge_pattern="Your branch and (.*) have diverged"
  if [[ ! ${git_status} =~ "nothing to commit" ]]; then
    local state="%{$fg[yellow]%}*"
  fi

  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    case ${match[1]} in
    "ahead")  remote="%{$fg[yellow]%}↑" ;;
    "behind") remote="%{$fg[yellow]%}↓" ;;
    esac
  else
    remote=""
  fi

  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="%{$fg[yellow]%}↕"
  fi

  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${match[1]}
    echo " (${branch})${remote}${state}"
  else
    if [[ %{git_status} =~ ${nobranch_pattern} ]]; then
      echo " (NOBRANCH)"
    fi
  fi
}

cloud_display() {
  if [[ ${HEROKU_CLOUD} != 'production' && ${HEROKU_CLOUD} != '' ]]; then
    echo "%{$fg[blue]%}[%{$fg[cyan]%}${HEROKU_CLOUD:u}%{$fg[blue]%}] "
  fi
}

PROMPT='$(cloud_display)%{$fg[green]%}%~%{$fg[magenta]%}$(parse_git_branch)%{$reset_color%}%(?. $. %{$fg[red]%}$%{$reset_color%}) '
# RPROMPT=%T
