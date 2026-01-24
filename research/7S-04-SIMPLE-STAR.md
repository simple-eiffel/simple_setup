# 7S-04: SIMPLE-STAR ECOSYSTEM
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Ecosystem Dependencies

### Uses (Dependencies)
- **simple_process** - Executes git and PowerShell commands
- **simple_console** - Colored terminal output
- **simple_env** - Environment variable access (via inheritance)
- **simple_template** - Inno Setup script generation

### Used By (Dependents)
- No libraries depend on simple_setup (it's a CLI tool)

## Integration Points

### SIMPLE_PROCESS Usage
```eiffel
process.run ("git clone " + url + " " + path)
if process.succeeded then
    -- Installation complete
end
```

### SIMPLE_CONSOLE Usage
```eiffel
console.set_foreground (console.Green)
print ("Success!")
console.reset_color
```

### SIMPLE_TEMPLATE Usage
```eiffel
create l_template.make_from_string (header_template)
l_template.set_variable ("version", a_version)
Result := l_template.render
```

## Ecosystem Role

simple_setup is the **meta-tool** for the simple_* ecosystem - it manages all other libraries but isn't a dependency for any of them.
