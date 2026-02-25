local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. LIMPEZA ANTI-DUPLICAÇÃO
local screenName = "SistemaAvancado_Painel"
if playerGui:FindFirstChild(screenName) then playerGui[screenName]:Destroy() end

-- 2. CRIAÇÃO DA ESTRUTURA
local screenGui = Instance.new("ScreenGui")
screenGui.Name = screenName
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Painel Principal (Tamanho Melhorado e Esticado)
local painel = Instance.new("Frame")
painel.Name = "Painel"
painel.Size = UDim2.new(0, 700, 0, 420) -- Tamanho otimizado
painel.Position = UDim2.new(0.5, 0, 0.5, 0)
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.new(1, 1, 1) -- Branco (UIGradient controla a cor)
painel.BackgroundTransparency = 0.2
painel.BorderSizePixel = 0
painel.Visible = false -- Começa invisível para o carregamento
painel.Parent = screenGui

local gradientePainel = Instance.new("UIGradient")
gradientePainel.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
})
gradientePainel.Rotation = 45
gradientePainel.Parent = painel

-- 3. ESTILO DE BORDA (UIStroke Animado com Gradiente)
local strokePrincipal = Instance.new("UIStroke")
strokePrincipal.Thickness = 3
strokePrincipal.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokePrincipal.Parent = painel

local gradienteStroke = Instance.new("UIGradient")
gradienteStroke.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
})
gradienteStroke.Parent = strokePrincipal

-- Animação infinita do Gradiente na Borda
task.spawn(function()
    while true do
        gradienteStroke.Offset = Vector2.new(-1, 0)
        local t = TweenService:Create(gradienteStroke, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
        t:Play()
        t.Completed:Wait()
    end
end)

-- 4. TELA DE CARREGAMENTO (Loading Screen)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 300, 0, 100)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

local loadLabel = Instance.new("TextLabel")
loadLabel.Text = "CARREGANDO SISTEMAS..."
loadLabel.Size = UDim2.new(1, 0, 0, 30)
loadLabel.TextColor3 = Color3.new(1, 1, 1)
loadLabel.BackgroundTransparency = 1
loadLabel.Font = Enum.Font.GothamBold
loadLabel.TextSize = 14
loadLabel.Parent = loadingFrame

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(0.8, 0, 0, 10)
barBackground.Position = UDim2.new(0.5, 0, 0.7, 0)
barBackground.AnchorPoint = Vector2.new(0.5, 0.5)
barBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBackground.Parent = loadingFrame

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.Parent = barBackground

-- 5. LÓGICA DE INICIALIZAÇÃO
task.spawn(function()
    -- Simulação de carregamento
    local progressTween = TweenService:Create(barFill, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    progressTween:Play()
    progressTween.Completed:Wait()
    
    -- Finaliza Loading e mostra Painel
    loadingFrame:Destroy()
    painel.Visible = true
    
    -- Som de sucesso ou efeito de escala ao abrir
    painel.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(painel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 700, 0, 420)}):Play()
end)

-- Arredondamento
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = painel

print("Sistema com Loading e Gradiente inicializado!")
