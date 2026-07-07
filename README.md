# AMBA APB-Based GPIO Controller

## Overview

This project presents the RTL design and functional verification of an **AMBA APB-compliant General Purpose Input/Output (GPIO) Controller** implemented in **Verilog HDL**.

The design enables communication between an APB master and GPIO peripheral through memory-mapped registers and has been functionally verified using **QuestaSim**.

---

## Features

- AMBA APB Slave Interface
- GPIO DATA Register
- GPIO DIRECTION Register
- APB Read Transactions
- APB Write Transactions
- Verilog RTL Design
- Functional Verification using QuestaSim

---

## Project Specifications

| Parameter | Value |
|-----------|-------|
| Protocol | AMBA APB |
| Language | Verilog HDL |
| Simulator | QuestaSim |
| GPIO Width | 8-bit |
| Data Width | 32-bit |
| Address Width | 8-bit |

---

## System Architecture

> *(Upload your architecture diagram to the `images` folder and replace the line below.)*

```markdown
![Architecture](images/architecture.png)
```

---

## APB Slave FSM

```markdown
![FSM](images/fsm.png)
```

---

## Register Map

| Address | Register | Description |
|----------|----------|-------------|
| 0x00 | DATA | GPIO Data Register |
| 0x04 | DIRECTION | GPIO Direction Register |

---

## Verification

The design was verified using a self-checking Verilog testbench in **QuestaSim**.

### Test Cases

- Reset Operation
- APB Write Transaction
- APB Read Transaction
- GPIO Direction Configuration
- GPIO Output Verification
- GPIO Input Verification

---

## Simulation Waveform

```markdown
![Waveform](images/waveform.png)
```

---

## Repository Structure

```text
APB_GPIO_Controller/
│
├── rtl/
│   └── apb_gpio.v
│
├── tb/
│   └── apb_gpio_tb.v
│
├── images/
│   ├── architecture.png
│   ├── fsm.png
│   └── waveform.png
│
├── docs/
│   └── APB_GPIO_Report.pdf
│
└── README.md
```

---

## Future Enhancements

- APB4 Support
- Interrupt Generation
- GPIO Edge Detection
- Debounce Logic
- Configurable GPIO Width

---

## Author

**Likhith Udayagiri**

B.Tech, Electronics and Communication Engineering

Visvesvaraya National Institute of Technology (VNIT), Nagpur
