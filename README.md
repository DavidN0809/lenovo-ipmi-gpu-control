# lenovo-ipmi-gpu-control
Uses nvidia smi to get temperature, then set the lenovo fan speed right now sets to 0x50, until gpu hits 65C then uses a linear curve from 65-80C, 80C being 100%
