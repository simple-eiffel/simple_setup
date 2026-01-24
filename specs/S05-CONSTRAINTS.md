# S05: CONSTRAINTS
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Technical Constraints

### Platform
- **Windows Only**: Uses PowerShell for env vars, rmdir for uninstall
- **Git Required**: Must have git.exe in PATH
- **Inno Setup Optional**: Only needed for installer builds

### Dependencies
- All libraries must exist in github.com/simple-eiffel organization
- Libraries must have standard ECF naming (library_name.ecf)
- Installation directory must be writable (default: D:\prod)

### Naming Conventions
- Library names: simple_* prefix
- Environment variables: SIMPLE_* uppercase
- ECF files: {library_name}.ecf

## Design Constraints

### Manifest-Driven
- All libraries must be pre-registered in SST_MANIFEST
- No dynamic discovery of libraries
- Dependencies must be explicitly declared

### Git-Only Distribution
- No support for zip/tarball downloads
- No private repository support (no auth)
- Always gets latest (no version pinning)

### Single Installation Directory
- All libraries install to same parent folder
- No per-user vs system-wide options
- No alternate installation paths per library

## Operational Constraints

### Network Required
- Installation requires internet (GitHub access)
- No offline mode
- No caching of downloads

### User-Level Only
- Environment variables set at user level
- No system-wide installation option
- PrivilegesRequired=lowest for installer
