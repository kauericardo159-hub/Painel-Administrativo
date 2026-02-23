--[[
    GITHUB: PanelInterface_V3_RGB.lua
    Função: Criar a interface base com UIStroke RGB e Perfil.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [LIMPEZA DE DUPLICATAS]
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- [PAINEL PRINCIPAL]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 320) -- Formato horizontal conforme rascunho
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true -- Defina como false se usar o botão de abrir/fechar
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

-- UIStroke com borda branca base (O RGB será aplicado aqui)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- [FOTO DE PERFIL (Canto Superior Esquerdo)]
local profilePic = Instance.new("ImageLabel")
profilePic.Name = "UserProfilePic"
profilePic.Size = UDim2.new(0, 50, 0, 50)
profilePic.Position = UDim2.new(0.03, 0, 0.05, 0)
profilePic.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
profilePic.Parent = mainFrame

Instance.new("UICorner", profilePic).CornerRadius = UDim.new(1, 0)
local profileStroke = Instance.new("UIStroke", profilePic)
profileStroke.Thickness = 2
profileStroke.Color = Color3.fromRGB(255, 255, 255)

-- Carregar Avatar
local userId = player.UserId
local content, isReady = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
if isReady then profilePic.Image = content end

-- [NOME DO JOGADOR]
local playerName = Instance.new("TextLabel")
playerName.Size = UDim2.new(0, 200, 0, 30)
playerName.Position = UDim2.new(0.16, 0, 0.08, 0)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName
playerName.TextColor3 = Color3.fromRGB(255, 50, 50) -- Cor vermelha conforme rascunho
playerName.Font = Enum.Font.GothamBold
playerName.TextSize = 16
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Parent = mainFrame

-- [LOGOTIPO DO PAINEL (Canto Superior Direito)]
local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(0, 50, 0, 20)
logoLabel.Position = UDim2.new(0.88, 0, 0.05, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "V0"
logoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextSize = 14
logoLabel.Parent = mainFrame

-- [LÓGICA DO EFEITO RGB]
task.spawn(function()
    local counter = 0
    while true do
        local hue = tick() % 5 / 5 -- Ciclo de 5 segundos
        local color = Color3.fromHSV(hue, 1, 1)
        
        mainStroke.Color = color
        profileStroke.Color = color
        
        RunService.RenderStepped:Wait()
    end
end)

print("Painel Base V3 (RGB) Carregado!")
