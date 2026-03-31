local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
⚙ ESTRUTURA E ESTILIZAÇÃO DO PAINEL V9 (Elite Design) ⚙
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

-- 3. PAINEL PRINCIPAL (Design Modernizado)
local painel = Instance.new("Frame")
painel.Name = "Panel" 
painel.Size = UDim2.new(0, 520, 0, 300)
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Começa bem abaixo da tela
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- Tom levemente mais azulado/escuro
painel.BackgroundTransparency = 0.15
painel.Visible = false -- CORREÇÃO: Começa invisível
painel.ClipsDescendants = false -- Permite que a sombra apareça
painel.Parent = screenGui

local painelCorner = Instance.new("UICorner")
painelCorner.CornerRadius = UDim.new(0, 24)
painelCorner.Parent = painel

-- 4. 🌑 EFEITO DE SOMBRA REALISTA (Drop Shadow)
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 45, 1, 45)
shadow.Image = "rbxassetid://6014264792" -- Textura de sombra suave
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = painel.ZIndex - 1
shadow.Parent = painel

-- 5. ✨ BORDAS E GRADIENTES (Premium Look)

-- Stroke principal (Borda fina e elegante)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = painel

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Rotation = 45
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 65)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 205)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 65))
})
strokeGradient.Parent = UIStroke

-- Brilho Interno Superior (Efeito de vidro)
local TopGlow = Instance.new("Frame")
TopGlow.Name = "TopGlow"
TopGlow.Size = UDim2.new(1, 0, 0, 40)
TopGlow.Position = UDim2.new(0, 0, 0, 0)
TopGlow.BackgroundTransparency = 1
TopGlow.Parent = painel

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 24)
topCorner.Parent = TopGlow

local topGradient = Instance.new("UIGradient")
topGradient.Rotation = 90
topGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.8),
    NumberSequenceKeypoint.new(1, 1)
})
topGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
topGradient.Parent = TopGlow
TopGlow.BackgroundTransparency = 0 -- Ativado pelo gradiente

-- 6. 🛠 LOGICA DE EXIBIÇÃO E ANIMAÇÃO

local function iniciarPainel()
    -- Espera um pouco para garantir que tudo carregou
    task.wait(0.1)
    
    -- Torna visível apenas quando a animação for disparada
    painel.Visible = true
    
    local tInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    -- Animação de subida e transparência
    painel.BackgroundTransparency = 1
    UIStroke.Transparency = 1
    
    TweenService:Create(painel, tInfo, {Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0.15}):Play()
    TweenService:Create(UIStroke, tInfo, {Transparency = 0.2}):Play()
    TweenService:Create(shadow, tInfo, {ImageTransparency = 0.5}):Play()
end

-- Ciclo de brilho metálico na borda (Animação infinita suave)
task.spawn(function()
    while painel.Parent do
        local tween = TweenService:Create(strokeGradient, TweenInfo.new(4, Enum.EasingStyle.Linear), {Rotation = 405})
        tween:Play()
        tween.Completed:Wait()
        strokeGradient.Rotation = 45
    end
end)

-- IMPORTANTE: Se quiser que ele apareça sozinho ao dar Play, mantenha a linha abaixo.
-- Se quiser que ele SÓ apareça quando clicar no botão, comente a linha abaixo!
-- iniciarPainel() 

print("✅ Painel V9: Design Minimalista e correção de visibilidade aplicados!")
