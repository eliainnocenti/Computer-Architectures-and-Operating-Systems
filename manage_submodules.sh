#!/bin/zsh

# Source the repository URLs and custom names from an external file (urls.txt)
source urls.txt

# Function to check and create a directory if it doesn't exist
# Args:
#   $1: Directory path to check/create
check_and_create_dir() {
    if [[ ! -d "$1" ]]; then
        echo "Creating directory: $1"
        mkdir -p "$1"
    else
        echo "Directory already exists: $1"
    fi
}

# Function to clone a repository or pull the latest changes if it already exists
# Args:
#   $1: Repository URL
#   $2: Target directory to clone the repo into
#   $3: Custom name for the repository (if provided, otherwise the repo name will be used)
clone_or_pull() {
    local repo_url=$1
    local target_dir=$2
    local custom_name=$3 # Custom name for the directory, if provided
    
    # Extract the repository name from the URL
    local repo_name=$(basename "$repo_url" .git)
    local final_name
    
    # Use custom name if given, otherwise use the repository's default name
    if [[ -n "$custom_name" ]]; then
        final_name="$custom_name"
    else
        final_name="$repo_name"
    fi
    
    # Construct the full path to the target directory
    local full_path="$target_dir/$final_name"
    
    # Check if the repository directory already exists
    if [[ -d "$full_path" ]]; then
        echo "Repository $final_name already exists. Pulling latest changes..."
        # Pull latest changes from 'main' or 'master' branch, if the repository already exists
        (cd "$full_path" && git pull origin main || git pull origin master)
        # After pulling, ensure all submodules are initialized and updated
        (cd "$full_path" && git submodule update --init --recursive)
    else
        # If the repository doesn't exist, clone it as a submodule
        echo "Cloning $final_name into $target_dir"
        git submodule add "$repo_url" "$full_path"
    fi
}

# Ensure that the 'Laboratories' and 'Exercises' directories exist
check_and_create_dir "Laboratories"
check_and_create_dir "Exercises"

# Check if we are on the 'main' or 'master' branch, and switch if necessary
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
    # Switch to 'main' branch if it exists, otherwise check for 'master'
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

# Clone or pull the CAOS repository (main repository for the project)
echo "Processing CAOS repository"
clone_or_pull "$CAOS_REPO" "."

# Clone or pull the Laboratories repositories using the list of URLs and custom names
echo "Processing Laboratories repositories"
for index in {1..$#LABORATORIES}; do
    repo="${LABORATORIES[$index]}"
    custom_name="${LABORATORIES_CUSTOM_NAMES[$index]}"
    clone_or_pull "$repo" "Laboratories" "$custom_name"
done

# Clone or pull the Exercises repositories using the list of URLs and custom names
echo "Processing Exercises repositories"
for index in {1..$#EXERCISES}; do
    repo="${EXERCISES[$index]}"
    custom_name="${EXERCISES_CUSTOM_NAMES[$index]}"
    clone_or_pull "$repo" "Exercises" "$custom_name"
done

# Ensure that all submodules in the entire repository are initialized and updated
# This command recursively initializes and updates any submodules that weren't covered earlier
git submodule update --init --recursive
# Uncomment the next line if you want to fetch the latest remote changes for submodules, but it may cause unintended updates
# git submodule update --recursive --remote

echo "All repositories have been processed (cloned or pulled) in their respective directories."
