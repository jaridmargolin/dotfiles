# Dotfiles Facelift Plan

## Executive Summary

Your dotfiles are well-organized with clear separation of concerns, but carry accumulated technical debt from multiple generations of tooling. The core architecture is sound—the modular zsh structure (`*.env.sh`, `*.profile.sh`, `*.rc.sh`) and platform separation (`common/`, `macos/`) is excellent. The issues are primarily:

1. **Unmaintained dependencies** (Antigen)
2. **Overlapping version managers** (mise + pyenv + asdf remnants)
3. **Legacy/unused code** (docker-machine, MAMP, Hyper-specific fixes)
4. **Chezmoi automation that doesn't actually trigger on changes**
5. **Inconsistent shell conventions**

---

## Part 1: Zsh Plugin Management (Antigen Replacement)

### Current State

```zsh
# dot_zshrc
source ~/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle pyenv
antigen bundle yarn
antigen bundle direnv
# ... more bundles
antigen apply
```

**Problems:**
- Antigen last released in 2018, effectively unmaintained
- Dynamic bundle loading adds shell startup latency
- Docker plugin disabled due to completion conflicts
- OMZ used only as a plugin library (no theme)

### Recommendation: Replace with Antidote

**Why Antidote:**
- Actively maintained (2024+ releases)
- Static bundle generation (faster startup)
- Mental model similar to Antigen (easy migration)
- Works with OMZ plugins, zsh-users plugins, and standalone repos

### Migration Path

1. **Create a new plugin list file**: `~/.zsh_plugins.txt`

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

2. **Update `dot_zshrc`**:

```zsh
# Load antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Generate static file and source it
antidote load

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
```

3. **Update `install-utils.sh`** to install Antidote instead of Antigen:

```sh
# Replace antigen block with:
if [ ! -d "${ZDOTDIR:-$HOME}/.antidote" ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
fi
```

### Plugins to Review During Migration

| Current Plugin | Recommendation | Reason |
|----------------|----------------|--------|
| `pyenv` | **Remove** | Redundant with mise |
| `yarn` | **Keep or Remove** | Modern yarn has its own completions via corepack |
| `direnv` | **Keep** | Useful, no overlap |
| `docker` | **Re-enable** | Try with Antidote, may resolve completion issues |
| `aws` | **Keep** | AWS CLI completions |
| `1password` | **Keep** | 1Password CLI integration |
| `history` | **Keep** | History configuration |
| `extract` | **Keep** | Useful utility |

---

## Part 2: Version Manager Consolidation (mise vs pyenv vs asdf)

### Current State

You have **three** version manager systems partially configured:

1. **mise** (actively used, installed via Homebrew)
   - `zsh/common/mise.profile.sh` - shims activation
   - `zsh/common/mise.rc.sh` - interactive activation
   - `scripts/macos/install-languages.sh` - installs Node, Python, Ruby, Go, Yarn

2. **pyenv** (legacy, still loading)
   - `zsh/macos/pyenv.env.sh` - sets `PYENV_ROOT` and PATH
   - `zsh/macos/pyenv.rc.sh` - runs `pyenv init --path`

3. **asdf** (abandoned, config file remains)
   - `dot_asdfrc` - `legacy_version_file = yes`
   - `dot_config/starship.toml` - comment references asdf

**Problems:**
- Shell startup runs both mise and pyenv initialization
- PATH pollution from multiple tools
- Confusing when debugging version issues
- Dead config files

### Recommendation: Consolidate to mise only

**Actions:**

1. **Delete `dot_asdfrc`** - asdf is not used
2. **Delete `zsh/macos/pyenv.env.sh`** - mise handles Python
3. **Delete `zsh/macos/pyenv.rc.sh`** - mise handles Python
4. **Remove `antigen bundle pyenv`** from dot_zshrc
5. **Update `starship.toml` comment** - references asdf, should reference mise

**Keep mise setup as-is** - the dual activation pattern (shims in profile, full activation in rc) is intentional and correct for IDE compatibility.

---

## Part 3: Dead/Legacy Code Removal

### docker.rc.sh - Docker Machine Aliases

```bash
dock() { eval $(docker-machine env $1) }
undock() { eval $(docker-machine env -u) }
```

**Status:** Docker Machine was deprecated in 2021. Docker Desktop is the standard now.

**Recommendation:** Remove `dock()` and `undock()` functions. Keep `dprune()` if useful.

### mamp.rc.sh - Incomplete MAMP Integration

```bash
# TODO: prefix all MAMP bin items with `mamp-`
# TODO: start/stop MAMP from command line
```

**Status:** Incomplete, has TODOs from original creation.

**Recommendation:** 
- If you still use MAMP: Complete or simplify
- If not: Delete `zsh/macos/mamp.rc.sh`

### hyper.rc.sh - Hyper Terminal Fix

```bash
# Fix "%" displaying upon new hyper session
unsetopt PROMPT_SP
```

