# 7S-01: SCOPE
**Library**: simple_setup
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## What Problem Does This Solve?

simple_setup addresses the complexity of managing the simple_* ecosystem installation:
- Installing multiple interdependent libraries from GitHub
- Managing environment variables for each library
- Building Windows installers with Inno Setup
- Tracking installation state across 50+ libraries

## Target Users

1. **Ecosystem Developers** - Need complete library installation
2. **End Users** - Want simple installer for all libraries
3. **Build Engineers** - Generate distributable Windows installers

## Domain

Package management and Windows installer generation for Eiffel libraries.

## In-Scope

- CLI application for install/update/list/info/status commands
- GitHub-based library installation via git clone
- Environment variable management via PowerShell
- Inno Setup script generation
- Dependency resolution and ordering
- Library manifest with metadata

## Out-of-Scope

- Linux/macOS installation support
- Version management (always uses latest)
- Compilation of installed libraries
- Package signing or verification
