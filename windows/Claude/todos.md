# Claude TODO List

Pending tasks with trigger conditions for contextual reminders.

---

## [TODO-001] Define project CLAUDE.md template
**Status:** done
**Trigger:** project has no CLAUDE.md
**Context:** Templates created at ~/.claude/templates/. Three files: CLAUDE.md.tmpl, overview.md.tmpl, notes.md.tmpl.
**Action:** When SessionStart reports no CLAUDE.md, offer to create from ~/.claude/templates/CLAUDE.md.tmpl.

---

## [TODO-002] Automate Stop hook - git commit
**Status:** pending
**Trigger:** any session
**Context:** Stop hook currently only notifies about uncommitted changes. Should auto-commit with Ollama-drafted message for both current repo and dotfiles.
**Action:** Implement auto-commit in stop-git-check.ps1 with ollama_draft_commit.

---

## [TODO-003] Automate CLAUDE.md updates
**Status:** pending
**Trigger:** any session
**Context:** CLAUDE.md updates depend on Claude remembering. Need criteria + PreCompact or Stop hook to detect when update is needed.
**Action:** Define update criteria. Implement hook (settings.json changed, hooks/ changed, user correction detected).

---
