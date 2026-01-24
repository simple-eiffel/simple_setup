# S06: BOUNDARIES
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## System Boundaries

```
┌─────────────────────────────────────────────────────┐
│                   simple_setup                       │
│  ┌─────────────────────────────────────────────┐   │
│  │              SST_APPLICATION                 │   │
│  │  (CLI parsing, command dispatch, output)    │   │
│  └─────────────────────────────────────────────┘   │
│         │              │              │             │
│         ▼              ▼              ▼             │
│  ┌───────────┐  ┌───────────────┐  ┌──────────┐   │
│  │ INSTALLER │  │ INNO_GENERATOR│  │ENV_MANAGER│   │
│  └───────────┘  └───────────────┘  └──────────┘   │
│         │              │              │             │
└─────────│──────────────│──────────────│─────────────┘
          │              │              │
          ▼              ▼              ▼
    ┌───────────┐  ┌───────────┐  ┌───────────┐
    │    Git    │  │Inno Setup │  │ PowerShell│
    │ (clone/   │  │ (iscc.exe)│  │  ([Env])  │
    │  pull)    │  │           │  │           │
    └───────────┘  └───────────┘  └───────────┘
          │              │
          ▼              ▼
    ┌───────────┐  ┌───────────┐
    │  GitHub   │  │ .exe      │
    │  Repos    │  │ Installer │
    └───────────┘  └───────────┘
```

## Interface Boundaries

### CLI Interface
- **Input**: Command-line arguments (ARGUMENTS_32)
- **Output**: Colored console text (SIMPLE_CONSOLE)
- **Exit Codes**: Standard 0=success convention

### Git Interface
- **Protocol**: HTTPS to github.com
- **Commands**: clone, pull, -C (directory change)
- **Error Handling**: Check process exit code

### PowerShell Interface
- **Commands**: [Environment]::SetEnvironmentVariable/GetEnvironmentVariable
- **Scope**: 'User' level only
- **Error Handling**: Check process output

### Inno Setup Interface
- **Input**: Generated .iss script file
- **Output**: Compiled .exe installer
- **Paths**: Auto-detected from common install locations
