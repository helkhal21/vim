# vim-lunfardo Windows Bootstrap

This repository contains a small PowerShell script, `bootstrap.ps1`, that sets up the **vim-lunfardo** configuration on **Windows** so your Vim/Neovim experience matches your Linux setup.

The script is a Windows-friendly version of the original bash installer.

## Requirements

* Windows 10 or later
* PowerShell 5+ (default on modern Windows)
* At least one of:
  * Vim for Windows / gVim
  * Neovim for Windows
* Internet access (to download vim-plug and the vim-lunfardo `vimrc`)

## Usage

### 1. Clone or download this repo
```powershell
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
```

(or just download `bootstrap.ps1` into a folder under your user profile, e.g. `C:\Users\<you>\vim-bootstrap`)

### 2. (One time) Allow local scripts to run

Open PowerShell as your normal user (not necessarily admin) and run:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

This allows you to run locally created scripts while still blocking untrusted remote scripts.

### 3. Run the bootstrap script

From the folder where `bootstrap.ps1` lives:
```powershell
cd <path-to-folder-with-bootstrap.ps1>
.\bootstrap.ps1
```

You should see messages about:

* Backing up existing config (if any)
* Downloading vim-plug
* Downloading the vim-lunfardo `vimrc`
* Running `PlugInstall`
* Configuring Neovim (if found)

When it finishes, you'll see:
```
vim-lunfardo was installed (Windows version).
```

## Verifying the installation

Open your editor:

* Run `vim` or `gvim` from a command prompt / PowerShell, or
* Run `nvim` for Neovim

You should see:

* vim-plug loading
* The vim-lunfardo theme, mappings, and plugins

You can manually re-run plugin installation at any time with:
```vim
:PlugInstall
```

inside Vim/Neovim.

## Updating the configuration

To pull in updates from the vim-lunfardo `vimrc`:

### 1. Re-run `bootstrap.ps1`

This will:

* Overwrite your current `.vimrc` / `_vimrc` with the latest vim-lunfardo file
* Re-run `PlugInstall`

### 2. Or update plugins only:
```vim
:PlugUpdate
```

## Restoring your old configuration

Before modifying anything, the script copies existing config files and directories to `*.old`. For example:

* `.vim` → `.vim.old`
* `.vimrc` → `.vimrc.old`
* `_vimrc` → `_vimrc.old`
* `vimfiles` → `vimfiles.old`

If you want to go back to your old setup:

1. Close Vim/Neovim.
2. Rename the backups back to their original names, for example:
```powershell
Rename-Item $HOME\.vim.old    .vim    -Force
Rename-Item $HOME\.vimrc.old  .vimrc  -Force
Rename-Item $HOME\_vimrc.old  _vimrc  -Force
Rename-Item $HOME\vimfiles.old vimfiles -Force
```

## Troubleshooting

### "Could not find vim, gvim, or nvim on PATH"

* Make sure you've installed Vim, gVim, or Neovim and that the executable is in your `PATH`.
* Try opening a new PowerShell window after installing Vim/Neovim, then run:
```powershell
vim --version
# or
gvim --version
# or
nvim --version
```

If none of those commands work, add the appropriate install directory to your `PATH` or reinstall with the "add to PATH" option.

## Notes

* This script is meant to mirror the Linux bootstrap behavior as closely as possible while respecting Windows paths and conventions.
* All changes are made in your user profile directory (e.g., `C:\Users\<you>`), so it does not require admin rights.