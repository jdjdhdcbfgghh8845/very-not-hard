--[[
    DRAWING UTILITIES (v4.0)
    Optimized ESP Drawing wrappers.
]]

local DrawingLib = {}

function DrawingLib:CreateLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = color or Color3.fromRGB(255, 255, 255)
    line.Thickness = thickness or 1
    line.Transparency = 1
    return line
end

function DrawingLib:CreateText(text, color, size)
    local label = Drawing.new("Text")
    label.Visible = false
    label.Text = text or ""
    label.Color = color or Color3.fromRGB(255, 255, 255)
    label.Size = size or 16
    label.Center = true
    label.Outline = true
    return label
end

return DrawingLib
