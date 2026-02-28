local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA EXTRA V3 (ALTURA) ⚙
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_V3")
local painel = coreGui:WaitForChild("Panel")

-- Limpa a lista extra anterior se existir
if painel:FindFirstChild("ExtraListContainer") then
    painel.ExtraListContainer:Destroy()
end

-- 2. CONTAINER DA LISTA EXTRA (Posição Esquerda + Altura Reduzida)
local extraContainer = Instance.new("ScrollingFrame")
extraContainer.Name = "ExtraListContainer"

-- TAMANHO E POSIÇÃO: Ajustado para o lado esquerdo
extraContainer.Size = UDim2.new(0.35, 0, 0.70, 0) -- ✅ ALTURA REDUZIDA para 70%
extraContainer.Position = UDim2.new(0.03, 0, 0.60, 0) -- ✅ POSIÇÃO VERTICAL AJUSTADA para 60%
extraContainer.AnchorPoint = Vector2.new(0, 0.5)

extraContainer.BackgroundTransparency = 1 -- Fundo transparente
extraContainer.BorderSizePixel = 0
extraContainer.ScrollBarThickness = 6
-- ScrollBar Azul para combinar com o tema
extraContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 50, 150)
extraContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
extraContainer.ClipsDescendants = true
extraContainer.ZIndex = painel.ZIndex + 2
extraContainer.Parent = painel

-- 3. ESTILIZAÇÃO: UICORNER & DOUBLE STROKE (Azul Escuro + Preto)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = extraContainer

-- ✅ UIStroke AZUL ESCURO (Borda principal)
local uiStrokeAzul = Instance.new("UIStroke")
uiStrokeAzul.Thickness = 3
uiStrokeAzul.Color = Color3.fromRGB(0, 50, 150) -- Azul Escuro
uiStrokeAzul.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStrokeAzul.Transparency = 0.5
uiStrokeAzul.Parent = extraContainer

-- ✅ UIStroke PRETO (Animação de "brilho interno")
local uiStrokePreto = Instance.new("UIStroke")
uiStrokePreto.Thickness = 6
uiStrokePreto.Color = Color3.fromRGB(0, 0, 0) -- Preto
uiStrokePreto.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStrokePreto.Transparency = 1 -- Inicia invisível
uiStrokePreto.Parent = extraContainer

-- 4. ANIMAÇÃO DIFERENTE NO UISTROKE PRETO
task.spawn(function()
    while extraContainer.Parent do
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
layout.Parent = extraContainer
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
padding.Parent = extraContainer

-- 6. LÓGICA DE ANIMAÇÃO DE ENTRADA (Slide + Fade)
local function animateListItems()
    for _, item in pairs(extraContainer:GetChildren()) do
        if item:IsA("GuiObject") and not item:IsA("UIPadding") and not item:IsA("UIListLayout") then
            local originalPos = item.Position
            -- Começa deslocado para a ESQUERDA e invisível
            item.Position = originalPos - UDim2.new(0, 30, 0, 0)
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
    extraContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
end)

-- Sincronização com a abertura do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.1) 
        animateListItems()
    end
end)

print("✅ Lista Extra V3 (Altura Reduzida) Carregada!")
