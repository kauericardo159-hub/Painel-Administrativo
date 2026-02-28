local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ ESTRUTURA E ESTILIZAÇÃO DO PAINEL V5 ⚙
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

-- 3. PAINEL PRINCIPAL (Reformulação de Fundo e Borda)
local painel = Instance.new("Frame")
painel.Name = "Panel" 
painel.Size = UDim2.new(0, 780, 0, 480)
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Inicia abaixo da tela
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
-- ✅ MELHORIA: Transparência definida para 0.2
painel.BackgroundTransparency = 0.2 
painel.BorderSizePixel = 0
painel.Visible = false
painel.Parent = screenGui

-- Arredondamento do Painel
local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 20)
painelCorner.Parent = painel

-- Gradiente de Fundo (Para manter o estilo visual)
local painelGradient = Instance.new("UIGradient")
painelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
painelGradient.Rotation = 135
painelGradient.Parent = painel

-- 4. ✨ BORDA LARANJA ESTILIZADA (UIStroke + Gradient)
local strokeExterno = Instance.new("UIStroke")
strokeExterno.Thickness = 4 -- Borda mais grossa para destacar
strokeExterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeExterno.Parent = painel

local strokeGradient = Instance.new("UIGradient")
-- ✅ MELHORIA: Gradiente Laranja vibrante
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
})
strokeGradient.Rotation = 45
strokeGradient.Parent = strokeExterno

-- 5. ANIMAÇÃO DE ESTILO (Pulsar de Brilho Laranja)
task.spawn(function()
    while painel.Parent do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(0.2, 0.2)})
        tween:Play()
        tween.Completed:Wait()
        
        local tweenBack = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(-0.2, -0.2)})
        tweenBack:Play()
        tweenBack.Completed:Wait()
    end
end)

-- ✅ MELHORIA: O Painel em si não deve esconder a lista automaticamente, 
-- a lógica de visibilidade da lista agora depende apenas do `ListManager`.

print("✅ Painel Base V5 (Laranja Premium) Carregado!")
