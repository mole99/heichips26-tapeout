# HeiChips 2025 Tapeout

![heichips25.jpg](img/heichips25.jpg)

This repository contains the chip for the [HeiChips Summer School 2025](https://heichips.github.io/). It includes several designs created during the Hackathon all connected to a common eFPGA fabric in the center.
Thanks to FABulous, the user bitstream for the FPGA can be generated using the upstream yosys and nextpnr toolchain.

The chip is designed with open source EDA tools and the [IHP Open Source PDK](https://github.com/IHP-GmbH/IHP-Open-PDK).

> [!WARNING]
> This repository is a Work in Progress.

<p align="center">
  <a href="img/heichips25_top_white.png">
    <img src="img/heichips25_top_white_small.png" alt="chip layout" width=40%>
  </a>
</p>

## Feature Overview

The chip includes several user submitted designs from the HeiChips 2025 Hackathon. In the center of the chip is an eFPGA which allows the user projects to connect to each other, utilize the SRAM or connect to the external I/Os.

- [FABulous](https://github.com/FPGA-Research/FABulous) eFPGA
  - 32x I/Os
  - 288x LUT4 + FF
    - w. carry chain
  - 1x SRAM
    - 4 KiB memory: 32 bit wide, 10 bit deep (1024 entries)
    - individual bit-enable
  - 1x global clock network

The following user projects are included:

| Project | Size | Location | Description | Link |
|---------------|---------------|---------------|---------------|------|
| heichips25_snitch_wrapper | Large | X0Y2          | Snitch RISC‑V (RV32) integer core implemented with LibreLane on IHP SG13G2 (130 nm). | [Link](https://github.com/HeiChips/heichips_25_snitch_core) |
| heichips25_CORDIC | Small | X0Y3          | Waveform + Tone Generation using CORDIC Algorithm. | [Link](https://github.com/HeiChips/heichips25_CORDIC) |
| heichips25_sap3 | Small | X0Y4          | SAP-3 (Simple-As-Possible Computer). | [Link](https://github.com/HeiChips/heiChips2025_sap3_and_sorter) |
| heichips25_top_sorter | Small | X0Y5          | A top N sorter (either sorting or finding top N elements) of 28 8-bit numbers at 143 MHz. | [Link](https://github.com/HeiChips/heiChips2025_sap3_and_sorter) |
| heichips25_systolicArrayTop | Small | X0Y6          | Computes the product of two 4x4 matrices. Each input matrix element is a 4-bit unsigned integer. | [Link](https://github.com/HeiChips/heichips25_systolicArray4x4) |
| heichips25_SDR | Small | X0Y7          | Software-Defined Radio System Hardware Acceleration | [Link](https://github.com/HeiChips/heichips25_SDR) |
|               | Small | X0Y8          |               | [Link]() |
|               | Small | X0Y9          |               | [Link]() |
| heichips25_fazyrv_exotiny | Large | X5Y4          | FazyRV ExoTiny CCX implements an minimal-area SoC with custom instruction interface based on the FazyRV RISC-V core. | [Link](https://github.com/HeiChips/heichips25-fazyrv-exotiny) |
| heichips25_bagel | Small | X5Y5          |  bAG O' Life (bAsic Game Of Life) with HDMI output (125 MHz clock, DDR). | [Link](https://github.com/HeiChips/heichips25_bagel) |
| heichips25_usb_cdc | Small | X5Y6          | A USB CDC core taken from https://github.com/ulixxe/usb_cdc. USB_CDC is a Verilog implementation of the Full Speed (12Mbit/s) USB communications device class (or USB CDC class). It implements the Abstract Control Model (ACM) subclass. | [Link](https://github.com/HeiChips/heichips25-usb_cdc) |
| heichips25_tiny_wrapper | Small | X5Y7          | FALU (Fancy ALU) is a custom-designed Arithmetic Logic Unit implemented in Verilog with a flexible interface and extended functionality beyond standard ALUs. It supports not only the typical arithmetic and logic operations, but also more advanced functions like population count, approximate log, and even a tiny “sort” operation. <br> This project aims to create a programmable PWM module. In this context, "programmable" signifies that the module is initialized with a set of instructions. These instructions are then executed by its internal state machine, enabling dynamic PWM behavior. This allows for modifications to the PWM characteristics over time. A practical application of this would be, for instance, creating a pulsing LED effect. | [Link](https://github.com/HeiChips/heichips25-tiny-wrapper) |
|               | Small | X5Y8          |               | [Link]() |
|               | Small | X5Y9          |               | [Link]() |

## Configuration of the FPGA Fabric

The eFPGA fabric can be configured using the SPI peripheral or the SPI controller, depending on the value of `fpga_mode`. If the SPI controller is selected, upon startup it will fetch the bitstream from slot 0 of the external SPI flash. Using the slot input and the trigger one can initiate a reconfiguration. If the SPI peripheral is selected it will wait for bitstream data on the SPI interface upon startup.

## Building User Designs for the eFPGA

To build a bitstream of a user design for the eFPGA, see [README.md](ip/fabric/user_designs/README.md) under `ip/fabric/user_design`.

## Building the Chip

### Prerequisites

To clone the compatible PDK version, simply run `make clone-pdk`.

In the next step, install LibreLane by following the Nix-based installation instructions: https://librelane.readthedocs.io/en/latest/installation/nix_installation/index.html

Afterwards you can enable a Nix shell by running `nix-shell`.

### Running LibreLane

To build the chip with LibreLane:

```console
make librelane
```

To view the design in OpenROAD:

```console
make librelane-openroad
```

Or to view it in KLayout:

```console
make librelane-klayout
```

To render an image of the chip:

```
make render-image
```

And with this the chip is ready for tapeout. 

### Running Chip-Top Level Simulation

The cocotb testbench is located under `tb/heichips25_top/heichips25_top_tb.py`.

To run all chip-top level simulations, simply run:

```
make sim
```

You can run the gate-level tests after the chip has been implemented:

```
make sim-gl
```

## License

The chip is licensed under the Apache 2.0 license. This license may *not* apply to the remainder of the repository.

## Acknowledgements

The chip was designed by Leo Moser for the HeiChips Summer School 2025.

Thanks to [Heidelberg University](https://www.uni-heidelberg.de/en), [BMFTR](https://www.bmftr.bund.de/) and [Chipdesign Germany](https://www.chipdesign-germany.de/en/) for the finanical support enabling the tapeout of the chip.
