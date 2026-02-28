local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ ESTRUTURA E ESTILIZAÇÃO DO PAINEL V3 ⚙
===========================================================
]]

-- 1. SISTEMA DE LIMPEZA E SUBSTITUIÇÃO
local coreName = "SistemaPainel_V3" -- Nome padronizado para o sistema
local oldGui = playerGui:FindFirstChild(coreName)
if oldGui then oldGui:Destroy() end

-- 2. ESTRUTURA BASE (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = coreName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Ocupa a tela inteira
screenGui.Parent = playerGui

-- 3. PAINEL PRINCIPAL
local painel = Instance.new("Frame")
painel.Name = "Panel" -- Nome esperado pelos scripts de perfil/botão
painel.Size = UDim2.new(0, 750, 0, 450) -- Ligeiramente maior para detalhamento
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Inicia abaixo para animação
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
painel.BackgroundTransparency = 0.1
painel.BorderSizePixel = 0
painel.Visible = false
painel.Parent = screenGui

-- Arredondamento do Painel
local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 15)
painelCorner.Parent = painel

-- Gradiente de Fundo Estiloso
local painelGradient = Instance.new("UIGradient")
painelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
})
painelGradient.Rotation = 60
painelGradient.Parent = painel

-- 4. REFORMULAÇÃO DOS UISTROKES (Bordas Estilosas)

-- Borda Interna (Sombra para dar profundidade)
local strokeInterno = Instance.new("UIStroke")
strokeInterno.Thickness = 5
strokeInterno.Color = Color3.new(0, 0, 0)
strokeInterno.Transparency = 0.5
strokeInterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeInterno.Parent = painel

-- Borda Externa (O "Brilho" com UIGradient Animado)
local strokeExterno = Instance.new("UIStroke")
strokeExterno.Thickness = 2
strokeExterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeExterno.Parent = painel

local strokeGradient = Instance.new("UIGradient")
-- Cores neon para a borda (ciano e branco para contraste)
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
strokeGradient.Parent = strokeExterno

-- 5. ANIMAÇÃO DE UISTROKE (Efeito de Brilho Pulsante e Rotativo)
local function startStrokeAnimation()
    task.spawn(function()
        while painel.Parent do
            -- Anima o deslocamento do gradiente para criar efeito de movimento na borda
            local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(1, 1)})
            strokeGradient.Offset = Vector2.new(-1, -1)
            tween:Play()
            tween.Completed:Wait()
            
            -- Reverte o deslocamento
            local tweenBack = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(-1, -1)})
            tweenBack:Play()
            tweenBack.Completed:Wait()
        end
    end
end
startStrokeAnimation()

-- 6. ÁREA DA LISTA DE OPÇÕES (Integrada e Abaixada)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"
listaContainer.Size = UDim2.new(0, 380, 0, 300) 
listaContainer.Position = UDim2.new(1, -25, 0.55, 0) -- Abaixado e à direita
listaContainer.AnchorPoint = Vector2.new(1, 0.5)
listaContainer.BackgroundTransparency = 1
listaContainer.ScrollBarThickness = 4
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255) -- Cor da scrollbar combinando com a borda
listaContainer.BorderSizePixel = 0
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.Parent = painel

local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.Padding = UDim.new(0, 15)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

print("✅ Painel Premium V3 recriado com Gradientes e Bordas Animadas!")
