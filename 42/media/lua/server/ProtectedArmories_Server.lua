-- =============================================================================
-- Protected Armories & Loot Respawn (Armerías Protegidas)
-- File: media/lua/server/ProtectedArmories_Server.lua
-- =============================================================================

ProtectedArmories = ProtectedArmories or {}

ProtectedArmories.TrackedContainers = {}

--- Snapshots initial loot of a protected container if not already stored
--- @param container ItemContainer
--- @param object IsoObject
function ProtectedArmories.snapshotLoot(container, object)
    if not container or not object or not object.getModData then return end
    local isProt, _ = ProtectedArmories.isProtected(object, nil, nil)
    if not isProt then return end

    local modData = object:getModData()
    if not modData then return end

    if not modData.pzc_initialLoot then
        local items = container:getItems()
        if items and items:size() > 0 then
            local snapshot = {}
            for i = 0, items:size() - 1 do
                local item = items:get(i)
                if item and item.getFullType then
                    local cond = 100
                    if item.getCondition then
                        cond = item:getCondition()
                    end
                    table.insert(snapshot, {
                        fullType = item:getFullType(),
                        condition = cond,
                    })
                end
            end
            modData.pzc_initialLoot = snapshot
            local currentH = 0
            if getGameTime then currentH = getGameTime():getWorldAgeHours() end
            modData.pzc_lastRespawn = currentH
        end
    end
end

--- Respawn missing loot for a container
--- @param container ItemContainer
--- @param object IsoObject
function ProtectedArmories.respawnLootIfNeeded(container, object)
    if not container or not object or not object.getModData then return end
    local isProt, _ = ProtectedArmories.isProtected(object, nil, nil)
    if not isProt then return end

    -- Ensure initial loot snapshot exists
    ProtectedArmories.snapshotLoot(container, object)

    local modData = object:getModData()
    if not modData then return end

    local initialLoot = modData.pzc_initialLoot
    if not initialLoot or type(initialLoot) ~= "table" or #initialLoot == 0 then return end

    local currentHours = 0
    if getGameTime then currentHours = getGameTime():getWorldAgeHours() end
    local interval = ProtectedArmories.getOption("RespawnIntervalHours") or 24
    local lastRespawn = modData.pzc_lastRespawn or 0

    if (currentHours - lastRespawn) >= interval then
        -- Count current items by fullType
        local currentItems = container:getItems()
        local currentCounts = {}
        if currentItems then
            for i = 0, currentItems:size() - 1 do
                local item = currentItems:get(i)
                if item and item.getFullType then
                    local ft = item:getFullType()
                    currentCounts[ft] = (currentCounts[ft] or 0) + 1
                end
            end
        end

        -- Count required initial items
        local requiredCounts = {}
        for _, entry in ipairs(initialLoot) do
            if entry and entry.fullType then
                requiredCounts[entry.fullType] = (requiredCounts[entry.fullType] or 0) + 1
            end
        end

        -- Add missing items
        local respawnedAny = false
        for fullType, requiredCount in pairs(requiredCounts) do
            local currentCount = currentCounts[fullType] or 0
            if currentCount < requiredCount then
                local missingCount = requiredCount - currentCount
                for c = 1, missingCount do
                    container:AddItem(fullType)
                    respawnedAny = true
                end
            end
        end

        if respawnedAny then
            modData.pzc_lastRespawn = currentHours
        end
    end
end

--- Hook destruction tool (Sledgehammer)
local function hookDestroyCursor()
    if ISDestroyCursor then
        local orig_canDestroy = ISDestroyCursor.canDestroy
        function ISDestroyCursor:canDestroy(object)
            if ProtectedArmories.getOption("PreventSledgehammer") then
                local playerObj = self.character or (getPlayer and getPlayer() or nil)
                local isProt = ProtectedArmories.isProtected(object, nil, playerObj)
                if isProt then
                    return false
                end
            end
            if orig_canDestroy then
                return orig_canDestroy(self, object)
            end
            return true
        end
    end
end

--- Hook container opening / updating
local function onContainerInteraction(character, container)
    if not container or not character then return end
    local object = container:getParent()
    if object then
        ProtectedArmories.snapshotLoot(container, object)
        if ProtectedArmories.getOption("EnableLootRespawn") then
            ProtectedArmories.respawnLootIfNeeded(container, object)
        end
    end
end

--- Periodic check for loaded cells
local function onEveryHours()
    if not ProtectedArmories.getOption("EnableLootRespawn") then return end
    if not getPlayer or not getPlayer() then return end
    local player = getPlayer()
    local pSquare = player:getSquare()
    if not pSquare then return end
    
    local room = pSquare:getRoom()
    if room and room:getSquares() then
        local sqs = room:getSquares()
        for i = 0, sqs:size() - 1 do
            local sq = sqs:get(i)
            if sq then
                local objects = sq:getObjects()
                if objects then
                    for j = 0, objects:size() - 1 do
                        local obj = objects:get(j)
                        if obj and obj.getContainer and obj:getContainer() ~= nil then
                            ProtectedArmories.respawnLootIfNeeded(obj:getContainer(), obj)
                        end
                    end
                end
            end
        end
    end
end

--- Scans surrounding squares/rooms and prints all protected containers to log/console
--- @return table List of protected container records {x, y, z, info, type}
function ProtectedArmories.dumpProtectedContainers()
    local results = {}
    if not getPlayer or not getPlayer() then return results end
    local player = getPlayer()
    local pSquare = player:getSquare()
    if not pSquare then return results end

    local cell = getCell and getCell() or nil
    if not cell then return results end

    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = math.floor(player:getZ())

    print("[ProtectedArmories] Scanning loaded cells around player (" .. px .. ", " .. py .. ", " .. pz .. ")...")

    local minX, maxX = px - 50, px + 50
    local minY, maxY = py - 50, py + 50

    for x = minX, maxX do
        for y = minY, maxY do
            local sq = cell:getGridSquare(x, y, pz)
            if sq then
                local objects = sq:getObjects()
                if objects then
                    for j = 0, objects:size() - 1 do
                        local obj = objects:get(j)
                        if obj then
                            local isProt, info = ProtectedArmories.isProtected(obj, nil, player)
                            if isProt then
                                local containerType = "Unknown"
                                if obj.getContainer and obj:getContainer() then
                                    containerType = obj:getContainer():getType() or "Unknown"
                                end
                                local rec = {
                                    x = x,
                                    y = y,
                                    z = pz,
                                    info = info,
                                    type = containerType,
                                }
                                table.insert(results, rec)
                                print(string.format("  [PROTECTED] Contenedor '%s' (%s) en X:%d, Y:%d, Z:%d", containerType, info, x, y, pz))
                            end
                        end
                    end
                end
            end
        end
    end

    print("[ProtectedArmories] Total contenedores protegidos encontrados: " .. tostring(#results))
    return results
end

if Events then
    if Events.OnGameStart then Events.OnGameStart.Add(hookDestroyCursor) end
    if Events.EveryHours then Events.EveryHours.Add(onEveryHours) end
end
hookDestroyCursor()
