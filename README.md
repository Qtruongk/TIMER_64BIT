# TIMER_8BIT – Bus-Based 8-bit Timer IP

## Overview
This repository contains a synthesizable **8-bit Timer IP** designed for integration into SoC/FPGA systems via a **memory-mapped bus interface**. The IP provides basic timer functionality such as start/stop control, programmable compare/period value, status reporting, and interrupt generation.

## Key Features
- **8-bit up-counter** with programmable period/compare value
- **Memory-mapped bus interface** for register access (read/write)
- **Start/Stop/Reset** control via control register
- **Interrupt (IRQ) support** on overflow/compare match (configurable)
- **Status flags** for overflow and compare match events
- Synchronous design, suitable for FPGA/ASIC flows

## Bus Interface (Memory-Mapped Registers)
The timer is controlled through a simple register map accessed by a system bus (e.g., AXI-lite-like / APB-like custom MMIO wrapper depending on integration). Typical registers include:

- `CTRL`  : enable, mode, IRQ enable, clear flags
- `PRESC` : optional prescaler configuration (if implemented)
- `PERIOD/COMPARE` : sets the compare/overflow threshold
- `COUNT` : current counter value (read-only or readable)
- `STATUS`: overflow/compare flags and IRQ status

> Note: The exact address offsets and bitfields are defined in the RTL and can be documented in the "Register Map" section below once finalized.

## Functional Description
1. The CPU (or host bus master) configures the timer by writing `CTRL` and `PERIOD/COMPARE`.
2. When enabled, the counter increments on each clock (or prescaled clock if used).
3. On **compare match** or **overflow**, the IP sets a status flag and can assert `irq` if enabled.
4. The CPU reads `STATUS` to check events and clears flags by writing back to `CTRL`/`STATUS` (depending on implementation).

## Project Structure
- `rtl/`      : RTL source files (Verilog/SystemVerilog)
- `tb/`       : testbench files
- `sim/`      : simulation scripts/configs (if available)
- `testcases/`: test vectors or scenario scripts (if available)

## How to Simulate (Example)
Update the commands below based on your simulator (ModelSim/Questa/iverilog/verilator):
