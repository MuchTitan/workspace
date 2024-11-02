# --- Starship (CLI prompt) ---

eval "$(starship init zsh)"

# --- PATH and other Setup ---

. "$HOME/.cargo/env"
export PATH=$PATH:/usr/local/go/bin:~/.local/bin:/snap/bin:~/go/bin:$BUN_INSTALL/bin:$HOME/.pyenv/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --- oh-my-zsh ---

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/plugins/git/git.plugin.zsh
source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh

# --- Homebrew setup ---

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- FZF ---

eval "$(fzf --zsh)"

# --- Use fd instead of fzf ---

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git/fzf-git.sh

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# --- Bat (better cat) ---

export BAT_THEME="Catppuccin Macchiato"
alias cat="bat -p --color=always"

# --- eza (better ls) ---

alias ls="eza --icons=always"
alias ll="eza -alh --icons=always"
alias tree="eza --tree"

# --- Zoxide (better cd) ---

eval "$(zoxide init zsh)"
alias cd="z"

# --- Kubecm (kubeconfig management) ---

[[ ! -f ~/.kubecm ]] || source ~/.kubecm

# --- misc ---

alias lg="lazygit"
alias vim="nvim"
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"
alias k="kubectl"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

if [ ! "$TMUX" ]; then
        tmux attach -t main || tmux new -s main
fi
. "/home/robin/.deno/env"