**Status:** Your Brewfile installs Warp (`cask "warp"`), not Hyper.

**Recommendation:** If you no longer use Hyper terminal, delete `zsh/macos/hyper.rc.sh`.

### heroku.env.sh - Heroku Autocomplete

```bash
HEROKU_AC_ZSH_SETUP_PATH="$HOME/Library/Caches/heroku/autocomplete/zsh_setup"
```

**Status:** Still potentially useful if you use Heroku.

**Recommendation:** Keep if using Heroku CLI, otherwise delete.

### java.env.sh - Static Java Home

```bash
export JAVA_HOME=/Library/Java/Home
```

**Status:** This is a generic symlink path. Modern approach would be to use `/usr/libexec/java_home`.

**Recommendation:** Update to:
```bash
if /usr/libexec/java_home &>/dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi
```

### react-native.env.sh - IDE Setting

```bash
export REACT_EDITOR=idea
```

**Status:** Single line, sets error overlay editor.

**Recommendation:** Keep if doing React Native, or merge into `editor.env.sh`.

---

## Part 4: Chezmoi Automation Fixes

### Current Problem: `run_onchange` Scripts Don't Actually Trigger on Change

Your scripts have sha256sum lines, but they're **inside comments**:

```sh
# run if the following files change:
# {{ include (printf "%s/scripts/common/install-utils.sh" .chezmoi.sourceDir) | sha256sum }}
```

The `#` at the beginning means chezmoi doesn't see this as a template directive—it's just a comment. These scripts run on **every** `chezmoi apply`.

### Fix: Uncomment the sha256sum lines

```sh
# run if the following files change:
# Ref: https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/
# {{ include (printf "%s/scripts/common/install-utils.sh" .chezmoi.sourceDir) | sha256sum }}
```

Should become:

```sh
# run if the following files change:
# Ref: https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/
{{ include (printf "%s/scripts/common/install-utils.sh" .chezmoi.sourceDir) | sha256sum }}
```

The sha256sum output will be embedded in the rendered script. When the source file changes, the hash changes, and chezmoi detects this as a "changed" script that needs to run.

**Files to update:**
- `.chezmoiscripts/run_onchange_after_00-sync-settings.sh.tmpl`
- `.chezmoiscripts/run_onchange_after_01-install-utils.sh.tmpl`
- `.chezmoiscripts/run_onchange_after_02-install-packages.sh.tmpl`
- `.chezmoiscripts/run_onchange_after_03-install-languages.sh.tmpl`

---

## Part 5: Shell Script Inconsistencies

### Shebang Mismatch

Several files in `zsh/` use `#!/bin/bash` but contain zsh-specific code or are only sourced by zsh:

| File | Current | Should Be |
|------|---------|-----------|
| `zsh/common/mise.profile.sh` | `#!/bin/zsh` | ✓ Correct |
| `zsh/common/mise.rc.sh` | `#!/bin/zsh` | ✓ Correct |
| `zsh/macos/pyenv.env.sh` | `#!/bin/bash` | `#!/bin/zsh` (or remove) |
| `zsh/macos/pyenv.rc.sh` | `#!/bin/bash` | `#!/bin/zsh` (or remove) |
| `zsh/macos/docker.rc.sh` | `#!/bin/bash` | `#!/bin/zsh` |
| `zsh/macos/mamp.rc.sh` | `#!/bin/bash` | `#!/bin/zsh` |
| `zsh/common/utl.rc.sh` | `#!/bin/bash` | `#!/bin/zsh` |
| `zsh/common/git.rc.sh` | `#!/bin/bash` | `#!/bin/zsh` |

**Note:** The shebang doesn't actually matter for sourced files (they inherit the parent shell), but it's confusing and affects syntax highlighting in editors.

**Recommendation:** Standardize all `zsh/**/*.sh` files to `#!/bin/zsh` for consistency.

### path.env.sh Filename vs Comment

```bash
# File: zsh/macos/path.env.sh
# ##############################################################################
#
# pth.env.sh  <-- Comment says "pth.env.sh"
#
# ##############################################################################
```

**Recommendation:** Update comment to match actual filename.

---

## Part 6: Brewfile Cleanup

### Deprecated/Unused Taps

```ruby
tap "homebrew/cask-fonts"
```

**Status:** Fonts were moved to `homebrew/cask` in 2023. This tap is deprecated.

**Recommendation:** Remove the tap line. `cask "font-hack-nerd-font"` still works without it.

### Commented Blocks Decision

Your Brewfile has large commented sections:
- VS Code extensions (lines 65-112) - with note "vscode sync handles this"
- Mac App Store apps (lines 58-63) - with note about `mas` purchase issues

**Recommendation:** Remove these commented blocks entirely. They add noise and the notes explain why they're not used.

---

## Part 7: source_scripts Function Simplification

### Current Implementation

