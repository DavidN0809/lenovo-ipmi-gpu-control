# lenovo-ipmi-gpu-control
Uses nvidia smi to get temperature, then set the lenovo fan speed
right now sets to 0x50, until gpu hits 65C then uses a linear curve from 65-80C, 80C being 100%

built on  nvidia/cuda:12.3.2-base-ubuntu22.04

docker run

```docker run --gpus all --privileged lenovo-ipmi-gpu-control:latest```

docker compose
```
version: '3.8'

services:
  fan-control:
    image: fan-control:latest
    privileged: true
    volumes:
      - /path/to/your/volume:/config
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```
