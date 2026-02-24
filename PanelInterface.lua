--[[
    GITHUB: PanelInterface_V5_Ultimate.lua
    Versão: 5.1 (Premium Dark Edition)
    Inovações: 
    - Efeito Bloom Suave (pós-processamento global)
    - Gradiente de Reflexo Cinza (animação de superfície)
    - Interface Expandida 650x420
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------
-- [SISTEMA DE EFEITOS AMBIENTAIS]
--------------------------------------------------------------------
-- Remove efeitos antigos para evitar sobreposição
local oldBloom = Lighting:FindFirstChild("PanelBloomEffect")
if oldBloom then oldBloom:Destroy() end

-- Configuração do Bloom (Brilho suave nas luzes sem embaçar)
local bloom = Instance.new("BloomEffect")
bloom.Name = "PanelBloomEffect"
bloom.Intensity = 0.4 -- Intensidade controlada para não cegar
bloom.Size = 12       -- Espalhamento suave
bloom.Threshold = 0.8 -- Garante que apenas tons claros brilhem
bloom.Enabled = true
bloom.Parent = Lighting

--------------------------------------------------------------------
-- [CONSTRUÇÃO DA INTERFACE]
--------------------------------------------------------------------
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- [MAINFRAME - PAINEL PRINCIPAL]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 420) 
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 20)

-- Borda Fixa Metálica
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(70, 70, 75)
mainStroke.Thickness = 2.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--------------------------------------------------------------------
-- [ANIMAÇÃO DE REFLEXO CINZA (UIGradient)]
--------------------------------------------------------------------
local shineGradient = Instance.new("UIGradient")
shineGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 14)),   -- Fundo Negro
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 45, 50)), -- Brilho Cinza (Reflexo)
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 14))    -- Fundo Negro
})
shineGradient.Rotation = 45
shineGradient.Offset = Vector2.new(-1, 0)
shineGradient.Parent = mainFrame

-- Loop contínuo do reflexo passando pelo painel
task.spawn(function()
    local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local tween = TweenService:Create(shineGradient, tweenInfo, {Offset = Vector2.new(1, 0)})
    tween:Play()
end)

--------------------------------------------------------------------
-- [ELEMENTOS DO HEADER]
--------------------------------------------------------------------
local headerLine = Instance.new("Frame", mainFrame)
headerLine.Size = UDim2.new(1, -60, 0, 1)
headerLine.Position = UDim2.new(0, 30, 0, 85)
headerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
headerLine.BackgroundTransparency = 0.8
headerLine.BorderSizePixel = 0

-- Foto de Perfil Circular
local profilePic = Instance.new("ImageLabel", mainFrame)
profilePic.Name = "UserProfilePic"
profilePic.Size = UDim2.new(0, 65, 0, 65)
profilePic.Position = UDim2.new(0, 30, 0, 12)
profilePic.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
profilePic.BackgroundTransparency = 0.2
Instance.new("UICorner", profilePic).CornerRadius = UDim.new(1, 0)

local profileStroke = Instance.new("UIStroke", profilePic)
profileStroke.Thickness = 2
profileStroke.Color = Color3.fromRGB(255, 255, 255)
profileStroke.Transparency = 0.4

local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
if isReady then profilePic.Image = content end

-- Nome do Jogador (Branco Gotham)
local playerName = Instance.new("TextLabel", mainFrame)
playerName.Size = UDim2.new(0, 350, 0, 30)
playerName.Position = UDim2.new(0, 110, 0, 24)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName:upper()
playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
playerName.Font = Enum.Font.GothamBold
playerName.TextSize = 22
playerName.TextXAlignment = Enum.TextXAlignment.Left

-- Versão
local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(0, 120, 0, 20)
versionLabel.Position = UDim2.new(1, -150, 0, 27)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "SYSTEM V5.1"
versionLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.TextSize = 13
versionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Barra de Status Estilizada
local loadingBar = Instance.new("Frame", mainFrame)
loadingBar.Size = UDim2.new(0, 180, 0, 2)
loadingBar.Position = UDim2.new(0, 110, 0, 56)
loadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadingBar.BackgroundTransparency = 0.85

local progress = Instance.new("Frame", loadingBar)
progress.Size = UDim2.new(0.7, 0, 1, 0) -- Preenchimento parcial para efeito estético
progress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progress.BorderSizePixel = 0

--------------------------------------------------------------------
-- [ANIMAÇÃO DE ENTRADA]
--------------------------------------------------------------------
mainFrame.GroupTransparency = 1 -- Requer CanvasGroup para transparência de grupo, usando transparência direta para compatibilidade
mainFrame.Position = UDim2.new(0.5, -325, 0.6, -210)
mainFrame.BackgroundTransparency = 1

TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -325, 0.5, -210),
    BackgroundTransparency = 0.05
}):Play()

print("Painel V5 Ultimate com Efeitos Visuais Ativados.")
