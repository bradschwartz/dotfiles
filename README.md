# dotfiles

Personal dotfiles for my personal workflow. This style was created with GNU
Stow in mind for managing the actual symbolic linking. I didn't want to have
a bunch of hidden files in a git repo, so I took advantage of a new (June 2019)
feature of stow that adds first-class support for managing dotfiles. To install
a certain applications configurations, just do:

```bash
stow --dotfiles bash
```

The `--dotfiles` flag converts any file or directory that starts with `dot-`
to having a `.` in the symbolic link it creates.

Tired of my personal settings? Remove them with:

```bash
stow -D bash
```

## On New Machine

It worked! Finally tested on a freshly wiped Mac to moderate success, but a few
steps were undocumented and needed to be done first. Here they are:

```bash
## Actually install Homebrew! And add it to zprofile since that's Mac default
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

## ensure rosetta2 installed for adoptopenjdk8 and temurin8
sudo softwareupdate --install-rosetta

## Actually install all the tools!
## Clone this repo into ~/.dotfiles and run the brew bundle command
cd $HOME
git clone https://github.com/bradschwartz/dotfiles .dotfiles
cd .dotfiles/
brew bundle ## this is what will actually install from Brewfile

## Actually reconfigure the machine with my settings
find . -type d -name '[!.]*' -maxdepth 1 -execdir stow --dotfile {} \;

## And finally, bash is best shell
## A StackExchange post for editing /etc/shells: https://superuser.com/a/1712219
echo $(which bash) | sudo tee -a /etc/shells
chsh -s $(which bash)

## Looks like docker needs to be opened once since it's installed as a Cask, and
## we need the Cask to install the cli for us for something in my startup scripts
## And `rustup-init` needs to run once, but that's only if we need rust.
```

### Brewfile

Brewfile is generated using:

```bash
brew bundle dump --all --verbose --force --describe
```
