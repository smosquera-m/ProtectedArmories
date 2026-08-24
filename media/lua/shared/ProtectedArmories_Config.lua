-- =============================================================================
-- Protected Armories & Loot Respawn (Armerías Protegidas)
-- File: media/lua/shared/ProtectedArmories_Config.lua
-- Compatible with Build 42.x & Build 41.x
-- =============================================================================

ProtectedArmories = ProtectedArmories or {}

-- Default configuration (can be adjusted via Sandbox Options)
ProtectedArmories.DefaultConfig = {
    OnlyWorldSpawned        = true,     -- Protect ONLY world-spawned containers (ignore player built/placed)
    ProtectPolice           = true,     -- Protect police station armories & lockers
    ProtectGunStores        = true,     -- Protect gun stores & gun storages
    ProtectMilitary         = true,     -- Protect military storages & surplus
    ProtectPrisons          = true,     -- Protect prison storages
    ProtectSecurity         = true,     -- Protect security rooms & archives
    ProtectGunLockers       = true,     -- Protect specific police gun lockers (furniture_storage_02_8..11)
    ProtectArmorLockers     = true,     -- Protect specific police armor lockers (furniture_storage_02_4..7)
    PreventMoving           = true,     -- Prevent picking up / moving
    PreventDisassembling    = true,     -- Prevent dismantling / scrapping
    PreventSledgehammer     = true,     -- Prevent sledgehammer destruction
    ShowHaloWarning         = true,     -- Display floating warning message on interaction
    CustomRoomsList         = "",       -- Custom entries format: "Building|Room|Category;..."
}

