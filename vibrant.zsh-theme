# Vibrant Theme for Oh My Zsh
# A colorful and modern terminal theme with bright colors
# Features: Git status, Conda environment, no username/hostname
# Author: zzy
# Version: 1.0

# Set prompt options
setopt PROMPT_SUBST

# Disable conda's default prompt modification, use custom one
export CONDA_CHANGEPS1=false

# Initialize path cache array (stores up to 10 recent paths)
typeset -a VIBRANT_PATH_CACHE
VIBRANT_PATH_CACHE=()

# Function to add current directory to path cache
add_to_path_cache() {
    local current_dir="$PWD"
    
    # Remove current directory from cache if it already exists
    VIBRANT_PATH_CACHE=(${VIBRANT_PATH_CACHE:#$current_dir})
    
    # Add current directory to the beginning of cache
    VIBRANT_PATH_CACHE=("$current_dir" "${VIBRANT_PATH_CACHE[@]}")
    
    # Keep only the last 10 directories
    if [[ ${#VIBRANT_PATH_CACHE[@]} -gt 10 ]]; then
        VIBRANT_PATH_CACHE=("${VIBRANT_PATH_CACHE[@]:0:10}")
    fi
}

# Enhanced cd function
cd() {
    local target_dir
    
    # Handle numeric arguments like cd -1, cd -2, etc.
    if [[ $1 =~ ^-[0-9]+$ ]]; then
        local index=${1#-}
        if [[ $index -gt 0 && $index -le ${#VIBRANT_PATH_CACHE[@]} ]]; then
            target_dir="${VIBRANT_PATH_CACHE[$index]}"
            echo "Switching to: $target_dir"
        else
            echo "Error: Invalid index $1. Available range: -1 to -${#VIBRANT_PATH_CACHE[@]}"
            return 1
        fi
    elif [[ $1 == "--list" || $1 == "-l" ]]; then
        # List cached paths
        echo "Recent paths:"
        for i in {1..${#VIBRANT_PATH_CACHE[@]}}; do
            echo "  -$i: ${VIBRANT_PATH_CACHE[$i]}"
        done
        return 0
    else
        target_dir="$1"
    fi
    
    # Use builtin cd
    builtin cd "$target_dir"
    local cd_result=$?
    
    # Add to cache only if cd was successful
    if [[ $cd_result -eq 0 ]]; then
        add_to_path_cache
    fi
    
    return $cd_result
}

# Auto-completion function for cd command
_cd_path_cache() {
    local context state line
    local -a cached_paths
    
    # Generate completion options based on current input
    if [[ $words[CURRENT] == -* ]]; then
        # If user typed cd -, show numbered options
        for i in {1..${#VIBRANT_PATH_CACHE[@]}}; do
            cached_paths+=("-$i:${VIBRANT_PATH_CACHE[$i]}")
        done
        
        _describe -t cached-paths 'Recent paths' cached_paths
    else
        # Default cd completion (directories)
        _path_files -/
    fi
}

# Register the completion function
compdef _cd_path_cache cd

# Enable menu selection for better navigation
zstyle ':completion:*' menu select
zstyle ':completion:*:cached-paths:*' format '%F{cyan}Recent paths:%f'
zstyle ':completion:*:cached-paths:*' group-name cached-paths

# Define Git status function
git_prompt_info() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local branch
        local git_status=""
        
        # First try to get branch name
        branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        
        if [[ -z $branch ]]; then
            # If no branch, display commit hash and relative position
            local commit_hash=$(git rev-parse --short HEAD 2>/dev/null)
            local head_info=$(git describe --contains --all HEAD 2>/dev/null)
            
            if [[ -n $commit_hash ]]; then
                if [[ -n $head_info ]]; then
                    branch="detached:$commit_hash~$head_info"
                else
                    branch="detached:$commit_hash"
                fi
            else
                branch="unknown"
            fi
        fi
        
        # Check if there are uncommitted changes
        if ! git diff --quiet HEAD 2>/dev/null; then
            git_status="%F{196}*%f"  # Bright red
        elif ! git diff --cached --quiet 2>/dev/null; then
            git_status="%F{226}+%f"  # Bright yellow
        fi
        
        # Use different bright colors for different states
        if [[ $branch == detached:* ]]; then
            # Detached state: bright purple brackets, bright red detached, bright blue commit info
            echo " %F{201}(%F{196}detached:%F{39}${branch#detached:}%F{201})%f$git_status"
        else
            # Normal branch: bright purple brackets, bright green branch name
            echo " %F{201}(%F{46}$branch%F{201})%f$git_status"
        fi
    fi
}

# Define Conda environment display function
conda_prompt_info() {
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
        if [[ $CONDA_DEFAULT_ENV != "base" ]]; then
            # Non-base environment highlighted in bright red
            echo "%F{196}($CONDA_DEFAULT_ENV)%f "
        else
            # Base environment also in bright red, but slightly dimmer
            echo "%F{124}($CONDA_DEFAULT_ENV)%f "
        fi
    fi
}

# Define time display function
time_prompt_info() {
    echo "%F{247}[%D{%Y-%m-%d %H:%M:%S}]%f"
}

# Main prompt configuration
PROMPT='$(conda_prompt_info)%F{51}%~%f$(git_prompt_info) $(time_prompt_info)
%F{82}❯%f '

# Disable right prompt
RPROMPT=''
