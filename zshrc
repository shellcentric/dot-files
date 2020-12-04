# ~/.zshrc for macOS and Linux
#
# This file should only be used for an interactive session.
[[ -o interactive ]] || exit 0

# Execute statements in background only if STDERR is bound to a TTY.
# -t fd: true if file descriptor is open and associated with a terminal device.
[[ -t 2 ]] && {
    # On this macOS host, always use localhost as DNS server (dnscrypt).
    if [[ "$OSTYPE" == darwin* ]] && [[ "$(hostname)" == 'c' ]]; then
        networksetup -setdnsservers Wi-Fi 127.0.0.1
    fi
    # >& int: stdio is duplicated from file descriptor number.
} >&2

# Powerline 10K prompt file
file="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[ -r "$file" ] && . "$file"

# Prezto RC file
[ -r "$HOME/.zprezto/init.zsh" ] && . "$HOME/.zprezto/init.zsh"

# Zsh options
autoload -Uz compinit
umask 022
setopt clobber
setopt rmstarsilent
setopt histignorespace

bindkey -v
bindkey "^U" backward-kill-line
bindkey "^R" history-incremental-search-backward

# Functions path array. Do not quote $fpath.
fpath=(/usr/local/share/zsh-completions "$HOME/var/zsh-completions" $fpath)

# Syntax and suggestions 
if [[ "$OSTYPE" == darwin* ]]; then
    file='/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    [ -h "$file" ] && . "$file"

    file='/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    [ -h "$file" ] && . "$file"
else
    file='/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    [ -r "$file" ] && . "$file"

    file='/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    [ -r "$file" ] && . "$file"
fi

unset file

############################################################################# 
# Aliases 
#
if [[ "$OSTYPE" == darwin* ]]; then
    alias brew='arch -x86_64 brew'
    alias c='clearmsg'
    alias edit='subl'
    alias locate='mdfind -name'
    alias sleepn='caffeinate -dims &'
    alias sleepy='killall caffeinate'
    alias ls='ls -F'
    alias l='ls'
    alias ll='ls -lh'
    alias la='ls -A'
    alias lla='ll -A'
    alias lls='ll -S'
    alias llt='ll -t'
    alias lltr='ll -tr'
    alias llz='ll -Z'

    [ -h '/usr/local/bin/lftp' ] && alias ftp='/usr/local/bin/lftp'
    [ -h '/usr/local/sbin/mtr' ] && alias pathping='/usr/local/sbin/mtr'
    [ -h '/usr/local/bin/gtac' ] && alias tac='/usr/local/bin/gtac'
    [ -h '/usr/local/bin/gtac' ] && alias last='last | /usr/local/bin/gtac'
    [ -x '/usr/bin/xcrun'      ] && alias swiftc='/usr/bin/xcrun -sdk macosx /usr/bin/swiftc'
else
    alias ls='ls --group-directories-first --color=auto -p'
    alias l='ls'
    alias ll='ls -lh'
    alias la='ls -A'
    alias lla='ll -A'
    alias lls='ll -S'
    alias llt='ll -t'
    alias lltr='ll -tr'
    alias llz='ll -Z'
fi

alias less='less -Fr'
alias filetree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias wget='wget --hsts-file /dev/null'
alias x='exit'

############################################################################# 
# Aliases for Generic Colouriser (grc)
#
# Remove prezto's grc alias. It conflicts with grc.
if (( $+commands[grc] )); then
    unalias grc &>/dev/null
fi

if [ -x '/usr/bin/grc' ] || [ -h '/usr/local/bin/grc' ]; then
    alias colorize='grc -es --colour=auto'
    alias configure='colorize ./configure'
    alias cvs='colorize cvs'
    alias traceroute='colorize traceroute'
    alias ifconfig='colorize ifconfig'
    alias ldap='colorize ldap'
    alias diff='colorize diff'
    alias make='colorize make'
    alias gcc='colorize gcc'
    alias g++='colorize g++'
    alias as='colorize as'
    alias gas='colorize gas'
    alias ld='colorize ld'
    alias netstat='colorize netstat'
    alias ping='colorize ping'
    alias traceroute='colorize traceroute'
    alias head='colorize head'
    alias tail='colorize tail'
    alias dig='colorize dig'
    alias mount='colorize mount'
    alias ps='colorize ps'
    alias mtr='colorize mtr'
    alias df='colorize df'
fi

