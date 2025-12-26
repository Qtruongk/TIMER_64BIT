# APB 64-bit Timer IP

## 1. Overview
This repository contains a synthesizable **64-bit Timer IP** designed for integration into SoC/FPGA systems via the **AMBA APB (Advanced Peripheral Bus)** interface. The IP features a 64-bit up-counter, a programmable clock prescaler, and interrupt generation capabilities based on a compare match mechanism.

## 2. Key Features
- **64-bit Up-Counter:** High-resolution time tracking distributed across two 32-bit registers.
- **APB Interface:** Standard 32-bit APB slave interface for register access.
- **Programmable Prescaler:** Configurable clock divider (from /2 to /256) controlled via the TCR register.
- **Interrupt Generation:** Generates an interrupt (`tim_int`) when the counter value matches the programmable 64-bit Compare Register (`TCMP`).
- **Debug Support:** Hardware halt request/acknowledge mechanism (`halt_req`/`halt_ack`) for debugging purposes.
- **Error Handling:** Reports `PSLVERR` on invalid configuration attempts during active operation.

## 3. Hardware Interface (Ports)

| Signal Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| **Clock & Reset** | | | |
| `sys_clk` | Input | 1 | System Clock |
| `sys_rst_n` | Input | 1 | Active-low asynchronous reset |
| **APB Interface** | | | |
| `tim_psel` | Input | 1 | APB Select |
| `tim_penable` | Input | 1 | APB Enable |
| `tim_pwrite` | Input | 1 | APB Write Control (1=Write, 0=Read) |
| `tim_paddr` | Input | 12 | APB Address Bus |
| `tim_pwdata` | Input | 32 | APB Write Data Bus |
| `tim_pstrb` | Input | 4 | APB Write Strobe (Byte enables) |
| `tim_pready` | Output | 1 | APB Ready (Handshake) |
| `tim_prdata` | Output | 32 | APB Read Data Bus |
| `tim_pslverr` | Output | 1 | APB Slave Error |
| **Interrupt & Debug** | | | |
| `tim_int` | Output | 1 | Interrupt Output (Active High) |
| `dbg_mode` | Input | 1 | Debug Mode Enable |

## 4. Register Map
**Base Address Offset:** `0x00`
**Access Width:** 32-bit

| Offset | Symbol | R/W | Description |
| :--- | :--- | :--- | :--- |
| `0x00` | **TCR** | R/W | **Timer Control Register** <br> `[0]`: Timer Enable (1=Run, 0=Stop)<br> `[1]`: Divider Enable<br> `[11:8]`: Divider Value (Prescaler Select) |
| `0x04` | **TDR0** | R | **Timer Data Register Low** <br> Read-only lower 32-bits of the counter (`cnt[31:0]`) |
| `0x08` | **TDR1** | R | **Timer Data Register High** <br> Read-only upper 32-bits of the counter (`cnt[63:32]`) |
| `0x0C` | **TCMP0**| R/W | **Timer Compare Register Low** <br> Lower 32-bits of compare value (`tcmp[31:0]`) |
| `0x10` | **TCMP1**| R/W | **Timer Compare Register High** <br> Upper 32-bits of compare value (`tcmp[63:32]`) |
| `0x14` | **TIER** | R/W | **Timer Interrupt Enable Register** <br> `[0]`: Interrupt Enable |
| `0x18` | **TISR** | R/W1C| **Timer Interrupt Status Register** <br> `[0]`: Interrupt Status (Read 1 = Active). Write 1 to clear. |
| `0x1C` | **THCSR**| R/W | **Timer Halt Control Status Register** <br> `[0]`: Halt Request |

## 5. Functional Description

### 5.1 Clock Divider (Prescaler)
The timer frequency is derived from `sys_clk` divided by a factor determined by the `div_val` field in the TCR register.

| div_val (4-bit) | Limit | Division Factor |
| :--- | :--- | :--- |
| `4'b0000` | - | No division (Normal Mode) |
| `4'b0001` | 1 | Divide by 2 |
| `4'b0010` | 3 | Divide by 4 |
| `4'b0011` | 7 | Divide by 8 |
| `4'b0100` | 15 | Divide by 16 |
| `4'b0101` | 31 | Divide by 32 |
| `4'b0110` | 63 | Divide by 64 |
| `4'b0111` | 127 | Divide by 128 |
| `4'b1000` | 255 | Divide by 256 |

### 5.2 Interrupt Operation
1.  **Configuration:** Set the Compare Value in `TCMP0` and `TCMP1`. Set bit 0 of `TIER` to enable interrupts.
2.  **Trigger:** When the 64-bit counter (`cnt`) exactly matches the 64-bit compare value (`tcmp`), the interrupt status bit in `TISR` is set, and `tim_int` is asserted.
3.  **Clear:** To clear the interrupt, software must write `1` to `TISR[0]`.

## 6. Project Structure

```text
.
├── rtl
│   ├── apb_slave.v        # APB bus interface logic
│   ├── counter_block.v    # 64-bit counter logic
│   ├── counter_control.v  # Prescaler and mode control
│   ├── interrupt.v        # Interrupt generation logic
│   ├── register.v         # Register map and decoding
│   └── timer_top.v        # Top-level wrapper
├── sim
├── tb
├── testcases
└── README.md
```
## Contact
For any inquiries or feedback regarding this IP, please contact:
- **Facebook:** https://www.facebook.com/qtrwuongnee
- **Email:** [tranquangkaito@gmail.com](mailto:tranquangkaito@gmail.com)