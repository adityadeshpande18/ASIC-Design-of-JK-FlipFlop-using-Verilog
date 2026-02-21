# ASIC-Design-of-JK-FlipFlop-using-Verilog
This project demonstrates the complete ASIC design flow of a JK Flip-Flop using Verilog HDL. The design is implemented at the RTL level, verified through simulation, and synthesized into a gate-level netlist using standard cell libraries. 

## ASIC Design of JK Flip-Flop using Verilog

This repository provides a structured documentation covering the complete ASIC design flow of a JK Flip-Flop using Verilog HDL. The flow includes RTL Design, Simulation, Logic Synthesis, Standard Cell Mapping and Gate-Level Netlist Generation using open-source ASIC tools.

The objective of this project is to understand how a simple sequential circuit is transformed from behavioral RTL code into a gate-level implementation using standard cells.

## RTL design

RTL Design is the representation of a required specification in a HDL like Verilog or VHDL. The RTL Design can be also generated using HCL(Hardware Construction Languages) like Chisel, MyHDL or Transaction Level Modelling Languages like TL-Verilog.

When the circuit specification is given, the first step is to write/generate the RTL design using any of the above HDL/HCLs

## JK Flip-Flop Functionality

J	K	Q(next)
0	0	Q
0	1	0
1	0	1
1	1	Q̅


## Logic Synthesis

The RTL describes only functionality.
### During synthesis:

RTL is converted into gate-level logic.
Flip-flop behavior is mapped to available standard cell D flip-flops.
Combinational logic is created to implement J and K behavior.
## Synthesis is performed using:

Yosys
Yosys reads:
Verilog RTL
Standard cell liberty (.lib) file
##### and generates: Gate-level netlist

## Simulation Tools
RTL simulation is performed using:
Icarus Verilog
GTKWave
Simulation verifies functional correctness before synthesis.

## Installing Required Packages (Local Setup)
apt install iverilog gtkwave yosys

## RTL Simulation
iverilog jk_ff.v tb_jk_ff.v
./a.out

## View waveform:
gtkwave jk_ff.vcd

## Logic Synthesis Flow

#### Start Yosys:
yosys

#### Read liberty file:
read_liberty <path_to_liberty_file>.lib

#### Read Verilog:
read_verilog jk_ff.v

#### Specify top module:
synth -top jk_ff

#### Map combinational logic:
abc -liberty <path_to_liberty_file>.lib

#### Map flip-flops:
dfflibmap -liberty <path_to_liberty_file>.lib

#### Optimize:
opt_clean -purge

#### Generate netlist:
write_verilog jk_ff_netlist.v

#### Visualize:
show


## Verifying the Synthesized Design

The generated netlist can be simulated again with the same testbench to verify functional equivalence between:
RTL design
Gate-level netlist

## Files Included

jk_ff.v → RTL Design
tb_jk_ff.v → Testbench
jk_ff_netlist.v → Gate-level netlist
jk_ff.vcd → Simulation waveform
Liberty file → Standard cell library


## References

[Yosys – Open Source Logic Synthesizer](https://yosyshq.net/yosys/)

[Icarus Verilog – Verilog Simulator](http://iverilog.icarus.com/)

[GTKWave – Waveform Viewer](http://gtkwave.sourceforge.net/)

[SkyWater 130nm PDK](https://skywater-pdk.readthedocs.io/)



