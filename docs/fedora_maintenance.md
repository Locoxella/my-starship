# Registro de Mantenimiento de Fedora - Laptop Scar

## Historial de Modificaciones y Reparaciones

### [2026-07-25] Reparación de KDE Discover y Desmantelamiento de Snap

#### Diagnóstico Técnico
* **Síntoma:** KDE Discover se bloqueaba indefinidamente al intentar buscar o aplicar actualizaciones.
* **Causa Raíz:**
  1. `discover-backend-snap` bloqueaba el hilo principal de la interfaz mientras esperaba respuestas D-Bus de `snapd`.
  2. Incompatibilidad de seguridad: Fedora opera sobre SELinux por defecto mientras Snap requiere AppArmor (inactivo en Fedora), generando *timeouts* constantes en `snapd.service`.
  3. Desperdicio de recursos: El demonio de Snap consumía ~1GB de RAM manteniendo montados múltiples entornos virtuales base (`core`, `core18`, `core22`, `gnome-3-26-1604`, `gnome-42-2204`).

#### Solución Aplicada
1. Eliminación de paquetes Snap de usuario (`qr-code-generator-desktop`).
2. Confirmación de reemplazos nativos: `Qrca` (`org.kde.qrca` en Flatpak) ya se encuentra activo como reemplazo.
3. Creación del script ejecutable `remove_snap.sh` para purgar los paquetes RPM `snapd` y `discover-backend-snap`.

#### Directivas para Futuras Sesiones
* **NO reinstalar `snapd` ni `discover-backend-snap`.**
* Utilizar **Flatpak** (`flathub`) para todo el software de escritorio o utilidades de usuario.
* Mantener las actualizaciones del sistema mediante `dnf upgrade` o Discover con backends exclusivamente RPM/Flatpak.
