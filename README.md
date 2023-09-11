# swtp - Switch PHP Version

The `swtp` script allows you to easily switch between different PHP versions installed on your system. It additionally has the capability to install any missing PHP versions using Homebrew.

## Articles
- [Simplyfying PHP version management](https://kisztof.medium.com/simplifying-php-version-management-with-swtp-c6cf1848c1f8)

## Prerequisites

- Homebrew must be installed on your macOS system. How to do this see [Homebrew](https://brew.sh)
- Your system should have the Bash shell installed, although the installation script supports various other shells 
bash, zsh, fish, csh, ksh, and dash.

## Installation

**Download the Repository**: Clone this repository to a directory of your choice.

```bash
git clone https://github.com/kisztof/swtp.git
```

**Navigate to the Directory**: Use the terminal to navigate into the directory where you have cloned the repository.

```bash
cd path/to/cloned/repo
```

**Run the Installer**: Before you use `swtp`, it's crucial to run the `install.sh` script. This will add `swtp` to your `$PATH`, enabling you to run it from any directory. Execute the following commands to make `install.sh` executable and run it:

```bash
chmod +x install.sh
./install.sh
```

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
