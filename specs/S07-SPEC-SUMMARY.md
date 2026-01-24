# S07: SPECIFICATION SUMMARY
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## One-Line Description

CLI tool for installing, updating, and packaging the simple_* Eiffel library ecosystem on Windows.

## Key Specifications

| Aspect | Specification |
|--------|---------------|
| **Type** | CLI Application |
| **Platform** | Windows only |
| **Language** | Eiffel |
| **Dependencies** | simple_process, simple_console, simple_env, simple_template |
| **External Tools** | git, PowerShell, Inno Setup (optional) |

## Commands

| Command | Purpose |
|---------|---------|
| install <lib>... | Clone libraries from GitHub |
| update [--all\|<lib>...] | Pull latest changes |
| list | Show all available libraries |
| info <lib> | Display library details |
| status | Show installation status |
| generate-inno | Create .iss installer script |
| build-installer | Generate Windows .exe installer |
| help | Display usage information |

## Data Flow

1. **Install**: User -> CLI -> Git clone -> Filesystem -> Env var
2. **Update**: User -> CLI -> Git pull -> Filesystem
3. **Build**: User -> CLI -> Generate .iss -> iscc.exe -> .exe installer

## Critical Invariants

1. Libraries always install to `install_directory/library_name/`
2. Environment variables follow SIMPLE_* naming
3. Dependencies must be installed before dependents
4. Manifest is the single source of truth for library metadata
