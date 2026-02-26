local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_V3", 5)
local painel = coreGui:WaitForChild("Painel")

if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER POSICIONADO À DIREITA (ScrollingFrame)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"

-- TAMANHO: Ocupa cerca de 60% da largura do painel e quase toda a altura útil
listaContainer.Size = UDim2.new(0.6, -20, 0.85, 0) 

-- POSIÇÃO: Alinhado à direita (X = 0.95) e centralizado verticalmente (Y = 0.5)
listaContainer.Position = UDim2.new(0.97, 0, 0.5, 0) 
listaContainer.AnchorPoint = Vector2.new(1, 0.5) -- Fixa a ancoragem no canto direito

listaContainer.BackgroundTransparency = 1
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 3
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.Parent = painel

-- 3. BORDAS ESTILIZADAS COM GRADIENTE (Double Stroke)
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.new(1, 1, 1)
uiStroke.Transparency = 0.7
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = listaContainer

-- Adiciona um sombreamento leve na borda da lista para profundidade
local uiStrokeBlack = Instance.new("UIStroke")
uiStrokeBlack.Thickness = 4
uiStrokeBlack.Color = Color3.new(0, 0, 0)
uiStrokeBlack.Transparency = 0.8
uiStrokeBlack.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStrokeBlack.Parent = listaContainer

-- 4. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12) -- Espaçamento elegante entre botões
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingBottom = UDim.new(0, 15)
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.Parent = listaContainer

-- 5. LÓGICA DE ANIMAÇÃO DE ENTRADA (Efeito Slide + Fade)
local function animateListItems()
    for _, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") then
            -- Define estado inicial para animação
            local originalPos = item.Position
            item.Position = originalPos + UDim2.new(0, 30, 0, 0) -- Vem da direita para esquerda
            
            -- Se o item for um botão ou frame, tenta animar transparência
            pcall(function() item.BackgroundTransparency = 1 end)
            
            TweenService:Create(item, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = originalPos
            }):Play()
        end
    end
end

-- 6. AJUSTE DINÂMICO DO CANVAS
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
end)

-- Sincronização com a abertura do painel principal
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        -- Pequeno delay para a lista aparecer após o painel expandir
        task.wait(0.1)
        animateListItems()
    end
end)

print("Lista de Opções movida para a Direita com sucesso!")
