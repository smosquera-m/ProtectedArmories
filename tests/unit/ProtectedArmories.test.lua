-- Unit tests for ProtectedArmories
print("[TEST] Running ProtectedArmories Unit Test Suite...")

assert(ProtectedArmories ~= nil, "ProtectedArmories table must be initialized")
assert(ProtectedArmories.ProtectedRooms["policegunstorage"] == "Police", "policegunstorage room must be mapped to Police category")
assert(ProtectedArmories.ProtectedRooms["gunstorestorage"] == "GunStore", "gunstorestorage room must be mapped to GunStore category")
assert(ProtectedArmories.ProtectedRooms["armystorage"] == "Military", "armystorage room must be mapped to Military category")
assert(ProtectedArmories.ProtectedRooms["prisonstorage"] == "Prison", "prisonstorage room must be mapped to Prison category")
assert(ProtectedArmories.WeaponSprites["furniture_storage_02_8"] == true, "furniture_storage_02_8 sprite must be protected")
assert(ProtectedArmories.WeaponSprites["furniture_storage_02_4"] == true, "furniture_storage_02_4 sprite must be protected")

print("[TEST] All ProtectedArmories unit assertions passed!")
