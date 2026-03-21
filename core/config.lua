--[[
    CORE CONFIG MANAGER (v4.0)
    Saves and Loads modular multihack configuration.
]]

local Config = {}
local G = getgenv and getgenv() or _G
local HttpService = game:GetService("HttpService")

local FILE_NAME = "UniversalModularConfig.json"

function Config:Save()
    local data = {}
    -- ... Logic to collect all current settings from modules ...
    -- In v4.0 we'll use the variables set in modules
    
    local success, err = pcall(function()
        writefile(FILE_NAME, HttpService:JSONEncode(G.UniversalShooter.Settings or {}))
    end)
    
    if success then
        print("[CONFIG] 💾 Configuration saved.")
    else
        warn("[CONFIG] ❌ Failed to save: " .. tostring(err))
    end
end

function Config:Load()
    if not isfile(FILE_NAME) then return end
    
    local success, content = pcall(function()
        return readfile(FILE_NAME)
    end)
    
    if success then
        local data = HttpService:JSONDecode(content)
        G.UniversalShooter.Settings = data
        
        -- Sync with UI via ConfigRegistry
        task.spawn(function()
            task.wait(1) -- Wait for UI to be ready
            for name, value in pairs(data) do
                local updateFunc = G.ConfigRegistry[name]
                if updateFunc then
                    pcall(updateFunc, value)
                end
            end
            print("[CONFIG] ✅ Configuration loaded and synced.")
        end)
    end
end

return Config
