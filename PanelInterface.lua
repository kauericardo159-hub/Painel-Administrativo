--[[
    GITHUB: PanelInterface_V7_Layout.lua
    Versão: 7.0 (Dashboard Premium)
    Função: Novo layout estrutural baseado no blueprint. 
    Contém Sidebar (Opções) e Content Area (Comandos & Funções) com bordas cinzas.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [CONFIGURAÇÕES DE ESTILO V7]
local CORES = {
    Fundo = Color3.fromRGB(12, 12, 14),
    FundoSecundario = Color3.fromRGB(18, 18, 20),
    Borda = Color3.fromRGB(60, 60, 65), -- Linhas cinzas solicitadas
    TextoPrincipal = Color3.fromRGB(255, 255, 255),
    TextoSecundario = Color3.fromRGB(150, 150, 155),
    Destaque = Color3.fromRGB(200, 200, 205)
}

-- [SISTEMA DE EFEITOS (BLOOM)]
local oldBloom = Lighting:FindFirstChild("PanelBloomEffect")
if oldBloom then oldBloom:Destroy() end

local bloom = Instance.new("BloomEffect")
bloom.Name = "PanelBloomEffect"
bloom.Intensity = 0.4
bloom.Size = 12
bloom.Threshold = 0.8
bloom.Parent = Lighting

-- [LIMPEZA DA INTERFACE ANTERIOR]
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ==========================================
-- 1. MAINFRAME (Fundo Geral)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 480) -- Aumentado para acomodar o novo design
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
mainFrame.BackgroundColor3 = CORES.Fundo
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = CORES.Borda
mainStroke.Thickness = 2

-- [EFEITO DE REFLEXO ANIMADO NO FUNDO]
local shineGradient = Instance.new("UIGradient")
shineGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CORES.Fundo),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 35, 40)),
    ColorSequenceKeypoint.new(1, CORES.Fundo)
})
shineGradient.Rotation = 45
shineGradient.Offset = Vector2.new(-1, 0)
shineGradient.Parent = mainFrame

task.spawn(function()
    local tInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    TweenService:Create(shineGradient, tInfo, {Offset = Vector2.new(1, 0)}):Play()
end)

-- ==========================================
-- 2. CABEÇALHO (Header)
-- ==========================================
-- Foto de Perfil
local profilePic = Instance.new("ImageLabel", mainFrame)
profilePic.Size = UDim2.new(0, 55, 0, 55)
profilePic.Position = UDim2.new(0, 20, 0, 20)
profilePic.BackgroundColor3 = CORES.FundoSecundario
Instance.new("UICorner", profilePic).CornerRadius = UDim.new(1, 0)
local profStroke = Instance.new("UIStroke", profilePic)
profStroke.Color = CORES.Borda
profStroke.Thickness = 2

local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
if isReady then profilePic.Image = content end

-- Nome do Jogador
local playerName = Instance.new("TextLabel", mainFrame)
playerName.Size = UDim2.new(0, 200, 0, 25)
playerName.Position = UDim2.new(0, 85, 0, 25)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName
playerName.TextColor3 = CORES.TextoPrincipal
playerName.Font = Enum.Font.GothamBold
playerName.TextSize = 18
playerName.TextXAlignment = Enum.TextXAlignment.Left

-- Versão
local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(0, 100, 0, 15)
versionLabel.Position = UDim2.new(0, 85, 0, 50)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "V7.0"
versionLabel.TextColor3 = CORES.TextoSecundario
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.TextSize = 12
versionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Barra de Título (Title)
local titleFrame = Instance.new("Frame", mainFrame)
titleFrame.Size = UDim2.new(0, 350, 0, 45)
titleFrame.Position = UDim2.new(0.45, 0, 0, 25)
titleFrame.BackgroundColor3 = CORES.FundoSecundario
Instance.new("UICorner", titleFrame).CornerRadius = UDim.new(0, 8)
local titleStroke = Instance.new("UIStroke", titleFrame)
titleStroke.Color = CORES.Borda
titleStroke.Thickness = 2

local titleText = Instance.new("TextLabel", titleFrame)
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "MENU PRINCIPAL"
titleText.TextColor3 = CORES.TextoPrincipal
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16

