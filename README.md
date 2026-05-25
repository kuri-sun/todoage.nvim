# todoage.nvim

Neovim plugin that displays the age of TODO comments as inline virtual text.

![demo](assets/demo.png)

## Requirements

- Neovim 0.10+ (for `vim.system`)
- `git` on `PATH`
- A tree-sitter parser installed for the languages you want annotated (`:TSInstall <lang>`)

## Installation

### lazy.nvim

```lua
{
  "kuri-sun/todoage.nvim",
}
```

## Usage

`:Todoage` - refresh the current buffer
`:TodoageEnable` - resume auto-refresh and re-annotate the current buffer
`:TodoageDisable` - clear all annotations and pause auto-refresh
`:TodoageToggle` - enable/disable

## Configuration

```lua
require("todoage").setup({
  keywords = { "TODO", "FIXME", "HACK", "XXX", "NOTE" },
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
  format = function(age_days)
    return string.format("(%d days)", age_days)
  end,
}
```

`keywords` replaces the default list wholesale, not merges. If you want the defaults plus extras, list them all. Each keyword must contain only letters, digits, and underscores — `setup()` raises an error otherwise.

`format` receives the age in days and must return a string. Errors in your `format` function are not caught — fix the function if annotations stop appearing.

## Customizing colors

Colors are not exposed through `setup({})` — set the highlight groups directly. This way colorschemes can ship `Todoage*` definitions that just work.

Two groups:

| Group                | Applies to                              | Default      |
| -------------------- | --------------------------------------- | ------------ |
| `Todoage`            | Committed TODOs — the `(N days)` label  | `Comment`    |
| `TodoageUncommitted` | TODOs not yet in git — `(uncommitted)`  | `Comment`    |

```lua
vim.api.nvim_set_hl(0, "Todoage",            { fg = "#888888" })
vim.api.nvim_set_hl(0, "TodoageUncommitted", { fg = "#5f5f5f", italic = true })
```

`:colorscheme` wipes all highlight groups. To have overrides survive theme switches, wrap them in a `ColorScheme` autocmd:

```lua
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Todoage", { fg = "#888888" })
    vim.api.nvim_set_hl(0, "TodoageUncommitted", { fg = "#5f5f5f", italic = true })
  end,
})
```

## Coexistence with other TODO plugins

Designed to complement `todo-comments.nvim` and similar plugins. `todoage.nvim` only adds end-of-line age annotations — it does not highlight the keyword itself, provide a quickfix list, or affect search.

## License

MIT
