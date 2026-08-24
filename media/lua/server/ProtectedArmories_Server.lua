-- =============================================================================
-- Protected Armories (Armerías Protegidas)
-- File: media/lua/server/ProtectedArmories_Server.lua
-- =============================================================================

ProtectedArmories = ProtectedArmories or {}

ProtectedArmories.TrackedContainers = {}

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
end
hookDestroyCursor()

