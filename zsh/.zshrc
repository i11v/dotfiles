# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enables zsh-autocomplete plugin
if [[ -r "$HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  source "$HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/ilnur.khalilov/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# zsh-autocomplete configuration
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
#bindkey -M menuselect '\r' .accept-line

# User configuration
export NODE_OPTIONS=--max_old_space_size=4096

export EDITOR="nvim"

export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"
export JAVA_HOME=$(/usr/libexec/java_home)
export PYENV_ROOT="$HOME/.pyenv"

#export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

export TERM="xterm-256color"

# Bat default theme
export BAT_THEME="GitHub"

# Git
inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

get_current_branch(){
	git symbolic-ref --short HEAD
}

# Workday
get_jira_id(){
	get_current_branch | sed 's/^\(STORIES-[0-9]*\).*/\1/'
}

# Detect Dark Mode
if [[ "$(uname -s)" == "Darwin" ]]; then
	toggle_theme() {
		if [[ $SYSTEM_APPEARANCE == "Dark" ]]; then
			sed -i '' -e 's/github_light/solarized_dark/' ~/.config/alacritty/alacritty.toml
		else
			sed -i '' -e 's/solarized_dark/github_light/' ~/.config/alacritty/alacritty.toml
		fi
	}

	detect_dark_mode() {
		val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
		if [[ $val == "Dark" ]]; then
			export SYSTEM_APPEARANCE="Dark"
				else
						export SYSTEM_APPEARANCE="Light"
		fi
	}

	detect_dark_mode
		toggle_theme
fi

# Shortcuts
export CLOUD_DOCS="/Users/ilnur.khalilov/Library/Mobile Documents/com~apple~CloudDocs"

# export MANPATH="/usr/local/man:$MANPATH"

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.jenv/bin:/usr/local/bin/pyenv:/usr/local/sbin:/usr/local/bin:/usr/local/opt/curl/bin:$PATH"

# Using node from fnm
export PATH="$HOME/.fnm:$PATH"
eval "`fnm env --use-on-cd`"

# Gradle
export GRADLE_HOME="/usr/local/bin/gradle/gradle-8.6"
export PATH="$GRADLE_HOME/bin:$PATH"

eval "$(starship init zsh)"
eval "$(jenv init -)"
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
		. "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
	else
		export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# bun completions
[ -s "/Users/ilnur.khalilov/.bun/_bun" ] && source "/Users/ilnur.khalilov/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# 1Password CLI
source /Users/ilnur.khalilov/.config/op/plugins.sh

