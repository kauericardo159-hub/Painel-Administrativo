local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ ESTRUTURA E ESTILIZAÇÃO DO PAINEL V8 (Shadow Edit) ⚙
===========================================================
]]

-- 1. SISTEMA DE LIMPEZA
local coreName = "SistemaPainel_V3"
local oldGui = playerGui:FindFirstChild(coreName)
if oldGui then oldGui:Destroy() end

-- 2. ESTRUTURA BASE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = coreName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true 
screenGui.Parent = playerGui

-- 3. PAINEL PRINCIPAL
local painel = Instance.new("Frame")
painel.Name = "Panel" 
painel.Size = UDim2.new(0, 780, 0, 480)
painel.Position = UDim2.new(0.5, 0, 1.6, 0) -- Fora da tela (baixo)
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
painel.BackgroundTransparency = 0.1
painel.Visible = true -- Invisível ao criar
painel.Parent = screenGui

local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 22)
painelCorner.Parent = painel

-- 4. 🌑 SOMBRA (Drop Shadow Estática)
-- Criamos um Frame idêntico atrás para servir de sombra suave
local sombra = Instance.new("UIStroke")
sombra.Name = "Sombra"
sombra.Thickness = 8 -- Tamanho da sombra
sombra.Color = Color3.fromRGB(0, 0, 0)
sombra.Transparency = 0.6 -- Suavidade
sombra.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sombra.Parent = painel

-- 5. ✨ SISTEMA DE BORDAS EM CAMADAS (Layered UIStroke)

-- CAMADA INTERNA (Mesma cor da base para criar o "gap")
local strokeInterno = Instance.new("UIStroke")
strokeInterno.Thickness = 2.5
strokeInterno.Color = painel.BackgroundColor3
strokeInterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeInterno.Parent = painel

-- CAMADA EXTERNA (O Brilho Animado)
local strokeExterno = Instance.new("UIStroke")
strokeExterno.Thickness = 4
strokeExterno.Color = Color3.fromRGB(255, 255, 255)
strokeExterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeExterno.Parent = painel

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
strokeGradient.Parent = strokeExterno

-- 6. 🛠 ANIMAÇÕES E CONTROLE DE EXIBIÇÃO

local function iniciarPainel()
    -- Torna visível apenas no início da animação para evitar flashes
    painel.Visible = true
    
    -- Animação da Base (Sobe suavemente)
    local tweenBase = TweenService:Create(painel, TweenInfo.new(1.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tweenBase:Play()
end

-- Ciclo do Brilho na Borda
task.spawn(function()
    while painel.Parent do
        local tInfo = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local anim1 = TweenService:Create(strokeGradient, tInfo, {Offset = Vector2.new(1, 0)})
        anim1:Play()
        anim1.Completed:Wait()
        
        strokeGradient.Offset = Vector2.new(-1, 0)
        local anim2 = TweenService:Create(strokeGradient, tInfo, {Offset = Vector2.new(0, 0)})
        anim2:Play()
        anim2.Completed:Wait()
    end
end)

-- Execução
iniciarPainel()

print("✅ Painel V8: Sombra aplicada e entrada suave configurada!")
