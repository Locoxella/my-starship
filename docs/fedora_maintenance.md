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
3. Creación del script ejecutable `scripts/maintenance/remove_snap.sh` para purgar los paquetes RPM `snapd` y `discover-backend-snap`.

---

### [2026-07-30] Mantenimiento Local de `my-starship` (Fuente de la Verdad)

Esta computadora (`Scar`) es la **fuente de la verdad** para la configuración de Starship (`~/.config/starship.toml`).

#### Guía Exclusiva para el Agente Local (Scar):
- Para sincronizar los cambios locales de esta máquina hacia el repositorio antes de hacer push:
  ```bash
  ./scripts/sync_starship_local.sh
  ```
- Para publicar las actualizaciones en el repositorio remoto:
  ```bash
  git add . && git commit -m "update: actualizar starship.toml" && git push origin main
  ```
- **Nota de Limpieza:** El script de sincronización local `scripts/sync_starship_local.sh` y la guía del administrador permanecen **exclusivamente** en este documento interno (`docs/fedora_maintenance.md`) y la carpeta `scripts/` ignorada, sin exponerse en el `README.md` público que leen los consumidores.

---

### [2026-09-10] Optimización para Consumo de Agentes de IA Externos y Sync Local

1. **Prompt de 1-clic:** Incorporado bloque de código con el prompt listo para copiar al portapapeles en `README.md`.
2. **Corrección de URLs:** Se corrigió en `dotfiles/setup_starship.ps1` la referencia obsoleta a `Locoxella/scar` que rompía la autoconfiguración en WSL.
3. **Mapeo Claro de Protocolos:** Se definieron explícitamente en el README los dos modos para agentes: Modo Express (instaladores de 1 línea) y Modo Paso a Paso (para terminales con restricciones).
4. **Soporte de Fuentes:** Se incluyó recordatorio para que las IAs visitantes instruyan al usuario sobre el uso de Nerd Fonts (JetBrains Mono NF, FiraCode NF, etc.) para renderizar correctamente los glifos.
5. **Script de Sincronización Local:** Implementado y verificado `scripts/sync_starship_local.sh` con validación de sintaxis vía `STARSHIP_CONFIG` y sincronización de `command_timeout = 2000`.
