# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git django brew celery fabric osx pip redis-cli web-search)

# User configuration

export GOPATH=$HOME/go
export PATH="/usr/local/Cellar/vim/8.0.0535/bin:$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.rbenv/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin/:/Applications/activator-dist-1.3.5:/usr/local/opt/kafka/bin/:/usr/local/go/bin:$GOPATH/bin:$HOME/.jenv/bin"
# export MANPATH="/usr/local/man:$MANPATH"

#export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
export EDITOR='mvim'
export SHELL='/bin/zsh'

source $ZSH/oh-my-zsh.sh

# Virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dimagi
source /usr/local/bin/virtualenvwrapper.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function delete-pyc() {
    find . -name '*.pyc' -delete
}
function pull-latest-master() {
    git checkout master; git pull origin master
    git submodule update --init
    git submodule foreach --recursive 'git checkout master; git pull origin master &'
    until [ -z "$(ps aux | grep '[g]it pull')" ]; do sleep 1; done
}
function update-code() {
    pull-latest-master
    delete-pyc
}
function show-branches() {
    for BRANCH in `git branch | grep -v '\\*'`
    do
        echo $(git show --no-patch $BRANCH\
        --pretty="
            %C(magenta)%ad
            %C(blue)%an
            %C(reset)<name>
            %C(yellow)%s
            %C(red)%d
            %C(reset)
        ") | sed "s|<name>|$BRANCH -|g"
    done
}

alias rahul="sudo openconnect --no-dtls -c /Users/benrudolph/nic-vpn/cert.pem -k /Users/benrudolph/nic-vpn/key.pem sconnect.nic.in"
alias umesh="sudo openconnect --no-dtls -c /Users/benrudolph/nic-vpn/umesh-cert.pem -k /Users/benrudolph/nic-vpn/umesh-key.pem sconnect.nic.in"
# Django stuff
alias dj="python manage.py"
alias djrun="python manage.py runserver"
alias dimagi-gpg="gpg --keyring dimagi.gpg --no-default-keyring"

alias cl="clear && ls"
alias u="cd ../"
alias p="pull-latest-master"

alias hqkill="tmux kill-session -t cchq"
alias zoo-start="zookeeper-server-start.sh /usr/local/opt/kafka/libexec/config/zookeeper.properties"
alias kafka-start="kafka-server-start.sh /usr/local/opt/kafka/libexec/config/server.properties"

# alias tags="ctags -R -f ./.git/tags ."

# Programs
alias we='workon commcare-hq && source ~/venv'
alias wcc='workon captain && source ~/.captain_venv && cd ~/Dimagi/captain'
alias wb='workon brain && cd ~/Dimagi/brain'
alias hqstart='tmuxinator start cchq'

alias open_ehead='http://localhost:9200/_plugin/head/'
alias ch='cd ~/Dimagi/commcare-hq'
alias ca='cd ~/Dimagi/commcarehq-ansible'
alias tf='cd ~/Dimagi/commcare-hq/submodules/touchforms-src/touchforms'
alias list-branches='for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r'

# Git
function gcn {
  git checkout -b br/$1
}

export ES_HEAP_SIZE=10g

eval "$(rbenv init -)"
eval "$(jenv init -)"

## Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/Users/benrudolph/riak/riak-cs-2.0.1/bin:/Users/benrudolph/riak/stanchion-2.0.0/bin:$PATH"
export PERL5LIB=/Users/benrudolph/perl5/lib/perl5/darwin-thread-multi-2level
export NVM_DIR=~/.nvm

source $(brew --prefix nvm)/nvm.sh
nvm use stable

function djlog {
    for n in 3 4 5; 
        do ssh hqdjango$n.internal.commcarehq.org 'echo; echo "On $(hostname):"; grep $(1) /home/cchq/www/production/log/';
    done
}

function vpn-connect {
/usr/bin/env osascript <<-EOF
tell application "System Events"
        tell current location of network preferences
                set VPN to service "DimagiVPN" -- your VPN name here
                if exists VPN then connect VPN
                repeat while (current configuration of VPN is not connected)
                    delay 1
                end repeat
        end tell
end tell
EOF
}

function vpn-connect-va {
/usr/bin/env osascript <<-EOF
tell application "System Events"
        tell current location of network preferences
                set VPN to service "DimagiVPN - VA" -- your VPN name here
                if exists VPN then connect VPN
                repeat while (current configuration of VPN is not connected)
                    delay 1
                end repeat
        end tell
end tell
EOF
}

function vpn-disconnect {
/usr/bin/env osascript <<-EOF
tell application "System Events"
        tell current location of network preferences
                set VPN to service "DimagiVPN" -- your VPN name here
                if exists VPN then disconnect VPN
        end tell
end tell
return
EOF
}

archey -c

# PERL_MB_OPT="--install_base \"/Users/benrudolph/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/Users/benrudolph/perl5"; export PERL_MM_OPT;
source ~/perl5/perlbrew/etc/bashrc

function list_prs() {
  git log $1 --grep 'Merge pull request #' |
    grep -Eo 'Merge pull request #\d+' |
    grep -Eo '\d+' |
    xargs -I % sh -c '
      curl -H "authToken: ad42886b0466d9c918f8b68d11229213ce08ef41" --silent https://api.github.com/repos/dimagi/commcare-hq/pulls/% |
      jsawk "out('\''#'\'' + this.number + '\'' '\'' + this.title + '\'' @'\'' + this.user.login); return"
    '
}


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
source '/Users/benrudolph/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/benrudolph/google-cloud-sdk/completion.zsh.inc'
