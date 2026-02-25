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

-- 2. CONTAINER CENTRALIZADO (ScrollingFrame)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"
-- Tamanho ajustado para ser o foco central do painel
listaContainer.Size = UDim2.new(0, 500, 0, 240) 
listaContainer.Position = UDim2.new(0.5, 0, 0.6, 0) -- Centralizado horizontalmente e levemente abaixo do perfil
listaContainer.AnchorPoint = Vector2.new(0.5, 0.5)
listaContainer.BackgroundTransparency = 1
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 2
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.Parent = painel

-- 3. BORDAS ESTILIZADAS DA LISTA (Opcional, para delimitar a área)
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 1.5
uiStroke.Color = Color3.new(1, 1, 1)
uiStroke.Transparency = 0.8
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = listaContainer

-- 4. ORGANIZAÇÃO AUTOMÁTICA
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingBottom = UDim.new(0, 15)
padding.Parent = listaContainer

-- 5. ANIMAÇÃO DE ENTRADA DOS ITENS
-- Esta função pode ser chamada sempre que adicionar um botão à lista
local function animateListItems()
    local itens = listaContainer:GetChildren()
    local delayTime = 0
    
    for _, item in pairs(itens) do
        if item:IsA("GuiObject") then
            item.GroupTransparency = 1 -- Requer CanvasGroup no item para fade perfeito, ou anime a transparência do objeto
            local originalPos = item.Position
            item.Position = originalPos + UDim2.new(0, 0, 0, 20)
            
            task.delay(delayTime, function()
                TweenService:Create(item, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
                    Position = originalPos
                }):Play()
            end)
            delayTime = delayTime + 0.1
        end
    end
end

-- 6. AJUSTE DINÂMICO E CONEXÃO
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
end)

-- Sincroniza a animação com a visibilidade do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        listaContainer.GroupTransparency = 1
        TweenService:Create(listaContainer, TweenInfo.new(0.8), {GroupTransparency = 0}):Play()
        animateListItems()
    end
end)

print("Lista de Opções Centralizada e Estilizada!")
