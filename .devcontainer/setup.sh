#!/usr/bin/env bash
set -e

echo "=== Instalando dependencias mínimas ==="
sudo apt-get update -y
sudo apt-get install -y curl

echo "=== Instalando kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "=== Instalando k3d ==="
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo ""
echo "======================================================"
echo "  Verificando disponibilidad del Docker daemon..."
echo "======================================================"

# Función para detectar Docker daemon
docker_is_available() {
    if command -v docker >/dev/null 2>&1; then
        if docker info >/dev/null 2>&1; then
            return 0  # Docker disponible
        fi
    fi
    return 1  # Docker NO disponible
}

if docker_is_available; then
    echo "✔ Docker daemon detectado. Podemos crear clusters k3d."
    echo "=== Creando cluster k3d z2h ==="

    k3d cluster create z2h \
        --servers 1 \
        --agents 1 \
        --port "8080:80@loadbalancer"

    echo "=== Cluster creado exitosamente ==="
    kubectl get nodes
else
    echo "⚠ Docker daemon NO disponible."
    echo "⚠ Esto es normal en Codespaces / DevContainers."
    echo "⚠ k3d NO puede crear clusters sin Docker."
    echo "⏭ Saltando creación de cluster k3d..."
fi

echo ""
echo "=== setup.sh finalizado exitosamente ==="
