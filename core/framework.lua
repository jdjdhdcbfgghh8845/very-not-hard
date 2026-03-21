--[[
    ENGINE FRAMEWORK (v4.0)
    Handles Module Management, Signal System, and Synchronization
]]

local Framework = {}
local G = getgenv and getgenv() or _G

Framework.Modules = {}
Framework.Signals = {}

-- [[ MODULE SYSTEM ]]

function Framework:LoadModule(name, path)
    print("[FRAMEWORK] 📦 Registering module: " .. name)
    local moduleCode = G.UniversalShooter.Load("modules/" .. path)
    
    if moduleCode then
        self.Modules[name] = moduleCode
        if moduleCode.Initialize then
            moduleCode:Initialize(self)
        end
        return moduleCode
    end
end

-- [[ SIGNAL SYSTEM (Event Emitter) ]]

function Framework:RegisterSignal(name)
    self.Signals[name] = {
        Listeners = {},
        Fire = function(self, ...)
            for _, callback in pairs(self.Listeners) do
                task.spawn(callback, ...)
            end
        end,
        Connect = function(self, callback)
            table.insert(self.Listeners, callback)
        end
    }
    return self.Signals[name]
end

function Framework:GetSignal(name)
    return self.Signals[name] or self:RegisterSignal(name)
end

-- [[ CORE LIFECYCLE ]]

function Framework:Initialize()
    print("[FRAMEWORK] ⚙️ Booting Engine...")
    
    -- Load Core Libraries (Order Matters)
    local Lib = G.UniversalShooter.Load("core/ui_lib")
    G.UniversalShooter.UIWindow = Lib:CreateWindow("UNIVERSAL MODULAR")
    
    local Config = G.UniversalShooter.Load("core/config")
    if Config then Config:Load() end
    
    local Bypass = G.UniversalShooter.Load("core/bypass")
    if Bypass then Bypass:Initialize() end
    
    -- Load Modules
    self:LoadModule("Aimbot", "aimbot")
    self:LoadModule("Visuals", "visuals")
    self:LoadModule("Movement", "movement")
    self:LoadModule("World", "world")
    
    print("[FRAMEWORK] 🚀 Framework Initialized!")
end

return Framework
