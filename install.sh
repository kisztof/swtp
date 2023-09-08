#!/bin/bash

# Detect the current shell
CURRENT_SHELL=$(basename "$SHELL")

# Automatically detect the directory containing this install script, and append /bin
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/bin"

# Make swtp executable
chmod +x "$SCRIPT_DIR/swtp"

add_to_path() {
    config_file=$1
    shell_name=$2
    if grep -q "export PATH.*$SCRIPT_DIR" "$config_file"; then
        echo "swtp is already in your PATH in $shell_name"
    else
        echo "export PATH=\$PATH:$SCRIPT_DIR" >> "$config_file"
        echo "swtp has been added to your PATH in $shell_name"
    fi
}

case "$CURRENT_SHELL" in
    bash)
        add_to_path "$HOME/.bashrc" ".bashrc"
        ;;
    zsh)
        add_to_path "$HOME/.zshrc" ".zshrc"
        ;;
    fish)
        if grep -q "$SCRIPT_DIR" "$HOME/.config/fish/config.fish"; then
            echo "swtp is already in your PATH in config.fish"
        else
            echo "set -U fish_user_paths $SCRIPT_DIR \$fish_user_paths" >> "$HOME/.config/fish/config.fish"
            echo "swtp has been added to your PATH in config.fish"
        fi
        ;;
    csh|tcsh)
        add_to_path "$HOME/.cshrc" ".cshrc"
        ;;
    ksh)
        add_to_path "$HOME/.kshrc" ".kshrc"
        ;;
    dash)
        add_to_path "$HOME/.dashrc" ".dashrc"
        ;;
    *)
        echo "Unsupported or unknown shell detected."
        echo "Please manually add the following line to your shell's startup file:"
        echo "export PATH=\$PATH:$SCRIPT_DIR"
        ;;
esac
