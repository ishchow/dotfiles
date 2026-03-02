# Copilot Instructions

## Adding VS Code Extensions

When adding a new VS Code extension to this repo, update **both** of the following files:

1. **`chezmoi_home/.chezmoitemplates/vscode/extensions.txt`**
   - This is the shared chezmoi template used by both Linux (`~/.config/Code/User/extensions.txt`) and Windows (`AppData/Roaming/Code/User/extensions.txt`).
   - Add the extension ID (e.g. `publisher.extension-name`) on its own line.

2. **`bootstrap/Brewfile`**
   - This is the Homebrew bundle file used on macOS.
   - Add a line in the `vscode` section: `vscode "publisher.extension-name"`

### Example

To add the extension `yzhang.markdown-all-in-one`:

**`chezmoi_home/.chezmoitemplates/vscode/extensions.txt`**
```
yzhang.markdown-all-in-one
```

**`bootstrap/Brewfile`**
```ruby
vscode "yzhang.markdown-all-in-one"
```

### Notes

- The two consumer files (`chezmoi_home/dot_config/private_Code/User/extensions.txt.tmpl` and `chezmoi_home/AppData/Roaming/Code/User/extensions.txt.tmpl`) both render from the shared template — do **not** edit them directly.
- On Linux, extensions are installed via a chezmoi run-once script that reads the template output and runs `code --install-extension` for each entry.
- On macOS, `brew bundle` handles VS Code extension installation from the Brewfile.
- On Windows, extensions are managed via the rendered `extensions.txt` file.

## Adding Winget Packages (Windows)

Winget packages are installed on Windows via `winget import` during bootstrap. There are three JSON files under `bootstrap/`, split by category and install scope:

| File | Description | Scope |
|------|-------------|-------|
| `bootstrap/winget-packages-cli.json` | CLI tools (installed on all machines) | `machine` |
| `bootstrap/winget-packages-ui-machine.json` | GUI apps installed machine-wide (skipped on work dev boxes) | `machine` |
| `bootstrap/winget-packages-ui-user.json` | GUI apps installed per-user (skipped on work dev boxes) | `user` |

Choose the appropriate file based on whether the package is a CLI tool or a GUI app, and whether it should be installed machine-wide or per-user.

### How to add a package

Add a new entry to the `Packages` array in the relevant JSON file:

```json
{
    "PackageIdentifier": "Publisher.PackageName",
    "Scope": "machine"
}
```

- **`PackageIdentifier`** — the winget package ID (find it with `winget search <name>`).
- **`Scope`** — use `"machine"` or `"user"` to match the file's convention. If installation fails with an explicit scope, omit `Scope` and add an `"x-comment"` explaining why.
- **`x-comment`** (optional) — a human-readable note, e.g. for MS Store packages that use opaque IDs like `"9P1741LKHQS9"`.

### MS Store packages

For Microsoft Store apps, add the entry under the `msstore` source section (which uses `"Name": "msstore"` in `SourceDetails`) rather than the `winget` source section. Use the Store product ID as the `PackageIdentifier`.

### Example

To add `sharkdp.bat` as a CLI tool:

**`bootstrap/winget-packages-cli.json`** — add to the `Packages` array:
```json
{
    "PackageIdentifier": "sharkdp.bat",
    "Scope": "machine"
}
```

### Notes

- These files follow the [winget import/export schema v2.0](https://aka.ms/winget-packages.schema.2.0.json).
- The bootstrap script (`chezmoi_home/AppData/Local/ishaat/bootstrap/005_install_packages.ps1.tmpl`) runs `winget import` for each file.
- UI packages (both `ui-machine` and `ui-user`) are skipped on work dev boxes (controlled by the `.isWorkDevBox` chezmoi variable).
- If a counterpart exists on macOS, also add a `brew` or `cask` entry to `bootstrap/Brewfile`.

## Adding Neovim Plugins

Neovim plugins are managed via the built-in `vim.pack` package manager. Plugin specs live in `home/.config/nvim/plugin/01_pack.lua` and plugin configurations in `home/.config/nvim/plugin/03_plugins.lua`.

### Where to add the plugin spec

There are **two** `vim.pack.add()` blocks in `01_pack.lua`:

1. **Core editor plugins** (top-level block) — loaded in **both** native Neovim and VS Code Neovim extension. Use this for text-editing plugins that don't depend on Neovim UI (e.g., surround, autopairs, motions).

2. **Native-only plugins** (inside `if not vim.g.vscode`) — loaded **only** in native Neovim. Use this for anything that depends on Neovim UI, LSP, file management, completion, etc.

Add the plugin URL string to the appropriate block:

**`home/.config/nvim/plugin/01_pack.lua`**
```lua
-- Core (VSCode + Native):
vim.pack.add({
  'https://github.com/user/plugin',
})

-- Native-only:
if not vim.g.vscode then
    vim.pack.add({
        'https://github.com/user/plugin',
    })
end
```

### Where to add plugin configuration

Add `require("plugin").setup({})` (or equivalent) to `home/.config/nvim/plugin/03_plugins.lua`, in the matching section:

- **Common Editor Plugins** section — for plugins in the core block.
- **Native-Only Plugins** section (inside `if not vim.g.vscode`) — for native-only plugins.

### LSP server configs

LSP servers use the native `vim.lsp.config` / `vim.lsp.enable` API (Neovim 0.11+). The `nvim-lspconfig` plugin provides base configs in its `lsp/` directory.

- **Enable a server**: add its name to the `vim.lsp.enable({})` call in `03_plugins.lua`.
- **Override server settings**: create `home/.config/nvim/after/lsp/<server>.lua` returning a config table. This merges on top of nvim-lspconfig's base. Only include overrides, not the full config.
- **Install the server binary externally** (via `mise`, `brew`, etc.) — we don't use Mason.

### vim.pack management commands

The lockfile is at `home/.config/nvim/nvim-pack-lock.json`. Useful commands:

| Task | Command |
|------|---------|
| Delete a plugin from disk | `:lua vim.pack.del({ 'plugin-name' })` |
| Force update to lockfile rev | `:lua vim.pack.update({ 'plugin-name' }, { offline = true, target = 'lockfile' })` |
| Update all plugins | `:lua vim.pack.update()` |
| Update specific plugin | `:lua vim.pack.update({ 'plugin-name' })` |
| List non-active (orphaned) plugins | `:lua =vim.iter(vim.pack.get()):filter(function(x) return not x.active end):map(function(x) return x.spec.name end):totable()` |

### Notes

- After removing a plugin spec from `01_pack.lua`, restart Neovim, then run `:lua vim.pack.del({ 'plugin-name' })` to clean it from disk.
- Plugins that ship prebuilt binaries (e.g., `blink.cmp`) need their lockfile `rev` to point to a **release tag commit** — not an arbitrary commit on `main`. Check the plugin's releases page for the correct commit hash.
- The lockfile should be committed to version control. On a new machine, `vim.pack` auto-installs all lockfile entries on first startup.
