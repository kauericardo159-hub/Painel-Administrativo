--[[
    PAINEL V7.0 - ESTRUTURA BASE (LAYOUT PREMIUM)
    Design: Bordas Brancas (UIStroke) + UIGradient
    Organização: Cabeçalho, Sidebar (Opções) e Content (Comandos)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [CONFIGURAÇÕES DE CORES E ESTILO]
local CORES = {
    Fundo = Color3.fromRGB(15, 15, 15),       -- Grafite Escuro
    FundoSecundario = Color3.fromRGB(25, 25, 25), -- Cinza para containers internos
    Borda = Color3.fromRGB(255, 255, 255),    -- Branco solicitado (UIStroke)
    GradienteInicio = Color3.fromRGB(45, 45, 45),
    GradienteFim = Color3.fromRGB(15, 15, 15),
    Texto = Color3.fromRGB(255, 255, 255)
}

-- [LIMPEZA DE INTERFACE ANTIGA]
if playerGui:FindFirstChild("MainPanel_V7") then
    playerGui.MainPanel_V7:Destroy()
end

-- [CRIAÇÃO DA SCREEN GUI]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_V7"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ==========================================
-- 1. MAINFRAME (Fundo Geral)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 480)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
mainFrame.BackgroundColor3 = CORES.Fundo
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Borda Branca Principal
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = CORES.Borda
mainStroke.Thickness = 2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Gradiente para Profundidade
local mainGradient = Instance.new("UIGradient", mainFrame)
mainGradient.Color = ColorSequence.new(CORES.GradienteInicio, CORES.GradienteFim)
mainGradient.Rotation = 45

-- ==========================================
-- 2. CABEÇALHO (Foto, Nome e Título)
-- ==========================================

-- Container Foto de Perfil
local profileFrame = Instance.new("Frame", mainFrame)
profileFrame.Name = "ProfileFrame"
profileFrame.Size = UDim2.new(0, 60, 0, 60)
profileFrame.Position = UDim2.new(0, 20, 0, 20)
profileFrame.BackgroundColor3 = CORES.FundoSecundario
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", profileFrame).Color = CORES.Borda

local profileImg = Instance.new("ImageLabel", profileFrame)
profileImg.Size = UDim2.new(0.9, 0, 0.9, 0)
profileImg.Position = UDim2.new(0.05, 0, 0.05, 0)
profileImg.BackgroundTransparency = 1
profileImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Instance.new("UICorner", profileImg).CornerRadius = UDim.new(1, 0)

-- Nome do Jogador e Versão
local nameLabel = Instance.new("TextLabel", mainFrame)
nameLabel.Name = "PlayerInfo"
nameLabel.Size = UDim2.new(0, 150, 0, 40)
nameLabel.Position = UDim2.new(0, 90, 0, 20)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = player.DisplayName .. "\n<font color='#aaaaaa'>V7.0</font>"
nameLabel.TextColor3 = CORES.Texto
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.RichText = true
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Container do Título (Ao lado do nome)
local titleBox = Instance.new("Frame", mainFrame)
titleBox.Name = "TitleBox"
titleBox.Size = UDim2.new(0, 350, 0, 50)
titleBox.Position = UDim2.new(1, -370, 0, 25)
titleBox.BackgroundColor3 = CORES.FundoSecundario
Instance.new("UICorner", titleBox).CornerRadius = UDim.new(0, 8)
local titleStroke = Instance.new("UIStroke", titleBox)
titleStroke.Color = CORES.Borda
titleStroke.Thickness = 1.5

local titleLabel = Instance.new("TextLabel", titleBox)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU DE OPERAÇÕES"
titleLabel.TextColor3 = CORES.Texto
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18

-- ==========================================
-- 3. SIDEBAR (Área de Opções)
-- ==========================================
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 210, 0, 350)
sidebar.Position = UDim2.new(0, 20, 0, 100)
sidebar.BackgroundColor3 = CORES.FundoSecundario
sidebar.BackgroundTransparency = 0.4
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local sideStroke = Instance.new("UIStroke", sidebar)
sideStroke.Color = CORES.Borda
sideStroke.Thickness = 1.5

local sideTitle = Instance.new("TextLabel", sidebar)
sideTitle.Size = UDim2.new(1, 0, 0, 30)
sideTitle.Text = "OPÇÕES"
sideTitle.TextColor3 = CORES.Texto
sideTitle.Font = Enum.Font.GothamBold
sideTitle.TextSize = 14
sideTitle.BackgroundTransparency = 1

-- Espaço reservado para os botões do script de Opções
local optionsContainer = Instance.new("Frame", sidebar)
optionsContainer.Name = "OptionsContainer"
optionsContainer.Size = UDim2.new(1, -10, 1, -40)
optionsContainer.Position = UDim2.new(0, 5, 0, 35)
optionsContainer.BackgroundTransparency = 1

-- ==========================================
-- 4. ÁREA DE CONTEÚDO (Para ListManager)
-- ==========================================
local contentArea = Instance.new("Frame", mainFrame)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(0, 430, 0, 350)
contentArea.Position = UDim2.new(0, 250, 0, 100)
contentArea.BackgroundColor3 = CORES.FundoSecundario
contentArea.BackgroundTransparency = 0.4
Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 8)

local contentStroke = Instance.new("UIStroke", contentArea)
contentStroke.Color = CORES.Borda
contentStroke.Thickness = 1.5

-- Container onde o ListManager irá atuar
local pagesFolder = Instance.new("Folder", contentArea)
pagesFolder.Name = "Pages"

-- [EFEITO DE ABERTURA]
mainFrame.ClipsDescendants = true
mainFrame.Size = UDim2.new(0, 700, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 480)}):Play()

print("Painel V7 Base Carregado. Aguardando Scripts de Opções e ListManager.")
