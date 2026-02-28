local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA DE OPÇÕES V3 ⚙
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_V3")
-- ATUALIZAÇÃO: O painel principal se chama "Panel" no script anterior
local painel = coreGui:WaitForChild("Panel")

if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER POSICIONADO À DIREITA (ScrollingFrame)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"

-- TAMANHO: Ajustado para combinar com o novo painel
listaContainer.Size = UDim2.new(0.5, -20, 0.75, 0) 

-- POSIÇÃO: Alinhado à direita
listaContainer.Position = UDim2.new(0.98, 0, 0.5, 0) 
listaContainer.AnchorPoint = Vector2.new(1, 0.5)

listaContainer.BackgroundTransparency = 1 -- Fundo transparente para mostrar o gradiente do painel
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 6
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255) -- Ciano Neon
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.Parent = painel

-- 3. BORDAS ESTILIZADAS COM GRADIENTE ANIMADO (Double Stroke)
-- Borda Externa Neon
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

-- Borda Interna (Sombra)
local uiStrokeBlack = Instance.new("UIStroke")
uiStrokeBlack.Thickness = 4
uiStrokeBlack.Color = Color3.new(0, 0, 0)
uiStrokeBlack.Transparency = 0.5
uiStrokeBlack.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStrokeBlack.Parent = listaContainer

-- Animação da Borda Neon (Pulsar)
task.spawn(function()
    while listaContainer.Parent do
        TweenService:Create(strokeGradient, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Offset = Vector2.new(0.5, 0.5)}):Play()
        task.wait(1.5)
        TweenService:Create(strokeGradient, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Offset = Vector2.new(-0.5, -0.5)}):Play()
        task.wait(1.5)
    end
end)

-- 4. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 15) -- Espaçamento elegante
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingBottom = UDim.new(0, 15)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = listaContainer

-- 5. LÓGICA DE ANIMAÇÃO DE ENTRADA (Efeito Slide + Fade)
local function animateListItems()
    for _, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") and not item:IsA("UIPadding") and not item:IsA("UIListLayout") then
            local originalPos = item.Position
            item.Position = originalPos + UDim2.new(0, 50, 0, 0) -- Vem da direita
            item.BackgroundTransparency = 1
            
            TweenService:Create(item, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = originalPos,
                BackgroundTransparency = 0.5 -- Exemplo: definir a transparência real depois
            }):Play()
        end
    end
end

-- 6. AJUSTE DINÂMICO DO CANVAS
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
end)

-- Sincronização com a abertura do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.2)
        animateListItems()
    end
end)

print("✅ Lista de Opções V3 Atualizada!")
