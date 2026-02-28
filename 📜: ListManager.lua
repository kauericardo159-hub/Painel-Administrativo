local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA DE OPÇÕES V4 (Premium) ⚙
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_V3")
local painel = coreGui:WaitForChild("Panel") -- Busca o Painel V4

-- Limpa apenas a lista se ela já existir, não o painel inteiro
if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER POSICIONADO À DIREITA (ScrollingFrame Reformulado)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"

-- TAMANHO E POSIÇÃO: Ajustados para o novo painel V4
listaContainer.Size = UDim2.new(0.5, -20, 0.75, 0) 
listaContainer.Position = UDim2.new(0.98, 0, 0.5, 0) 
listaContainer.AnchorPoint = Vector2.new(1, 0.5)

listaContainer.BackgroundTransparency = 1 -- Fundo transparente
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 6
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 128, 0) -- Laranja Neon
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Será ajustado automaticamente
listaContainer.ClipsDescendants = true
listaContainer.Parent = painel

-- 3. BORDAS ESTILIZADAS COM GRADIENTE LARANJA
-- Borda Externa Neon Laranja
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = listaContainer

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 128, 0)), -- Laranja
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 100)), -- Laranja Claro
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 128, 0)) -- Laranja
})
strokeGradient.Parent = uiStroke

-- Borda Interna (Sombra para Profundidade)
local uiStrokeBlack = Instance.new("UIStroke")
uiStrokeBlack.Thickness = 4
uiStrokeBlack.Color = Color3.new(0, 0, 0)
uiStrokeBlack.Transparency = 0.5
uiStrokeBlack.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStrokeBlack.Parent = listaContainer

-- 4. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS (Aqui estava o erro principal)
local layout = Instance.new("UIListLayout")
layout.Name = "ListaLayout"
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12) -- Espaçamento entre botões
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Padding Interno do Container
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.Parent = listaContainer

-- 5. AJUSTE DINÂMICO DO CANVAS (Crucial para rolagem funcionar)
local function updateCanvasSize()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
updateCanvasSize() -- Ajuste inicial

-- 6. EXEMPLO DE ITEM (Para testar se a lista funciona)
-- ADICIONE SEUS BOTÕES AQUI DEPOIS, ISSO É APENAS UM TESTE
for i = 1, 10 do
    local testBtn = Instance.new("TextButton")
    testBtn.Name = "Opcao"..i
    testBtn.Size = UDim2.new(0.9, 0, 0, 40)
    testBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    testBtn.Text = "Comando "..i
    testBtn.TextColor3 = Color3.new(1, 1, 1)
    testBtn.Font = Enum.Font.GothamBold
    testBtn.TextSize = 16
    testBtn.Parent = listaContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = testBtn
end

-- 7. ANIMAÇÃO DE ENTRADA (Slide suave)
local function animateListItems()
    for _, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") then
            local originalPos = item.Position
            item.Position = originalPos + UDim2.new(0, 30, 0, 0)
            item.BackgroundTransparency = 1
            if item:IsA("TextButton") then item.TextTransparency = 1 end
            
            TweenService:Create(item, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                Position = originalPos,
                BackgroundTransparency = 0.2
            }):Play()
            
            if item:IsA("TextButton") then
                TweenService:Create(item, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
            end
        end
    end
end

-- Sincronização com a abertura do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.2) -- Espera o painel terminar de subir
        animateListItems()
    end
end)

print("✅ Lista de Opções V4 (Laranja Neon) Carregada!")
