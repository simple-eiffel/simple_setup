<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# SIMPLE_SETUP

**[Documentation](https://simple-eiffel.github.io/simple_setup/)** | **[GitHub](https://github.com/simple-eiffel/simple_setup)**

### Package Manager and Windows Installer Generator for the simple_* Ecosystem

[![Language](https://img.shields.io/badge/language-Eiffel-blue.svg)](https://www.eiffel.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()
[![SCOOP](https://img.shields.io/badge/SCOOP-compatible-brightgreen.svg)]()

---

## Overview

SIMPLE_SETUP is a command-line package manager and installer generator for the simple_* ecosystem of Eiffel libraries. It provides:

- **Library Installation** - Clone libraries from GitHub and set up environment variables
- **Library Updates** - Pull latest changes for installed libraries
- **Status Tracking** - See which libraries are installed
- **Inno Setup Integration** - Generate professional Windows installers

The library handles all 50+ simple_* libraries with proper dependency management, ensuring libraries are installed in the correct order.

**Developed using AI-assisted methodology:** Built interactively with Claude Opus 4.5 following rigorous Design by Contract principles.

---

## Quick Start

### Installation

1. Clone the repository:

```bash
git clone https://github.com/simple-eiffel/simple_setup.git
```

2. Set the environment variable:

```powershell
[Environment]::SetEnvironmentVariable('SIMPLE_SETUP', 'D:\prod\simple_setup', 'User')
```

3. Add to your ECF file:

```xml
<library name="simple_setup" location="$SIMPLE_SETUP\simple_setup.ecf"/>
```

### Building

```bash
cd simple_setup
ec -config simple_setup.ecf -target simple_setup -c_compile
```

### Running Tests

```bash
ec -config simple_setup.ecf -target simple_setup_tests -c_compile
./EIFGENs/simple_setup_tests/W_code/simple_setup.exe
```

---

## Commands

| Command | Description |
|---------|-------------|
| `install <lib>...` | Install one or more libraries from GitHub |
| `update [--all]` | Update installed libraries |
| `list` | List all available libraries by layer |
| `info <lib>` | Show detailed library information |
| `status` | Show which libraries are installed |
| `generate-inno` | Generate Inno Setup script |
| `build-installer` | Build Windows installer |
| `help` | Show usage information |

### Examples

```bash
simple_setup install simple_json simple_csv
simple_setup update --all
simple_setup status
simple_setup build-installer --version=1.0.0
```

---

## Library Layers

| Layer | Description | Examples |
|-------|-------------|----------|
| **Foundation** | Core utilities, no dependencies | json, csv, hash, uuid, regex |
| **Platform** | OS-specific features | env, console, registry, win32_api |
| **Service** | Higher-level services | sql, smtp, jwt, http, encryption |
| **API** | Aggregate facades | foundation_api, service_api, web |

---

## Dependencies

Uses these simple_* libraries:
- simple_json, simple_process, simple_env, simple_console, simple_template, simple_testing

---

## Resources

- **Organization:** https://github.com/simple-eiffel
- **Inno Setup:** https://jrsoftware.org/isinfo.php
- **Eiffel:** https://www.eiffel.org/

---

## License

MIT License - see [LICENSE](LICENSE) file.

---

**Author:** Larry Rix
**Built with:** Claude Opus 4.5 (Anthropic)
