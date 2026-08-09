# Git

## Gitsigns

Shows git diff information in the sign column and provides hunk operations.

### Sign column icons

| Status | Icon | Symbol |
|---|---|---|
| Added line | `┃` | BoldLineMiddle |
| Changed line | `┋` | BoldLineDashedMiddle |
| Deleted line | `` | TriangleShortArrowRight |
| Top delete | `` | TriangleShortArrowRight |
| Change+delete | `┃` | BoldLineMiddle |

### Keymaps

| Key | Action | Description |
|---|---|---|
| `<leader>gj` | Next hunk | Jump to next git change |
| `<leader>gk` | Prev hunk | Jump to previous git change |
| `<leader>gp` | Preview hunk | Show diff in floating window |
| `<leader>gr` | Reset hunk | Discard changes in current hunk |
| `<leader>gs` | Stage hunk | Stage current hunk |
| `<leader>gu` | Undo stage | Unstage current hunk |
| `<leader>gR` | Reset buffer | Discard all changes in buffer |
| `<leader>gl` | Blame | Show git blame for current line |
| `<leader>gd` | Diff HEAD | Show diff against HEAD |

### Blame

Inline blame shows the author, date, and commit message summary on the current line:

```
author, 2024-01-15 - Fix: update config
```

Updated with 200ms debounce — no performance hit.

### Preview

Hunk preview opens a floating window above the cursor with minimal style and rounded border. Relative to cursor position.

### Watch

Git directory is watched with 1-second interval, following file renames. Updates signs automatically. Attaches to untracked files. Disabled for files >40,000 lines.

---

## LazyGit

Full-featured terminal-based Git UI. Toggle with `<leader>gg`.

All commands (`LazyGit`, `LazyGitConfig`, `LazyGitCurrentFile`, `LazyGitFilter`, `LazyGitFilterCurrentFile`) are available.
