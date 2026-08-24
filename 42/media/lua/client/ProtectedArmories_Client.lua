-- =============================================================================
-- Protected Armories & Loot Respawn (Armerías Protegidas)
-- File: media/lua/client/ProtectedArmories_Client.lua
-- =============================================================================

ProtectedArmories = ProtectedArmories or {}

ProtectedArmories.LastHaloTime = 0
ProtectedArmories.HaloCooldown = 2.0

--- Displays floating notification above player's character
--- @param playerObj IsoPlayer
--- @param reasonText string
function ProtectedArmories.notifyPlayerBlocked(playerObj, reasonText)
    if not playerObj then return end
    if not ProtectedArmories.getOption("ShowHaloWarning") then return end

    local currentTime = getTimeInMillis and (getTimeInMillis() / 1000) or os.time()
    if (currentTime - ProtectedArmories.LastHaloTime) < ProtectedArmories.HaloCooldown then
        return
    end
    ProtectedArmories.LastHaloTime = currentTime

    local messageText = reasonText or "Este armario de armas esta blindado y no se puede mover ni romper"

    if HaloTextHelper and HaloTextHelper.addTextWithColor then
        HaloTextHelper.addTextWithColor(playerObj, messageText, 255, 60, 60)
    elseif playerObj.setHaloNote then
        playerObj:setHaloNote(messageText, 255, 60, 60, 150)
    elseif playerObj.Say then
        playerObj:Say(messageText)
    end
end

--- Apply monkey-patches to Moveable and Disassembly systems
function ProtectedArmories.applyClientPatches()
    if ProtectedArmories.PatchesApplied then return end

    if ISMoveableSpriteProps then
        -- Build 42: canPickUpMoveable
        if ISMoveableSpriteProps.canPickUpMoveable then
            local orig_canPickUpMoveable = ISMoveableSpriteProps.canPickUpMoveable
            function ISMoveableSpriteProps:canPickUpMoveable(_character, _square, _object)
                local targetObj = _object or self.object
                if ProtectedArmories.getOption("PreventMoving") then
                    local isProt, info = ProtectedArmories.isProtected(targetObj, self, _character)
                    if isProt then
                        ProtectedArmories.notifyPlayerBlocked(_character, "Armeria protegida (" .. info .. "): No se puede mover")
                        return false
                    end
                end
                return orig_canPickUpMoveable(self, _character, _square, _object)
            end
        end

        -- Build 41 Fallback: canPickUp
        if ISMoveableSpriteProps.canPickUp then
            local orig_canPickUp = ISMoveableSpriteProps.canPickUp
            function ISMoveableSpriteProps:canPickUp(playerObj, square, object)
                local targetObj = object or self.object
                if ProtectedArmories.getOption("PreventMoving") then
                    local isProt, info = ProtectedArmories.isProtected(targetObj, self, playerObj)
                    if isProt then
                        ProtectedArmories.notifyPlayerBlocked(playerObj, "Armeria protegida (" .. info .. "): No se puede mover")
                        return false
                    end
                end
                return orig_canPickUp(self, playerObj, square, object)
            end
        end

        -- Build 42: canScrapObjectInternal
        if ISMoveableSpriteProps.canScrapObjectInternal then
            local orig_canScrapObjectInternal = ISMoveableSpriteProps.canScrapObjectInternal
            function ISMoveableSpriteProps:canScrapObjectInternal(_result, _object)
                local targetObj = _object or self.object
                local player = getPlayer and getPlayer() or nil
                if ProtectedArmories.getOption("PreventDisassembling") then
                    local isProt = ProtectedArmories.isProtected(targetObj, self, player)
                    if isProt then
                        return false
                    end
                end
                return orig_canScrapObjectInternal(self, _result, _object)
            end
        end

        -- Build 41 Fallback: canDisassemble
        if ISMoveableSpriteProps.canDisassemble then
            local orig_canDisassemble = ISMoveableSpriteProps.canDisassemble
            function ISMoveableSpriteProps:canDisassemble(playerObj, square, object)
                local targetObj = object or self.object
                if ProtectedArmories.getOption("PreventDisassembling") then
                    local isProt, info = ProtectedArmories.isProtected(targetObj, self, playerObj)
                    if isProt then
                        ProtectedArmories.notifyPlayerBlocked(playerObj, "Armeria protegida (" .. info .. "): No se puede desmontar")
                        return false
                    end
                end
                return orig_canDisassemble(self, playerObj, square, object)
            end
        end
    end

    -- Timed Action check for moveables
    if ISMoveablesAction then
        local orig_isValid = ISMoveablesAction.isValid
        function ISMoveablesAction:isValid()
            if self.mode == "pickup" or self.mode == "scrap" or self.mode == "disassemble" then
                local props = self.moveProps or self.spriteProps
                local obj = self.targetObject or (props and props.object)
                if props or obj then
                    local isProt, info = ProtectedArmories.isProtected(obj, props, self.character)
                    if isProt then
                        ProtectedArmories.notifyPlayerBlocked(self.character, "Armeria protegida: Accion denegada")
                        return false
                    end
                end
            end
            if orig_isValid then
                return orig_isValid(self)
            end
            return true
        end
    end

    -- Timed Action check for Destruction (Sledgehammer / Debug destruction)
    if ISDestroyStuffAction then
        local orig_isValid = ISDestroyStuffAction.isValid
        function ISDestroyStuffAction:isValid()
            local obj = self.item or self.object or self.targetObject
            if obj and ProtectedArmories.getOption("PreventSledgehammer") then
                local isProt, info = ProtectedArmories.isProtected(obj, nil, self.character)
                if isProt then
                    ProtectedArmories.notifyPlayerBlocked(self.character, "Armeria protegida: No se puede destruir")
                    return false
                end
            end
            if orig_isValid then
                return orig_isValid(self)
            end
            return true
        end

        local orig_perform = ISDestroyStuffAction.perform
        function ISDestroyStuffAction:perform()
            local obj = self.item or self.object or self.targetObject
            if obj and ProtectedArmories.getOption("PreventSledgehammer") then
                local isProt, info = ProtectedArmories.isProtected(obj, nil, self.character)
                if isProt then
                    ProtectedArmories.notifyPlayerBlocked(self.character, "Armeria protegida: No se puede destruir")
                    return
                end
            end
            if orig_perform then
                return orig_perform(self)
            end
        end
    end

    -- Sledgehammer Cursor tool check (ISDestroyCursor)
    if ISDestroyCursor then
        local orig_canDestroy = ISDestroyCursor.canDestroy
        function ISDestroyCursor:canDestroy(object)
            if ProtectedArmories.getOption("PreventSledgehammer") then
                local playerObj = self.character or (getPlayer and getPlayer() or nil)
                local isProt, info = ProtectedArmories.isProtected(object, nil, playerObj)
                if isProt then
                    ProtectedArmories.notifyPlayerBlocked(playerObj, "Armeria protegida (" .. info .. "): No se puede destruir con mazo")
                    return false
                end
            end
            if orig_canDestroy then
                return orig_canDestroy(self, object)
            end
            return true
        end

        local orig_destroy = ISDestroyCursor.destroy
        function ISDestroyCursor:destroy(object)
            if ProtectedArmories.getOption("PreventSledgehammer") then
                local playerObj = self.character or (getPlayer and getPlayer() or nil)
                local isProt = ProtectedArmories.isProtected(object, nil, playerObj)
                if isProt then
                    ProtectedArmories.notifyPlayerBlocked(playerObj, "Armeria protegida: No se puede destruir con mazo")
                    return
                end
            end
            if orig_destroy then
                return orig_destroy(self, object)
            end
        end
    end

        -- Track when players place moveable objects so they are tagged as player created
        if ISMoveableSpriteProps.placeMoveable then
            local orig_placeMoveable = ISMoveableSpriteProps.placeMoveable
            function ISMoveableSpriteProps:placeMoveable(_character, _square, _spriteName)
                local resObj = orig_placeMoveable(self, _character, _square, _spriteName)
                local targetObj = resObj or self.object
                if targetObj and targetObj.getModData then
                    local md = targetObj:getModData()
                    if md then md.pzc_playerCreated = true end
                end
                return resObj
            end
        end

    ProtectedArmories.PatchesApplied = true
end

--- Context menu inspection entry
--- @param playerIndex number
--- @param context ISContextMenu
--- @param worldobjects table
function ProtectedArmories.onFillWorldObjectContextMenu(playerIndex, context, worldobjects, test)
    if not context or not worldobjects or test then return end
    local playerObj = getSpecificPlayer and getSpecificPlayer(playerIndex) or (getPlayer and getPlayer() or nil)

    local targetObj = nil
    local protInfo = "None"
    local detailObj = nil

    for _, obj in ipairs(worldobjects) do
        if obj then
            local isProt, info, _, detail = ProtectedArmories.isProtected(obj, nil, playerObj)
            if isProt then
                targetObj = obj
                protInfo = info
                detailObj = detail
                break
            end
        end
    end

    if targetObj then
        -- Add informational menu entry for the protected container
        local menuTitle = "🔒 Armeria Protegida"
        if detailObj and detailObj.building then
            menuTitle = "🔒 Armeria Protegida [" .. tostring(detailObj.building) .. "]"
        elseif protInfo and protInfo ~= "None" then
            menuTitle = "🔒 Armeria Protegida [" .. tostring(protInfo) .. "]"
        end

        local protOption = context:addOption(menuTitle, nil, nil)
        
        local subMenu = nil
        if context.getNew then
            subMenu = context:getNew(context)
        elseif ISContextMenu and ISContextMenu.getNew then
            subMenu = ISContextMenu:getNew(context)
        end

        if subMenu then
            context:addSubMenu(protOption, subMenu)
            if detailObj then
                if detailObj.building then
                    subMenu:addOption("Edificio: " .. tostring(detailObj.building), nil, nil)
                end
                if detailObj.roomName or detailObj.room then
                    local roomStr = detailObj.roomName and (detailObj.roomName .. " (" .. detailObj.room .. ")") or detailObj.room
                    subMenu:addOption("Habitacion: " .. tostring(roomStr), nil, nil)
                end
                if detailObj.containerName then
                    subMenu:addOption("Tipo: " .. tostring(detailObj.containerName), nil, nil)
                end
            else
                subMenu:addOption("Ubicacion: " .. tostring(protInfo), nil, nil)
            end
            subMenu:addOption("Estado: Inamovible e Indestructible", nil, nil)
        end
    end
end

--- Event listener to tag player constructed object tiles
local function onObjectAdded(object)
    if not object or not object.getModData then return end
    if instanceof and instanceof(object, "IsoThumpable") then
        local md = object:getModData()
        if md then
            md.pzc_playerCreated = true
        end
    end
end

-- Events
if Events then
    if Events.OnGameStart then Events.OnGameStart.Add(ProtectedArmories.applyClientPatches) end
    if Events.OnFillWorldObjectContextMenu then Events.OnFillWorldObjectContextMenu.Add(ProtectedArmories.onFillWorldObjectContextMenu) end
    if Events.OnObjectAdded then Events.OnObjectAdded.Add(onObjectAdded) end
end

ProtectedArmories.applyClientPatches()

