local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA DE OPÇÕES V8 (RE-FIT) ⚙
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_V3")
local painel = coreGui:WaitForChild("Panel")

if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER (ScrollingFrame) - AJUSTADO
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"

-- ✅ LARGURA REDUZIDA (0.52) e POSIÇÃO MAIS BAIXA (0.6)
listaContainer.Size = UDim2.new(0.52, 0, 0.72, 0) 
listaContainer.Position = UDim2.new(0.96, 0, 0.6, 0) -- Topo desceu para não bater no perfil
listaContainer.AnchorPoint = Vector2.new(1, 0.5)

listaContainer.BackgroundTransparency = 1
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 2 -- Scroll mais fino e moderno
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listaContainer.ScrollBarImageTransparency = 0.6
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.ZIndex = painel.ZIndex + 2
listaContainer.Parent = painel

-- 3. ESTILIZAÇÃO DE BORDA SUTIL (Matching V9)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = listaContainer

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 1.5
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Transparency = 0.85 -- Quase invisível, estilo luxo
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = listaContainer

-- 4. ORGANIZAÇÃO AUTOMÁTICA
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8) -- Espaçamento reduzido
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = listaContainer

-- 5. LÓGICA DE ANIMAÇÃO DE ENTRADA
local function animateListItems()
    for i, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") then
            local targetPos = item.Position
            item.Position = targetPos + UDim2.new(0.1, 0, 0, 0)
            item.Size = UDim2.new(0.8, 0, 0, item.Size.Y.Offset) -- Começa menor
            
            task.delay(i * 0.05, function() -- Efeito cascata
                TweenService:Create(item, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                    Position = targetPos,
                    Size = UDim2.new(1, 0, 0, item.Size.Y.Offset)
                }):Play()
            end)
        end
    end
end

-- 6. AJUSTE DINÂMICO
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

-- Sincronização com o Painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.4) -- Espera o painel subir para animar os itens
        animateListItems()
    end
end)

print("✅ Lista V8: Posição corrigida e design refinado!")
