-- [[ NEXUS MULTIHACK v2.0 - MODULAR LOADER ]]
-- This is the main entry point for the multihack.
-- It initializes the framework and loads core components and feature modules.

_G.Nexus = {
    Version = "2.0.0",
    Modules = {},
    Core = {},
    Config = {},
    BaseURL = "https://raw.githubusercontent.com/jdjdhdcbfgghh8845/very-not-hard/main/",
    LocalPath = "c:/Users/JDH/Desktop/AC/new/" -- Absolute path for your PC
}

local function loadScript(path, isLocal)
    local content
    local success
    
    if isLocal then
        local fullPath = _G.Nexus.LocalPath .. path
        print("[NEXUS] Loading LOCAL: " .. fullPath)
        success, content = pcall(function() return readfile(fullPath) end)
    else
        local url = _G.Nexus.BaseURL .. path
        print("[NEXUS] Loading REMOTE: " .. url)
        success, content = pcall(function() return game:HttpGet(url) end)
    end
    
    if not success or not content or content == "" then
        warn("[NEXUS] ❌ Could not load: " .. path)
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

-- Choose mode (true = local files on PC, false = GitHub)
local USE_LOCAL = false 

-- Step 1: Load Core UI Engine
_G.Nexus.Core.UI = loadScript("core/ui.lua", USE_LOCAL)
if _G.Nexus.Core.UI then
    _G.Nexus.Core.UI.Init()
end

-- Step 2: Load Module Loader
_G.Nexus.Core.Loader = loadScript("core/loader.lua", USE_LOCAL)

-- Step 3: Initialize System
if _G.Nexus.Core.Loader then
    _G.Nexus.Core.Loader.Init(function(p) return loadScript(p, USE_LOCAL) end)
end

print("[NEXUS] 🚀 System successfully initialized!")
