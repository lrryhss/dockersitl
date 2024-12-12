# ArduCopter SITL Docker Setup

This repository contains Docker configuration for running ArduCopter SITL (Software In The Loop) simulation with MAVProxy. The setup allows connecting to the simulation using Mission Planner or other ground control stations.

## Prerequisites

- Docker installed on your system
- Mission Planner or another ground control station
- Git (for cloning the repository)

## Files

The setup consists of two main files:

### 1. Dockerfile
Contains the configuration for building the Docker image with all necessary dependencies including:
- ArduPilot SITL
- MAVProxy
- Python dependencies

### 2. start_sitl.sh
A bash script that initializes the SITL environment with proper networking configuration.


## Quick Start

1. Create the start script (choose one of the following options):

### Default location:
```bash
echo '#!/bin/bash
sim_vehicle.py -v ArduCopter --console --map --out=tcpin:0.0.0.0:14550 --out=tcpin:0.0.0.0:14551' > start_sitl.sh
```

### Custom location:
```bash
echo '#!/bin/bash
sim_vehicle.py -v ArduCopter --console --map --out=tcpin:0.0.0.0:14550 --out=tcpin:0.0.0.0:14551 --custom-location=LAT,LON,ALT,HEADING' > start_sitl.sh
```

Parameters for custom location:
- LAT: Latitude in decimal degrees
- LON: Longitude in decimal degrees
- ALT: Altitude in meters above sea level
- HEADING: Initial heading in degrees (0-360)

2. Make it executable:
```bash
chmod +x start_sitl.sh
```

Let me know if you would like me to add any additional information about location configuration!
3. Build the Docker image:
```bash
docker build -t ardupilot-sitl .
```

4. Run the container:
```bash
docker run -it --rm --network host ardupilot-sitl
```

## Connecting with Mission Planner

1. Open Mission Planner
2. In the top-right corner, select "TCP"
3. Enter the connection string:
   - Local connection: `tcp://localhost:14550`
   - Remote connection: `tcp://YOUR_IP:14550`
4. Click "Connect"

## Port Information

The simulator exposes several ports:
- 5760: Primary SITL connection
- 14550: Primary GCS connection
- 14551: Secondary GCS connection

## Troubleshooting

1. If you can't connect, verify the ports are open:
```bash
ss -tuln | grep -E '5760|14550|14551'
```

2. Check firewall settings if connecting remotely:
```bash
sudo ufw status
```

3. For remote connections, ensure the container is running with proper network access:
```bash
docker run -it --rm --network host ardupilot-sitl
```

## Environment Variables

The Docker container uses the following environment variables:
- `DEBIAN_FRONTEND=noninteractive`: Prevents interactive prompts during package installation

## Notes

- The simulation runs without a GUI by default
- All ports are exposed for remote connections
- The container uses host networking for easier connectivity
- The setup includes both TCP and UDP port configurations

## License

This project uses various components with their respective licenses:
- ArduPilot: GPL-3.0
- MAVProxy: GPL-3.0
- Other components may have their own licenses
