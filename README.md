# my-dotfiles

Personal dotfiles: shell configs (bash/zsh), aliases, scripts, and helpers. Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink packages into `$HOME`.

## Architecture

- **Public packages** are stowed from the repo root (vim, tmux, bin, bash, zsh, git, etc.). Clone and run install to get a full setup.
- **Overlay packages** (private or work-specific) live as submodules under `overlay/<name>` (e.g. `overlay/work`). They are stowed after the main packages and layer on top. See [overlay/README.md](overlay/README.md) for a full scenario.

Overlay packages use the same stow layout (directories mirroring `$HOME`). For shell config, put aliases in `.bash_aliases/` and scripts in `.bash_scripts/`—both bash and zsh already source those.

## New machine

1. Clone this repo to `~/.dotfiles`.
2. Run `./install.sh`.
3. If you use overlay packages: `git submodule update --init overlay/work` (or whichever), then run `./install.sh` again.

## Adding a work/private overlay

**Quick start:** create a new overlay from the template, then add it as a submodule:

```bash
./overlay/unfold.sh work
# Edit the new repo at ../dotfiles-overlay-work, commit, push, then:
git submodule add <your-repo-url> overlay/work
./install.sh
```

Or add an existing repo: `git submodule add <your-repo-url> overlay/work` then `./install.sh`. The overlay repo must mirror `$HOME` (e.g. `.bash_aliases/`, `.bash_scripts/`, `.local/bin/`).

**Full walkthrough:** [overlay/README.md](overlay/README.md)

## Contents

Bash scripts, aliases, and helper methods used across work and personal setups. Shared env, paths, and keybindings live in `.env`, `.paths`, and `.keybindings`; overlay packages add aliases and scripts via `.bash_aliases/` and `.bash_scripts/`.
