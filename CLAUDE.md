# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal macOS dotfiles. Source of truth lives here (`$HOME/dotfile`, exported as `$DOTFILES` and added to `PATH` from `.zshrc`). Per `README.md`, the user installs by copying files into `$HOME`:

```sh
cp -r dotfile/.* ~
```

So **editing a file here does not change live behavior** until it is copied into `$HOME` (or the user has set up an external symlink). When changing things that the user is actively running (zsh, tmux, Hammerspoon, alacritty, ghostty, gh, sheldon), tell the user the file changed here and that they need to sync to `$HOME` (or reload the relevant tool) for the change to take effect. The two exceptions are `.config/brewfile/Brewfile` (a symlink to the top-level `Brewfile`) and the `.git_template/` directory, which is referenced directly by the user's global `init.templatedir`.

## Layout

- **Shell** — `.zshrc`, `.zprofile`, `.zpreztorc` (Prezto config, `pure` prompt, `vi` keybindings); `.config/sheldon/plugins.toml` manages zsh plugins via [sheldon](https://github.com/rossmacarthur/sheldon). `.zshrc` auto-recompiles to `~/.zshrc.zwc` when `$DOTFILES/.zshrc` is newer.
- **Terminals** — `.config/alacritty/alacritty.toml`, `.config/ghostty/config`, `.tmux.conf` (prefix is `C-r`, not `C-b`).
- **Git** — `.gitconfig` (uses `delta` pager), `.gitmessage.txt` (Japanese template; comment char is `;`, set globally via `core.commentchar=";"`), `.gitignore_global`. Hooks in `.git_template/hooks/` are wired into new repos via `git config --global init.templatedir '~/dotfile/.git_template'`.
- **Editor / linters** — `.vimrc`, `.editorconfig` (2 spaces default, 4 for PHP), `.eslintrc`, `.stylelintrc`, `.tigrc`, `.less`/`.lesskey`.
- **macOS automation** — `.hammerspoon/` (Lua). `init.lua` loads `base`, `mouse_key`, `mouse_button`, `event_listener`, `prefix`, `utils`, `double_cmdq_to_quit`, then `pcall`s a separate machine-local module if present, so per-machine overrides don't pollute the shared init.
- **Packages** — top-level `Brewfile` lists every brew/cask/tap. Apply with `brew bundle --file=Brewfile`. A `file` directive at the bottom pulls in machine-specific additions from a separate location that isn't tracked here.
- **GitHub** — `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE.md`, `.config/gh/`, `.config/gh-copilot/`.
- **Other** — `raycast/` (Raycast config export), `prepare-commit-msg` (top-level copy; the active one is `.git_template/hooks/prepare-commit-msg`).

## Conventions worth knowing before editing

- **Commit-message hook (`prepare-commit-msg`)** parses the current branch name with `sed -E 's/.*[\/|-]([1-9][0-9]*).*/\1/'` and substitutes the captured issue number into `{issue}` placeholders in the commit template. So branches must be named like `id/123`, `feature/123`, or `something-123` for the substitution to land. To test, the README documents `git checkout id/000 && touch test && git add test && git commit`.
- **`.gitmessage.txt` uses `;` as the comment char**, not `#`. Don't introduce `#`-prefixed lines as comments here — they would be committed verbatim.
- **`pre-commit` hook** in `.git_template/hooks/` rewrites Japanese punctuation (`、` → `,`, `。` → `.`) in staged `*.md` files and re-stages them. Be aware before adding fancier checks: the hook silently mutates content.
- **Paths in `.zshrc` are macOS-specific** and assume both Intel (`/usr/local/...`) and Apple Silicon (`/opt/homebrew/...`) prefixes. Some lines reference tools the user may no longer have installed (e.g. `thefuck`, `scalaenv init`, `ng completion script`, `sdkman-init.sh`). Don't delete those without checking — they're guarded by `eval` and silently no-op if missing on a given machine, but they may be load-bearing on another.
- **No build / test / lint commands run from this repo.** It's pure config. The lint configs (`.eslintrc`, `.stylelintrc`) are intended to be picked up by editors / projects that copy them, not run here.

## When the user asks to add a tool

1. Add the package to `Brewfile` in the appropriate section (`brew`, `cask`, or under a `tap`).
2. If the tool has config, drop it under `.config/<tool>/` (XDG style) when the tool supports `XDG_CONFIG_HOME`, otherwise as a dotfile at the repo root.
3. If shell integration is required, add it to `.zshrc` (most tools live near the bottom; `eval "$(... init -)"` style).
4. Remind the user to `brew bundle --file=Brewfile` and re-copy the changed files into `$HOME`.
