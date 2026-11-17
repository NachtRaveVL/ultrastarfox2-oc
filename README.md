# UltraStarFox2 Overclocked

Star Fox 2 source code adapted for overclocked SuperFX cartridge development.

> **NR-RetroWorks fork notice:** This repository is an overclocking-focused fork of the original [UltraStarFox2 project](https://github.com/Sunlitspace542/ultrastarfox2), maintained by NachtRaveVL for use with the **26/33MHz+ SuperFX overclocking PCB** sold through [NR-RetroWorks on Etsy](https://www.etsy.com/shop/NachtRaveRetroWerks). The upstream repository remains the general-purpose source project.
>
> **Two source layouts are provided:** **1MB Original** retains the more original, non-folderized layout for the GSU-1 cartridge target; **2MB Folderized** retains the reorganized source tree for GSU-2 builds and emulator development. These are distinct build targets; do not assume that output for one is interchangeable with the other.
>
> **The hardware overclock is external:** a replacement clock source drives the SuperFX hardware. Source-level configuration and timing work are separate from the physical clock change.

Go [here](#building) to jump straight to the build instructions.

## Credits (A-Z)

- **Argonaut Software and Nintendo** — Original Star Fox 2 development.
- **Kandowontu** — Contributor to the UltraStarFox2 project.
- **Nachtrave** - Optimizations, overclocking/elapsed time fixes, FASTROM support
- **Sunlit** — UltraStarFox2 upstream maintainer and source-tree/toolchain work.

## Features

### Cartridge Hardware Support and ROM Configuration

- Intended for real **GSU-1/2 SuperFX hardware overclocked to approximately 26/33MHz+** using the NR-RetroWorks overclocking adapter PCB
- Super FX clock divider disabled via `fast equ 1`
- Super FX MS1 high-speed multiply enabled
- FastROM support
- MSU-1 support

### QOL / Ease-of-use

- Separate source trees make the physical-cartridge and folderized build targets easier to identify.
- PAL version support in the folderized tree (StarWing 2 logo by Josete2k, edited by Sunlit).

### Miscellaneous

- **Kando and Randy were involved so you know it's good**

## Notes

- **This codebase can be difficult to work with.** In source, the Normal, Hard, and Expert difficulties are called Easy, Normal, and Hard.
- Many source files use DOS (CP437) encoding. Message files are in UTF-8.
- The original assembler expects DOS/Windows (CRLF) line endings; configure your editor accordingly.
- The 1 MB and 2 MB layouts use different paths and build scripts. Enter the appropriate directory before building.

## Building

### Building on Windows

**Requirements:** Microsoft Windows, the repository's assembler/toolchain, and DOSBox-X as used by the supplied command scripts.

For **1MB Original**, open `1MB Original/` and run `build.cmd` (or `build to log.cmd` for a logged build).

For **2MB Folderized**, open `2MB Folderized/` and run `build.cmd`; `build to log.cmd` and `clean.cmd` are also provided.

When a build succeeds, check the output and symbol/map reports produced by that specific build script. Do not assume both trees emit the same file names or ROM sizes without checking.

### Building on Linux / WSL

**Requirements:** An environment able to run DOSBox-X and the supplied DOS toolchain. The folderized tree contains a Makefile that invokes DOSBox-X.

```bash
git clone https://github.com/NachtRaveVL/ultrastarfox2-oc.git
cd ultrastarfox2-oc/'2MB Folderized'
make        # build
make log    # build with logging
make clean  # clean build files
```

The `1MB Original` tree uses its own Windows/DOS build scripts; it does not provide the same root-level Makefile interface.

### Uploading to SNES with SD2SNES / FXPAK Pro

The folderized source tree includes USB upload command scripts. These require the appropriate [QUsb2Snes](https://github.com/Skarsnik/QUsb2snes/releases) setup and connected compatible hardware. Build and verify the correct ROM variant before uploading.

## Contributing

Pull requests and corrections are welcome. Open changes against this fork's [`master`](https://github.com/NachtRaveVL/ultrastarfox2-oc/tree/master) branch. Please preserve historical developer credits and the birthday messages in the source.

## Helpful Links/Tools

[NR-RetroWorks](https://nr-retroworks.com/)  
[NR-RetroWorks on Etsy](https://www.etsy.com/shop/NachtRaveRetroWerks)  
[NR-RetroWorks on Patreon](https://www.patreon.com/nachtrave)  
[Original UltraStarFox2 Repository](https://github.com/Sunlitspace542/ultrastarfox2)  
[ArgSfx/SASM Assembler Manual](https://github.com/Sunlitspace542/ArgSfx-SASM-Docs/tree/main)  
[Super FX (MARIO) Chip ASM Reference](https://en.m.wikibooks.org/wiki/Super_NES_Programming/Super_FX_tutorial)  
[fullsnes — SNES Hardware Specifications](https://problemkaputt.de/fullsnes.htm)

## Project Structure

```text
ultrastarfox2-oc
├── 1MB Original: Original 1MB ROM layout for GSU-1 hardware
│   ├── sf2: Main source code directory
│   │   ├── *.ASM: Main game code (65816)
│   │   ├── *.MC: Super FX (MARIO) assembly code
│   │   ├── *.INC: Assembly includes and configuration
│   │   ├── *.EXT: External symbol declarations
│   │   ├── DATA: Graphics and other game data
│   │   ├── MAPS: Level scripts
│   │   ├── MSPRITES: Super FX textures
│   │   └── SND: Sound and music data
│   ├── BUILD.BAT: ROM build script
│   ├── BLDtolog.BAT: Build with logging
│   ├── build.cmd: DOSBox build launcher
│   ├── build to log.cmd: Logging build launcher
│   └── dosbox-x.conf: DOSBox-X configuration
├── 2MB Folderized: Expanded ROM layout for GSU-2 hardware
│   ├── SF2: Main source code directory
│   │   ├── ASM: Main game code (65816)
│   │   ├── BANK: ROM bank data and assembly files
│   │   ├── CONFIG: Game and ROM configuration
│   │   ├── DATA: Graphics and other game data
│   │   ├── EXT: External symbol declarations
│   │   ├── FONT: Font graphics and data
│   │   ├── INC: Assembly includes and lookup tables
│   │   ├── MAPS: Level scripts
│   │   ├── MARIO: Super FX (MARIO) assembly code
│   │   ├── MSG: English and Japanese text
│   │   ├── MSPRITES: Interleaved Super FX textures
│   │   ├── PATH: Object behavior scripts
│   │   ├── SHAPES: Model and shape data
│   │   ├── SOUND: Sound and music data
│   │   └── STRAT: Object strategy code
│   ├── TOOLS: Build and content utilities
│   ├── docs: Star Fox 2 technical documentation
│   ├── optionalstuff: Optional graphics and assets
│   ├── BUILD.BAT: ROM build script
│   ├── Makefile: Linux build automation
│   └── dosbox-x.conf: DOSBox-X configuration
└── README.md: Project overview and build documentation
```
