# dotfiles

Personal dotfile script to setup and maintain my configuration across multiple devices


![Shell](./assets/shell.png)

Also include configuration for NeoVim and Vim

![NeoVim](./assets/nvim.png)


### Usage

Clone this repository:

```bash
git clone https://github.com/bdryanovski/dotfiles
```

Inside it just run the basic task for the first time

```bash
bash init.sh --help
```

![Intro](./assets/intro.png)


### Run specific package
The dotfiles are build with the idea that multiple packages could be run one at the time without depending much on other packages.

This is not true for all packages but in general this is the idea.

To run a package just mention his name as first argument:

```bash
bash init.sh shell
```

The above command will run only the `shell` package and nothing more.

### Helpers

Helpers is a collections of useful functions that are used across packages - this way a single change could be apply to multiple files, keep everything the same, and simplify a lot of clunky BASH functionality.




### Packages

Packages are located inside `packages` folder. Everyone must include `init.sh` script, everything inside it is optional.

The basic structure is that every package support few things as commands:

  * help - provide description of the package usage
  * version - give information about the package version
  * setup - the initial task to be run without any arguments
  * sync - syncing the current stage of the computer with the package - (they way to move things between machines)


```bash
  🤌  Available packages to run:

  packages/base

    Description:
    Basic system setup require for later packages to pass without depending on each other

  packages/git

    Description:
    Configure control version tooling
    This include git configuration, additional commands
    Also instructions how to setup GPG Signing

  packages/nodejs

    Setup NodeJS for development

  packages/osx

    Description:
    This package will configure MacOS by setting and modify system settings
    From system settings, env, and more

  packages/shell

    Description:
    Setup ZSH and install Homebrew.
    This include command line aliases, theme, automation and more

  packages/vim

    Description:
    Setup NeoVim and Vim as editor
    Configure the editors for development by installing additional packages

```
