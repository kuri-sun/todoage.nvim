# todoage.nvim

Neovim plugin that displays the age of TODO comments as inline virtual text.

## Requirements

- Neovim 0.10+ (for `vim.system`)
- `git` on `PATH`
- A tree-sitter parser installed for the languages you want annotated (`:TSInstall <lang>`)

## Installation

### lazy.nvim

```lua
{
  "kuri-sun/todoage.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = true,
}
```

## Usage

Annotations refresh automatically on:

- `BufReadPost` — opening a file
- `BufWritePost` — saving a file
- `FocusGained` — re-focusing Neovim (catches external `git pull`)

Manual trigger:

```
:Todoage
```

## Configuration

```lua
require("todoage").setup({
  keywords = { "TODO", "FIXME", "HACK", "XXX", "NOTE" },
  tiers = {
    aging  = 14,
    stale  = 60,
    fossil = 365,
  },
  format = function(age_days)
    if age_days < 365 then
      return string.format("(%d days)", age_days)
    end
    return string.format("(%.1f yrs)", age_days / 365)
  end,
})
```

Defaults:

```lua
{
  keywords = { "TODO", "FIXME", "HACK" },
  tiers = {
    aging  = 7,
    stale  = 30,
    fossil = 180,
  },
  format = function(age_days)
    return string.format("(%d days)", age_days)
  end,
}
```

`keywords` replaces the default list wholesale, not merges. If you want the defaults plus extras, list them all. `tiers` is merged key-by-key, so you can override just one threshold.

Each `tiers` value is the day count at which the next tier begins. `aging = 14` reads as "Fresh tops out at 14 days; day 14 and beyond is Aging."

`format` receives the age in days and must return a string. It controls only the text; the tier highlight color is applied separately. Errors in your `format` function are not caught — fix the function if annotations stop appearing.

## Age tiers

| Tier   | Range      | Default highlight   |
| ------ | ---------- | ------------------- |
| Fresh       | < 7 days        | `Comment`           |
| Aging       | < 30 days       | `WarningMsg`        |
| Stale       | < 180 days      | `WarningMsg` + bold |
| Fossil      | ≥ 180 days      | `ErrorMsg` + bold   |
| Uncommitted | not yet in git  | `Comment`           |

Uncommitted TODOs render as `(uncommitted)` — the label is intentional, not an age.

## Customizing colors

Colors are not exposed through `setup({})` — set the highlight groups directly. This way colorschemes can ship `Todoage*` definitions that just work, and your overrides survive `:colorscheme` changes the same way every other plugin's highlights do.

```lua
vim.api.nvim_set_hl(0, "TodoageFresh",       { fg = "#888888" })
vim.api.nvim_set_hl(0, "TodoageAging",       { fg = "#d7af5f" })
vim.api.nvim_set_hl(0, "TodoageStale",       { fg = "#d75f5f", bold = true })
vim.api.nvim_set_hl(0, "TodoageFossil",      { fg = "#ff0000", bold = true, underline = true })
vim.api.nvim_set_hl(0, "TodoageUncommitted", { fg = "#5f5f5f", italic = true })
```

## Behavior on non-git files

Buffers without a filename, files outside a git repository, and files not yet tracked render no annotations. No errors.

## Coexistence with other TODO plugins

Designed to complement `todo-comments.nvim` and similar plugins. `todoage.nvim` only adds end-of-line age annotations — it does not highlight the keyword itself, provide a quickfix list, or affect search.

## Known limitations

- Blame results are not cached — each refresh re-runs `git blame`.
- No fallback for filetypes without a tree-sitter parser.

## License

TBD
