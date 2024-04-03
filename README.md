# lenovo-ipmi-gpu-control
Uses nvidia smi to get temperature, then set the lenovo fan speed
right now sets to 0x50, until gpu hits 65C then uses a linear curve from 65-80C, 80C being 100%

built on  nvidia/cuda:12.3.2-base-ubuntu22.04

docker hub link
```https://hub.docker.com/repository/docker/blackops010/lenovo-ipmi-gpu-control/general```

docker run

```docker run --gpus all --privileged lenovo-ipmi-gpu-control:latest```

docker compose
```
version: '3.8'

services:
  fan-control:
    image: fan-control:latest
    privileged: true
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```


### Build yourself

If you want to modify the script, just modify the ipmi.sh then run
``` sudo docker build -t lenovo-ipmi-gpu-control:latest . ```

```docker run --gpus all --privileged lenovo-ipmi-gpu-control:latest```
