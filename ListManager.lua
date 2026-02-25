local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. LOCALIZAÇÃO DO PAINEL PAI
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = playerGui:WaitForChild("MeuPainelAnimado", 5) or playerGui:WaitForChild("InterfaceMenu", 5)
local painel = screenGui:WaitForChild("Painel")

-- 2. LIMPEZA AUTOMÁTICA
if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 3. CONTAINER DA LISTA (Abaixado e posicionado à direita)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"
-- Tamanho ajustado
listaContainer.Size = UDim2.new(0, 380, 0, 280) 
-- Position alterada: 0.6 no Y para descer mais no painel
listaContainer.Position = UDim2.new(1, -20, 0.6, 0) 
listaContainer.AnchorPoint = Vector2.new(1, 0.5)
listaContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
listaContainer.BackgroundTransparency = 0.3
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 3
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.Parent = painel

-- 4. BORDAS DUPLAS GROSSAS
-- Borda interna Branca
local strokeBranco = Instance.new("UIStroke")
strokeBranco.Thickness = 3.5
strokeBranco.Color = Color3.new(1, 1, 1)
strokeBranco.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeBranco.Parent = listaContainer

-- Borda externa Cinza
local strokeCinza = Instance.new("UIStroke")
strokeCinza.Thickness = 6
strokeCinza.Color = Color3.fromRGB(100, 100, 100)
strokeCinza.Transparency = 0.4
strokeCinza.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeCinza.Parent = listaContainer

-- 5. CONFIGURAÇÃO DE LAYOUT (Organização Automática)
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10) -- Espaçamento entre os futuros botões
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.Parent = listaContainer

-- 6. ATUALIZAÇÃO AUTOMÁTICA DO SCROLL
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 25)
end)

print("Lista reposicionada com sucesso!")
