--[[
    GITHUB: ListManager.lua
    Função: Gerenciar o ScrollingFrame onde os comandos aparecerão.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Aguarda o painel existir para evitar erros de execução
local panelGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = panelGui:WaitForChild("MainFrame")

-- [LIMPEZA DE LISTAS ANTIGAS]
if mainFrame:FindFirstChild("CommandList") then
    mainFrame.CommandList:Destroy()
end

-- [SCROLLING FRAME - A LISTA]
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "CommandList"
listFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
listFrame.BackgroundTransparency = 1
listFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- Expande conforme adiciona itens
listFrame.ScrollBarThickness = 4
listFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
listFrame.Parent = mainFrame

-- [LAYOUT AUTOMÁTICO]
local layout = Instance.new("UIListLayout")
layout.Parent = listFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingTop = UDim.new(0, 5)
padding.Parent = listFrame

print("Sistema de Lista carregado com sucesso. Pronto para receber comandos externos.")
