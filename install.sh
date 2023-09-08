#!/bin/bash

# Detect the current shell
CURRENT_SHELL=$(basename "$SHELL")

# Automatically detect the directory containing this install script, and append /bin
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/bin"

# Make swtp executable
chmod +x "$SCRIPT_DIR/swtp"

case "$CURRENT_SHELL" in
    bash)
        echo "export PATH=\$PATH:$SCRIPT_DIR" >> "$HOME/.bashrc"
        echo "swtp has been added to your PATH in .bashrc"
        ;;
    zsh)
        echo "export PATH=\$PATH:$SCRIPT_DIR" >> "$HOME/.zshrc"
        echo "swtp has been added to your PATH in .zshrc"
        ;;
    fish)
        echo "set -U fish_user_paths $SCRIPT_DIR \$fish_user_paths" >> "$HOME/.config/fish/config.fish"
        echo "swtp has been added to your PATH in config.fish"
        ;;
    csh|tcsh)
        echo "setenv PATH \$PATH:$SCRIPT_DIR" >> "$HOME/.cshrc"
        echo "swtp has been added to your PATH in .cshrc"
        ;;
    ksh)
        echo "export PATH=\$PATH:$SCRIPT_DIR" >> "$HOME/.kshrc"
        echo "swtp has been added to your PATH in .kshrc"
        ;;
    dash)
        echo "export PATH=\$PATH:$SCRIPT_DIR" >> "$HOME/.dashrc"
        echo "swtp has been added to your PATH in .dashrc"
        ;;
    *)
        echo "Unsupported or unknown shell detected."
        echo "Please manually add the following line to your shell's startup file:"
        echo "export PATH=\$PATH:$SCRIPT_DIR"
        ;;
esac
