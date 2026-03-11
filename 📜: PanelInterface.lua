local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ ESTRUTURA E ESTILIZAÇÃO DO PAINEL V7 ⚙
===========================================================
]]

-- 1. SISTEMA DE LIMPEZA
local coreName = "SistemaPainel_V3"
local oldGui = playerGui:FindFirstChild(coreName)
if oldGui then oldGui:Destroy() end

-- 2. ESTRUTURA BASE (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = coreName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true 
screenGui.Parent = playerGui

-- 3. PAINEL PRINCIPAL
local painel = Instance.new("Frame")
painel.Name = "Panel" 
painel.Size = UDim2.new(0, 780, 0, 480)
-- Posição inicial (abaixo da tela para animação)
painel.Position = UDim2.new(0.5, 0, 1.5, 0) 
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Cor base sólida
painel.BackgroundTransparency = 0.1 
painel.BorderSizePixel = 0
painel.Visible = true -- Definido como true para a animação iniciar
painel.Parent = screenGui

local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 20)
painelCorner.Parent = painel

local painelGradient = Instance.new("UIGradient")
painelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
})
painelGradient.Rotation = 135
painelGradient.Parent = painel

-- 4. ✨ SISTEMA DE BORDAS DUPLAS (UIStroke Layering)

-- CAMADA 1: Borda de Cor da Base (Cria o efeito de separação/preenchimento)
local strokeInterno = Instance.new("UIStroke")
strokeInterno.Name = "StrokeInterno"
strokeInterno.Thickness = 2.5 -- Espessura entre a base e o brilho
strokeInterno.Color = painel.BackgroundColor3 -- Mesma cor da base
strokeInterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeInterno.Transparency = 0
strokeInterno.Parent = painel

-- CAMADA 2: Borda Externa Branca (O Brilho)
local strokeExterno = Instance.new("UIStroke")
strokeExterno.Name = "StrokeExterno"
strokeExterno.Thickness = 4.5 -- Aumentado conforme solicitado
strokeExterno.Color = Color3.fromRGB(255, 255, 255)
strokeExterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeExterno.Parent = painel

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 80)), -- Contraste maior
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
strokeGradient.Parent = strokeExterno

-- 5. 🛠 ANIMAÇÕES

-- A: Animação de Entrada do Painel (Base)
local function animarEntrada()
    local infoEntrada = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local objetivo = {Position = UDim2.new(0.5, 0, 0.5, 0)}
    TweenService:Create(painel, infoEntrada, objetivo):Play()
end

-- B: Animação de Ciclo do UIStroke (Brilho "Correndo")
task.spawn(function()
    while painel.Parent do
        local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        
        local tween1 = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(1, 0)})
        tween1:Play()
        tween1.Completed:Wait()
        
        strokeGradient.Offset = Vector2.new(-1, 0)
        local tween2 = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(0, 0)})
        tween2:Play()
        tween2.Completed:Wait()
    end
end)

-- Iniciar animação de entrada
animarEntrada()

print("✅ Painel V7: Bordas em Camadas e Animação de Base Ativada!")