```bash
# dot_zshenv
source_scripts () {
  BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" > /dev/null && pwd -P)"
  for f in $(find -L $1 -name "$2"); do [ -f $f ] && source "$f"; done
}
```

**Issues:**
- `BASE_DIR` is set but never used
- Uses `find` which has inconsistent ordering across systems
- No error handling for missing directories

### Recommended Simplification

```zsh
source_scripts() {
  local dir="$1" pattern="$2"
  [[ -d "$dir" ]] || return 0
  for f in "$dir"/$~pattern(N); do
    [[ -f "$f" ]] && source "$f"
  done
}
```

This version:
- Removes unused `BASE_DIR`
- Uses zsh glob with `(N)` null_glob (no error if no matches)
- More predictable ordering
- Handles missing directories gracefully

---

## Part 8: Minor Cleanups

### envman Block in dot_zshrc

```bash
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
```

**Question:** Do you use webi installer tools that require envman?

**Recommendation:** Keep if using webi-installed tools, otherwise remove.

### Raycast Config

```
raycast/2023-09-04.rayconfig
```

**Question:** Is this being managed by chezmoi intentionally? Raycast has its own sync.

**Recommendation:** Consider if this needs to be in dotfiles or if Raycast Cloud Sync handles it.

---

## Implementation Phases

### Phase 1: Safe Cleanups (Low Risk)
- [ ] Delete `dot_asdfrc`
- [ ] Delete `zsh/macos/pyenv.env.sh`
- [ ] Delete `zsh/macos/pyenv.rc.sh`
- [ ] Delete `zsh/macos/hyper.rc.sh` (if not using Hyper)
- [ ] Delete `zsh/macos/mamp.rc.sh` (if not using MAMP)
- [ ] Remove `antigen bundle pyenv` from `dot_zshrc`
- [ ] Fix `path.env.sh` comment
- [ ] Update `starship.toml` comment (asdf → mise)
- [ ] Remove deprecated `tap "homebrew/cask-fonts"` from Brewfile
- [ ] Remove commented VS Code extensions from Brewfile
- [ ] Standardize shebangs to `#!/bin/zsh` in zsh modules

### Phase 2: Chezmoi Fixes (Medium Risk)
- [ ] Uncomment sha256sum lines in all `run_onchange` scripts
- [ ] Test `chezmoi apply` to verify scripts only run when source files change

### Phase 3: Antigen → Antidote Migration (Higher Risk)
- [ ] Create `dot_zsh_plugins.txt` with plugin list
- [ ] Update `install-utils.sh` to install Antidote
- [ ] Update `dot_zshrc` to use Antidote
- [ ] Remove `~/antigen` directory after migration
- [ ] Test shell startup, completions, and plugin functionality

### Phase 4: Refinements
- [ ] Simplify `source_scripts` function
- [ ] Update `java.env.sh` to use `/usr/libexec/java_home`
- [ ] Remove docker-machine aliases from `docker.rc.sh`
- [ ] Evaluate and clean up remaining macos-specific modules
- [ ] Consider if `envman` block is needed

---

## Questions to Answer Before Proceeding

1. **Hyper terminal:** Still in use? (Warp is in Brewfile)
2. **MAMP:** Still in use?
3. **Heroku:** Still in use?
4. **React Native development:** Still active?
5. **envman/webi tools:** Any installed via webi?
6. **Raycast config:** Managed by Raycast Cloud Sync or chezmoi?

---

## Expected Outcomes

After completing this facelift:

1. **Faster shell startup** - Static plugin loading, no pyenv overhead
2. **Simpler mental model** - One version manager (mise), one plugin manager (Antidote)
3. **Working change detection** - Chezmoi scripts only run when needed
4. **Less dead code** - Removed legacy/unused modules
5. **Consistent conventions** - Proper shebangs, accurate comments
6. **Easier maintenance** - Clear plugin list, modern tooling

---

## Files Summary

### To Delete
- `dot_asdfrc`
- `zsh/macos/pyenv.env.sh`
- `zsh/macos/pyenv.rc.sh`
- `zsh/macos/hyper.rc.sh` (if confirmed unused)
- `zsh/macos/mamp.rc.sh` (if confirmed unused)

### To Create
- `dot_zsh_plugins.txt` (Antidote plugin list)

### To Modify
- `dot_zshrc` (Antigen → Antidote, remove pyenv bundle)
- `scripts/common/install-utils.sh` (Antigen → Antidote)
- `.chezmoiscripts/run_onchange_*.sh.tmpl` (uncomment sha256sum)
- `Brewfile` (remove deprecated tap, commented blocks)
- `dot_zshenv` (simplify source_scripts)
- `zsh/macos/path.env.sh` (fix comment)
- `zsh/macos/java.env.sh` (modernize)
- `zsh/macos/docker.rc.sh` (remove docker-machine)
- `dot_config/starship.toml` (fix comment)
- All `zsh/**/*.sh` files (standardize shebangs)
