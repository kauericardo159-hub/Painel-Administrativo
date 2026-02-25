local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. SISTEMA DE SUBSTITUIÇÃO (Limpeza de scripts antigos)
local screenName = "PainelCustomizado_Sistema"
for _, child in pairs(playerGui:GetChildren()) do
    if child.Name == screenName then
        child:Destroy()
    end
end

-- 2. ESTRUTURA PRINCIPAL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = screenName
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Painel (Largura esticada conforme solicitado)
local painel = Instance.new("Frame")
painel.Name = "Painel"
-- Aumentei de 500 para 650 na largura (X)
painel.Size = UDim2.new(0, 650, 0, 400) 
painel.Position = UDim2.new(0.5, 0, 0.5, 0)
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.new(0, 0, 0)
painel.BackgroundTransparency = 0.2
painel.BorderSizePixel = 0
painel.Visible = false -- Controlado pelo botão
painel.Parent = screenGui

-- 3. BORDAS (UIStroke)
-- Stroke 1: Efeito Cinza/Branco Animado (Externo)
local strokePrincipal = Instance.new("UIStroke")
strokePrincipal.Thickness = 2.5
strokePrincipal.Color = Color3.fromRGB(120, 120, 120)
strokePrincipal.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokePrincipal.Parent = painel

-- Stroke 2: Camada Preta 0.2 (Interna para profundidade)
local strokeInterno = Instance.new("UIStroke")
strokeInterno.Thickness = 5
strokeInterno.Color = Color3.new(0, 0, 0)
strokeInterno.Transparency = 0.2
strokeInterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeInterno.Parent = painel

-- 4. ANIMAÇÃO DE COR (Cinza <-> Branco)
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local anim = TweenService:Create(strokePrincipal, tweenInfo, {
    Color = Color3.fromRGB(255, 255, 255)
})
anim:Play()

-- 5. INTEGRAÇÃO AUTOMÁTICA
-- Tenta encontrar a GUI do botão para se auto-organizar
task.spawn(function()
    local btnGui = playerGui:WaitForChild("InterfaceMenu", 3)
    if btnGui then
        painel.Parent = btnGui
        screenGui:Destroy()
    end
end)

print("Painel Largo e Animado carregado!")
