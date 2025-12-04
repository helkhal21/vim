# bootstrap.ps1 - Windows version of vim-lunfardo bootstrap
$ErrorActionPreference = "Stop"

function Die {
    param([string]$Message)
    Write-Host $Message
    exit 1
}

function Backup {
    # Back up any existing Vim configs
    $paths = @(
        "$HOME\.vim",
        "$HOME\.vimrc",
        "$HOME\_vimrc",
        "$HOME\vimfiles"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            $backup = "$path.old"
            Write-Host "$path has been copied to $backup"
            Copy-Item -Path $path -Destination $backup -Recurse -Force
        }
    }
}

function Download-Plug {
    # Use vimfiles/autoload on Windows
    $autoloadDir = Join-Path $HOME "vimfiles\autoload"
    if (!(Test-Path $autoloadDir)) {
        New-Item -ItemType Directory -Force -Path $autoloadDir | Out-Null
    }

    $plugPath = Join-Path $autoloadDir "plug.vim"
    if (!(Test-Path $plugPath)) {
        Write-Host "Downloading vim-plug..."
        Invoke-WebRequest `
            -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" `
            -OutFile $plugPath `
            -UseBasicParsing
    }
}

function Download-Vimrc {
    # On Windows Vim, _vimrc is the canonical name, but we can also write .vimrc
    $vimrcUrl = "https://raw.githubusercontent.com/unbalancedparentheses/vim-lunfardo/master/vimrc"

    $dotVimrc = Join-Path $HOME ".vimrc"
    $underVimrc = Join-Path $HOME "_vimrc"

    Write-Host "Downloading vim-lunfardo vimrc..."
    Invoke-WebRequest -Uri $vimrcUrl -OutFile $dotVimrc -UseBasicParsing
    Copy-Item $dotVimrc $underVimrc -Force  # ensure Windows Vim sees it
}

function Install-Plugins {
    # Try vim first, then nvim
    if (Get-Command vim -ErrorAction SilentlyContinue) {
        Write-Host "Running PlugInstall in vim..."
        vim -c "PlugInstall | qa" | Out-Null
    }
    elseif (Get-Command gvim -ErrorAction SilentlyContinue) {
        Write-Host "Running PlugInstall in gvim..."
        gvim -c "PlugInstall | qa" | Out-Null
    }
    elseif (Get-Command nvim -ErrorAction SilentlyContinue) {
        Write-Host "Running PlugInstall in nvim..."
        nvim -c "PlugInstall | qa" | Out-Null
    }
    else {
        Die "Could not find vim, gvim, or nvim on PATH. Install one of them first."
    }
}

function Nvim-Support {
    # Make Neovim use the same config
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        # Neovim on Windows uses %LOCALAPPDATA%\nvim\init.vim or ~/.config/nvim/init.vim
        $nvimDir = Join-Path $env:LOCALAPPDATA "nvim"
        if (!(Test-Path $nvimDir)) {
            New-Item -ItemType Directory -Force -Path $nvimDir | Out-Null
        }

        $initVim = Join-Path $nvimDir "init.vim"
        $underVimrc = Join-Path $HOME "_vimrc"

        Write-Host "Configuring Neovim to use vim-lunfardo vimrc..."
        Copy-Item $underVimrc $initVim -Force
    }
}

# Run steps
Backup
Download-Plug
Download-Vimrc
Install-Plugins
Nvim-Support

Write-Host "vim-lunfardo was installed (Windows version)."
