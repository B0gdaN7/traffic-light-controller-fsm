# Traffic Light Controller – CLP Project

## Overview

This project implements a modular traffic light controller for a four-way intersection using Verilog HDL. The system controls both vehicle and pedestrian traffic using finite state machines (FSMs), configurable timers, and synchronized sequencing between directions.

The project was developed for the CLP (Circuite Logice Programabile) course.

---

# Features

- Traffic light control for four directions:
  - North (N)
  - South (S)
  - East (E)
  - West (V)

- Vehicle traffic management
- Pedestrian crossing support
- Pedestrian request memory system
- SERVICE mode with blinking signals
- Synchronous FSM implementation
- Modular Verilog architecture
- RTL synthesis and waveform simulation

---

# Traffic Sequence

The intersection activates directions in the following order:

```text
S → N → E → V
```

Timing values used in the project:

| State | Duration |
|---|---|
| North green | 17 s |
| South green | 22 s |
| East green | 19 s |
| West green | 20 s |
| Pedestrian green | 12 s |
| Pedestrian blinking | 8 s |
| Yellow auto | 2 s |

---

# FSM States

The main FSM implemented in `semafor_directie.v` contains the following states:

| State | Description |
|---|---|
| IDLE | Initial waiting state |
| VERDE_AUTO | Green light for vehicles |
| GALBEN_AUTO | Yellow light transition |
| PIETONI_VERDE | Green light for pedestrians |
| PIETONI_CLIPIRE | Blinking pedestrian signal |
| SERVICE | Maintenance / blinking mode |

---

# Project Structure

```text
.
├── intersectie.v
├── semafor_directie.v
├── clock_divider.v
├── tb_intersectie.v
├── scenariu2_tb.v
├── reset_tb.v
├── service_tb.v
└── docs/
    └── CLP_Project_Documentation.pdf
```

---

# Modules Description

## intersectie.v
Top-level module that coordinates the entire intersection and selects the active direction.

## semafor_directie.v
Implements the FSM for one traffic direction, including vehicle and pedestrian control.

## clock_divider.v
Generates a slower clock used for FSM timing and simulation.

## Testbench Files

- `tb_intersectie.v` – main testbench
- `scenariu2_tb.v` – pedestrian scenario
- `reset_tb.v` – reset verification
- `service_tb.v` – SERVICE mode verification

---

# Simulation Scenarios

The project includes the following verification scenarios:

## Scenario 1 – Normal Operation
- Sequential activation of all directions
- Vehicle traffic only

## Scenario 2 – Pedestrian Requests
- Detection of `pietoni_btn_i`
- Request stored in `cerere_pietoni`
- Pedestrian crossing sequence execution

## Scenario 3 – Reset Verification
- FSM reset during operation
- Return to `IDLE`

## Scenario 4 – SERVICE Mode
- Blinking yellow vehicle signal
- Blinking pedestrian signal

---

# RTL and FSM Visualization

The project was synthesized and simulated using Xilinx Vivado.

Generated outputs include:
- RTL schematic
- FSM diagram
- Waveform simulations

---

# Technologies Used

- Verilog HDL
- Xilinx Vivado Design Suite
- Finite State Machines (FSM)
- RTL Design
- Digital Logic Design

---

# Conclusion

The project demonstrates the implementation of a complete traffic light controller using synchronous digital design principles. The modular architecture allows easy testing, extension, and reuse of the implemented components.

---

# Author

Bogdan Calistru 