############################################################################# 
# Functions
#
if [[ "$OSTYPE" == darwin* ]]; then
    cookies()   { printf 'Finding new cookie files...\n'; km -f; }
    getsn()     { ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}'; }
    listjobs()  { launchctl list | grep "$(hostname)"; }
    mand()      { open dash://manpages:"$1"; }
    manp()      { man -t "$@" | open -f -a Preview; }
    ripa()      { curl -s api.infoip.io/ip 2>/dev/null > "$HOME/.ipa"; }
    rmmeta()    { xattr -c "$1"; }
    getssid()   { /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I  | awk -F' SSID: '  '/ SSID: / {print $2}'; }
    mkramdisk() {
        if [ -z "$1" ]; then
            printf 'Error: function requires a positive integer argument representing megabytes\n'
        elif [ "$1" -ge 0 ] 2>/dev/null; then
            size=$(( 2048 * "$1" ))
            diskutil erasevolume HFS+ "RamDisk" $(hdiutil attach -nomount ram://"$size")
        else
            printf 'Error: function requires a positive integer argument representing megabytes\n'
        fi
    }

    t() {
        if [ -z "$1" ]; then
            printf 'Error: function requires an argument\n'
        else
            grep "$1" /usr/local/etc/mybase.txt >/dev/null
            exit_code="$?"

            if [ "$exit_code" -eq 0 ]; then
                printf 'No. Do not trust this host or domain.\n'
            else
                printf 'Yes. Trust this host or domain.\n'
            fi
        fi
    }

    asltail() {
        /usr/bin/log stream --info --debug --predicate "process == 'syslog'" \
            --predicate "process == 'logger'" \
            --predicate "process == 'blowhole'"
            --style syslog
    }

    aslgrep() {
        if [ -z "$1" ]; then
            printf 'Error: function requires an argument\n'
        else
            /usr/bin/log show --info --debug --predicate "process == 'syslog'" \
                --predicate "process == 'logger'" \
                --predicate "process == 'blowhole'" \
                --predicate "eventMessage contains '$1'"
                --style syslog
        fi
    }

    update_brew() {
        printf 'Updating and cleaning brew...\n'

        if brew update 2>/dev/null; then
            brew upgrade
            brew cleanup
            rm -rf "$(brew --cache)"
        fi
    }

    update_pyci() { python3 -m pip install --user --upgrade pip; python3 -m pip install --user -qU CodeIntel; }

    update_blacklist() {
        src='https://download.dnscrypt.info/blacklists/domains/mybase.txt'
        dst='/usr/local/etc/mybase.txt'

        wget -qO "$dst" "$src" > /dev/null 2>&1
        exit_code="$?"

        if [ "$exit_code" -eq 0 ]; then
            printf 'Updated list of banned domains. Restarting daemon...\n'
            sudo brew services restart dnscrypt-proxy
        else
            printf 'Error downloading list of banned domains.\n'
        fi
    }

    update_repos() {
        printf 'Updating repositories...\n'
        if cd "$HOME/src/repos/bible_databases"; then
            git pull origin master
        fi

        if cd "$HOME/src/repos/ide-stubs"; then
            git pull origin master
        fi
    }

    update_bundles() {
        dir="$HOME/src/websites/shellcentric.com"

        printf 'Updating bundles for shellcentric.com...\n'
        
        if [ -d "$dir" ]; then
            cd "$dir"
            bundle update > /dev/null 2>&1
            exit_code="$?"

            if [ "$exit_code" -eq 0 ]; then
                printf 'Bundle update success: shellcentric.com.\n'
            else
                printf 'Bundle update failure: shellcentric.com. Exit code: %s\n' "$exit_code"
            fi
        else
            printf 'Directory does not exist: %s.\n' "$dir"
        fi
    }

    associations() {
        printf 'Removing old program associations...\n'
        lsregister -kill -r -domain local -domain system -domain user
        killall Finder
    }

    rm_thumbnails() {
        printf 'Removing thumbnail cache...\n'
        target="$TMPDIR/../C/com.apple.QuickLook.thumbnailcache"
        [ -d "$target" ] && rm -rf "$target"
    }

    update() {
        silnite au
        update_brew
        update_repos
        update_bundles
        update_pyci
        update_blacklist
        update_z
        cookies
        printf 'Done.\n'
    }

    backup() {
        volume='/Volumes/Backup'

        (caffeinate -dims &)

        if [ ! -d "$volume" ]; then
            printf 'Backup volume is not available. Is the disk plugged in?\n'
        else
            host='venus'
            printf "Mirroring $host..."
            ping -qc 1 "$host" >/dev/null
            if [ "$?" -eq 0 ]; then
                if [ ! -d "$volume/$host" ]; then
                    mkdir "$volume/$host"
                fi
                printf '\n'
                rsync -avzhe ssh "root@$host:/home" "$volume/$host" --progress --delete
            else
                printf ' offline.\n'
            fi

            host='miyuki'
            printf "Mirroring $host..."
            ping -qc 1 "$host" >/dev/null
            if [ "$?" -eq 0 ]; then
                if [ ! -d "$volume/$host" ]; then
                    mkdir "$volume/$host"
                fi
                printf '\n'
                rsync -avzhe ssh "root@$host:/Users" "$volume/$host" --progress --delete
            else
                printf ' offline.\n'
            fi

            printf 'Cleaning up music and downloads...\n'
            fdupes -Arq ~/Music | grep -E 'mp3|m4a'
            if [ "$?" = 0 ]; then
                printf '\nPlease delete any duplicate files in ~/Music from iTunes Library and disk.\n'
                return 0
            fi

            printf 'Taking a snapshot of local sources...\n'
            file="$HOME/.config/restic/exclude"
            restic -r "$volume/restic" snapshots &>/dev/null
            if [ "$?" -eq 0 ]; then
                restic -r "$volume/restic" --verbose backup ~/         --exclude-file="$file"
                restic -r "$volume/restic" --verbose backup /usr/local --exclude-file="$file"
                restic -r "$volume/restic" --verbose backup /etc/hosts --exclude-file="$file"
                restic forget --keep-last 1 --prune
                diskutil unmountDisk "$volume"
            else
                printf 'Repository does not exist. The error code is %s.\n' "$exit_code"
            fi

        fi

        restic cache --cleanup
        killall caffeinate
    }

    brepos() {
        restic -r "$RESTIC_REPOSITORY" snapshots --group-by host
    }

    brepoc() {
        restic -r "$RESTIC_REPOSITORY" check
    }

    brepoi() {
        restic -r "$RESTIC_REPOSITORY" check --read-data
    }

    restore() {
        if [ -z "$1" ]; then
            printf 'Error: function requires and argument.\n'
            exit 1
        fi

        f="$1"
        restic -r "$RESTIC_REPOSITORY" restore latest --target "$HOME/tmp" --path "$HOME" --include "$f"
    }
else
    mkramdisk() {
        if [ -z "$1" ]; then
            printf 'Error: function requires a positive integer argument representing megabytes\n'
        elif [ "$1" -ge 0 ] 2>/dev/null; then
            dir='/tmp/ramdisk'
            user="$(id -u)"
            group="$(id -g)"
            size=$(( 1048576 * "$1" ))

            mkdir "$dir"
            sudo mount -t tmpfs -o size="$size" ramdisk /tmp/ramdisk
            sudo chown "$user":"$group" "$dir"
            sudo chmod 0700 "$dir"
        else
            printf 'Error: function requires a positive integer argument representing megabytes\n'
        fi
    }
fi

calc()      { bc -l <<< "$@"; }
colors()    { for i in {0..255}; do printf "\x1b[38;5;%smcolor: %s\n" "${i}" "${i}" ; done }
colorout()  { printf '\033[38;2;%s;%s;%s;48;2;%s;%s;%sm%s\e[0m' "$1" "$2" "$3" "$4" "$5" "$6" "$7"; }
manv()      { text=$(man "$@") && printf '%s' "$text" | vim -R +':set ft=man' -; }
sha384sum() { openssl dgst -sha384 -binary < "$1" | openssl base64 -A; }
update_z()  { printf 'Updating zprezto...\n'; zprezto-update; }
clearmsg()  {
    msg=''

    clear

    if [[ "$OSTYPE" == darwin* ]]; then
        ipa=$(ipconfig getifaddr en0)
    else
        ipa="$(hostname -I)"
    fi
    if [ -n "$ipa" ]; then
        msg=$(colorout 50 215 0 0 0 0 "$ipa")
        printf ' Local IPA: %s\n' "$msg"
    else
        msg=$(colorout 247 69 58 0 0 0 'none')
        printf ' Local IPA: %s\n' "$msg"
    fi

    ipa=$(< "$HOME/.ipa")
    if [ -n "$ipa" ]; then
        msg=$(colorout 50 215 0 0 0 0 "$ipa")
        printf 'Remote IPA: %s\n' "$msg"
    else
        msg=$(colorout 247 69 58 0 0 0 "$ipa")
        printf 'Remote IPA: none\n'
    fi

    nameservers=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | tr '\n' ' ')
    printf 'Resolver/s: '
    for ns in "$nameservers"; do
        msg=$(colorout 55 110 229 0 0 0 "$ns ")
    done
    printf '%s\n' "$msg"

    if [[ "$OSTYPE" == darwin* ]]; then
        if pgrep dnscrypt-proxy >/dev/null; then
            msg=$(colorout 50 215 0 0 0 0 'running')
            printf '  DNSCrypt: %s\n' "$msg"
        else
            msg=$(colorout 247 215 0 0 0 0 'not running')
            printf '  DNSCrypt: %s\n' "$msg"
        fi

        jobs=$(launchctl list | grep david | awk -v ORS=' ' -F '.' '{ print $3 }')
        msg=$(colorout 75 75 75 0 0 0 "$jobs")
        printf 'Periodical: %s\n' "$msg"
    fi
}

############################################################################# 
#
# Execute statements in background only if STDERR is bound to a TTY.
# -t fd: true if file descriptor is open and associated with a terminal device.
[[ -t 2 ]] && {
    compinit
    # >& int: stdio is duplicated from file descriptor number.
} >&2

############################################################################# 
# Powerlevel 10K configuration file 
#
[ -f "$HOME/.p10k.zsh" ] && . "$HOME/.p10k.zsh"

# Disable gitstatusd because a binary does not exist for M1 CPU.
# https://github.com/romkatv/gitstatus/issues/73
POWERLEVEL9K_DISABLE_GITSTATUS=true

# Set the list of directories that Zsh searches for programs.
path=(
    /usr/local/bin
    /usr/local/sbin
    /usr/local/opt/ruby/bin
    $HOME/bin
    $HOME/.gem/ruby/2.7.0/bin
    $HOME/Library/Python/3.9/bin
    $path
)

