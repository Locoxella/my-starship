#!/usr/bin/env bash
# Script para remover completamente snapd y el backend de Discover en Fedora

set -e

echo "===> Deteniendo servicios de snapd..."
sudo systemctl disable --now snapd.socket snapd.service snapd.apparmor.service 2>/dev/null || true

echo "===> Desinstalando paquetes RPM de snapd y el complemento de Discover..."
sudo dnf remove -y snapd discover-backend-snap

echo "===> Limpiando directorios residuales de Snap..."
sudo rm -rf /var/lib/snapd /snap ~/snap

echo "===> Proceso finalizado exitosamente. Snap ha sido completamente removido de Fedora."
