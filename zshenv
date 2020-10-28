# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    . "${ZDOTDIR:-$HOME}/.zprofile"
fi

[ -z "$LANG" ] && export LANG='en_US.UTF-8'

# Set the list of directories that Zsh searches for programs.
path=(
    /usr/local/{bin,sbin}
    /usr/local/opt/ruby/bin
    $HOME/bin
    $HOME/.gem/ruby/2.7.0/bin
    $HOME/Library/Python/3.7/bin
    $HOME/Library/Python/3.8/bin
    $path
)

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# LSCOLORS
#
# lowercase = normal, uppercase = bold or bright
# aA black / bB red / cC green / dD brown / eE blue / fF magenta / gG cyan / hH grey
# x default foreground or background
#
# Order
#  1. directory
#  2. symbolic link
#  3. socket
#  4. pipe
#  5. executable
#  6. block special
#  7. character special
#  8. executable with setuid bit set
#  9. executable with setgid bit set
# 10. directory writable to others, with sticky bit
# 11. directory writable to others, without sticky bit
#
# Linux:
# export LS_COLORS='di=33:ln=35:so=36:pi=34:ex=32:bd=37:cd=01;37:su=01;31:sg=31:tw=01;31:ow=31'
if [[ "$OSTYPE" == darwin* ]]; then
	export CLICOLOR='1'
	export LSCOLORS='dxfxgxexcxhxHxBxbxBxbx'
	export PASSWORD_STORE_DIR="$HOME/.config/password-store"
	export PASSWORD_STORE_KEY="$(cat $HOME/.config/password_store_key)"
	export PASSWORD_STORE_GENERATED_LENGTH='30'
	export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(/usr/local/bin/brew --prefix openssl@1.1)"
	export HOMEBREW_NO_ANALYTICS='1'
	export RESTIC_REPOSITORY='/Volumes/Backup/restic'
	export RESTIC_PASSWORD_FILE="$HOME/.config/restic/password"
	export BROWSER='open'
	export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
else
	export LS_COLORS='di=33:ln=35:so=36:pi=34:ex=32:bd=37:cd=01;37:su=01;31:sg=31:tw=01;31:ow=31'
	export LESSOPEN="|/usr/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
fi

export RSYNC_IGNORE_FILE="$HOME/.config/rsync-backup-exclude"
export SHELLCHECK_OPTS='--exclude=SC1090 --exclude=SC2181'
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
export LESSHISTFILE="-"
