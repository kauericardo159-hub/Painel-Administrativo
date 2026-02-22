--[[
    GITHUB: PanelInterface_V2.lua
    Função: Criar a interface principal baseada no desenho (Fundo, Perfil, Textos).
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [LIMPEZA DE DUPLICATAS]
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- [PAINEL PRINCIPAL (Fundo Cinza Escuro)]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 480) -- Formato mais vertical/quadrado
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40) -- Cinza Escuro
mainFrame.BackgroundTransparency = 0.15 -- Um pouco transparente
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Fica invisível até clicar no botão do Script 1
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- UIStroke Branco no Fundo
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 2.5
mainStroke.Parent = mainFrame

-- [TÍTULO DO PAINEL (Name panel)]
local titleBg = Instance.new("Frame")
titleBg.Size = UDim2.new(0, 140, 0, 35)
titleBg.Position = UDim2.new(0.05, 0, 0.04, 0)
titleBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fundo preto como no desenho
titleBg.Parent = mainFrame
Instance.new("UICorner", titleBg).CornerRadius = UDim.new(0, 6)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = " 🛠 Admin Panel "
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = titleBg

-- [NOME DO JOGADOR (Name Player)]
local playerName = Instance.new("TextLabel")
playerName.Size = UDim2.new(0, 120, 0, 30)
playerName.Position = UDim2.new(0.45, 0, 0.05, 0)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName
playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
playerName.Font = Enum.Font.GothamMedium
playerName.TextSize = 15
playerName.TextXAlignment = Enum.TextXAlignment.Right
playerName.Parent = mainFrame

-- [FOTO DE PERFIL (Circular)]
local profilePic = Instance.new("ImageLabel")
profilePic.Name = "UserProfilePic"
profilePic.Size = UDim2.new(0, 60, 0, 60)
profilePic.Position = UDim2.new(0.8, 0, 0.02, 0)
profilePic.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
profilePic.Parent = mainFrame

-- Deixar a imagem redonda
Instance.new("UICorner", profilePic).CornerRadius = UDim.new(1, 0)

-- UIStroke Branco no Perfil
local profileStroke = Instance.new("UIStroke")
profileStroke.Color = Color3.fromRGB(255, 255, 255)
profileStroke.Thickness = 2
profileStroke.Parent = profilePic

-- Carregar o Avatar do Jogador
local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
if isReady then
    profilePic.Image = content
end
