# Vibrant Theme for Oh My Zsh
# A colorful and modern terminal theme with bright colors
# Features: Git status, Conda environment, no username/hostname
# Author: zzy
# Version: 1.0

# Set prompt options
setopt PROMPT_SUBST

# Disable conda's default prompt modification, use custom one
export CONDA_CHANGEPS1=false

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
