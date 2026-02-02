# Phase 1: Safe cleanups

**Risk:** Low

---

## 1. Remove asdf

- [x] Delete `dot_asdfrc` (asdf is not used; mise is the version manager).

---

## 2. Consolidate to mise only (remove pyenv)

- [x] Delete `zsh/macos/pyenv.env.sh` (mise handles Python).
- [x] Delete `zsh/macos/pyenv.rc.sh` (mise handles Python).
- [x] In `dot_zshrc`, remove the line `antigen bundle pyenv`.
- [x] In `dot_config/starship.toml`, update the comment that references asdf so it references mise (e.g. “mise takes more time…” instead of “asdf…”).

**Keep:** `zsh/common/mise.profile.sh` and `zsh/common/mise.rc.sh` as-is.

---

## 3. Remove legacy/unused modules

- [x] Delete `zsh/macos/hyper.rc.sh` (Hyper not in use; Warp is in Brewfile). *(already removed)*
- [x] Delete `zsh/macos/mamp.rc.sh` (MAMP not in use). *(already removed)*
- [x] Delete `zsh/macos/heroku.env.sh` (Heroku not in use). *(already removed)*

---

## 4. Fix path.env.sh comment

- [x] In `zsh/macos/path.env.sh`, change the header comment from `pth.env.sh` to `path.env.sh` so it matches the filename.

---

## 5. Brewfile cleanup

- [x] Remove the line `tap "homebrew/cask-fonts"` (deprecated; fonts work from main cask).
- [ ] Remove the commented block of Mac App Store apps (lines ~58–63) and the commented block of VS Code extensions (lines ~65–112). *(deferred: keeping for audit)*

---

## 6. Standardize shebangs in zsh modules

- [x] In every `zsh/**/*.sh` file that currently has `#!/bin/bash`, change it to `#!/bin/zsh`.

**Files to update (after step 3 the deleted modules are gone):**

- `zsh/common/utl.rc.sh`
- `zsh/common/git.rc.sh`
- `zsh/common/direnv.env.sh`
- `zsh/common/editor.env.sh`
- `zsh/macos/docker.rc.sh`
- `zsh/macos/osx.rc.sh`
- `zsh/macos/android.env.sh`
- `zsh/macos/foundry.env.sh`
- `zsh/macos/java.env.sh`
- `zsh/macos/path.env.sh`
- `zsh/macos/react-native.env.sh`

**Already correct:** `zsh/common/mise.profile.sh`, `zsh/common/mise.rc.sh`.

---

## Verification

- [ ] Run `chezmoi apply` (dry run or real) and confirm no errors.
- [ ] Start a new zsh session and confirm shell loads and mise works.
- [ ] Confirm no references to pyenv or asdf in your interactive setup.
