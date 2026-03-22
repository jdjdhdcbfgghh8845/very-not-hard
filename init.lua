-- [[ AAC - ADVANCED ADAPTIVE CHEAT ]]
-- Main entry point for the Roblox multihack.

_G.AAC = {
    Version = "1.0.0",
    Modules = {},
    Core = {},
    Settings = {},
    LocalPath = "c:/Users/JDH/Desktop/AC/AAC/" 
}

-- Loader function
local function loadScript(path)
    local fullPath = _G.AAC.LocalPath .. path
    print("[AAC] Loading: " .. fullPath)
    
    local success, content = pcall(function() return readfile(fullPath) end)
    if not success or not content or content == "" then
        warn("[AAC] ❌ Failed to read: " .. path)
        return nil
    end
    
    local func, err = loadstring(content)
    if not func then
        warn("[AAC] ❌ Syntax error in " .. path .. ": " .. tostring(err))
        return nil
    end
    
    local ok, result = pcall(func)
    if not ok then
        warn("[AAC] ❌ Runtime error in " .. path .. ": " .. tostring(result))
        return nil
    end
    
    return result
end

-- 1. Initialize UI
_G.AAC.Core.UI = loadScript("ui.lua")
if _G.AAC.Core.UI then
    _G.AAC.Core.UI:Init()
end

-- 2. Load Modules
local modules = {"combat.lua", "visuals.lua", "movement.lua", "misc.lua", "settings.lua"}
for _, m in pairs(modules) do
    local success = loadScript("modules/" .. m)
    if success then
        print("[AAC] ✅ Loaded: " .. m)
    end
end

print("[AAC] 🚀 System Ready!")