-- Structured default list of protected room definitions with Building & Room metadata
ProtectedArmories.DefaultProtectedList = {
    -- Comisarias de Policia (Police Stations)
    { building = "Comisaria de Policia", room = "policegunstorage", roomName = "Armeria Principal", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policestorage", roomName = "Almacen Policial", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policelocker", roomName = "Taquillas Policiales", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policeswat", roomName = "Armeria SWAT", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policeoutfitstorage", roomName = "Almacen de Equipamiento", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policearchive", roomName = "Archivo Policial", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policeoffice", roomName = "Oficina Policial", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policeevidence", roomName = "Almacen de Pruebas", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "policehall", roomName = "Pasillo Policial", category = "Police", defaultEnabled = true },
    { building = "Comisaria de Policia", room = "police", roomName = "Area Policial General", category = "Police", defaultEnabled = true },

    -- Tiendas de Armas (Gun Stores)
    { building = "Tienda de Armas", room = "gunstorestorage", roomName = "Almacen de Armas", category = "GunStore", defaultEnabled = true },
    { building = "Tienda de Armas", room = "gunstore", roomName = "Tienda de Armas", category = "GunStore", defaultEnabled = true },
    { building = "Tienda de Armas", room = "gunstoredisplay", roomName = "Exhibicion de Armas", category = "GunStore", defaultEnabled = true },

    -- Bases & Tiendas Militares (Military)
    { building = "Base Militar", room = "armystorage", roomName = "Armeria Militar", category = "Military", defaultEnabled = true },
    { building = "Tienda Militar / Surplus", room = "armysurplus", roomName = "Almacen Surplus", category = "Military", defaultEnabled = true },
    { building = "Base Militar", room = "armytent", roomName = "Carpa de Armamento", category = "Military", defaultEnabled = true },
    { building = "Base Militar", room = "armymedical", roomName = "Almacen Medico Militar", category = "Military", defaultEnabled = true },
    { building = "Base Militar", room = "army", roomName = "Area Militar General", category = "Military", defaultEnabled = true },

    -- Prisiones (Prisons)
    { building = "Prision", room = "prisonstorage", roomName = "Almacen de Prision", category = "Prison", defaultEnabled = true },
    { building = "Prision", room = "prisonarmory", roomName = "Armeria de Prision", category = "Prison", defaultEnabled = true },
    { building = "Prision", room = "prisoncell", roomName = "Celda de Prision", category = "Prison", defaultEnabled = true },
    { building = "Prision", room = "prison", roomName = "Area de Prision General", category = "Prison", defaultEnabled = true },

    -- Edificios de Seguridad (Security)
    { building = "Edificio de Seguridad", room = "securitystorage", roomName = "Boveda de Seguridad", category = "Security", defaultEnabled = true },
    { building = "Edificio de Seguridad", room = "security", roomName = "Oficina de Seguridad", category = "Security", defaultEnabled = true },
}

-- Structured default list of weapon/armor locker sprites with metadata
ProtectedArmories.DefaultSpriteList = {
    -- Police Gun Lockers
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_8", containerName = "Armario de Armas (Tipo 1)", category = "GunLocker", defaultEnabled = true },
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_9", containerName = "Armario de Armas (Tipo 2)", category = "GunLocker", defaultEnabled = true },
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_10", containerName = "Armario de Armas (Tipo 3)", category = "GunLocker", defaultEnabled = true },
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_11", containerName = "Armario de Armas (Tipo 4)", category = "GunLocker", defaultEnabled = true },

    -- Police Armor Lockers
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_4", containerName = "Armario Blindado (Tipo 1)", category = "ArmorLocker", defaultEnabled = true },
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_5", containerName = "Armario Blindado (Tipo 2)", category = "ArmorLocker", defaultEnabled = true },
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_6", containerName = "Armario Blindado (Tipo 3)", category = "ArmorLocker", defaultEnabled = true },
    { building = "Cualquier Edificio", room = "Todas las Habitaciones", sprite = "furniture_storage_02_7", containerName = "Armario Blindado (Tipo 4)", category = "ArmorLocker", defaultEnabled = true },
}

-- Direct Room definition lookup map
ProtectedArmories.ProtectedRooms = {
    -- Police Stations
    ["policestorage"]       = "Police",
    ["policegunstorage"]    = "Police",
    ["policelocker"]        = "Police",
    ["policeswat"]          = "Police",
    ["policeoutfitstorage"] = "Police",
    ["policearchive"]       = "Police",
    ["policeoffice"]        = "Police",
    ["policeevidence"]      = "Police",
    ["policehall"]          = "Police",
    ["police"]              = "Police",
    
    -- Gun Stores
    ["gunstore"]            = "GunStore",
    ["gunstorestorage"]     = "GunStore",
    ["gunstoredisplay"]     = "GunStore",
    
    -- Military & Army
    ["armystorage"]         = "Military",
    ["armysurplus"]         = "Military",
    ["armytent"]            = "Military",
    ["armymedical"]         = "Military",
    ["army"]                = "Military",
    
    -- Prisons
    ["prisonstorage"]       = "Prison",
    ["prisonarmory"]        = "Prison",
    ["prisoncell"]          = "Prison",
    ["prison"]              = "Prison",
    ["security"]            = "Security",
    ["securitystorage"]     = "Security",
}

-- Direct Weapon Sprite lookup map
ProtectedArmories.WeaponSprites = {
    -- Police Gun Lockers
    ["furniture_storage_02_8"]  = "GunLocker",
    ["furniture_storage_02_9"]  = "GunLocker",
    ["furniture_storage_02_10"] = "GunLocker",
    ["furniture_storage_02_11"] = "GunLocker",
    
    -- Police Armor Lockers
    ["furniture_storage_02_4"]  = "ArmorLocker",
    ["furniture_storage_02_5"]  = "ArmorLocker",
    ["furniture_storage_02_6"]  = "ArmorLocker",
    ["furniture_storage_02_7"]  = "ArmorLocker",
}

--- Retrieves room metadata definition entry by room definition name
--- @param roomName string
--- @return table|nil entry { building, room, roomName, category }
function ProtectedArmories.getRoomEntry(roomName)
    if not roomName or roomName == "" then return nil end

    for _, entry in ipairs(ProtectedArmories.DefaultProtectedList) do
        if entry.room == roomName then
            return entry
        end
    end

    local customListStr = ProtectedArmories.getOption("CustomRoomsList")
    if customListStr and customListStr ~= "" then
        for customEntryStr in string.gmatch(customListStr, "([^;]+)") do
            local building, rName, category = string.match(customEntryStr, "^([^|]+)|([^|]+)|([^|]+)$")
            if rName and string.lower(string.trim and string.trim(rName) or rName) == string.lower(roomName) then
                return {
                    building = building and (string.trim and string.trim(building) or building) or "Edificio Personalizado",
                    room = roomName,
                    roomName = roomName,
                    category = category and (string.trim and string.trim(category) or category) or "Custom",
                    defaultEnabled = true
                }
            end
        end
    end

    if ProtectedArmories.ProtectedRooms[roomName] then
        local cat = ProtectedArmories.ProtectedRooms[roomName]
        return {
            building = "Edificio Protegido (" .. tostring(cat) .. ")",
            room = roomName,
            roomName = roomName,
            category = cat,
            defaultEnabled = true
        }
    end

    return nil
end

--- Retrieves sprite metadata definition entry by sprite name
--- @param spriteName string
--- @return table|nil entry { building, room, sprite, containerName, category }
function ProtectedArmories.getSpriteEntry(spriteName)
    if not spriteName or spriteName == "" then return nil end

    for _, entry in ipairs(ProtectedArmories.DefaultSpriteList) do
        if entry.sprite == spriteName then
            return entry
        end
    end

    if ProtectedArmories.WeaponSprites[spriteName] then
        local cat = ProtectedArmories.WeaponSprites[spriteName]
        return {
            building = "Cualquier Edificio",
            room = "Todas las Habitaciones",
            sprite = spriteName,
            containerName = "Armario de Armas (" .. tostring(spriteName) .. ")",
            category = cat,
            defaultEnabled = true
        }
    end

    return nil
end

--- Retrieves active sandbox configuration option with fallback
--- @param optionName string
--- @return any
function ProtectedArmories.getOption(optionName)
    if not optionName then return false end

    -- 1. Query live SandboxOptions Java object for dynamic in-game menu changes
    if getSandboxOptions then
        local sb = getSandboxOptions()
        if sb then
            local opt = sb:getOptionByName("ProtectedArmories." .. tostring(optionName))
            if not opt then
                opt = sb:getOptionByName(tostring(optionName))
            end
            if opt then
                if opt.getValue then
                    return opt:getValue()
                elseif opt.asConfigOption and opt:asConfigOption() and opt:asConfigOption().getValue then
                    return opt:asConfigOption():getValue()
                end
            end
        end
    end

    -- 2. Query SandboxVars table
    if SandboxVars then
        if SandboxVars.ProtectedArmories and SandboxVars.ProtectedArmories[optionName] ~= nil then
            return SandboxVars.ProtectedArmories[optionName]
        end
        if SandboxVars["ProtectedArmories_" .. tostring(optionName)] ~= nil then
            return SandboxVars["ProtectedArmories_" .. tostring(optionName)]
        end
        if SandboxVars[optionName] ~= nil then
            return SandboxVars[optionName]
        end
    end

    -- 3. Fallback to DefaultConfig
    if ProtectedArmories.DefaultConfig and ProtectedArmories.DefaultConfig[optionName] ~= nil then
        return ProtectedArmories.DefaultConfig[optionName]
    end

    return false
end

--- Checks if a player has admin or moderator privileges
--- @param playerObj IsoPlayer
--- @return boolean
function ProtectedArmories.isAdmin(playerObj)
    if not playerObj then return false end
    if playerObj.getAccessLevel then
        local accessLevel = playerObj:getAccessLevel()
        if accessLevel and accessLevel ~= "" and accessLevel ~= "None" and accessLevel ~= "Observer" then
            return true
        end
    end
    return false
end

--- Checks if a container object was constructed or placed by a player
--- @param object IsoObject
--- @return boolean isPlayerCreated
function ProtectedArmories.isPlayerCreated(object)
    if not object then return false end

    -- Check modData for player flags set during carpentry/metalworking/placement
    if object.getModData then
        local modData = object:getModData()
        if modData then
            if modData.pzc_playerCreated == true then return true end
            if modData.bBuilt == true then return true end
            if modData.buildBy ~= nil and modData.buildBy ~= "" then return true end
            if modData.playerBuilt == true then return true end
            if modData.constructed == true then return true end
            if modData.placedBy ~= nil and modData.placedBy ~= "" then return true end
        end
    end

    -- Check if object is an IsoThumpable with builder properties
    if instanceof and instanceof(object, "IsoThumpable") then
        if object.isCanPass and object:getModData() then
            local md = object:getModData()
            if md and (md.bBuilt or md.buildBy or md.pzc_playerCreated) then
                return true
            end
        end
    end

    return false
end

--- Determines if a given world object or sprite is a protected armory container
--- @param object IsoObject Target tile object
--- @param spriteProps table ISMoveableSpriteProps instance (optional)
--- @param playerObj IsoPlayer
--- @return boolean isProtected
--- @return string categoryType Description of protection type ("Police Armory", etc.)
--- @return boolean isAdminOverride Always false
--- @return table|nil detailObj Detailed metadata containing building, room, category
function ProtectedArmories.isProtected(object, spriteProps, playerObj)
    local square = nil
    if object and object.getSquare then
        square = object:getSquare()
    elseif spriteProps and spriteProps.square then
        square = spriteProps.square
    end

    local isContainer = false
    local containerType = ""
    local spriteName = ""

    if object then
        if object.getContainer and object:getContainer() ~= nil then
            isContainer = true
            containerType = object:getContainer():getType() or ""
        elseif object.getContainerCount and object:getContainerCount() > 0 then
            isContainer = true
        end
        if object.getSprite and object:getSprite() then
            if object:getSprite():getName() then
                spriteName = object:getSprite():getName()
            end
        end
        if (not spriteName or spriteName == "") and object.getSpriteName then
            spriteName = object:getSpriteName() or ""
        end
    end

    if spriteProps then
        if spriteProps.isContainer then isContainer = true end
        if spriteProps.name and spriteProps.name ~= "" then spriteName = spriteProps.name end
        if spriteProps.type then containerType = spriteProps.type end
    end

    -- Protection ONLY applies to actual container objects
    if not isContainer then
        return false, "NotContainer", false, nil
    end

    -- Exclude player-created/built containers if OnlyWorldSpawned option is enabled
    if ProtectedArmories.getOption("OnlyWorldSpawned") then
        if ProtectedArmories.isPlayerCreated(object) then
            return false, "PlayerCreated", false, nil
        end
    end

    local isProt = false
    local catInfo = "None"
    local detailObj = {}

    -- Check room metadata if container is inside a defined room
    local roomEntry = nil
    if square and square.getRoom and square:getRoom() ~= nil then
        local room = square:getRoom()
        local rName = room:getName()
        if rName and rName ~= "" then
            roomEntry = ProtectedArmories.getRoomEntry(rName)
            if not roomEntry then
                roomEntry = {
                    building = "Edificio (" .. tostring(rName) .. ")",
                    room = rName,
                    roomName = rName,
                    category = "Custom",
                    defaultEnabled = true
                }
            end
        end
    end

    -- Check sprite metadata
    local spriteEntry = nil
    if spriteName and spriteName ~= "" then
        spriteEntry = ProtectedArmories.getSpriteEntry(spriteName)
    end

    -- 1. Direct weapon/armor locker sprite match
    if spriteEntry then
        local lockerType = spriteEntry.category
        if lockerType == "GunLocker" and ProtectedArmories.getOption("ProtectGunLockers") then
            isProt = true
            catInfo = spriteEntry.containerName or ("Weapon Locker (" .. spriteName .. ")")
        elseif lockerType == "ArmorLocker" and ProtectedArmories.getOption("ProtectArmorLockers") then
            isProt = true
            catInfo = spriteEntry.containerName or ("Armor Locker (" .. spriteName .. ")")
        end
    end

    -- 2. Room-based match
    if not isProt and roomEntry then
        local roomCategory = roomEntry.category
        if (roomCategory == "Police" and ProtectedArmories.getOption("ProtectPolice"))
        or (roomCategory == "GunStore" and ProtectedArmories.getOption("ProtectGunStores"))
        or (roomCategory == "Military" and ProtectedArmories.getOption("ProtectMilitary"))
        or (roomCategory == "Prison" and ProtectedArmories.getOption("ProtectPrisons"))
        or (roomCategory == "Security" and ProtectedArmories.getOption("ProtectSecurity"))
        or (roomCategory ~= "Police" and roomCategory ~= "GunStore" and roomCategory ~= "Military" and roomCategory ~= "Prison" and roomCategory ~= "Security") then
            isProt = true
            catInfo = roomEntry.building .. " - " .. (roomEntry.roomName or roomEntry.room)
        end
    end

    if not isProt then
        return false, "None", false, nil
    end

    -- Combine building, room, and container details
    if roomEntry then
        detailObj.building = roomEntry.building
        detailObj.room = roomEntry.room
        detailObj.roomName = roomEntry.roomName
        detailObj.category = roomEntry.category
    else
        detailObj.building = spriteEntry and spriteEntry.building or "Ubicacion General"
        detailObj.room = "General"
        detailObj.roomName = "General"
        detailObj.category = spriteEntry and spriteEntry.category or "General"
    end

    if spriteEntry then
        detailObj.containerName = spriteEntry.containerName or spriteName
    elseif containerType and containerType ~= "" then
        detailObj.containerName = containerType
    else
        detailObj.containerName = "Contenedor de Armas"
    end

    return true, catInfo, false, detailObj
end