-- ==========================================
-- 3. SIDEBAR (Opções)
-- ==========================================
local sidebarFrame = Instance.new("Frame", mainFrame)
sidebarFrame.Name = "Sidebar"
sidebarFrame.Size = UDim2.new(0, 200, 0, 360)
sidebarFrame.Position = UDim2.new(0, 20, 0, 100)
sidebarFrame.BackgroundColor3 = CORES.FundoSecundario
sidebarFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", sidebarFrame).CornerRadius = UDim.new(0, 8)
local sideStroke = Instance.new("UIStroke", sidebarFrame)
sideStroke.Color = CORES.Borda
sideStroke.Thickness = 2

local sideTitle = Instance.new("TextLabel", sidebarFrame)
sideTitle.Size = UDim2.new(1, 0, 0, 30)
sideTitle.Position = UDim2.new(0, 0, 0, 5)
sideTitle.BackgroundTransparency = 1
sideTitle.Text = "Opções"
sideTitle.TextColor3 = CORES.TextoPrincipal
sideTitle.Font = Enum.Font.GothamBold
sideTitle.TextSize = 14

local tabContainer = Instance.new("Frame", sidebarFrame)
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 1, -40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ==========================================
-- 4. ÁREA DE CONTEÚDO (Comandos & Funções)
-- ==========================================
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Name = "ContentArea"
contentFrame.Size = UDim2.new(0, 435, 0, 360)
contentFrame.Position = UDim2.new(0, 240, 0, 100)
contentFrame.BackgroundColor3 = CORES.FundoSecundario
contentFrame.BackgroundTransparency = 0.5
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)
local contentStroke = Instance.new("UIStroke", contentFrame)
contentStroke.Color = CORES.Borda
contentStroke.Thickness = 2

local contentTitle = Instance.new("TextLabel", contentFrame)
contentTitle.Name = "ContentTitle"
contentTitle.Size = UDim2.new(1, 0, 0, 30)
contentTitle.Position = UDim2.new(0, 0, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Comandos & Funções"
contentTitle.TextColor3 = CORES.TextoPrincipal
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextSize = 14

local pagesFolder = Instance.new("Folder", contentFrame)
pagesFolder.Name = "Pages"

-- ==========================================
-- 5. LÓGICA DO SISTEMA DE ABAS
-- ==========================================
local function CreateTab(name, icon, isDefault)
    -- Botão da Aba
    local tabBtn = Instance.new("TextButton", tabContainer)
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    tabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(40, 40, 45) or CORES.Fundo
    tabBtn.BackgroundTransparency = isDefault and 0 or 1
    tabBtn.Text = icon .. "  " .. name
    tabBtn.TextColor3 = isDefault and CORES.TextoPrincipal or CORES.TextoSecundario
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", tabBtn)
    btnStroke.Color = CORES.Borda
    btnStroke.Transparency = isDefault and 0 or 1
    btnStroke.Thickness = 1

    -- Página de Conteúdo
    local page = Instance.new("ScrollingFrame", pagesFolder)
    page.Name = name .. "Page"
    -- A página começa abaixo do título "Comandos & Funções"
    page.Size = UDim2.new(1, -10, 1, -45) 
    page.Position = UDim2.new(0, 5, 0, 40)
    page.BackgroundTransparency = 1
    page.Visible = isDefault
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = CORES.TextoSecundario

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    -- Animação de Troca de Aba
    tabBtn.MouseButton1Click:Connect(function()
        -- Muda o título superior dinamicamente
        titleText.Text = string.upper(name)
        
        for _, p in ipairs(pagesFolder:GetChildren()) do p.Visible = false end
        for _, b in ipairs(tabContainer:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = CORES.TextoSecundario}):Play()
                b.UIStroke.Transparency = 1
            end
        end
        
        page.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = CORES.TextoPrincipal}):Play()
        tabBtn.UIStroke.Transparency = 0
    end)

    return page
end

-- [CRIANDO AS ABAS CONFORME SOLICITADO]
local tabComandos = CreateTab("Comandos", "⚡", true)
local tabVisuais = CreateTab("Visuais", "👁️", false)
local tabConfigs = CreateTab("Configurações", "⚙️", false)

-- Define o título inicial
titleText.Text = "COMANDOS"

print("Painel V7.0 Carregado com Sucesso!")
