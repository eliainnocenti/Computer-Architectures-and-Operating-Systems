#!/bin/zsh

# 
source urls.txt

# Function to check and create directory if it doesn't exist
check_and_create_dir() {
    if [[ ! -d "$1" ]]; then
        echo "Creating directory: $1"
        mkdir -p "$1"
    else
        echo "Directory already exists: $1"
    fi
}

# Function to clone or pull a repository
clone_or_pull() {
    local repo_url=$1
    local target_dir=$2
    local custom_name=$3 # Custom name for the directory, if provided
    
    local repo_name=$(basename "$repo_url" .git)
    local final_name
    
    # Use custom name if given, otherwise default to repo_name
    if [[ -n "$custom_name" ]]; then
        final_name="$custom_name"
    else
        final_name="$repo_name"
    fi
    
    local full_path="$target_dir/$final_name"
    
    if [[ -d "$full_path" ]]; then
        echo "Repository $final_name already exists. Pulling latest changes..."
        (cd "$full_path" && git pull origin main || git pull origin master)
    else
        echo "Cloning $final_name into $target_dir"
        git submodule add "$repo_url" "$full_path"
    fi
}

# Check and create Laboratories and Exercises directories
check_and_create_dir "Laboratories"
check_and_create_dir "Exercises"

# Check if we're on the main or master branch, switch if not
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
    if git show-ref --verify --quiet refs/heads/main; then
        echo "Switching to main branch"
        git checkout main
    elif git show-ref --verify --quiet refs/heads/master; then
        echo "Switching to master branch"
        git checkout master
    else
        echo "Neither 'main' nor 'master' branch exists. Aborting."
        exit 1
    fi
else
    echo "Already on $current_branch branch"
fi

# Clone or pull CAOS repository in the current directory
echo "Processing CAOS repository"
clone_or_pull "$CAOS_REPO" "."

# Clone or pull Laboratories repositories
echo "Processing Laboratories repositories"
for index in {1..$#LABORATORIES}; do
    repo="${LABORATORIES[$index]}"
    custom_name="${LABORATORIES_CUSTOM_NAMES[$index]}"
    clone_or_pull "$repo" "Laboratories" "$custom_name"
done

# Clone or pull Exercises repositories
echo "Processing Exercises repositories"
for index in {1..$#EXERCISES}; do
    repo="${EXERCISES[$index]}"
    custom_name="${EXERCISES_CUSTOM_NAMES[$index]}"
    clone_or_pull "$repo" "Exercises" "$custom_name"
done

# Initialize and update all submodules
git submodule init
git submodule update --recursive --remote # TODO: check "--recursive --remote"

echo "All repositories have been processed (cloned or pulled) in their respective directories."
