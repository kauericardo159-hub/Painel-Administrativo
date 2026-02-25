--[[
    ====================================================================
    PROJETO: Painel V7.0 - Fundação e Layout
    DESCRIÇÃO: Estrutura visual baseada no blueprint (caixas separadas).
    ESTILO: Dark Mode com Bordas Cinzas (UIStroke) e Fontes Modernas.
    ====================================================================
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- [1] CONFIGURAÇÕES DE PALETA E FONTES
-- ==========================================
local CONFIG = {
    Cores = {
        FundoGeral = Color3.fromRGB(15, 15, 18),       -- Fundo escuro principal
        FundoCaixas = Color3.fromRGB(22, 22, 26),      -- Fundo das áreas internas
        BordaCinza = Color3.fromRGB(80, 80, 85),       -- Substitui a linha vermelha do blueprint
        TextoPrimario = Color3.fromRGB(255, 255, 255),
        TextoSecundario = Color3.fromRGB(170, 170, 175)
    },
    Fontes = {
        Titulo = Enum.Font.Jura,         -- Fonte tecnológica para títulos
        Nome = Enum.Font.MontserratBold, -- Fonte elegante e forte para o nome
        Textos = Enum.Font.GothamMedium  -- Fonte limpa para leitura
    }
}

-- ==========================================
-- [2] LIMPEZA DE INTERFACE ANTERIOR
-- ==========================================
if playerGui:FindFirstChild("PainelV7_ScreenGui") then
    playerGui.PainelV7_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PainelV7_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ==========================================
-- [3] CAIXA PRINCIPAL (O contorno externo vermelho da imagem)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 720, 0, 500)
mainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
mainFrame.BackgroundColor3 = CONFIG.Cores.FundoGeral
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = CONFIG.Cores.BordaCinza
mainStroke.Thickness = 2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ==========================================
-- [4] ÁREA DO CABEÇALHO (Header)
-- ==========================================

-- 4.1. Foto de Perfil (Círculo vermelho na imagem)
local profileFrame = Instance.new("Frame", mainFrame)
profileFrame.Name = "ProfileContainer"
profileFrame.Size = UDim2.new(0, 65, 0, 65)
profileFrame.Position = UDim2.new(0, 25, 0, 25)
profileFrame.BackgroundColor3 = CONFIG.Cores.FundoCaixas
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(1, 0) -- Deixa redondo

local profileStroke = Instance.new("UIStroke", profileFrame)
profileStroke.Color = CONFIG.Cores.BordaCinza
profileStroke.Thickness = 2

local profileImg = Instance.new("ImageLabel", profileFrame)
profileImg.Size = UDim2.new(1, 0, 1, 0)
profileImg.BackgroundTransparency = 1
Instance.new("UICorner", profileImg).CornerRadius = UDim.new(1, 0)

-- Carrega a foto do jogador
task.spawn(function()
    local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    if isReady then profileImg.Image = content end
end)

-- 4.2. Caixa do Nome do Jogador (Retângulo vermelho ao lado da foto na imagem)
local nameBox = Instance.new("Frame", mainFrame)
nameBox.Name = "NameBox"
nameBox.Size = UDim2.new(0, 160, 0, 35)
nameBox.Position = UDim2.new(0, 105, 0, 25)
nameBox.BackgroundColor3 = CONFIG.Cores.FundoCaixas
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)

local nameStroke = Instance.new("UIStroke", nameBox)
nameStroke.Color = CONFIG.Cores.BordaCinza
nameStroke.Thickness = 1.5

