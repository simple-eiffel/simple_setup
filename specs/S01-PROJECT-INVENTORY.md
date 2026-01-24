# S01: PROJECT INVENTORY
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Project Structure

```
simple_setup/
├── src/
│   ├── sst_application.e      # CLI entry point
│   ├── sst_installer.e        # Git install/update operations
│   ├── sst_inno_generator.e   # Inno Setup script generation
│   ├── sst_env_manager.e      # Environment variable management
│   ├── sst_manifest.e         # Library registry
│   └── sst_library_info.e     # Library metadata
├── testing/
│   ├── test_app.e             # Test runner
│   └── lib_tests.e            # Test suite
├── research/                   # 7S research documents
├── specs/                      # Specification documents
└── simple_setup.ecf           # Project configuration
```

## Source Files

| File | Type | Lines | Purpose |
|------|------|-------|---------|
| sst_application.e | Main | 447 | CLI commands and dispatch |
| sst_installer.e | Core | 223 | Git clone/pull operations |
| sst_inno_generator.e | Generator | 302 | .iss script creation |
| sst_env_manager.e | Utility | 176 | PowerShell env var calls |
| sst_manifest.e | Data | 146 | Library catalog |
| sst_library_info.e | Data | 79 | Single library record |

## Dependencies

### External Libraries
- EiffelBase (standard library)
- simple_process
- simple_console
- simple_env
- simple_template

### Test Dependencies
- None (basic test harness)
