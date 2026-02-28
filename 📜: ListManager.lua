local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA DE OPÇÕES V4 (ESTILIZADO) ⚙
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_V3")
local painel = coreGui:WaitForChild("Panel")

-- Limpa a lista anterior se existir
if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER CENTRALIZADO (ScrollingFrame)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"

-- TAMANHO: Esticado (80% da largura, 75% da altura)
listaContainer.Size = UDim2.new(0.8, 0, 0.75, 0) 

-- POSIÇÃO: Centralizado no painel
listaContainer.Position = UDim2.new(0.5, 0, 0.55, 0) 
listaContainer.AnchorPoint = Vector2.new(0.5, 0.5)

listaContainer.BackgroundTransparency = 1 -- Fundo transparente
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 8
-- ScrollBar laranja para combinar
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0)
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.ZIndex = painel.ZIndex + 2 -- Garante que fique NA FRENTE
listaContainer.Parent = painel

-- 3. UICORNER & UISTROKE ESTILIZADOS
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = listaContainer

-- UIStroke LARANJA com Gradient
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Transparency = 0.2
uiStroke.Parent = listaContainer

local strokeGradient = Instance.new("UIGradient")
-- Gradiente Laranja Vibrante
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
})
strokeGradient.Rotation = 45
strokeGradient.Parent = uiStroke

-- 4. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS (Corrigindo o bug de layout)
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 15) -- Espaçamento entre botões
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Padding Interno para os botões não ficarem colados na borda
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 20)
padding.PaddingBottom = UDim.new(0, 20)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = listaContainer

-- 5. LÓGICA DE ANIMAÇÃO DE ENTRADA (Slide + Fade)
local function animateListItems()
    for _, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") and not item:IsA("UIPadding") and not item:IsA("UIListLayout") then
            local originalPos = item.Position
            -- Começa deslocado para baixo e invisível
            item.Position = originalPos + UDim2.new(0, 0, 0, 30)
            item.BackgroundTransparency = 1 
            
            TweenService:Create(item, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = originalPos,
                BackgroundTransparency = 0.3 -- Ajuste conforme o design dos botões
            }):Play()
        end
    end
end

-- 6. AJUSTE DINÂMICO DO CANVAS (Corrige o scroll não funcionar)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
end)

-- Sincronização com a abertura do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.1) -- Delay pequeno para garantir que o painel abriu
        animateListItems()
    end
end)

print("✅ Lista V4 Recriada e Estilizada!")
