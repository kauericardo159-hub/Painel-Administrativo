local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ SISTEMA DE NOTIFICAÇÃO ELITE V10 ⚙
===========================================================
]]

local function notify(titleText, messageText, status)
    -- status: true (Ativado/Verde) | false (Desativado/Vermelho)
    
    local coreName = "EliteNotifications"
    local screenGui = playerGui:FindFirstChild(coreName) or Instance.new("ScreenGui", playerGui)
    screenGui.Name = coreName
    screenGui.DisplayOrder = 100 -- Sempre acima de tudo
    
    -- 1. CONFIGURAÇÃO DE CORES
    local accentColor = status and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
    local bgColor = Color3.fromRGB(15, 15, 20)

    -- 2. ESTRUTURA DO TOAST
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(0, 280, 0, 70)
    toast.Position = UDim2.new(1.2, 0, 0.85, 0) -- Começa fora da tela (Direita)
    toast.BackgroundColor3 = bgColor
    toast.BackgroundTransparency = 0.2
    toast.BorderSizePixel = 0
    toast.Parent = screenGui

    local corner = Instance.new("UICorner", toast)
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", toast)
    stroke.Thickness = 2
    stroke.Color = accentColor
    stroke.Transparency = 0.5

    -- Sombra
    local shadow = Instance.new("ImageLabel", toast)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014264792"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.4
    shadow.ZIndex = toast.ZIndex - 1

    -- Título
    local title = Instance.new("TextLabel", toast)
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = titleText:upper()
    title.TextColor3 = accentColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Mensagem
    local msg = Instance.new("TextLabel", toast)
    msg.Size = UDim2.new(1, -20, 0, 20)
    msg.Position = UDim2.new(0, 15, 0, 32)
    msg.BackgroundTransparency = 1
    msg.Text = messageText
    msg.TextColor3 = Color3.fromRGB(200, 200, 200)
    msg.Font = Enum.Font.GothamMedium
    msg.TextSize = 13
    msg.TextXAlignment = Enum.TextXAlignment.Left

    -- Barra de Progresso (Cronômetro visual de 5s)
    local progressBar = Instance.new("Frame", toast)
    progressBar.Size = UDim2.new(1, -20, 0, 3)
    progressBar.Position = UDim2.new(0, 10, 1, -8)
    progressBar.BackgroundColor3 = accentColor
    progressBar.BorderSizePixel = 0
    
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1,0)

    -- 3. SOM
    local sound = Instance.new("Sound", toast)
    sound.SoundId = "rbxassetid://232127604"
    sound.Volume = 0.5
    sound:Play()

    -- 4. ANIMAÇÕES
    -- Entrada (Slide para esquerda)
    toast:TweenPosition(UDim2.new(1, -300, 0.85, 0), "Out", "Quart", 0.6, true)

    -- Animação da Barra (5 segundos)
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(5, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)})
    progressTween:Play()

    -- Saída
    task.delay(5, function()
        toast:TweenPosition(UDim2.new(1.2, 0, 0.85, 0), "In", "Quart", 0.6, true)
        task.wait(0.6)
        toast:Destroy()
    end)
end

-- Exportar para ser usado por outros scripts
_G.NotifyElite = notify

-- EXEMPLO DE USO (Apenas para teste, pode apagar as linhas abaixo depois):
-- _G.NotifyElite("Sistema", "View Player Ativado!", true)
-- task.wait(2)
-- _G.NotifyElite("Sistema", "View Bot Desativado!", false)
