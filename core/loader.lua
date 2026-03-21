-- [[ NEXUS CORE - LOADER ]]
-- Manages the loading and registration of feature modules.

local Loader = {}

function Loader.Init(loadScriptFunc)
    print("[NEXUS] 📂 Initializing Modules...")
    
    local modulesToLoad = {
        "combat.lua",
        "visuals.lua",
        "movement.lua",
        "world.lua"
    }
    
    local basePath = "modules/"
    
    for _, moduleFile in pairs(modulesToLoad) do
        local path = basePath .. moduleFile
        local module = loadScriptFunc(path)
        
        if module and type(module) == "table" then
            if module.Init then
                local success, err = pcall(function()
                    module.Init()
                end)
                
                if success then
                    table.insert(_G.Nexus.Modules, module)
                    print("[NEXUS] ✅ Loaded Module: " .. (module.Name or moduleFile))
                else
                    warn("[NEXUS] ❌ Failed to initialize " .. moduleFile .. ": " .. tostring(err))
                end
            else
                warn("[NEXUS] ⚠️ Module " .. moduleFile .. " has no Init function.")
            end
        end
    end
    
    print("[NEXUS] 📊 Total Modules Loaded: " .. #_G.Nexus.Modules)
end

return Loader
