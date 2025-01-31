#!/bin/bash

# Cargar variables
source vars.sh

# Crear instancias de proxy con IP pública automática
INSTANCE_PROXY1_ID=$(aws ec2 run-instances \
    --image-id ami-04b4f1a9cf54c11d0 \
    --instance-type t2.micro \
    --key-name ssh-mensagl-2025-Equipo6 \
    --subnet-id $SUBNET_PUBLIC1_ID \
    --security-group-ids $SG_PROXY_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Proxyinverso1}]' \
    --associate-public-ip-address \
    --query 'Instances[0].InstanceId' \
    --output text)
echo "Instancia Proxyinverso1 ID: $INSTANCE_PROXY1_ID"

INSTANCE_PROXY2_ID=$(aws ec2 run-instances \
    --image-id ami-04b4f1a9cf54c11d0 \
    --instance-type t2.micro \
    --key-name ssh-mensagl-2025-Equipo6 \
    --subnet-id $SUBNET_PUBLIC2_ID \
    --security-group-ids $SG_PROXY_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Proxyinverso2}]' \
    --associate-public-ip-address \
    --query 'Instances[0].InstanceId' \
    --output text)
echo "Instancia Proxyinverso2 ID: $INSTANCE_PROXY2_ID"

# Obtener las IPs públicas de las instancias de proxy
INSTANCE_PROXY1_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_PROXY1_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
INSTANCE_PROXY2_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_PROXY2_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "IP pública de Proxyinverso1: $INSTANCE_PROXY1_PUBLIC_IP"
echo "IP pública de Proxyinverso2: $INSTANCE_PROXY2_PUBLIC_IP"