# Lenovo IPMI GPU Control

This container uses `nvidia-smi` to monitor the GPU temperature and adjusts the Lenovo fan speed accordingly. It sets the fan to `0x50` until the GPU hits 65°C, after which it follows a linear curve, with 100% fan speed at 80°C.

Built on `nvidia/cuda:12.3.2-base-ubuntu22.04`.

## Features
- GPU temperature monitoring via `nvidia-smi`.
- Automatic fan control based on GPU temperature using IPMI.

## Environment Variables
- `HOST`: IP address of the Lenovo server.
- `USER`: IPMI username for authentication.
- `PASSWORD`: IPMI password for authentication.

## Run the Container

You can run the container by using Docker, either by pulling from Docker Hub or building the image yourself.

### Option 1: Pull from Docker Hub

To pull the pre-built image from Docker Hub and run the container:

```bash
docker run -d --name lenovo-ipmi-container --runtime=nvidia \
    -e HOST=192.168.68.123 \
    -e USER=USERID \
    -e PASSWORD=PASSW0RD \
    blackops010/lenovo-ipmi-gpu-control:main
```

### Option 2: Pull from Gitea
```bash
docker run -d --name lenovo-ipmi-container --runtime=nvidia \
    -e HOST=192.168.68.123 \
    -e USER=USERID \
    -e PASSWORD=PASSW0RD \
    git.nicholstech.org/david/lenovo-ipmi-gpu-control:latest
```

### Docker Compose
If you prefer to use Docker Compose, create a docker-compose.yml file with the following content:
```yaml
services:
  fan-control:
    image: blackops010/lenovo-ipmi-gpu-control:latest
    privileged: true
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    environment:
      HOST: 192.168.68.123
      USER: USERID
      PASSWORD: PASSW0RD
```
If pulling from Gitea or Docker Hub, make sure to change the image field to reflect the correct registry:
For Docker Hub: blackops010/lenovo-ipmi-gpu-control:latest
For Gitea: git.nicholstech.org/david/lenovo-ipmi-gpu-control:latest

### Repo Links:
https://hub.docker.com/repository/docker/blackops010/lenovo-ipmi-gpu-control/general
https://git.nicholstech.org/david/lenovo-ipmi-gpu-control


## Option 3: Build the Image Yourself
If you want to modify the script (ipmi.sh), make your changes and then build the image locally:

```bash
sudo docker build -t lenovo-ipmi-gpu-control:latest .
```

After building, run the container:

```bash
docker run --gpus all --privileged lenovo-ipmi-gpu-control:latest
```