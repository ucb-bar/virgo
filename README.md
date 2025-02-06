Virgo
=====

Virgo is a GPU microarchitecture that integrates dedicated matrix units at the
cluster (SM)-level, achieving better FLOPS scalability and energy efficiency.

This repository includes the essential IPs for Virgo's implementation and
baseline evaluation, including the shared memory, Hopper-style Tensor Core,
memory coalescer, and Vortex SIMT core integration.

The entire Virgo GPU design is implemented within the Chipyard SoC environment.
To evaluate the full design, please follow the instructions in
[Chipyard](https://github.com/ucb-bar/chipyard/commits/virgo/) (TODO).
