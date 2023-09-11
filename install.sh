#!/bin/bash

# Define the target directory where the swtp script will be placed
TARGET_DIR="$HOME/.swtp/bin"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Download the latest tagged version of swtp script from the repository
LATEST_TAG=$(curl -s https://api.github.com/repos/kisztof/swtp/tags | grep -o '"name": "[^"]*' | head -n 1 | sed 's/"name": "//')
if [ $? -ne 0 ]; then
    echo "Failed to fetch the latest tag. Exiting."
    exit 1
fi

curl -L "https://raw.githubusercontent.com/kisztof/swtp/$LATEST_TAG/bin/swtp.sh" -o "$TARGET_DIR/swtp"
if [ $? -ne 0 ]; then
    echo "Failed to download swtp. Exiting."
    exit 1
fi

# Make swtp executable
chmod +x "$TARGET_DIR/swtp"
if [ $? -ne 0 ]; then
    echo "Failed to make swtp executable. Exiting."
    exit 1
fi

echo "swtp has been installed successfully in $TARGET_DIR."

# Determine the shell profile file based on the current shell
SHELL_PROFILE=""
case "$SHELL" in
    */bash)
        SHELL_PROFILE="$HOME/.bashrc"
        ;;
    */zsh)
        SHELL_PROFILE="$HOME/.zshrc"
        ;;
    */fish)
        SHELL_PROFILE="$HOME/.config/fish/config.fish"
        ;;
    */csh)
        SHELL_PROFILE="$HOME/.cshrc"
        ;;
    */ksh)
        SHELL_PROFILE="$HOME/.kshrc"
        ;;
    */dash)
        SHELL_PROFILE="$HOME/.dashrc"
        ;;
    *)
        echo "Unsupported shell. Please update your PATH manually."
        exit 1
        ;;
esac

# Update PATH in the shell profile if it doesn't already contain the target directory
if [ -n "$SHELL_PROFILE" ] && ! grep -q "export PATH=\"$TARGET_DIR:\$PATH\"" "$SHELL_PROFILE"; then
    case "$SHELL" in
        */fish)
            echo "set -gx PATH $TARGET_DIR \$PATH" >> "$SHELL_PROFILE"
            ;;
        *)
            echo "export PATH=\"$TARGET_DIR:\$PATH\"" >> "$SHELL_PROFILE"
            ;;
    esac
    echo "PATH has been updated. You may need to restart your shell or run 'source $SHELL_PROFILE'."
else
    echo "PATH already contains $TARGET_DIR. No changes were made."
fi

read -p "Would you like to restart your shell to apply changes? (y/n): " choice
case "$choice" in
    y|Y)
        # Restart the shell
        exec "$SHELL"
        ;;
    n|N)
        echo "You may need to restart your shell or run 'source $SHELL_PROFILE' to apply changes."
        ;;
    *)
        echo "Invalid option. You may need to restart your shell or run 'source $SHELL_PROFILE' to apply changes."
        ;;
esac