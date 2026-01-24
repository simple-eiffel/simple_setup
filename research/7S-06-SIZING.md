# 7S-06: SIZING
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Current Size

### Source Files
- **Classes**: 6 Eiffel classes
- **Lines**: ~900 lines of Eiffel code
- **Test Classes**: 2

### Class Breakdown
| Class | Lines | Responsibility |
|-------|-------|----------------|
| SST_APPLICATION | 447 | CLI entry point and commands |
| SST_INSTALLER | 223 | Git operations for install/update |
| SST_INNO_GENERATOR | 302 | Inno Setup script generation |
| SST_ENV_MANAGER | 176 | Environment variable management |
| SST_MANIFEST | 146 | Library metadata registry |
| SST_LIBRARY_INFO | 79 | Individual library metadata |

## Complexity Assessment

- **Cyclomatic Complexity**: Low (simple command dispatch)
- **Coupling**: Moderate (depends on 4 simple_* libraries)
- **Library Count in Manifest**: 40+ libraries defined

## Growth Projections

- Manifest grows as ecosystem grows
- Core logic remains stable
- Potential additions: version pinning, dependency graphs
