local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ ESTRUTURA E ESTILIZAÇÃO DO PAINEL V4 ⚙
===========================================================
]]

-- 1. SISTEMA DE LIMPEZA (Garante a remoção de versões anteriores)
local coreName = "SistemaPainel_V3"
local oldGui = playerGui:FindFirstChild(coreName)
if oldGui then oldGui:Destroy() end

-- 2. ESTRUTURA BASE (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = coreName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Ocupa a tela inteira, inclusive atrás da barra do topo
screenGui.Parent = playerGui

-- 3. PAINEL PRINCIPAL (Reformulação de Tamanho e Fundo)
local painel = Instance.new("Frame")
painel.Name = "Panel" -- NOME CRÍTICO: Não alterar
painel.Size = UDim2.new(0, 780, 0, 480) -- Ligeiramente maior para respiro
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Inicia abaixo da tela
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Mais escuro para contraste
painel.BackgroundTransparency = 0.05 -- Quase opaco
painel.BorderSizePixel = 0
painel.Visible = false
painel.Parent = screenGui

-- Arredondamento do Painel (Mais suave)
local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 20)
painelCorner.Parent = painel

-- 💎 EFEITO DE GRADIENTE DE FUNDO (Ciano Profundo)
local painelGradient = Instance.new("UIGradient")
painelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
painelGradient.Rotation = 135
painelGradient.Parent = painel

-- 4. REFORMULAÇÃO DOS UISTROKES (Sombra e Brilho)

-- 💡 DROP SHADOW (Sombra projetada atrás do painel)
local dropShadow = Instance.new("ImageLabel")
dropShadow.Name = "DropShadow"
dropShadow.Size = UDim2.new(1, 40, 1, 40)
dropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
dropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
dropShadow.BackgroundTransparency = 1
dropShadow.Image = "rbxassetid://1316045217" -- ID de uma sombra suave
dropShadow.ImageColor3 = Color3.new(0, 0, 0)
dropShadow.ImageTransparency = 0.5
dropShadow.ZIndex = painel.ZIndex - 1 -- Atrás do painel
dropShadow.Parent = painel

-- ✨ BORDA NEON PULSANTE (UIStroke + UIGradient)
local strokeExterno = Instance.new("UIStroke")
strokeExterno.Thickness = 3 -- Borda mais espessa para destacar
strokeExterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeExterno.Parent = painel

local strokeGradient = Instance.new("UIGradient")
-- Paleta Neon: Ciano vibrante para um visual moderno
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
strokeGradient.Parent = strokeExterno

-- 5. ANIMAÇÃO DE ESTILO (Pulsar de Brilho)
task.spawn(function()
    while painel.Parent do
        -- Animação suave de opacidade do gradiente de borda
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(0.2, 0.2)})
        tween:Play()
        tween.Completed:Wait()
        
        local tweenBack = TweenService:Create(strokeGradient, tweenInfo, {Offset = Vector2.new(-0.2, -0.2)})
        tweenBack:Play()
        tweenBack.Completed:Wait()
    end
end)

print("✅ Painel Base V4 (Premium) Carregado!")
