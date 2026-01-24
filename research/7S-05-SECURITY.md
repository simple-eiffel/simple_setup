# 7S-05: SECURITY
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Security Considerations

### Threat Model

1. **Malicious Repository**: Compromised GitHub repo could inject code
2. **Environment Variable Manipulation**: Injected paths could redirect execution
3. **Installer Tampering**: Generated installer could be modified

### Mitigations

#### Repository Integrity
- Uses only github.com/simple-eiffel organization
- HTTPS for all git operations
- No arbitrary URL support in manifest

#### Environment Variables
- User-level only (no admin required)
- Known naming pattern (SIMPLE_*)
- Values are paths, not executables

#### Installer Security
- Inno Setup uses LZMA compression
- PrivilegesRequired=lowest (no admin)
- Source files copied from known location

### Limitations

- **No Package Signing**: Libraries not cryptographically verified
- **No Hash Verification**: Downloaded content not checksummed
- **Trust Model**: Relies entirely on GitHub org security

### Recommendations

1. Consider adding SHA256 verification of ECF files
2. Document organizational access controls
3. Add commit hash pinning for reproducible installs
