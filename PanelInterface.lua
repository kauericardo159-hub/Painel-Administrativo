--[[
    GITHUB: PanelInterface.lua
    Função: Criar a interface horizontal centralizada.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [LIMPEZA DE DUPLICATAS]
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- [PAINEL PRINCIPAL]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 300) -- Formato Horizontal
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Começa invisível
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50))
})
gradient.Parent = mainFrame

-- [TÍTULO]
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "COMMAND PANEL V1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame
