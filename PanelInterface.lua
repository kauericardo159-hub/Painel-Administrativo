--[[
    GITHUB: PanelInterface_V4_Expanded.lua
    Função: Painel Principal Expandido, Borda RGB, Textos Brancos e Perfil.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [LIMPEZA DE DUPLICATAS]
-- Garante que versões antigas sejam removidas antes de carregar a nova para evitar bugs de sobreposição.
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Faz com que a interface ignore a barra superior do Roblox
screenGui.Parent = playerGui

-- [PAINEL PRINCIPAL EXPANDIDO]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
-- Tamanho aumentado para melhor organização dos comandos na lista centralizada
mainFrame.Size = UDim2.new(0, 550, 0, 380) 
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- Cinza quase preto
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true 
mainFrame.Parent = screenGui

-- Bordas Arredondadas (UICorner)
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Contorno RGB (UIStroke)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 3.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- [FOTO DE PERFIL CIRCULAR]
local profilePic = Instance.new("ImageLabel")
profilePic.Name = "UserProfilePic"
profilePic.Size = UDim2.new(0, 65, 0, 65)
profilePic.Position = UDim2.new(0.04, 0, 0.06, 0)
profilePic.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
profilePic.BorderSizePixel = 0
profilePic.Parent = mainFrame

local picCorner = Instance.new("UICorner")
picCorner.CornerRadius = UDim.new(1, 0) -- Torna a imagem um círculo perfeito
picCorner.Parent = profilePic

local profileStroke = Instance.new("UIStroke")
profileStroke.Thickness = 2.5
profileStroke.Color = Color3.fromRGB(255, 255, 255)
profileStroke.Parent = profilePic

-- Carregamento dinâmico da imagem do usuário
local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
if isReady then 
    profilePic.Image = content 
end

-- [NOME DO JOGADOR (Texto Branco)]
local playerName = Instance.new("TextLabel")
playerName.Size = UDim2.new(0, 250, 0, 30)
playerName.Position = UDim2.new(0.18, 0, 0.1, 0)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName
playerName.TextColor3 = Color3.fromRGB(255, 255, 255) -- Atualizado para Branco
playerName.Font = Enum.Font.GothamBold
playerName.TextSize = 18
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Parent = mainFrame

-- [VERSÃO DO PAINEL (Canto Superior Direito)]
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 60, 0, 20)
versionLabel.Position = UDim2.new(0.85, 0, 0.06, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "V0" -- Indicador de Versão
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Atualizado para Branco
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextSize = 16
versionLabel.Parent = mainFrame

-- [LOOP DO EFEITO RGB]
-- Utiliza interpolação de cor baseada em tempo para um efeito neon suave.
task.spawn(function()
    while true do
        local hue = tick() % 6 / 6 -- Ciclo completo a cada 6 segundos
        local rgbColor = Color3.fromHSV(hue, 0.8, 1)
        
        mainStroke.Color = rgbColor
        profileStroke.Color = rgbColor
        
        RunService.RenderStepped:Wait()
    end
end)

print("Painel Principal Expandido V4 carregado com sucesso.")
