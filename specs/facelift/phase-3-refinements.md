# Phase 3: Refinements

**Risk:** Low–Medium  
**Prerequisite:** Phases 1–2 done (recommended).

---

## 1. Simplify source_scripts (dot_zshenv)

- [ ] In `dot_zshenv`, replace the current `source_scripts` implementation with:

```zsh
source_scripts() {
  local dir="$1" pattern="$2"
  [[ -d "$dir" ]] || return 0
  for f in "$dir"/$~pattern(N); do
    [[ -f "$f" ]] && source "$f"
  done
}
```

This removes the unused `BASE_DIR`, uses zsh glob with `(N)` null_glob, and skips cleanly when the directory doesn’t exist.

---

## 2. Modernize java.env.sh

- [x] Added opt-in Java installation via chezmoi prompt (`install_java`)
- [x] Added Java to `install-languages.sh` (conditional on `INSTALL_JAVA` env var)
- [x] Updated `java.env.sh` to use dynamic `/usr/libexec/java_home` detection
- [x] Fixed comment in `install-languages.sh` (asdf → mise)

---

## 3. Remove docker-machine from docker.rc.sh

- [ ] In `zsh/macos/docker.rc.sh`, remove the `dock()` and `undock()` functions (docker-machine is deprecated).
- [ ] Keep `dprune()` if you use it.
- [ ] Ensure shebang is `#!/bin/zsh`.

---

## Verification

- [ ] New zsh session loads without errors.
- [ ] `source_scripts` still loads all `*.env.sh` and `*.rc.sh` as before.
- [ ] Java and Docker behavior match your expectations (no reliance on docker-machine).
