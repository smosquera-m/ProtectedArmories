# 🧟 Protected Armories & Loot Respawn (Build 42 & 41)
> **Mod para Project Zomboid (Build 42.x & Build 41.x)**  
> *Protege automáticamente armarios de armas y contenedores en comisarías, armerías, tiendas de armas, bases militares y prisiones: inamovibles, indestructibles y con reaparición automática de loot inicial.*

---

## 📌 1. Características Principales

1. **🔒 Protección Absoluta e Inquebrantable:**
   - **Inamovible:** Bloquea la herramienta de mover muebles (`Pick Up`).
   - **Indestructible:** Bloquea las herramientas de desmontar/desguazar (`Disassemble` / `Scrap`) y destrucción con mazo (*Sledgehammer*).
   - **Sin excepciones:** La protección aplica para **todos** los jugadores (incluyendo usuarios con rol de Administrador).

2. **🔄 Reaparición Automática de Loot Inicial (*Loot Respawn*):**
   - Guarda una copia (*snapshot*) de las armas, municiones y accesorios iniciales en el `ModData` del mueble al cargarse o abrirse por primera vez.
   - Restaura automáticamente cualquier objeto saqueado en cada ciclo configurable (por defecto cada 24 horas del juego).

3. **ℹ️ Menú Informativo de Clic Derecho:**
   - Al hacer clic derecho sobre un armario protegido, se muestra la entrada:
     ```text
     🔒 Armería Protegida [Ubicación]
        ├── Contenedor inamovible e indestructible
        ├── Ubicación: Police Armory (policegunstorage)
        └── Respawn de Loot: Activo (Cada 24h)
     ```

4. **🎯 Detección Dinámica Inteligente:**
   - Detecta automáticamente los muebles de armas por su tipo de sprite (`furniture_storage_02_*`) en cualquier parte del mapa.
   - Detecta automáticamente todos los contenedores dentro de salas de armería (`policegunstorage`, `gunstorestorage`, `armystorage`, `prisonstorage`, etc.).

---

## ⚙️ 2. Opciones Configurables (Sandbox Vars)

El mod incluye opciones personalizables desde el menú de Sandbox al crear o modificar una partida:

| Variable Sandbox | Valor por Defecto | Descripción |
| :--- | :--- | :--- |
| `ProtectPolice` | `true` | Proteger comisarías de policía y taquillas armeras. |
| `ProtectGunStores` | `true` | Proteger tiendas de armas y sus almacenes. |
| `ProtectMilitary` | `true` | Proteger bases militares, armerías y tiendas surplus. |
| `ProtectPrisons` | `true` | Proteger armerías y taquillas de prisiones. |
| `PreventMoving` | `true` | Impedir mover o levantar los contenedores. |
| `PreventDisassembling` | `true` | Impedir desmontar o desguazar. |
| `PreventSledgehammer` | `true` | Impedir destrucción con mazo. |
| `EnableLootRespawn` | `true` | Activar reaparición periódica del loot inicial. |
| `RespawnIntervalHours` | `24` | Intervalo en horas de juego para el respawn de loot. |

---

## 📍 3. Lista de Ubicaciones y Comandos de Teletransporte

Puedes usar estos comandos en el chat del juego (`/teleportto X,Y,Z`) o en la consola de Lua (`getPlayer():setX(X); getPlayer():setY(Y); getPlayer():setZ(Z)`) para probar cualquier armería:

### 🚓 Comisarías de Policía
| Ubicación | Zona de Protección | Coordenadas `(X, Y, Z)` | Comando Chat |
| :--- | :--- | :--- | :--- |
| **Rosewood Police Station** | `policegunstorage` | `8067, 11722, 0` | `/teleportto 8067,11722,0` |
| **Muldraugh Police Station** | `policegunstorage` | `10635, 10410, 0` | `/teleportto 10635,10410,0` |
| **West Point Police Station** | `policegunstorage` | `11900, 6960, 0` | `/teleportto 11900,6960,0` |
| **Riverside Police Station** | `policegunstorage` | `6080, 5265, 0` | `/teleportto 6080,5265,0` |
| **Louisville Central Police HQ** | `policegunstorage` | `12480, 3600, 0` | `/teleportto 12480,3600,0` |
| **Louisville SWAT HQ / Armory** | `policeswat` | `12350, 3520, 0` | `/teleportto 12350,3520,0` |

### 🔫 Tiendas de Armas (*Gun Stores*)
| Ubicación | Zona de Protección | Coordenadas `(X, Y, Z)` | Comando Chat |
| :--- | :--- | :--- | :--- |
| **West Point Gun Store** | `gunstore` / `gunstorestorage` | `12065, 6765, 0` | `/teleportto 12065,6765,0` |
| **Doe Valley Gun Store** | `gunstore` | `3790, 8520, 0` | `/teleportto 3790,8520,0` |
| **Louisville East Gun Store** | `gunstorestorage` | `13240, 3340, 0` | `/teleportto 13240,3340,0` |
| **Louisville West Gun Store** | `gunstorestorage` | `12110, 1530, 0` | `/teleportto 12110,1530,0` |

### 🎖️ Bases y Tiendas Militares (*Army & Surplus*)
| Ubicación | Zona de Protección | Coordenadas `(X, Y, Z)` | Comando Chat |
| :--- | :--- | :--- | :--- |
| **Dixie Highway Army Surplus** | `armysurplus` | `11580, 8820, 0` | `/teleportto 11580,8820,0` |
| **Valley Station Surplus Store** | `armysurplus` | `12905, 5120, 0` | `/teleportto 12905,5120,0` |
| **Louisville Checkpoint Storage** | `armystorage` | `12550, 4300, 0` | `/teleportto 12550,4300,0` |
| **Base Militar Secreta (Bosque)** | `armystorage` | `5570, 12480, 0` | `/teleportto 5570,12480,0` |

### 🔒 Prisiones y Seguridad
| Ubicación | Zona de Protección | Coordenadas `(X, Y, Z)` | Comando Chat |
| :--- | :--- | :--- | :--- |
| **Rosewood Prison Armory** | `prisonarmory` | `7660, 11825, 0` | `/teleportto 7660,11825,0` |
| **March Ridge Security Office** | `securitystorage` | `10100, 12720, 0` | `/teleportto 10100,12720,0` |
| **Louisville Pawn Shop** | `securitystorage` | `12810, 3620, 0` | `/teleportto 12810,3620,0` |

---

## 🛠️ 4. Herramientas para Desarrolladores (`dev.py`)

El proyecto incluye un CLI automático en Python para análisis estático, ejecución de tests y despliegue directo a la carpeta de mods del juego:

```bash
# Ejecutar todo el pipeline (Linter + Test Suite + Sync automático)
python dev.py all

# Análisis estático y verificación de sintaxis Lua
python dev.py lint

# Ejecución de la suite de pruebas unitarias automatizadas (18 tests)
python dev.py test

# Sincronización y despliegue directo a la carpeta de mods de Project Zomboid
python dev.py sync

# Modo observador (Watcher): Re-analiza y re-despliega automáticamente al guardar
python dev.py watch
```

---

## 📦 5. Instalación

1. Copia la carpeta `ProtectedArmories` a la ruta de mods de Project Zomboid:
   `C:\Users\<TuUsuario>\Zomboid\mods\ProtectedArmories\`
2. Activa el mod en el menú de **Mods** del juego.
3. Al iniciar una nueva partida o cargar una existente, los contenedores quedarán protegidos automáticamente.

---

## 📜 Licencia y Créditos
- **Autor:** Sergio
- **Versión de Project Zomboid:** Build 42.20.3+ / Build 41.78+
