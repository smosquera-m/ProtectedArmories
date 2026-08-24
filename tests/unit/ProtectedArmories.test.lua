-- Unit tests for ProtectedArmories
print("[TEST] Running ProtectedArmories Unit Test Suite...")

assert(ProtectedArmories ~= nil, "ProtectedArmories table must be initialized")
assert(ProtectedArmories.ProtectedRooms["policegunstorage"] == "Police", "policegunstorage room must be mapped to Police category")
assert(ProtectedArmories.ProtectedRooms["gunstorestorage"] == "GunStore", "gunstorestorage room must be mapped to GunStore category")
assert(ProtectedArmories.ProtectedRooms["armystorage"] == "Military", "armystorage room must be mapped to Military category")
assert(ProtectedArmories.ProtectedRooms["prisonstorage"] == "Prison", "prisonstorage room must be mapped to Prison category")
assert(ProtectedArmories.ProtectedRooms["securitystorage"] == "Security", "securitystorage room must be mapped to Security category")
assert(ProtectedArmories.WeaponSprites["furniture_storage_02_8"] == "GunLocker", "furniture_storage_02_8 sprite must be mapped to GunLocker")
assert(ProtectedArmories.WeaponSprites["furniture_storage_02_4"] == "ArmorLocker", "furniture_storage_02_4 sprite must be mapped to ArmorLocker")

assert(ProtectedArmories.DefaultConfig.OnlyWorldSpawned == true, "OnlyWorldSpawned must default to true")
assert(ProtectedArmories.DefaultConfig.ProtectGunLockers == true, "ProtectGunLockers must default to true")
assert(ProtectedArmories.DefaultConfig.ProtectArmorLockers == true, "ProtectArmorLockers must default to true")
assert(ProtectedArmories.DefaultConfig.ProtectSecurity == true, "ProtectSecurity must default to true")
assert(ProtectedArmories.DefaultConfig.EnableLootRespawn == nil, "EnableLootRespawn must be deprecated")

-- Test isPlayerCreated logic
local mockPlayerBuiltObj = {
    getModData = function() return { bBuilt = true } end
}
local mockWorldObj = {
    getModData = function() return {} end
}
assert(ProtectedArmories.isPlayerCreated(mockPlayerBuiltObj) == true, "Player built object must be detected as player created")
assert(ProtectedArmories.isPlayerCreated(mockWorldObj) == false, "World spawned object must NOT be detected as player created")

print("[TEST] All ProtectedArmories unit assertions passed!")

