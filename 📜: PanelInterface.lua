local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ ESTRUTURA E ESTILIZAÇÃO DO PAINEL V6 ⚙
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

-- 3. PAINEL PRINCIPAL (Gradiente de fundo + UICorner)
local painel = Instance.new("Frame")
painel.Name = "Panel" 
painel.Size = UDim2.new(0, 780, 0, 480)
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Inicia abaixo da tela
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
painel.BackgroundTransparency = 0.2 
painel.BorderSizePixel = 0
painel.Visible = false
painel.Parent = screenGui

-- Arredondamento do Painel
local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 20)
painelCorner.Parent = painel

-- ✅ MELHORIA: UIGradient APENAS no fundo do Painel
local painelGradient = Instance.new("UIGradient")
painelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)), -- Mais claro
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 15)), -- Cor base
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- Mais escuro
})
painelGradient.Rotation = 135
painelGradient.Parent = painel

-- 4. ✨ BORDA BRANCA ESTILIZADA (UIStroke + Animação)
local strokeExterno = Instance.new("UIStroke")
strokeExterno.Thickness = 3
strokeExterno.Color = Color3.fromRGB(255, 255, 255) -- ✅ Borda Branca
strokeExterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeExterno.Parent = painel

-- UIGradient na Borda para criar o efeito de "passar luz" (branco -> preto)
local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), -- Branco
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)), -- Cinza
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- Preto
})
strokeGradient.Parent = strokeExterno

-- 5. ✅ ANIMAÇÃO ESTILOSA (Brilho "correndo" na borda)
task.spawn(function()
    while painel.Parent do
        -- Move o gradiente de um lado para o outro para criar o efeito de luz
        local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        
        local tween1 = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(1, 1)})
        tween1:Play()
        tween1.Completed:Wait()
        
        local tween2 = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(-1, -1)})
        tween2:Play()
        tween2.Completed:Wait()
    end
end)

print("✅ Painel Base V6 (Gradiente + Borda Animada) Carregado!")
