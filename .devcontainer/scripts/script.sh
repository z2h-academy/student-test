#!/bin/bash
set -e

CLUSTER_NAME="z2h"

# Verificar si el cluster ya existe
if k3d cluster list | grep -q "$CLUSTER_NAME"; then
    echo "✔️ El clúster '$CLUSTER_NAME' ya existe. Saltando creación."
else
    echo "🚀 Creando clúster k3d '$CLUSTER_NAME'..."

    k3d cluster create $CLUSTER_NAME \
        --servers 1 \
        --agents 1 \
        --port "8080:80@loadbalancer"

    echo "✔️ Clúster k3d creado correctamente."
fi
