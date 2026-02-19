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
