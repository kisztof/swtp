# swtp - Switch PHP Version

The `swtp` script allows you to easily switch between different PHP versions installed on your system. It additionally has the capability to install any missing PHP versions using Homebrew.

## Articles
- [Simplyfying PHP version management](https://kisztof.medium.com/simplifying-php-version-management-with-swtp-c6cf1848c1f8)

## Prerequisites

- Homebrew must be installed on your macOS system. How to do this see [Homebrew](https://brew.sh)
- Your system should have the Bash shell installed, although the installation script supports various other shells 
bash, zsh, fish, csh, ksh, and dash.

## One-Step Automated Installation

To install swtp in a manner similar to Homebrew, you can use the following one-liner. This will download and execute the `install.sh` script, placing the swtp utility in `/usr/local/bin`.

```bash
/bin/bash -c "$(curl -fsSL https://github.com/kisztof/swtp/releases/download/latest/install.sh)"
```

**Note**: You may need to enter your root password since the script installs swtp into `/usr/local/bin`, which typically requires `root` permissions.

## Usage

Once you've executed `install.sh`, you can switch PHP versions easily using `swtp`.

```bash
swtp 7.4 # Switches to PHP 7.4
swtp 8.0 # Switches to PHP 8.0
```

If the desired PHP version is not installed, `swtp` will automatically attempt to install it using Homebrew.

## Supported Shells

The `install.sh` script supports the following shells:

- Bash
- Zsh
- Fish
- Csh
- Ksh
- Dash

---
