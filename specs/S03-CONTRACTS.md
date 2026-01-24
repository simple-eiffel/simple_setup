# S03: CONTRACTS
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Design by Contract Summary

### SST_INSTALLER Contracts

```eiffel
make (a_manifest: SST_MANIFEST)
    -- Create installer with manifest

set_install_directory (a_path: STRING)
    require
        path_not_empty: not a_path.is_empty
    ensure
        directory_set: install_directory = a_path

install (a_lib: SST_LIBRARY_INFO): BOOLEAN
    -- Install a library from GitHub
    -- Returns True on success, sets last_error on failure
    ensure
        error_on_failure: not Result implies last_error /= Void
```

### SST_LIBRARY_INFO Contracts

```eiffel
make (a_name, a_description, a_layer, a_github: STRING)
    require
        name_not_empty: not a_name.is_empty
    ensure
        name_set: name = a_name
```

### SST_MANIFEST Contracts

```eiffel
library_by_name (a_name: STRING): detachable SST_LIBRARY_INFO
    -- Find library by name, Void if not found
```

## Class Invariants

### SST_INSTALLER
```eiffel
invariant
    manifest_exists: manifest /= Void
    process_exists: process /= Void
```

### SST_LIBRARY_INFO
```eiffel
invariant
    name_exists: name /= Void
    dependencies_exist: dependencies /= Void
```

## Contract Coverage

| Class | Preconditions | Postconditions | Invariants |
|-------|---------------|----------------|------------|
| SST_APPLICATION | Low | Low | None |
| SST_INSTALLER | Medium | Medium | Implicit |
| SST_INNO_GENERATOR | Low | Low | None |
| SST_ENV_MANAGER | Low | Low | None |
| SST_MANIFEST | Low | Low | None |
| SST_LIBRARY_INFO | Medium | Medium | Implicit |
