# 7S-02: STANDARDS
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Applicable Standards

### Windows Standards
- **Environment Variables**: User-level registry storage via PowerShell
- **Installer Format**: Inno Setup 5/6 (.iss script format)
- **File Paths**: Windows backslash conventions with quoted paths

### Git Standards
- **Repository Access**: HTTPS URLs to github.com/simple-eiffel/*
- **Operations**: Clone for install, pull for update

### Eiffel Standards
- **ECF Discovery**: Libraries identified by presence of .ecf file
- **Naming**: Libraries follow simple_* naming convention
- **Environment Variables**: SIMPLE_* uppercase naming

## Design Patterns

1. **Manifest Pattern** - Centralized library registry with metadata
2. **Layered Architecture** - Foundation/Service/Platform/API layers
3. **Dependency Resolution** - Topological sort for installation order
4. **CLI Pattern** - Command with subcommands and options

## References

- Inno Setup Documentation: https://jrsoftware.org/ishelp/
- Git CLI Reference: https://git-scm.com/docs
- PowerShell Environment API: [Environment]::SetEnvironmentVariable
