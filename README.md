<div align="center">

![Protected Armories](poster.png)

# 🧟 Protected Armories

**Protección absoluta e indestructible configurable para armerías, comisarías, tiendas de armas y bases militares en Project Zomboid.**

[![Project Zomboid Build 42](https://img.shields.io/badge/Project_Zomboid-Build_42_%26_41-orange.svg?style=for-the-badge&logo=projectzomboid)](https://projectzomboid.com/)
[![Steam Workshop](https://img.shields.io/badge/Steam_Workshop-3788795717-blue.svg?style=for-the-badge&logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=3788795717)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![Status](https://img.shields.io/badge/Tests-20%2F20_Passing-brightgreen.svg?style=for-the-badge)]()

</div>

---

## 📖 Acerca del Mod

**Protected Armories** es un mod avanzado para **Project Zomboid (Build 42.x & Build 41.x)** diseñado para servidores multijugador y partidas en solitario. Identifica y protege automáticamente todos los contenedores de armas y armaduras que **spawnean en el mundo** en comisarías, tiendas de armas, puestos militares y prisiones de Knox Country.

> [!IMPORTANT]
> - **Exclusivo para Contenedores del Mundo (World-Spawned Only):** La protección aplica **únicamente** a los contenedores que se generan naturalmente en el mapa. Si un jugador fabrica o coloca un contenedor (carpintería, metalistería o sistema de muebles), este **NO** será protegido y podrá ser movido o destruido libremente.
> - **Protección Absoluta Sin Excepciones:** Para los contenedores del mundo configurados, estos son **100% inamovibles e indestructibles** por métodos tradicionales para **TODOS** los jugadores (incluyendo usuarios con rol de Administrador o Moderador).

---

## ⚡ Características Destacadas

* 🌍 **Filtro de Contenedores del Mundo:** Comprueba y excluye automáticamente cualquier mueble fabricado o colocado por jugadores.
* ⚙️ **Totalmente Configurable:** Permite seleccionar exactamente qué armarios o categorías de habitaciones se desean proteger desde las Opciones de Sandbox.
* 🔒 **Bloqueo Inamovible:** Anula la herramienta de mover/levantar muebles (`Pick Up`).
* 🔨 **Bloqueo Indestructible:** Anula las opciones de desguazar/desmontar (`Disassemble` / `Scrap`) y la destrucción con mazo (*Sledgehammer*).
* ℹ️ **Menú Contextual Informativo:** Clic derecho sobre un contenedor protegido muestra un submenú limpio con el estado y la ubicación de la armería.
* 🎯 **Detección Dinámica Universal:** Funciona automáticamente en mapas nativos (Rosewood, Muldraugh, West Point, Riverside, Louisville, etc.) y en mapas de mods personalizados.

---

## 🛡️ Contenedores y Habitaciones Protegidas

### 1. Sprites Específicos de Armería (Protegidos en todo el mapa)
| Sprite ID | Tipo de Contenedor | Configuración | Descripción |
| :--- | :--- | :--- | :--- |
| `furniture_storage_02_8` .. `11` | Armarios armeros metálicos | `ProtectGunLockers` | Armarios de armas con rejilla frontal / metálicos |
| `furniture_storage_02_4` .. `7` | Armarios blindados de protección | `ProtectArmorLockers` | Armarios metálicos de equipamiento / armadura |

### 2. Habitaciones Protegidas (`RoomDef`)
* **Comisarías de Policía (`ProtectPolice`):** `policestorage`, `policegunstorage`, `policelocker`, `policeswat`, `policeoutfitstorage`, `policearchive`, `policeoffice`, `policeevidence`, `policehall`, `police`
* **Tiendas de Armas (`ProtectGunStores`):** `gunstore`, `gunstorestorage`, `gunstoredisplay`
* **Bases & Tiendas Militares (`ProtectMilitary`):** `armystorage`, `armysurplus`, `armytent`, `armymedical`, `army`
* **Prisiones (`ProtectPrisons`):** `prisonstorage`, `prisonarmory`, `prisoncell`, `prison`
* **Salas de Seguridad (`ProtectSecurity`):** `security`, `securitystorage`

---

## ⚙️ Opciones de Sandbox (Sandbox Vars)

Puedes personalizar el comportamiento del mod directamente desde las opciones de Sandbox:

| Variable | Defecto | Descripción |
| :--- | :---: | :--- |
| `OnlyWorldSpawned` | `true` | Proteger únicamente contenedores que spawnean en el mundo (ignora contenedores de jugador). |
| `ProtectPolice` | `true` | Proteger comisarías de policía y taquillas armeras. |
| `ProtectGunStores` | `true` | Proteger tiendas de armas y sus almacenes. |
| `ProtectMilitary` | `true` | Proteger bases militares, armerías y tiendas surplus. |
| `ProtectPrisons` | `true` | Proteger armerías y taquillas de prisiones. |
| `ProtectSecurity` | `true` | Proteger salas de seguridad y archivos. |
| `ProtectGunLockers` | `true` | Proteger taquillas/armarios de armas específicos (`furniture_storage_02_8..11`). |
| `ProtectArmorLockers` | `true` | Proteger taquillas de armadura/blindaje específicas (`furniture_storage_02_4..7`). |
| `PreventMoving` | `true` | Bloquear mover o levantar muebles. |
| `PreventDisassembling` | `true` | Bloquear desguazar o desmontar. |
| `PreventSledgehammer` | `true` | Bloquear destrucción con mazo. |
| `ShowHaloWarning` | `true` | Mostrar aviso flotante al intentar interactuar con un contenedor bloqueado. |
| `CustomRoomsList` | `""` | Lista personalizada de edificios y habitaciones protegidas. |

### 📝 Ejemplos de Configuración Personalizada (`CustomRoomsList`)

Puedes añadir nuevos edificios y habitaciones (por ejemplo, para mapas de mods personalizados como *Raven Creek*, *Bedford Falls* o *Fort Redstone*) directamente en el campo de texto `CustomRoomsList` desde las Opciones de Sandbox:

**Formato:** `Nombre de Edificio|Nombre de Habitación|Categoría` *(múltiples entradas separadas por `;`)*

- **Ejemplo 1 (Añadir una armería en un mapa mod de comisaría):**
  `Comisaría Raven Creek|ravenpolicearmory|Police`

- **Ejemplo 2 (Añadir un búnker militar de armas):**
  `Búnker Subterráneo|bunkergunroom|Military`

- **Ejemplo 3 (Múltiples zonas personalizadas en la misma partida):**
  `Comisaría Raven Creek|ravenpolicearmory|Police;Búnker Subterráneo|bunkergunroom|Military;Tienda Custom|customgunstore|GunStore`

---

## 📍 Lista de Ubicaciones y Comandos de Teletransporte

Puedes usar estos comandos directamente en el chat (`/teleportto X,Y,Z`) o en la consola Lua (`getPlayer():setX(X); getPlayer():setY(Y); getPlayer():setZ(Z)`):

### 🚓 Comisarías de Policía
| Ubicación | Zona | Coordenadas `(X, Y, Z)` | Comando de Teletransporte |
| :--- | :--- | :---: | :--- |
| **Rosewood Police Station** | `policegunstorage` | `8067, 11722, 0` | `/teleportto 8067,11722,0` |
| **Muldraugh Police Station** | `policegunstorage` | `10635, 10410, 0` | `/teleportto 10635,10410,0` |
| **West Point Police Station** | `policegunstorage` | `11900, 6960, 0` | `/teleportto 11900,6960,0` |
| **Riverside Police Station** | `policegunstorage` | `6080, 5265, 0` | `/teleportto 6080,5265,0` |
| **Louisville Central Police HQ** | `policegunstorage` | `12480, 3600, 0` | `/teleportto 12480,3600,0` |
| **Louisville SWAT HQ / Armory** | `policeswat` | `12350, 3520, 0` | `/teleportto 12350,3520,0` |

### 🔫 Tiendas de Armas (*Gun Stores*)
| Ubicación | Zona | Coordenadas `(X, Y, Z)` | Comando de Teletransporte |
| :--- | :--- | :---: | :--- |
| **West Point Gun Store** | `gunstorestorage` | `12065, 6765, 0` | `/teleportto 12065,6765,0` |
| **Doe Valley Gun Store** | `gunstore` | `3790, 8520, 0` | `/teleportto 3790,8520,0` |
| **Louisville East Gun Store** | `gunstorestorage` | `13240, 3340, 0` | `/teleportto 13240,3340,0` |
| **Louisville West Gun Store** | `gunstorestorage` | `12110, 1530, 0` | `/teleportto 12110,1530,0` |

### 🎖️ Bases y Tiendas Militares (*Army & Surplus*)
| Ubicación | Zona | Coordenadas `(X, Y, Z)` | Comando de Teletransporte |
| :--- | :--- | :---: | :--- |
| **Dixie Highway Army Surplus** | `armysurplus` | `11580, 8820, 0` | `/teleportto 11580,8820,0` |
| **Valley Station Surplus Store** | `armysurplus` | `12905, 5120, 0` | `/teleportto 12905,5120,0` |
| **Louisville Checkpoint Storage** | `armystorage` | `12550, 4300, 0` | `/teleportto 12550,4300,0` |
| **Secret Military Base (Forest)** | `armystorage` | `5570, 12480, 0` | `/teleportto 5570,12480,0` |

### 🔒 Prisiones y Seguridad
| Ubicación | Zona | Coordenadas `(X, Y, Z)` | Comando de Teletransporte |
| :--- | :--- | :---: | :--- |
| **Rosewood Prison Armory** | `prisonarmory` | `7660, 11825, 0` | `/teleportto 7660,11825,0` |
| **March Ridge Security Office** | `securitystorage` | `10100, 12720, 0` | `/teleportto 10100,12720,0` |
| **Louisville Pawn Shop** | `securitystorage` | `12810, 3620, 0` | `/teleportto 12810,3620,0` |

---

## 🛠️ Developer Toolkit (`dev.py`)

El repositorio incluye un conjunto de herramientas CLI automáticas en Python para garantizar la calidad del código:

```bash
# Ejecutar pipeline completo (Linter + Test Suite + Sync automático)
python dev.py all

# Análisis estático y verificación de sintaxis Lua
python dev.py lint

# Ejecutar suite de pruebas unitarias (20 tests)
python dev.py test

# Desplegar automáticamente a la carpeta de mods del juego y Workshop
python dev.py sync

# Modo observador (Watcher): Re-analiza y re-despliega automáticamente al guardar
python dev.py watch
```

---

## 📜 Licencia
Este proyecto está bajo la Licencia MIT. Creado por **Sergio**.

