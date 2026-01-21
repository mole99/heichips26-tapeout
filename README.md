# HeiChips 2025 Tapeout

![heichips25.jpg](img/heichips25.jpg)

This repository contains the chip for the HeiChips Summer School 2025. It includes several designs created during the Hackathon all connected to a common eFPGA fabric in the center.
Thanks to FABulous, the user bitstream for the FPGA can be generated using the upstream yosys and nextpnr toolchain.

The chip is designed with open source EDA tools and the [IHP Open Source PDK](https://github.com/IHP-GmbH/IHP-Open-PDK).

> [!WARNING]
> This repository is a Work in Progress.

<p align="center">
  <a href="img/heichips25_top.png">
    <img src="img/heichips25_top_small.png" alt="chip layout" width=40%>
  </a>
</p>

## Feature Overview

The chip includes several user submitted designs from the HeiChips 2025 Hackathon. In the center of the chip is an eFPGA which allows the user projects to connect to each other, utilize the SRAM or connect to the external I/Os.

- [FABulous](https://github.com/FPGA-Research/FABulous) eFPGA
  - 32x I/Os
  - 256x LUT4 + FF
    - w. carry chain
  - 1x SRAM
    - 4 KiB memory: 32 bit wide, 10 bit deep (1024 entries)
    - individual bit-enable
  - 1x global clock network

The following user projects are included:

| Project | Size | Location | Description |
|---------------|---------------|---------------|---------------|
| heichips25_snitch_wrapper | Large | X0Y2          |               |
| heichips25_CORDIC | Small | X0Y3          |               |
| heichips25_sap3 | Small | X0Y4          |               |
| heichips25_top_sorter | Small | X0Y5          |               |
| heichips25_systolicArrayTop | Small | X0Y6          |               |
|               |               | X0Y7          |               |
|               |               | X0Y8          |               |
| heichips25_fazyrv_exotiny | Large | X5Y4          |               |
| heichips25_bagel | Small | X5Y5          |               |
| heichips25_usb_cdc | Small | X5Y6          |               |
|               |               | X5Y7          |               |
|               |               | X5Y8          |               |

## Configuration of the FPGA Fabric

The eFPGA fabric can be configured using the SPI peripheral or the SPI controller, depending on the value of `fpga_mode`. If the SPI controller is selected, upon startup it will fetch the bitstream from slot 0 of the external SPI flash. Using the slot input and the trigger one can initiate a reconfiguration. If the SPI peripheral is selected it will wait for bitstream data on the SPI interface upon startup.

## Building User Designs for the eFPGA

To build a bitstream of a user design for the eFPGA, see [README.md](ip/fabric/user_designs/README.md) under `ip/fabric/user_design`.

## Running Chip-Top Level Simulation

TODO

The chip-top level testbench is written using cocotb and located under `tb/heichips25_top/`.

Enable a Nix shell with Icarus Verilog (`iverilog-12.0` at the time of writing):

```
nix shell nixpkgs#iverilog
```

Next, run the testbench:

```
python3 heichips25_top_tb.py
```

You can select a different test case in the Pyhon testbench.

## Building the Chip

### Prerequisites

To clone the latest PDK version, simply run `make clone-pdk`.

In the next step, install LibreLane by following the Nix-based installation instructions: https://librelane.readthedocs.io/en/latest/installation/nix_installation/index.html

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

The final steps:

```
make copy-final
make create-image
```

And with this the chip is ready for tapeout. 

## License

The chip is licensed under the Apache 2.0 license. This license may *not* apply to the remainder of the repository.

## Acknowledgements

The chip was designed by Leo Moser for the HeiChips Summer School 2025.

Thanks to [Heidelberg University](https://www.uni-heidelberg.de/en), [BMFTR](https://www.bmftr.bund.de/) and [Chipdesign Germany](https://www.chipdesign-germany.de/en/) for the finanical support enabling the tapeout of the chip.
