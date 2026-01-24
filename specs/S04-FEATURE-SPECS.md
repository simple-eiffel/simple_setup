# S04: FEATURE SPECIFICATIONS
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## SST_APPLICATION Features

### Command Execution
| Feature | Signature | Description |
|---------|-----------|-------------|
| execute_install | | Install specified libraries |
| execute_update | | Update libraries (--all or named) |
| execute_list | | List all available libraries by layer |
| execute_info | | Show detailed library information |
| execute_status | | Show installation status |
| execute_generate_inno | | Generate Inno Setup script |
| execute_build_installer | | Build Windows installer |
| execute_help | | Display usage help |

### Output Helpers
| Feature | Signature | Description |
|---------|-----------|-------------|
| print_line | (a_text: STRING) | Print with newline |
| print_error | (a_text: STRING) | Print in red |
| print_success | (a_text: STRING) | Print in green |

## SST_INSTALLER Features

### Operations
| Feature | Signature | Description |
|---------|-----------|-------------|
| install | (a_lib: SST_LIBRARY_INFO): BOOLEAN | Git clone library |
| update | (a_lib: SST_LIBRARY_INFO): BOOLEAN | Git pull library |
| uninstall | (a_lib: SST_LIBRARY_INFO): BOOLEAN | Remove library |
| install_all | : BOOLEAN | Install all with dependency order |

### Status
| Feature | Signature | Description |
|---------|-----------|-------------|
| is_installed | (a_lib: SST_LIBRARY_INFO): BOOLEAN | Check ECF exists |
| is_git_available | : BOOLEAN | Check git command works |
| install_path | (a_lib: SST_LIBRARY_INFO): STRING | Full installation path |

## SST_INNO_GENERATOR Features

### Generation
| Feature | Signature | Description |
|---------|-----------|-------------|
| generate | (a_version, a_output: STRING) | Write .iss file |
| generate_script_content | (a_version: STRING): STRING | Build full script |
| compile_installer | (a_script: STRING): BOOLEAN | Run iscc.exe |
