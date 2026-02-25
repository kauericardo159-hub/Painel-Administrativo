local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. LIMPEZA DE SISTEMAS ANTIGOS
local mainName = "SistemaPainelLux"
if playerGui:FindFirstChild(mainName) then playerGui[mainName]:Destroy() end

-- 2. ESTRUTURA INICIAL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = mainName
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 3. TELA DE CARREGAMENTO (INTRO)
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(1, 0, 1, 0)
loadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
loadFrame.ZIndex = 10
loadFrame.Parent = screenGui

local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(0, 300, 0, 4)
loadBarBg.Position = UDim2.new(0.5, 0, 0.5, 40)
loadBarBg.AnchorPoint = Vector2.new(0.5, 0.5)
loadBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadBarBg.BorderSizePixel = 0
loadBarBg.Parent = loadFrame

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadBarFill.BorderSizePixel = 0
loadBarFill.Parent = loadBarBg

local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(0, 200, 0, 30)
loadText.Position = UDim2.new(0.5, 0, 0.5, 0)
loadText.AnchorPoint = Vector2.new(0.5, 0.5)
loadText.BackgroundTransparency = 1
loadText.Text = "INICIALIZANDO SISTEMAS..."
loadText.TextColor3 = Color3.new(1, 1, 1)
loadText.Font = Enum.Font.GothamMedium
loadText.TextSize = 14
loadText.Parent = loadFrame

-- 4. CRIAÇÃO DO PAINEL PRINCIPAL (MELHORADO)
local painel = Instance.new("Frame")
painel.Name = "Painel"
painel.Size = UDim2.new(0, 750, 0, 480) -- Tamanho expandido e imponente
painel.Position = UDim2.new(0.5, 0, 0.5, 0)
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
painel.BackgroundTransparency = 0.2 -- Transparência conforme solicitado
painel.Visible = false
painel.ClipsDescendants = true
painel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = painel

-- Gradiente Estiloso no Fundo
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient.Rotation = 45
gradient.Parent = painel

-- 5. UISTROKE AVANÇADO (Bordas Animadas)
local strokeBranco = Instance.new("UIStroke")
strokeBranco.Thickness = 3
strokeBranco.Color = Color3.new(1, 1, 1)
strokeBranco.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeBranco.Parent = painel

local strokeGrad = Instance.new("UIGradient")
strokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
})
strokeGrad.Parent = strokeBranco

local strokeCinza = Instance.new("UIStroke")
strokeCinza.Thickness = 6
strokeCinza.Color = Color3.fromRGB(0, 0, 0)
strokeCinza.Transparency = 0.4
strokeCinza.Parent = painel

-- 6. LÓGICA DE CARREGAMENTO E ANIMAÇÃO
task.spawn(function()
    -- Simulação de carregamento da barra
    local tweenLoad = TweenService:Create(loadBarFill, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    tweenLoad:Play()
    
    task.wait(2.2)
    
    -- Fade out da tela de loading
    TweenService:Create(loadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(loadBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadBarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    loadFrame:Destroy()
    
    -- Animação infinita do UIStroke (Rotação do Brilho)
    task.spawn(function()
        while true do
            strokeGrad.Rotation = strokeGrad.Rotation + 2
            task.wait(0.02)
        end
    end)
end)

print("Painel de Luxo com Sequência de Boot carregado!")
