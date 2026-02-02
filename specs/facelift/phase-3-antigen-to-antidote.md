# Phase 3: Antigen → Antidote

**Risk:** Higher (touches plugin loading and startup).  
**Prerequisite:** Phase 1 done (pyenv removed from dot_zshrc; optional but cleaner).

---

## Why Antidote

- Antigen is effectively unmaintained (last release 2018).
- Antidote is actively maintained, uses a static plugin list, and gives faster startup.
- Same ecosystem: OMZ plugins, zsh-users plugins, and standalone repos.

---

## 1. Add Antidote plugin list

- [ ] Create `dot_zsh_plugins.txt` in the chezmoi source root (it will be applied to `~/.zsh_plugins.txt`).

**Contents (adjust if you add/remove plugins later):**

```txt
# Framework
ohmyzsh/ohmyzsh path:lib
ohmyzsh/ohmyzsh path:plugins/history
ohmyzsh/ohmyzsh path:plugins/extract
ohmyzsh/ohmyzsh path:plugins/aws
ohmyzsh/ohmyzsh path:plugins/1password
ohmyzsh/ohmyzsh path:plugins/direnv

# External plugins
jaridmargolin/bm
lukechilds/zsh-better-npm-completion
zsh-users/zsh-autosuggestions
zsh-users/zsh-history-substring-search
zsh-users/zsh-syntax-highlighting
```

**Note:** Omit `pyenv` (removed in Phase 1). Re-enable `docker` plugin here if you want to retry it with Antidote; if completion issues persist, remove that line.

---

## 2. Install Antidote in install-utils

- [ ] In `scripts/common/install-utils.sh`, replace the Antigen block with:

```sh
# antidote (zsh plugin manager)
if [ ! -d "${ZDOTDIR:-$HOME}/.antidote" ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR:-$HOME}/.antidote"
fi
```

- [ ] Remove any Antigen-specific logic (e.g. cloning antigen into `~/antigen`).

---

## 3. Switch dot_zshrc to Antidote

- [ ] In `dot_zshrc`, replace the entire Antigen block (from `export ANTIGEN_LOG` through `antigen apply`) with:

```zsh
# zsh plugins (Antidote)
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# Key bindings for history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
```

- [ ] Remove any `zstyle` lines that were for OMZ/antigen (e.g. `zstyle ':omz:plugins:yarn'`, `zstyle ':omz:plugins:docker'`) unless Antidote/OMZ docs say to keep them.
- [ ] Keep the rest of `dot_zshrc` unchanged: `source_scripts` for `*.rc.sh`, then Starship, then envman (if you keep it).

---

## 4. Remove Antigen from the machine

- [ ] Run the new install-utils once so Antidote is installed (e.g. via Phase 2 run_onchange or manually).
- [ ] Open a new zsh session and confirm plugins and completions work.
- [ ] Delete `~/antigen` (or `$HOME/antigen`) if it exists.

---

## Verification

- [ ] New zsh session starts without errors.
- [ ] Autosuggestions, syntax highlighting, and history-substring-search work.
- [ ] OMZ plugins (e.g. history, extract, aws, direnv, 1password) work as expected.
- [ ] Completions (e.g. aws, git) work; if you re-enabled docker, test docker completion.
- [ ] Starship prompt still loads after your rc scripts.
