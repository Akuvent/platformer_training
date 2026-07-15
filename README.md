# Mario

A small 2D platformer built in Godot 4.6.

## Local auto-commit safety net

This project runs a local scheduled task every few minutes that automatically commits any uncommitted changes, with an AI-generated commit message describing what changed. This exists purely as a safety net against Godot editor bugs (e.g. scene-save mixups) that can silently corrupt a `.tscn`/`.tres` file on disk.

- Script: `.cursor-autocommit/autocommit.ps1` (git-ignored, machine-local only)
- Log: `.cursor-autocommit/autocommit.log`
- Scheduled task name: `MarioAutoCommit` (Windows Task Scheduler)

If a scene ever looks wrong or won't open correctly, check `git log` — there's almost certainly a recent commit you can `git checkout -- <file>` back to.
