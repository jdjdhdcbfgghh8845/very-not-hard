--[[
    MATH UTILITIES (v4.0)
    Optimized math functions for Aimbot and Visuals.
]]

local Math = {}

local Camera = workspace.CurrentCamera
local WorldToViewportPoint = Camera.WorldToViewportPoint

function Math:GetScreenPos(worldPos)
    local screenPos, onScreen = WorldToViewportPoint(Camera, worldPos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

function Math:GetMouseDistance(worldPos)
    local screenPos, onScreen = self:GetScreenPos(worldPos)
    if not onScreen then return math.huge end
    
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
    return (screenPos - mousePos).Magnitude
end

function Math:IsOnScreen(worldPos)
    local _, onScreen = WorldToViewportPoint(Camera, worldPos)
    return onScreen
end

return Math
