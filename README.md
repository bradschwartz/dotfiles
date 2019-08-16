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