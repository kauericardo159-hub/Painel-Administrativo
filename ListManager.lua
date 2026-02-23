--[[
    GITHUB: ListManager_V3_RGB.lua
    Função: Criar a ScrollingFrame centralizada com suporte a RGB dinâmico.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Aguarda a existência do painel principal para evitar erros
local panelGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = panelGui:WaitForChild("MainFrame")

-- [LIMPEZA DE LISTAS ANTIGAS]
if mainFrame:FindFirstChild("CommandList") then
    mainFrame.CommandList:Destroy()
end

-- [ÁREA DA LISTA - CENTRALIZADA]
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "CommandList"
-- Tamanho e posição ajustados para o centro conforme o desenho
listFrame.Size = UDim2.new(0, 310, 0, 200) 
listFrame.Position = UDim2.new(0.5, -155, 0.55, -100)
listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
listFrame.BackgroundTransparency = 0.3
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Cresce com os comandos
local listCorner = Instance.new("UICorner", listFrame)
listCorner.CornerRadius = UDim.new(0, 8)

-- UIStroke RGB da Lista
local listStroke = Instance.new("UIStroke")
listStroke.Color = Color3.fromRGB(255, 255, 255)
listStroke.Thickness = 2
listStroke.Parent = listFrame

-- [CONFIGURAÇÃO DE LAYOUT]
local layout = Instance.new("UIListLayout")
layout.Parent = listFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = listFrame

-- [SINCRONIZAÇÃO RGB]
-- Faz a borda da lista brilhar na mesma frequência que o painel principal
task.spawn(function()
    while true do
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        listStroke.Color = color
        
        -- Ajusta o CanvasSize automaticamente conforme novos comandos entram
        listFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        
        RunService.RenderStepped:Wait()
    end
end)

print("Gerenciador de Lista V3 (Centralizado) carregado com sucesso.")
