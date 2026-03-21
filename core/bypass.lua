--[[
    ANTICHEAT BYPASS ENGINE (v4.0)
    Metatable Hooking & Security Logic
]]

local Bypass = {}
local G = getgenv and getgenv() or _G

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ SECURITY UTILS ]]
local function isOurScript()
    return checkcaller()
end

-- [[ METATABLE HOOKING ]]

function Bypass:Initialize()
    print("[BYPASS] 🛡️ Hooking Metatable...")
    
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    local oldNewIndex = mt.__newindex
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    
    -- Spoofing __index (Anticheat reading our stats)
    mt.__index = newcclosure(function(self, key)
        if not isOurScript() then
            -- Spoof Humanoid properties
            if self:IsA("Humanoid") then
                if key == "WalkSpeed" then return 16 end
                if key == "JumpPower" then return 50 end
            end
        end
        return oldIndex(self, key)
    end)
    
    -- Spoofing __newindex (Game trying to reset our stats)
    mt.__newindex = newcclosure(function(self, key, value)
        if not isOurScript() then
            if self:IsA("Humanoid") then
                -- Prevent the game from slowing us down if we have speedhack on
                if key == "WalkSpeed" and G.UniversalShooter.Settings and G.UniversalShooter.Settings.speedHackEnabled then
                    return
                end
            end
        end
        return oldNewIndex(self, key, value)
    end)
    
    -- Spoofing __namecall (Remote detection bypass)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not isOurScript() then
            -- Example: Prevent common "CheckSpeed" remotes
            if method == "FireServer" and tostring(self) == "MainEvent" then
                if args[1] == "WalkSpeed" or args[1] == "CheckSpeed" then
                    return -- Block detection remote
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("[BYPASS] ✅ Metatable Hooks Active!")
end

return Bypass