local nameLabel = Instance.new("TextLabel", nameBox)
nameLabel.Size = UDim2.new(1, -10, 1, 0)
nameLabel.Position = UDim2.new(0, 5, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = player.DisplayName
nameLabel.TextColor3 = CONFIG.Cores.TextoPrimario
nameLabel.Font = CONFIG.Fontes.Nome
nameLabel.TextSize = 16
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 4.3. Texto da Versão (Abaixo do nome)
local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(0, 100, 0, 20)
versionLabel.Position = UDim2.new(0, 105, 0, 65)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "V7.0"
versionLabel.TextColor3 = CONFIG.Cores.TextoSecundario
versionLabel.Font = CONFIG.Fontes.Textos
versionLabel.TextSize = 13
versionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 4.4. Caixa de Título (Retângulo vermelho grande no topo direito na imagem)
local titleBox = Instance.new("Frame", mainFrame)
titleBox.Name = "TitleBox"
titleBox.Size = UDim2.new(0, 410, 0, 50)
titleBox.Position = UDim2.new(0, 285, 0, 25)
titleBox.BackgroundColor3 = CONFIG.Cores.FundoCaixas
Instance.new("UICorner", titleBox).CornerRadius = UDim.new(0, 8)

local titleStroke = Instance.new("UIStroke", titleBox)
titleStroke.Color = CONFIG.Cores.BordaCinza
titleStroke.Thickness = 2

local titleLabel = Instance.new("TextLabel", titleBox)
titleLabel.Name = "TitleText"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU PRINCIPAL"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = CONFIG.Fontes.Titulo
titleLabel.TextSize = 22

-- ==========================================
-- [5] ÁREA DE OPÇÕES / SIDEBAR (Retângulo vermelho vertical esquerdo)
-- ==========================================
local optionsBox = Instance.new("Frame", mainFrame)
optionsBox.Name = "OptionsBox"
optionsBox.Size = UDim2.new(0, 240, 0, 365)
optionsBox.Position = UDim2.new(0, 25, 0, 110)
optionsBox.BackgroundColor3 = CONFIG.Cores.FundoCaixas
Instance.new("UICorner", optionsBox).CornerRadius = UDim.new(0, 8)

local optionsStroke = Instance.new("UIStroke", optionsBox)
optionsStroke.Color = CONFIG.Cores.BordaCinza
optionsStroke.Thickness = 2

local optionsTitle = Instance.new("TextLabel", optionsBox)
optionsTitle.Size = UDim2.new(1, 0, 0, 40)
optionsTitle.BackgroundTransparency = 1
optionsTitle.Text = "Opções"
optionsTitle.TextColor3 = CONFIG.Cores.TextoPrimario
optionsTitle.Font = CONFIG.Fontes.Titulo
optionsTitle.TextSize = 18

-- Container Vazio onde o Script de Lista de Opções vai trabalhar
local optionsContainer = Instance.new("Frame", optionsBox)
optionsContainer.Name = "OptionsContainer"
optionsContainer.Size = UDim2.new(1, -20, 1, -50)
optionsContainer.Position = UDim2.new(0, 10, 0, 40)
optionsContainer.BackgroundTransparency = 1

-- ==========================================
-- [6] ÁREA DE COMANDOS (Retângulo vermelho vertical direito)
-- ==========================================
local contentBox = Instance.new("Frame", mainFrame)
contentBox.Name = "ContentBox"
contentBox.Size = UDim2.new(0, 410, 0, 365)
contentBox.Position = UDim2.new(0, 285, 0, 110)
contentBox.BackgroundColor3 = CONFIG.Cores.FundoCaixas
Instance.new("UICorner", contentBox).CornerRadius = UDim.new(0, 8)

local contentStroke = Instance.new("UIStroke", contentBox)
contentStroke.Color = CONFIG.Cores.BordaCinza
contentStroke.Thickness = 2

local contentTitle = Instance.new("TextLabel", contentBox)
contentTitle.Name = "ContentTitle"
contentTitle.Size = UDim2.new(1, 0, 0, 40)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Comandos & Funções"
contentTitle.TextColor3 = CONFIG.Cores.TextoPrimario
contentTitle.Font = CONFIG.Fontes.Titulo
contentTitle.TextSize = 18

-- Container Vazio onde o Script de Comandos vai trabalhar
local pagesFolder = Instance.new("Folder", contentBox)
pagesFolder.Name = "PagesFolder"

print("[Painel V7] Fundação e Layout carregados com sucesso!")
