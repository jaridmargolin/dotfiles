# Phase 2: Chezmoi fixes

**Risk:** Medium  
**Prerequisite:** Phase 1 done (or at least no dependency on phase 1).

---

## Problem

The `run_onchange` scripts contain sha256sum template lines **inside comments** (with a `#` prefix). Chezmoi does not treat those as template directives, so the scripts run on **every** `chezmoi apply` instead of only when their source files change.

---

## 1. Uncomment sha256sum in run_onchange scripts

For each file below, change the line so the `{{ include ... | sha256sum }}` is **not** commented out. Keep any human-readable comment on a separate line above it.

**Rule:** Remove the leading `#` from the line that contains `{{ include ... | sha256sum }}` so that line is rendered as template output (the hash will appear in the script body and drive change detection).

### Files to edit

- [ ] `.chezmoiscripts/run_onchange_after_00-sync-settings.sh.tmpl`  
  Uncomment the sha256sum line that references `scripts/macos/sync-settings.sh`.

- [ ] `.chezmoiscripts/run_onchange_after_01-install-utils.sh.tmpl`  
  Uncomment the sha256sum line that references `scripts/common/install-utils.sh`.

- [ ] `.chezmoiscripts/run_onchange_after_02-install-packages.sh.tmpl`  
  Uncomment the sha256sum line(s) that reference the install script and/or Brewfile (as documented in the script comments).

- [ ] `.chezmoiscripts/run_onchange_after_03-install-languages.sh.tmpl`  
  Uncomment the sha256sum line(s) that reference the install script and/or Brewfile (as documented in the script comments).

**Example change:**

From:

```sh
# run if the following files change:
# Ref: https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/
# {{ include (printf "%s/scripts/common/install-utils.sh" .chezmoi.sourceDir) | sha256sum }}
```

To:

```sh
# run if the following files change:
# Ref: https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/
{{ include (printf "%s/scripts/common/install-utils.sh" .chezmoi.sourceDir) | sha256sum }}
```

---

## 2. Verify change detection

- [ ] Run `chezmoi apply` once (scripts may run).
- [ ] Run `chezmoi apply` again without changing any source file; the run_onchange scripts should **not** run (or only run if their source files actually changed).
- [ ] Change one of the source files referenced by a run_onchange script (e.g. add a comment to `scripts/common/install-utils.sh`), run `chezmoi apply` again, and confirm the corresponding script runs.

---

## Verification

- [ ] No errors from `chezmoi apply`.
- [ ] Second apply with no edits does not re-run run_onchange scripts.
- [ ] Editing a referenced file and applying does trigger the right script.
