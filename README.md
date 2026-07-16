# Mario

A small 2D platformer built in Godot 4.6.

## Local auto-commit safety net

Launch the project via the **Mario** shortcut on the Desktop (instead of opening Godot directly). That shortcut silently starts a watcher alongside Godot which, every 10 minutes *while Godot is running*, commits any uncommitted changes with an AI-generated commit message describing what changed. The watcher exits automatically the moment Godot closes, and does nothing at all if Godot isn't open (e.g. while gaming). This exists purely as a safety net against Godot editor bugs (e.g. scene-save mixups) that can silently corrupt a `.tscn`/`.tres` file on disk.

- Launcher shortcut: `Desktop\Mario.lnk` (pin this to the taskbar instead of a raw Godot shortcut)
- Silent entry point: `.cursor-autocommit/launch_mario_silent.vbs`
- Watcher script: `.cursor-autocommit/launch_mario.ps1` (git-ignored, machine-local only)
- Commit script: `.cursor-autocommit/autocommit.ps1`
- Logs: `.cursor-autocommit/watcher.log`, `.cursor-autocommit/autocommit.log`

If a scene ever looks wrong or won't open correctly, check `git log` — there's almost certainly a recent commit you can `git checkout -- <file>` back to.

Note: this is a plain local mechanism (Windows-only, no cloud), not a Cursor Automation — it won't show up in Cursor's Automations tab.
