--[[
    GITHUB: ListManager_V4_Centered.lua
    Função: Criar a ScrollingFrame centralizada com borda RGB.
]]

local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Aguarda a base do painel existir
local panelGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = panelGui:WaitForChild("MainFrame")

-- [LIMPEZA DE LISTAS ANTIGAS]
if mainFrame:FindFirstChild("CommandList") then
    mainFrame.CommandList:Destroy()
end

-- [LISTA DE COMANDOS (CENTRALIZADA)]
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "CommandList"
-- Posição Centralizada e tamanho proporcional
listFrame.Size = UDim2.new(0.85, 0, 0.65, 0)
listFrame.Position = UDim2.new(0.075, 0, 0.28, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
listFrame.BackgroundTransparency = 0.3
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Ajusta automaticamente
listFrame.ScrollBarThickness = 4
listFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 10)
listCorner.Parent = listFrame

local listStroke = Instance.new("UIStroke")
listStroke.Thickness = 2
listStroke.Color = Color3.fromRGB(255, 255, 255)
listStroke.Parent = listFrame

-- [LAYOUT AUTOMÁTICO]
local layout = Instance.new("UIListLayout")
layout.Parent = listFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.Parent = listFrame

-- Sincronizar o CanvasSize conforme botões são adicionados
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 25)
end)

-- [SINCRONIZAÇÃO RGB PARA A LISTA]
task.spawn(function()
    while true do
        local hue = tick() % 6 / 6
        listStroke.Color = Color3.fromHSV(hue, 0.8, 1)
        RunService.RenderStepped:Wait()
    end
end)

print("Lista Centralizada V4 carregada e sincronizada com RGB.")
