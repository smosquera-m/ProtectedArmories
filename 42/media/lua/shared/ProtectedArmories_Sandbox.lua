-- =============================================================================
-- Protected Armories & Loot Respawn (Armerías Protegidas)
-- File: media/lua/shared/ProtectedArmories_Sandbox.lua
-- =============================================================================

ProtectedArmories = ProtectedArmories or {}

local function initSandboxVars()
    SandboxVars = SandboxVars or {}
    SandboxVars.ProtectedArmories = SandboxVars.ProtectedArmories or {}

    local defaults = ProtectedArmories.DefaultConfig or {}
    for optionKey, defaultValue in pairs(defaults) do
        if SandboxVars.ProtectedArmories[optionKey] == nil then
            SandboxVars.ProtectedArmories[optionKey] = defaultValue
        end
    end
end

if Events then
    if Events.OnGameStart then Events.OnGameStart.Add(initSandboxVars) end
    if Events.OnInitGlobalModData then Events.OnInitGlobalModData.Add(initSandboxVars) end
    if Events.OnLoadedTileDefinitions then Events.OnLoadedTileDefinitions.Add(initSandboxVars) end
end
