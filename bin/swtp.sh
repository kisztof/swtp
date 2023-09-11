#!/bin/bash

# Function to update swtp
update_swtp() {
    echo "Updating swtp..."
    LATEST_TAG=$(curl -s https://api.github.com/repos/kisztof/swtp/tags | grep -o '"name": "[^"]*' | head -n 1 | sed 's/"name": "//')
    if [ $? -ne 0 ]; then
        echo "Failed to fetch the latest tag. Exiting."
        exit 1
    fi

    # Execute the install.sh script directly from the repository
    /bin/bash -c "$(curl -fsSL "https://raw.githubusercontent.com/kisztof/swtp/$LATEST_TAG/install.sh")"

    if [ $? -ne 0 ]; then
        echo "Failed to update swtp using install.sh. Exiting."
        exit 1
    fi

    echo "swtp has been updated to version $LATEST_TAG."
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

# Check for --update, --version, or -h options
case "$1" in
    --update)
        update_swtp
        exit 0
        ;;
    --version)
        if [ -f "$HOME/.swtp/version" ]; then
            CURRENT_VERSION=$(cat "$HOME/.swtp/version")
            echo "swtp version $CURRENT_VERSION"
        else
            echo "Could not determine the version of swtp."
        fi
        exit 0
        ;;
    -h|--help)
        display_help
        exit 0
        ;;
    *)
        CURRENT_PHP_VERSION=$(php -v | head -n 1 | awk -F " " '{print $2}' | awk -F "." '{print $1 "." $2}')
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
            if [ -z "$PHP_VERSION" ]; then
                echo "Invalid selection. Exiting."
                exit 1
            fi
        else
            PHP_VERSION="$1"
        fi

        # Check if the requested PHP version is installed
        if ! echo "${PHP_VERSIONS[@]}" | grep -q -w "$PHP_VERSION"; then
            read -p "PHP version $PHP_VERSION is not installed. Would you like to install it now? (y/n): " choice
            case "$choice" in
                y|Y ) 
                    echo "Installing PHP version $PHP_VERSION..."
                    brew install php@"$PHP_VERSION"
                    ;;
                n|N ) 
                    echo "Exiting."
                    exit 1
                    ;;
                * ) 
                    echo "Invalid option. Exiting."
                    exit 1
                    ;;
            esac
        fi

        # Unlink the current PHP version
        echo "Unlinking the current PHP version..."
        brew unlink php &> /dev/null

        # Link the new PHP version
        echo "Linking PHP version $PHP_VERSION..."
        if brew link php@"$PHP_VERSION" --force &> /dev/null; then
            echo "Switched to PHP version $PHP_VERSION."
            NEW_PHP_VERSION=$(php -v | head -n 1 | awk -F " " '{print $2}' | awk -F "." '{print $1 "." $2}')
            echo "You are now using PHP version: $NEW_PHP_VERSION"
        else
            echo "Failed to switch to PHP version $PHP_VERSION."
            exit 1
        fi
        ;;
esac
