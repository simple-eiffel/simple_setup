# S02: CLASS CATALOG
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Class Hierarchy

```
ARGUMENTS_32
└── SST_APPLICATION (main CLI application)

SIMPLE_ENV
└── SST_ENV_MANAGER (environment management)

ANY
├── SST_INSTALLER (git operations)
├── SST_INNO_GENERATOR (script generation)
├── SST_MANIFEST (library registry)
└── SST_LIBRARY_INFO (library metadata)
```

## Class Descriptions

### SST_APPLICATION
**Purpose**: Command-line interface entry point
**Responsibilities**:
- Parse command-line arguments
- Dispatch to appropriate command handlers
- Format colored console output
**Key Features**: install, update, list, info, status, generate-inno, build-installer, help

### SST_INSTALLER
**Purpose**: Handle git operations for library management
**Responsibilities**:
- Clone libraries from GitHub
- Pull updates for installed libraries
- Check installation status
- Resolve dependency order

### SST_INNO_GENERATOR
**Purpose**: Generate Windows installer scripts
**Responsibilities**:
- Generate Inno Setup .iss files
- Include all libraries with exclusions
- Generate Pascal code for env var setup
- Compile using iscc.exe

### SST_ENV_MANAGER
**Purpose**: Manage user environment variables
**Responsibilities**:
- Set/get/remove user-level env vars via PowerShell
- Generate batch/PowerShell setup scripts
- Read current environment values

### SST_MANIFEST
**Purpose**: Central registry of all libraries
**Responsibilities**:
- Store library metadata
- Group by layer (foundation/service/platform/api)
- Lookup by name

### SST_LIBRARY_INFO
**Purpose**: Metadata for a single library
**Attributes**: name, description, layer, github_url, dependencies, tags
