#!/bin/bash

# Fetch the latest tag from GitHub
fetch_latest_tag() {
    LATEST_TAG=$(curl -s https://api.github.com/repos/kisztof/swtp/tags \
                | grep -o '"name": "[^"]*' \
                | head -n 1 \
                | sed 's/"name": "//')
    if [ $? -ne 0 ]; then
        echo "Failed to fetch the latest tag. Exiting."
        exit 1
    fi
    echo "$LATEST_TAG"
}

# Update swtp
update_swtp() {
    LATEST_TAG=$(fetch_latest_tag)
    /bin/bash -c "$(curl -fsSL "https://raw.githubusercontent.com/kisztof/swtp/$LATEST_TAG/install.sh")"

    if [ $? -ne 0 ]; then
        echo "Failed to update swtp using install.sh. Exiting."
        exit 1
    fi

    echo "swtp has been updated to version $LATEST_TAG."
}

# Display current version
display_version() {
    if [ -f "$HOME/.swtp/version" ]; then
        CURRENT_VERSION=$(cat "$HOME/.swtp/version")
        echo "swtp version $CURRENT_VERSION"
    else
        echo "Could not determine the version of swtp."
    fi
}

# Function to check for a newer version
check_for_update() {
    LATEST_TAG=$(fetch_latest_tag)
    if [ $? -ne 0 ]; then
        echo "Failed to fetch the latest tag."
        return
    fi

    if [ -f "$HOME/.swtp/version" ]; then
        CURRENT_VERSION=$(cat "$HOME/.swtp/version")
        if [ "$CURRENT_VERSION" != "$LATEST_TAG" ]; then
            read -p "A newer version of swtp ($LATEST_TAG) is available. Would you like to update now? (y/n): " choice
            case "$choice" in
                y|Y)
                    update_swtp
                    ;;
                n|N)
                    echo "Continuing without updating."
                    ;;
                *)
                    echo "Invalid choice. Continuing without updating."
                    ;;
            esac
        fi
    else
        echo "Could not determine the current version of swtp."
    fi
}

# Function to display help message
display_help() {
    echo "Usage: swtp [OPTION] [PHP_VERSION]"
    echo "Switch PHP versions easily."
    echo
    echo "Options:"
    echo "  -h, --help    Display this help message and exit."
    echo "  --update      Update swtp to the latest version."
    echo "  --version     Display the current version of swtp."
    echo
    echo "Examples:"
    echo "  swtp          List available PHP versions and prompt for selection."
    echo "  swtp 7.4      Switch to PHP version 7.4."
}

# Fetch the currently linked PHP version
fetch_current_php_version() {
    php -v | head -n 1 | awk -F " " '{print $2}' | awk -F "." '{print $1 "." $2}'
}

# List available PHP versions and prompt for selection
prompt_php_version_selection() {
    echo "Available PHP versions:"
    for index in "${!FULL_VERSIONS[@]}"; do
        full_version="${FULL_VERSIONS[$index]}"
        major_minor_version="${PHP_VERSIONS[$index]}"
        if [ "$major_minor_version" == "$CURRENT_PHP_VERSION" ]; then
            echo -e "\033[0;32m* [$((index + 1))] $full_version\033[0m"
        else
            echo "* [$((index + 1))] $full_version"
        fi
    done
    read -p "Please choose a PHP version to switch to (enter the number): " choice
    PHP_VERSION="${PHP_VERSIONS[$((choice - 1))]}"
}

# Switch to the selected PHP version
switch_php_version() {
    echo "Unlinking the current PHP version..."
    brew unlink php &> /dev/null

    echo "Linking PHP version $1..."
    if brew link php@"$1" --force &> /dev/null; then
        echo "Switched to PHP version $1."
        NEW_PHP_VERSION=$(fetch_current_php_version)
        echo "You are now using PHP version: $NEW_PHP_VERSION"
    else
        echo "Failed to switch to PHP version $1."
        exit 1
    fi
}

# Check if the requested PHP version is installed
check_php_version_installed() {
    if ! echo "${PHP_VERSIONS[@]}" | grep -q -w "$1"; then
        return 1
    fi
    return 0
}

# Offer to install PHP version if not installed
offer_install_php_version() {
    read -p "PHP version $1 is not installed. Would you like to install it now? (y/n): " choice
    case "$choice" in
        y|Y ) 
            echo "Installing PHP version $1..."
            brew install php@"$1"
            return 0
            ;;
        n|N ) 
            echo "Exiting."
            return 1
            ;;
        * ) 
            echo "Invalid option. Exiting."
            return 1
            ;;
    esac
}

# Function to handle command-line options
handle_option() {
    case "$1" in
        --update)
            update_swtp
            ;;
        --version)
            display_version
            ;;
        -h|--help)
            display_help
            ;;
        *)
            handle_php_version_switch "$1"
            ;;
    esac
}

# Function to handle PHP version switch logic
handle_php_version_switch() {
    CURRENT_PHP_VERSION=$(fetch_current_php_version)
    echo "Currently linked PHP version: $CURRENT_PHP_VERSION"

    # Populate PHP_VERSIONS array
    declare -a PHP_VERSIONS=()
    declare -a FULL_VERSIONS=()
    while read -r path; do
        full_version=$(basename "$path")
        major_minor_version=$(echo "$full_version" | awk -F '.' '{print $1 "." $2}')
        PHP_VERSIONS+=("$major_minor_version")
        FULL_VERSIONS+=("$full_version")
    done < <(find /opt/homebrew/Cellar/php* -type d -maxdepth 1 -mindepth 1 | awk -F '/' '{print $NF}' | sort -V)

    # Check if a version number is provided
    if [ -z "$1" ]; then
        prompt_php_version_selection
        if [ -z "$PHP_VERSION" ]; then
            echo "Invalid selection. Exiting."
            exit 1
        fi
    else
        PHP_VERSION="$1"
    fi

    # Further logic to switch, install, or exit based on PHP version
    if check_php_version_installed "$PHP_VERSION"; then
        switch_php_version "$PHP_VERSION"
    else
        if offer_install_php_version "$PHP_VERSION"; then
            switch_php_version "$PHP_VERSION"
        else
            exit 1
        fi
    fi
}

# Main execution function
main() {
    check_for_update
    handle_option "$1"
    exit 0
}

# Invoke the main function with the first command-line argument
main "$1"
