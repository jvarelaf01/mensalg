#!/bin/bash

# Crear VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=VPC-mensagl-2025-Equipo6}]' --query 'Vpc.VpcId' --output text)
echo "VPC ID: $VPC_ID"

# Habilitar soporte DNS y nombres DNS
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames

# Crear subredes públicas
SUBNET_PUBLIC1_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Subnet-Public-1-mensagl-2025-Equipo6}]' --query 'Subnet.SubnetId' --output text)
echo "Subred Pública 1 ID: $SUBNET_PUBLIC1_ID"

SUBNET_PUBLIC2_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.2.0/24 --availability-zone us-east-1b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Subnet-Public-2-mensagl-2025-Equipo6}]' --query 'Subnet.SubnetId' --output text)
echo "Subred Pública 2 ID: $SUBNET_PUBLIC2_ID"

# Habilitar asignación automática de IP pública en las subredes públicas
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC1_ID --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC2_ID --map-public-ip-on-launch

# Crear subredes privadas
SUBNET_PRIVATE1_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.3.0/24 --availability-zone us-east-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Subnet-Private-1-mensagl-2025-Equipo6}]' --query 'Subnet.SubnetId' --output text)
echo "Subred Privada 1 ID: $SUBNET_PRIVATE1_ID"

SUBNET_PRIVATE2_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.4.0/24 --availability-zone us-east-1b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Subnet-Private-2-mensagl-2025-Equipo6}]' --query 'Subnet.SubnetId' --output text)
echo "Subred Privada 2 ID: $SUBNET_PRIVATE2_ID"

# Exportar variables para su uso en otros scripts
echo "export VPC_ID=$VPC_ID" > vars.sh
echo "export SUBNET_PUBLIC1_ID=$SUBNET_PUBLIC1_ID" >> vars.sh
echo "export SUBNET_PUBLIC2_ID=$SUBNET_PUBLIC2_ID" >> vars.sh
echo "export SUBNET_PRIVATE1_ID=$SUBNET_PRIVATE1_ID" >> vars.sh
echo "export SUBNET_PRIVATE2_ID=$SUBNET_PRIVATE2_ID" >> vars.sh