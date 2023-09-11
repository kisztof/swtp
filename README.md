# swtp - Switch PHP Version
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/kisztof/swtp)

The `swtp` script allows you to easily switch between different PHP versions installed on your system. It additionally has the capability to install any missing PHP versions using Homebrew.

## Articles
- [Simplyfying PHP version management](https://kisztof.medium.com/simplifying-php-version-management-with-swtp-c6cf1848c1f8)

## Prerequisites

- Homebrew must be installed on your macOS system. How to do this see [Homebrew](https://brew.sh)
- Your system should have the Bash shell installed, although the installation script supports various other shells 
bash, zsh, fish, csh, ksh, and dash.

## One-Step Automated Installation

To install swtp in a manner similar to Homebrew, you can use the following one-liner. This will download and execute the `install.sh` script, placing the swtp tool into `$HOME/.swtp/bin/swtp`.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kisztof/swtp/main/install.sh)"
```

## Usage

Once you've executed `install.sh`, you can switch PHP versions easily using `swtp`.

```bash
swtp 7.4 # Switches to PHP 7.4
swtp 8.0 # Switches to PHP 8.0
```

If the desired PHP version is not installed, `swtp` will automatically attempt to install it using Homebrew.

### Auto-Update

To update swtp to the latest version, run:

```bash
swtp --update
```

This will fetch the latest version from the GitHub repository and update the script.

### Display Current Version

To display the current version of swtp, run:

```bash
swtp --version
```
This will show the version of swtp that you are currently using.


## Supported Shells

The `install.sh` script supports the following shells:

- Bash
- Zsh
- Fish
- Csh
- Ksh
- Dash

---
