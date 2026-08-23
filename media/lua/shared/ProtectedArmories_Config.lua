-- =============================================================================
-- Protected Armories & Loot Respawn (Armerías Protegidas)
-- File: media/lua/shared/ProtectedArmories_Config.lua
-- Compatible with Build 42.x & Build 41.x
-- =============================================================================

ProtectedArmories = ProtectedArmories or {}

-- Default configuration (can be adjusted via Sandbox Options)
ProtectedArmories.DefaultConfig = {
    ProtectPolice           = true,     -- Protect police station armories & lockers
    ProtectGunStores        = true,     -- Protect gun stores & gun storages
    ProtectMilitary         = true,     -- Protect military storages & surplus
    ProtectPrisons          = true,     -- Protect prison storages
    PreventMoving           = true,     -- Prevent picking up / moving
    PreventDisassembling    = true,     -- Prevent dismantling / scrapping
    PreventSledgehammer     = true,     -- Prevent sledgehammer destruction
    EnableLootRespawn       = true,     -- Automatically respawn initial loot
    RespawnIntervalHours    = 24,       -- In-game hours between loot respawn checks
    ShowHaloWarning         = true,     -- Display floating warning message on interaction
}

-- Room definition names that contain weapon / armor armories
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

-- Specific weapon/armor locker sprite names used in Project Zomboid
ProtectedArmories.WeaponSprites = {
    -- Police Gun Lockers
    ["furniture_storage_02_8"]  = true,
    ["furniture_storage_02_9"]  = true,
    ["furniture_storage_02_10"] = true,
    ["furniture_storage_02_11"] = true,
    
    -- Police Armor Lockers
    ["furniture_storage_02_4"]  = true,
    ["furniture_storage_02_5"]  = true,
    ["furniture_storage_02_6"]  = true,
    ["furniture_storage_02_7"]  = true,
}

--- Retrieves active sandbox configuration option with fallback
--- @param optionName string
--- @return any
function ProtectedArmories.getOption(optionName)
    if SandboxVars and SandboxVars.ProtectedArmories and SandboxVars.ProtectedArmories[optionName] ~= nil then
        return SandboxVars.ProtectedArmories[optionName]
    end
    if ProtectedArmories.DefaultConfig[optionName] ~= nil then
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

--- Determines if a given world object or sprite is a protected armory container
--- @param object IsoObject Target tile object
--- @param spriteProps table ISMoveableSpriteProps instance (optional)
--- @param playerObj IsoPlayer
--- @return boolean isProtected
--- @return string categoryType Description of protection type ("Police Armory", etc.)
--- @return boolean isAdminOverride Always false
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
        return false, "NotContainer", false
    end

    local isProt = false
    local catInfo = "None"

    -- 1. Direct weapon/armor sprite match (e.g. Gun locker tiles anywhere)
    if spriteName and spriteName ~= "" and ProtectedArmories.WeaponSprites[spriteName] then
        isProt = true
        catInfo = "Weapon Locker (" .. spriteName .. ")"
    end

    -- 2. Room-based match (e.g. any container in policegunstorage, policestorage, gunstorestorage, armystorage)
    if not isProt and square and square.getRoom and square:getRoom() ~= nil then
        local room = square:getRoom()
        local roomName = room:getName()
        if roomName and ProtectedArmories.ProtectedRooms[roomName] then
            local roomCategory = ProtectedArmories.ProtectedRooms[roomName]
            
            if roomCategory == "Police" and ProtectedArmories.getOption("ProtectPolice") then
                isProt = true
                catInfo = "Police Armory (" .. roomName .. ")"
            elseif roomCategory == "GunStore" and ProtectedArmories.getOption("ProtectGunStores") then
                isProt = true
                catInfo = "Gun Store Armory (" .. roomName .. ")"
            elseif roomCategory == "Military" and ProtectedArmories.getOption("ProtectMilitary") then
                isProt = true
                catInfo = "Military Armory (" .. roomName .. ")"
            elseif roomCategory == "Prison" and ProtectedArmories.getOption("ProtectPrisons") then
                isProt = true
                catInfo = "Prison Armory (" .. roomName .. ")"
            elseif roomCategory == "Security" and ProtectedArmories.getOption("ProtectPolice") then
                isProt = true
                catInfo = "Security Armory (" .. roomName .. ")"
            end
        end
    end

    if not isProt then
        return false, "None", false
    end

    return true, catInfo, false
end
