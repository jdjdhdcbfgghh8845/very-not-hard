--[[
    UNIVERSAL SHOOTER MODULAR (v4.0)
    GITHUB LOADER - Entry Point
]]

local G = getgenv and getgenv() or _G
G.UniversalShooter = G.UniversalShooter or {}

-- [[ CONFIGURATION ]]
local REPO = "jdjdhdcbfgghh8845/script"
local BRANCH = "main" -- Change this if you use another branch
local BASE_URL = "https://raw.githubusercontent.com/" .. REPO .. "/refs/heads/" .. BRANCH .. "/AC/new/"
local LOCAL_PATH = "new/" -- Path inside your executor's workspace

-- [[ DEV MODE TOGGLE ]]
-- Set _G.DevMode = true to load files from workspace instead of GitHub

-- [[ SMART LOADER FUNCTION ]]
local function loadModule(path)
    local source
    local localFile = LOCAL_PATH .. path .. ".lua"
    
    -- Check DevMode or Local availability
    if G.DevMode or (not game:IsLoaded() and readfile) then
        local success, content = pcall(readfile, localFile)
        if success then
            source = content
            print("[LOADER] 📁 Loaded local module: " .. path)
        end
    end
    
    -- Fallback to Remote
    if not source then
        local success, content = pcall(game.HttpGet, game, BASE_URL .. path .. ".lua")
        if success then
            source = content
            print("[LOADER] 🌐 Loaded remote module: " .. path)
        else
            warn("[LOADER] ❌ Failed to load module: " .. path .. " | Error: " .. tostring(content))
            return nil
        end
    end
    
    -- Load the code
    local func, err = loadstring(source)
    if not func then
        warn("[LOADER] ❌ Syntax error in " .. path .. ": " .. tostring(err))
        return nil
    end
    
    return func()
end

G.UniversalShooter.Load = loadModule

-- [[ INITIALIZATION SEED ]]
print([[
--------------------------------------------------
   UNIVERSAL SHOOTER MODULAR (v4.0) LOADING...
--------------------------------------------------
]])

local Framework = loadModule("core/framework")
if not Framework then return end

-- Initialize Framework and Store Window
G.UniversalShooter.Framework = Framework
Framework:Initialize()

print("[LOADER] ✅ Multihack Initialized Successfully!")
