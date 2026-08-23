-- Integration test for server loading
print("[TEST] Running ProtectedArmories Server Load Integration Test...")

assert(ProtectedArmories ~= nil, "ProtectedArmories must load without errors")
assert(type(ProtectedArmories.isProtected) == "function", "isProtected function must be defined")
assert(type(ProtectedArmories.snapshotLoot) == "function", "snapshotLoot function must be defined")
assert(type(ProtectedArmories.respawnLootIfNeeded) == "function", "respawnLootIfNeeded function must be defined")
assert(type(ProtectedArmories.dumpProtectedContainers) == "function", "dumpProtectedContainers function must be defined")

print("[TEST] Server Load integration assertions passed!")
