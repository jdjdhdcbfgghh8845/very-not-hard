-- [[ NEXUS MULTIHACK v2.0 - MODULAR LOADER ]]
-- This is the main entry point for the multihack.
-- It initializes the framework and loads core components and feature modules.

_G.Nexus = {
    Version = "2.0.0",
    Modules = {},
    Core = {},
    Config = {}
}

local function loadScript(path)
    print("[NEXUS] Loading script: " .. path)
    local success, content = pcall(function()
        return readfile(path)
    end)
    
    if not success or not content then
        warn("[NEXUS] ❌ Could not read file: " .. path)
        return nil
    end
    
    local func, err = loadstring(content)
    if not func then
        warn("[NEXUS] ❌ Syntax error in " .. path .. ": " .. tostring(err))
        return nil
    end
    
    local ok, result = pcall(func)
    if not ok then
        warn("[NEXUS] ❌ Execution error in " .. path .. ": " .. tostring(result))
        return nil
    end
    
    return result
end

-- Step 1: Load Core UI Engine
_G.Nexus.Core.UI = loadScript("c:/Users/JDH/Desktop/AC/new/core/ui.lua")
if _G.Nexus.Core.UI then
    _G.Nexus.Core.UI.Init()
end

-- Step 2: Load Module Loader
_G.Nexus.Core.Loader = loadScript("c:/Users/JDH/Desktop/AC/new/core/loader.lua")

-- Step 3: Initialize System
if _G.Nexus.Core.Loader then
    _G.Nexus.Core.Loader.Init(loadScript)
end

print("[NEXUS] 🚀 System successfully initialized!")
