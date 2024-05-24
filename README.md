# lenovo-ipmi-gpu-control
Uses nvidia smi to get temperature, then set the lenovo fan speed
right now sets to 0x50, until gpu hits 65C then uses a linear curve from 65-80C, 80C being 100%

built on  nvidia/cuda:12.3.2-base-ubuntu22.04
docker run

```
 docker run -d --name lenovo-ipmi-container --runtime=nvidia -e HOST=192.168.68.123 -e USER=USERID -e PASSWORD=PASSW0RD  blackops010/lenovo-ipmi-gpu-control:maine=nvidia -e HOST=192.168.68.123 -e USER
```


### Build yourself

If you want to modify the script, just modify the ipmi.sh then run
```
sudo docker build -t lenovo-ipmi-gpu-control:latest . 
```

```
docker run --gpus all --privileged lenovo-ipmi-gpu-control:latest
```
docker hub link
```
https://hub.docker.com/repository/docker/blackops010/lenovo-ipmi-gpu-control/general
```
