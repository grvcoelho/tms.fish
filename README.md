# tms.fish

A Fish shell plugin for managing git projects as tmux sessions

## What is tms.fish?

tms.fish is a Fish plugin that works as a tmux session manager. It's inspired by [ThePrimeagen's tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles/blob/602019e902634188ab06ea31251c01c1a43d1621/bin/.local/scripts/tmux-sessionizer) but extends the functionality by integrating with [ghq](https://github.com/x-motemen/ghq) for a seamless git repository management.

- **Quick Session Management**: Create or switch tmux sessions for git projects
- **ghq Integration**: Navigate projects across your filesystem
- **Fuzzy Finding**: Select projects quickly with fzf
- **Auto-cloning**: Clone non-existent repositories automatically
- **Consistent Naming**: Generate uniform session names from repo names
- **Smart Session Handling**: Switch to existing sessions or create new ones

## Installation

Using [fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install grvcoelho/tms.fish
```

### Requirements

- [ghq](https://github.com/x-motemen/ghq) A Git repository management tool for organizing and accessing your repositories
- [fzf](https://github.com/junegunn/fzf) A command-line fuzzy finder for quickly searching and selecting items from a list

## Usage

```fish
# Open fzf to select a repository from your ghq list
$ tms

# Clone the repo if it doesn't exist, then open a tmux session for it
$ tms username/repo
```

## Other Work

- [tmux-sessionizer](https://github.com/jrmoulton/tmux-sessionizer): A similar rust tool
