--[[
    GITHUB: ListManager_V2.lua
    Função: Criar a Lista de Comandos com design transparente e borda branca.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Aguarda o painel principal existir
local panelGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = panelGui:WaitForChild("MainFrame")

-- [LIMPEZA DE LISTAS ANTIGAS]
if mainFrame:FindFirstChild("CommandList") then
    mainFrame.CommandList:Destroy()
end

-- [ÁREA DA LISTA (Fundo Cinza e Transparente)]
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "CommandList"
listFrame.Size = UDim2.new(0.9, 0, 0.78, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 65) -- Cinza mais claro que o fundo
listFrame.BackgroundTransparency = 0.25 -- Um pouco transparente
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
listFrame.ScrollBarThickness = 5
listFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listFrame.Parent = mainFrame

Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

-- UIStroke Branco na Lista
local listStroke = Instance.new("UIStroke")
listStroke.Color = Color3.fromRGB(255, 255, 255)
listStroke.Thickness = 2
listStroke.Parent = listFrame

-- [ORGANIZAÇÃO AUTOMÁTICA DOS BOTÕES]
local layout = Instance.new("UIListLayout")
layout.Parent = listFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = listFrame

print("Lista de comandos carregada. Pronta para receber botões.")
