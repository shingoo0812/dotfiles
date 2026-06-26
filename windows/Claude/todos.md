# Claude TODO List

Pending tasks with trigger conditions for contextual reminders.

---

## [TODO-001] Define project CLAUDE.md template
**Status:** pending
**Trigger:** project has no CLAUDE.md
**Context:** Decided to standardize project CLAUDE.md structure. No template exists yet.
**Action:** Create a template based on dotfiles/CLAUDE.md structure. Apply when Claude starts in a new project without CLAUDE.md.

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
