#!/bin/bash

# Cargar variables
source vars.sh

# Crear grupos de seguridad
SG_PROXY_ID=$(aws ec2 create-security-group --group-name SG-Proxy --description "Grupo de Seguridad para servidores Proxy con NGINX" --vpc-id $VPC_ID --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=SG-Proxy-mensagl-2025-Equipo6}]' --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_PROXY_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_PROXY_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_PROXY_ID --protocol tcp --port 443 --cidr 0.0.0.0/0

SG_LAMP_WORDPRESS_ID=$(aws ec2 create-security-group --group-name SG-LAMP-Wordpress --description "Grupo de Seguridad para servidores LAMP y Wordpress" --vpc-id $VPC_ID --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=SG-LAMP-Wordpress-mensagl-2025-Equipo6}]' --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_LAMP_WORDPRESS_ID --protocol tcp --port 22 --cidr 10.0.0.0/16
aws ec2 authorize-security-group-ingress --group-id $SG_LAMP_WORDPRESS_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_LAMP_WORDPRESS_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_LAMP_WORDPRESS_ID --protocol tcp --port 3306 --cidr 10.0.0.0/16

# Exportar variables adicionales
echo "export SG_PROXY_ID=$SG_PROXY_ID" >> vars.sh
echo "export SG_LAMP_WORDPRESS_ID=$SG_LAMP_WORDPRESS_ID" >> vars.sh