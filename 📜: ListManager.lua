local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA DE OPÇÕES V6 ⚙
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

-- 2. CONTAINER REPOSICIONADO À DIREITA (ScrollingFrame)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"

-- TAMANHO: Ocupa quase toda a parte direita (ex: 45% largura, 90% altura)
listaContainer.Size = UDim2.new(0.45, 0, 0.9, 0) 

-- POSIÇÃO: Alinhado à direita
listaContainer.Position = UDim2.new(0.97, 0, 0.5, 0) 
listaContainer.AnchorPoint = Vector2.new(1, 0.5)

listaContainer.BackgroundTransparency = 1 -- Fundo transparente
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 6
-- ScrollBar branca para combinar com a borda do painel
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.ClipsDescendants = true
listaContainer.ZIndex = painel.ZIndex + 2 -- Garante que fique NA FRENTE
listaContainer.Parent = painel

-- 3. ESTILIZAÇÃO: UICORNER & DOUBLE STROKE (Cinza + Preto)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = listaContainer

-- ✅ UIStroke CINZA (Borda principal)
local uiStrokeCinza = Instance.new("UIStroke")
uiStrokeCinza.Thickness = 3
uiStrokeCinza.Color = Color3.fromRGB(150, 150, 150) -- Cinza
uiStrokeCinza.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStrokeCinza.Transparency = 0.5
uiStrokeCinza.Parent = listaContainer

-- ✅ UIStroke PRETO (Animação de "brilho interno")
local uiStrokePreto = Instance.new("UIStroke")
uiStrokePreto.Thickness = 6
uiStrokePreto.Color = Color3.fromRGB(0, 0, 0) -- Preto
uiStrokePreto.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStrokePreto.Transparency = 1 -- Inicia invisível
uiStrokePreto.Parent = listaContainer

-- 4. ANIMAÇÃO DIFERENTE NO UISTROKE PRETO
task.spawn(function()
    while listaContainer.Parent do
        -- Animação de pulsar da transparência do stroke preto
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        
        local fadeOut = TweenService:Create(uiStrokePreto, tweenInfo, {Transparency = 1})
        local fadeIn = TweenService:Create(uiStrokePreto, tweenInfo, {Transparency = 0.7})
        
        fadeIn:Play()
        fadeIn.Completed:Wait()
        fadeOut:Play()
        fadeOut.Completed:Wait()
    end
end)

-- 5. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS (UIListLayout)
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10) -- Espaçamento entre botões
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Padding Interno
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingBottom = UDim.new(0, 15)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = listaContainer

-- 6. LÓGICA DE ANIMAÇÃO DE ENTRADA (Slide + Fade)
local function animateListItems()
    for _, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") and not item:IsA("UIPadding") and not item:IsA("UIListLayout") then
            local originalPos = item.Position
            -- Começa deslocado para a direita e invisível
            item.Position = originalPos + UDim2.new(0, 30, 0, 0)
            item.BackgroundTransparency = 1 
            
            TweenService:Create(item, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = originalPos,
                BackgroundTransparency = 0.5 
            }):Play()
        end
    end
end

-- 7. AJUSTE DINÂMICO DO CANVAS
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
end)

-- Sincronização com a abertura do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.1) 
        animateListItems()
    end
end)

print("✅ Lista V6 (Direita + Borda Animada) Recriada!")
