#!/bin/bash

# Clonar el repositorio
git clone https://github.com/tu-usuario/tu-repositorio.git
cd scriptsAWS

# Ejecutar los scripts en orden
./1-crear-vpc-subnets.sh
./2-crear-gateways.sh
./3-crear-security-groups.sh
./4-crear-instances.sh