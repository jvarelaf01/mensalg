#!/bin/bash

# Cargar variables
source vars.sh

# Crear Gateway de Internet
IGW_ID=$(aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=IGW-mensagl-2025-Equipo6}]' --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
echo "Gateway de Internet ID: $IGW_ID"

# Crear Gateway NAT en la subred pública 1
EIP_ALLOC_ID=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
NAT_GW_ID=$(aws ec2 create-nat-gateway --subnet-id $SUBNET_PUBLIC1_ID --allocation-id $EIP_ALLOC_ID --tag-specifications 'ResourceType=natgateway,Tags=[{Key=Name,Value=NATGW-mensagl-2025-Equipo6}]' --query 'NatGateway.NatGatewayId' --output text)
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_ID
echo "Gateway NAT ID: $NAT_GW_ID"

# Crear tablas de enrutamiento y asociarlas a las subredes
RTB_PUBLIC_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=RTB-Public-mensagl-2025-Equipo6}]' --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $RTB_PUBLIC_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
aws ec2 associate-route-table --route-table-id $RTB_PUBLIC_ID --subnet-id $SUBNET_PUBLIC1_ID
aws ec2 associate-route-table --route-table-id $RTB_PUBLIC_ID --subnet-id $SUBNET_PUBLIC2_ID
echo "Tabla de enrutamiento pública ID: $RTB_PUBLIC_ID"

RTB_PRIVATE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=RTB-Private-mensagl-2025-Equipo6}]' --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $RTB_PRIVATE_ID --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT_GW_ID
aws ec2 associate-route-table --route-table-id $RTB_PRIVATE_ID --subnet-id $SUBNET_PRIVATE1_ID
aws ec2 associate-route-table --route-table-id $RTB_PRIVATE_ID --subnet-id $SUBNET_PRIVATE2_ID
echo "Tabla de enrutamiento privada ID: $RTB_PRIVATE_ID"

# Exportar variables adicionales
echo "export IGW_ID=$IGW_ID" >> vars.sh
echo "export NAT_GW_ID=$NAT_GW_ID" >> vars.sh
echo "export RTB_PUBLIC_ID=$RTB_PUBLIC_ID" >> vars.sh
echo "export RTB_PRIVATE_ID=$RTB_PRIVATE_ID" >> vars.sh