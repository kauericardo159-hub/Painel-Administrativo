--[[
    GITHUB: Command_ViewEntities.lua
    Função: Visualizar Players (Cor do Time) e Bots (Vermelho) com ESP e Otimização.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [CONFIGURAÇÕES]
local DISTANCIA_MAXIMA = 500 -- Distância para evitar lag
local ESTADO_ATIVO = false
local NOME_COMANDO = "View Bots & Players"

-- [LOCALIZAÇÃO DA LISTA NO PAINEL]
local panelGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = panelGui:WaitForChild("MainFrame")
local listFrame = mainFrame:WaitForChild("CommandList")

-- [LIMPEZA DE DUPLICATAS DO BOTÃO]
if listFrame:FindFirstChild(NOME_COMANDO) then
    listFrame[NOME_COMANDO]:Destroy()
end

-- [CRIAÇÃO DO BOTÃO NA LISTA]
local cmdBtn = Instance.new("TextButton")
cmdBtn.Name = NOME_COMANDO
cmdBtn.Size = UDim2.new(0.95, 0, 0, 40)
cmdBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
cmdBtn.Text = NOME_COMANDO .. " [ Inativo ]"
cmdBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
cmdBtn.Font = Enum.Font.GothamMedium
cmdBtn.TextSize = 14
cmdBtn.Parent = listFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = cmdBtn

-- [SISTEMA DE NOTIFICAÇÃO]
local function Notify(msg, color)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 200, 0, 30)
    notif.Position = UDim2.new(1, -210, 0.9, 0)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notif.Text = msg
    notif.TextColor3 = color
    notif.Font = Enum.Font.GothamBold
    notif.Parent = screenGui or playerGui:FindFirstChild("MainButton_ScreenGui")
    
    Instance.new("UICorner", notif)
    task.wait(2)
    TweenService:Create(notif, TweenInfo.new(1), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    game:GetService("Debris"):AddItem(notif, 1.1)
end

-- [LÓGICA DO ESP]
local espFolder = Instance.new("Folder", workspace)
espFolder.Name = "ESP_Storage"

local function UpdateESP()
    espFolder:ClearAllChildren()
    if not ESTADO_ATIVO then return end

    for _, target in ipairs(workspace:GetDescendants()) do
        local humanoid = target:FindFirstChildOfClass("Humanoid")
        local root = target:FindFirstChild("HumanoidRootPart")
        
        if humanoid and root and target ~= player.Character then
            local dist = (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) 
                and (root.Position - player.Character.HumanoidRootPart.Position).Magnitude or 0
            
            if dist < DISTANCIA_MAXIMA then
                -- Diferenciar Bot de Player
                local isPlayer = Players:GetPlayerFromCharacter(target)
                local color = Color3.fromRGB(255, 0, 0) -- Padrão Bot (Vermelho)

                if isPlayer then
                    color = isPlayer.TeamColor.Color
                end

                -- Criar Outline (Highlight)
                local highlight = Instance.new("Highlight")
                highlight.FillTransparency = 1
                highlight.OutlineColor = color
                highlight.Adornee = target
                highlight.Parent = espFolder

                -- Criar Billboard (Nick e Pos)
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.Adornee = target:FindFirstChild("Head")
                billboard.AlwaysOnTop = true
                billboard.ExtentsOffset = Vector3.new(0, 3, 0)
                billboard.Parent = espFolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = string.format("%s\n[%.0f, %.0f, %.0f]", target.Name, root.Position.X, root.Position.Y, root.Position.Z)
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.GothamBold
                label.TextSize = 12
                label.Parent = billboard
            end
        end
    end
end

-- Loop de atualização (Otimizado)
task.spawn(function()
    while task.wait(0.5) do
        if ESTADO_ATIVO then
            UpdateESP()
        end
    end
end)

-- [EVENTO DE CLIQUE]
cmdBtn.MouseButton1Click:Connect(function()
    ESTADO_ATIVO = not ESTADO_ATIVO
    
    if ESTADO_ATIVO then
        cmdBtn.Text = NOME_COMANDO .. " [ Ativo ]"
        cmdBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        Notify("Comando Ativado!", Color3.fromRGB(0, 255, 0))
    else
        cmdBtn.Text = NOME_COMANDO .. " [ Inativo ]"
        cmdBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        espFolder:ClearAllChildren()
        Notify("Comando Desativado!", Color3.fromRGB(255, 0, 0))
    end
end)
