# --- Starship (CLI prompt) ---

eval "$(starship init zsh)"

# --- PATH ---

export PATH=$PATH:/usr/local/go/bin:~/.local/bin:/snap/bin:~/go/bin

# --- oh-my-zsh ---

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/plugins/git/git.plugin.zsh
source $ZSH/oh-my-zsh.sh

# --- FZF ---

source $HOME/.fzf.zsh

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
alias cat="batcat -p --color=always"

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
export EDITOR=nvim
