local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA DE OPÇÕES V4 ⚙
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local coreGui = playerGui:WaitForChild("SistemaPainel_V3")
local painel = coreGui:WaitForChild("Panel")

-- Limpa a lista antiga se existir
if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER DA LISTA (ScrollingFrame Premium)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"
-- Tamanho e posição ajustados para o visual V4
listaContainer.Size = UDim2.new(0.5, -30, 0.75, 0)
listaContainer.Position = UDim2.new(0.98, 0, 0.5, 0)
listaContainer.AnchorPoint = Vector2.new(1, 0.5)
listaContainer.BackgroundTransparency = 1 -- Transparente para mostrar o fundo do painel
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 6
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255) -- Ciano Neon
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.Parent = painel

-- 3. BORDAS ESTILIZADAS COM GRADIENTE NEON
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = listaContainer

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
strokeGradient.Parent = uiStroke

-- Animação de Pulsar da Borda (Sincronizada com o estilo do painel)
task.spawn(function()
    while listaContainer.Parent do
        local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine)
        TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(0.3, 0.3)}):Play()
        task.wait(1.5)
        TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(-0.3, -0.3)}):Play()
        task.wait(1.5)
    end
end)

-- 4. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS (Layout)
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12) -- Espaçamento entre botões
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- 5. PADDING (Espaçamento interno)
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 20)
padding.PaddingBottom = UDim.new(0, 20)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = listaContainer

-- 6. LÓGICA DE ANIMAÇÃO DE ENTRADA (Slide + Fade)
local function animateListItems()
    for _, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") then
            -- Esconde o item antes de animar
            item.Position = item.Position + UDim2.new(0, 40, 0, 0)
            pcall(function() item.BackgroundTransparency = 1 end)
            
            -- Animação suave para a posição original
            TweenService:Create(item, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(item.Position.X.Scale, item.Position.X.Offset - 40, item.Position.Y.Scale, item.Position.Y.Offset),
                BackgroundTransparency = 0.5 -- Ajuste conforme necessário
            }):Play()
        end
    end
end

-- 7. AJUSTE DINÂMICO DO CANVAS
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
end)

-- Sincronização segura com a abertura do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.3) -- Espera o painel subir
        animateListItems()
    end
end)

print("✅ Gerenciador da Lista de Opções V4 Carregado!")
