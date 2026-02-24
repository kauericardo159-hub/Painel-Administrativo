--[[
    GITHUB: PanelInterface_V5_Clean.lua
    Função: Painel Expandido, Design Dark Premium, Sem RGB, Estilo Moderno.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [LIMPEZA]
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- [PAINEL PRINCIPAL MUITO MAIOR]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
-- Aumentado para 650x420 para suportar listas complexas e botões grandes
mainFrame.Size = UDim2.new(0, 650, 0, 420) 
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14) -- Tom mais profundo
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 20) -- Bordas mais arredondadas

-- Borda Fixa Elegante (Substituindo o RGB)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(60, 60, 65) -- Cinza metálico fixo
mainStroke.Thickness = 2.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [HEADER / TOPO]
local headerLine = Instance.new("Frame", mainFrame)
headerLine.Size = UDim2.new(1, -60, 0, 1)
headerLine.Position = UDim2.new(0, 30, 0, 85)
headerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
headerLine.BackgroundTransparency = 0.8
headerLine.BorderSizePixel = 0

-- [FOTO DE PERFIL]
local profilePic = Instance.new("ImageLabel", mainFrame)
profilePic.Name = "UserProfilePic"
profilePic.Size = UDim2.new(0, 60, 0, 60)
profilePic.Position = UDim2.new(0, 30, 0, 15)
profilePic.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", profilePic).CornerRadius = UDim.new(1, 0)

local profileStroke = Instance.new("UIStroke", profilePic)
profileStroke.Thickness = 2
profileStroke.Color = Color3.fromRGB(255, 255, 255)
profileStroke.Transparency = 0.5

-- Carregar Imagem
local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
if isReady then profilePic.Image = content end

-- [NOME DO JOGADOR]
local playerName = Instance.new("TextLabel", mainFrame)
playerName.Size = UDim2.new(0, 300, 0, 30)
playerName.Position = UDim2.new(0, 105, 0, 22)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName:upper() -- Nome em caixa alta para estilo
playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
playerName.Font = Enum.Font.GothamBold
playerName.TextSize = 20
playerName.TextXAlignment = Enum.TextXAlignment.Left

-- [VERSÃO / STATUS]
local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(0, 100, 0, 20)
versionLabel.Position = UDim2.new(1, -130, 0, 27)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "VERSION: V5.0"
versionLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.TextSize = 12
versionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- [INDICADOR DE CARGA]
local loadingBar = Instance.new("Frame", mainFrame)
loadingBar.Size = UDim2.new(0, 150, 0, 2)
loadingBar.Position = UDim2.new(0, 105, 0, 52)
loadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadingBar.BackgroundTransparency = 0.9

local progress = Instance.new("Frame", loadingBar)
progress.Size = UDim2.new(1, 0, 1, 0)
progress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progress.BorderSizePixel = 0

print("Painel V5 Clean carregado.")
