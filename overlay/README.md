# Overlay packages (private / work)

Packages here **overlay** on top of the base dotfiles. When present, they are stowed into `$HOME` by `install.sh` after the main packages, so work/private config and scripts sit alongside the rest.

## Creating a new overlay (unfold)

From the dotfiles repo root, run:

```bash
./overlay/unfold.sh work
```

That creates a new git repo at `../.dotfiles-overlay-work` (hidden; or pass a second argument for a custom path) with the right layout (`.bash_aliases/`, `.bash_scripts/`, `.local/bin/`). Edit the files, commit, push to a remote, then add it as a submodule:

```bash
git submodule add <your-repo-url> overlay/work
./install.sh
```

Install skips any overlay whose name starts with `_`.

---

## Scenario: work-related dotfiles

You have a separate repo (e.g. `my-work-dotfiles`) with work-only aliases, scripts, and maybe a few binaries. You want them on work machines and optionally on personal ones, without putting them in the public dotfiles repo.

**1. Create the work repo (if you don’t have it yet).**

Either use `./overlay/unfold.sh work` (see above) or create the repo by hand. Layout must mirror `$HOME`. Example:

```
my-work-dotfiles/
├── .bash_aliases/
│   └── work      # work aliases (e.g. alias deploy='...')
├── .bash_scripts/
│   └── work.sh   # work helpers, env vars, functions
└── .local/
    └── bin/      # work-only scripts (optional)
```

**2. Add it as a submodule under `overlay/`.**

From your main dotfiles repo:

```bash
cd ~/.dotfiles
git submodule add https://github.com/you/my-work-dotfiles.git overlay/work
./install.sh
```

Install stows the main packages, then stows `overlay/work` into `$HOME`. You get:

- `~/.bash_aliases/work` (sourced by both shells with the rest of `.bash_aliases/`)
- `~/.bash_scripts/work.sh` (sourced with `.bash_scripts/*.sh`)
- `~/.local/bin/<work scripts>` if you added any

**3. On a new machine.**

```bash
git clone https://github.com/you/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
# then add work overlay:
git submodule add https://github.com/you/my-work-dotfiles.git overlay/work
./install.sh
```

If the submodule is already committed (e.g. you use it on every machine):

```bash
git clone --recurse-submodules https://github.com/you/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

**4. Multiple overlays.**

You can have several: `overlay/work`, `overlay/contracting`, etc. Each is one stow package. Install loops over `overlay/*/` and stows each. Order is by directory name.

---

## What to put in an overlay (avoiding conflicts)

Overlays are stowed **after** the main packages into the same `$HOME`. Stow creates symlinks; if the overlay uses the same path as the main repo, the overlay wins (last stow overwrites the link). To **add** config without replacing main, use only **additive** paths:

**Safe to add (no conflict):**

| Place | Use | Main already has |
|-------|-----|------------------|
| `.bash_aliases/<name>` | One file per group (e.g. `work`, `contracting`) | `terminal`, `python`, `node`, `git`, `databases`, `apps`, `ansible` — pick a **different** name |
| `.bash_scripts/<name>.sh` | Env, functions, PATH for this overlay | `python-venv.sh`, `nvm.sh`, `git-worktree.sh`, `custom_bash_prompt.sh`, etc. — pick a **different** name |
| `.local/bin/<script>` | Scripts on PATH | `cht.sh`, `jq`, `zoxide`, `tmux-sessionizer`, etc. — use a **different** name |
| `.local/scripts/<script>` | Scripts you source or call by path | Various — use a **different** name |

**Avoid in overlay (would override main):**

- **`.env`**, **`.paths`**, **`.keybindings`**, **`.shared-rc.sh`** — main provides these from the `common` package; putting them in an overlay replaces the main symlink and can break PATH / helpers.
- **`.bashrc`**, **`.zshrc`** — main entrypoints; overlay versions would replace them entirely.
- **Same filenames** as main in `.bash_aliases/` or `.bash_scripts/` (e.g. overlay `.bash_aliases/git` would override main's `git` alias file).

With `--no-folding`, `~/.local` is a real directory and both main and overlay add **files** into it. So overlay `.local/bin/my-work-tool` and main's `.local/bin/cht.sh` coexist as long as the filenames differ.

---

## Directory may be empty

On a fresh clone, `overlay/` may contain only this README. Install skips missing or empty packages. You don’t commit private URLs in the main repo; add submodules locally per machine if you prefer.
