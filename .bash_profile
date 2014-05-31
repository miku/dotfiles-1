# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# use gnu coreutils
[ -d /usr/local/opt/coreutils/libexec/gnubin ] && export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

if [ "$TERM" != "dumb" ]; then
    # export LS_OPTIONS='--color=auto'
    eval `dircolors ~/.dir_colors`
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra,python}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Homebrew version ofbash completion
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

# rupa/z
[ -f "$HOME/Code/rupa/z/z.sh" ] && source "$HOME/Code/rupa/z/z.sh"

# rbenv
if which rbenv 1> /dev/null; then eval "$(rbenv init -)"; fi

# Go
export PATH=${PATH}:/usr/local/opt/go/libexec/bin

# Elasticsearch
function escat() {
    INDEXCAT="curl -sL localhost:9200/_cat/indices"
    if [ $# -eq 0 ]; then
         $INDEXCAT|sort -k2
    else
        case $1 in
            -s) $INDEXCAT|sort -nrk 5; shift 1;;
            -S) $INDEXCAT|sort -nrk 5; shift 1;;
            -n) $INDEXCAT|sort -k 2; shift 1;;
            -t) $INDEXCAT|sort -k 1; shift 1;;
            *) shift 1;;
        esac
    fi
}

function estop() {
    clear
    while true; do escat "$@"; sleep 2; clear; done
}

