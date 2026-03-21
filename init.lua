--[[
    UNIVERSAL SHOOTER MODULAR (v4.0)
    GITHUB LOADER - Entry Point
]]

local G = getgenv and getgenv() or _G
G.UniversalShooter = G.UniversalShooter or {}

-- [[ CONFIGURATION ]]
local REPO = "jdjdhdcbfgghh8845/very-not-hard"
local BRANCH = "main"
local BASE_URL = "https://raw.githubusercontent.com/" .. REPO .. "/" .. BRANCH .. "/"
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
        local url = BASE_URL .. path .. ".lua"
        print("[LOADER] 🌐 Fetching: " .. url)
        
        local success, content = pcall(game.HttpGet, game, url)
        if success then
            -- Double check for 404 (GitHub returns a text/html error page)
            if content:find("<!DOCTYPE html>") or content:find("404: Not Found") then
                 warn("[LOADER] ❌ 404 Not Found at: " .. url)
                 return nil
            end
            source = content
            print("[LOADER] ✅ Loaded remote module: " .. path)
        else
            warn("[LOADER] ❌ HTTP Error in " .. path .. ": " .. tostring(content))
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
