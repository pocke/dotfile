# Created by newuser for 5.0.2

#setopt correct
setopt list_packed    #補完を詰める
setopt globdots    #ドットファイルを*で選択する
setopt noautoremoveslash    #パスの最後のスラッシュを削除しない
export EDITOR=vim
setopt mark_dirs # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt print_eight_bit #日本語ファイル名等8ビットを通す
setopt extended_glob

disable r

### compinit

autoload -U compinit
compinit
setopt auto_param_slash # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt magic_equal_subst    # = 以降でも補完
#  補完の際(大|小)文字を区別しない,ドットの直前を*に置き換えて補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} l:|=.'
# 補完メッセージを読みやすくする
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
# 矢印とかで移動
#zstyle ':completion:*:default' menu select=1

# syntax highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi

setopt complete_aliases
### alias
alias ls="ls --color=auto -F"
alias la="ls -A"
alias ll="ls -l"
alias lla='ls -Al'
alias df="df -h"
alias du='du -h'
alias cp='cp -v'
alias mv='mv -v'
alias vi='vim'
which yaourt > /dev/null 2>&1 && alias yao='yaourt -Syua'
### global alias
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g C='| xsel --input --clipboard'
alias -g N='> /dev/null 2>&1'
alias -g ALL='**/*~.git/*~*/.git/*(.)'
### suffix alias
function extract() {
  local tmp_dir="$(mktemp -d)"
  local zip_file_name="$(basename "$1")"
  case $1 in
    (*.tar.gz)
      local command='tar xzvf'
      local suffix='.tar.gz' ;;
    (*.tgz)
      local command='tar xzvf'
      local suffix='.tgz' ;;
    (*.tar.xz)
      local command='tar Jxvf'
      local suffix='.tar.xz' ;;
    (*.zip)
      local command='unzip'
      local suffix='.zip' ;;
    (*.lzh)
      local command='lha e'
      local suffix='.lzh' ;;
    (*.tar.bz2)
      local command='tar xjvf'
      local suffix='.tar.bz2' ;;
    (*.tbz)
      local command='tar xjvf'
      local suffix='.tbz' ;;
    (*.tar.Z)
      local command='tar zxvf'
      local suffix='.tar.Z' ;;
    (*.gz)
      local command='gzip -dc'
      local suffix='.gz' ;;
    (*.bz2)
      local command='bzip2 -dc'
      local suffix='.bz2' ;;
    (*.Z)
      local command='uncompress'
      local suffix='.Z' ;;
    (*.tar)
      local command='tar xvf'
      local suffix='.tar' ;;
    (*.arj)
      local command='unarj'
      local suffix='.arg' ;;
  esac
  'cp' "$1" "${tmp_dir}"
  (
    cd "${tmp_dir}"
    eval "${command} ${zip_file_name}"
    rm "${zip_file_name}"
  )
  if [[ "$(ls "${tmp_dir}" | wc -l)" == '1' && "$(ls -F "${tmp_dir}" | grep '/' | wc -l)" == '1' ]]; then
    'cp' "${tmp_dir}/"* ./ -R
  else
    local d="$(basename "${zip_file_name}" "${suffix}")"
    mkdir "${d}"
    'cp' "${tmp_dir}/"* "${d}" -R
  fi
  rm -rf "${tmp_dir}"
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract
alias -s rb=ruby

### cd
setopt auto_cd
setopt auto_pushd
function chpwd() { ls }
setopt pushd_ignore_dups

### prompt
# git branch
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '*** branch: %b'
zstyle ':vcs_info:*' actionformats '*** branch: %b / %a'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
prompt_git='%B%1(v|%F{cyan}%1v
%f|)'

# default
prompt_exit_status="(%(?.%F{green}%?%f.%F{red}%?%f))"
PROMPT="%B${prompt_git}%F{cyan}%n%f[%F{cyan}INS%f]${prompt_exit_status} %#%b "
RPROMPT='%B( %F{magenta}%~%f )Oo%b'

# vim keybind mode
function zle-line-init zle-keymap-select {
  local vim_mode='%F{cyan}INS%f'
  if [ "${KEYMAP}" = 'vicmd' ]; then
    vim_mode='%F{red}NOR%f'
  fi
  PROMPT="%B${prompt_git}%F{cyan}%n%f[${vim_mode}]${prompt_exit_status} %#%b "
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

### history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_space      # スペースからはじまるものをヒストリに登録しない
setopt hist_no_store
setopt share_history

### keybind
bindkey -v
bindkey "[Z" reverse-menu-complete    # Shift-Tabで補完を逆順
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey 'OH' beginning-of-line        # Homeキーがうまく効かないのを修正
bindkey 'OF' end-of-line              # Endキーがうまく効かないのを修正
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char

### color
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

#コマンドスタック
show_buffer_stack() {
  POSTDISPLAY="
  stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack
setopt noflowcontrol
bindkey '^Q' show_buffer_stack

# function
function take()
{
  if [[ -d $1 ]]; then
    cd $1 && echo -e "\e[1;35m***\e[m\e[1;34m$1\e[m already exists. cd to it"
  else
    mkdir -p $1 && cd $1 && echo -e "\e[1;35m***\e[mCreated \e[1;34m$1\e[m and cd to it"
  fi
}

# コマンドラインが空の場合、Enterで補完を更新する。
function _rehash()
{
  zle accept-line  # accept-line がデフォルトのEnterに割り当てられている
  if [[ -z "$BUFFER" ]]; then
    rehash
  fi
}
zle -N _rehash
bindkey "\C-m" _rehash
