local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- CONFIGURAÇÕES DO BOTÃO
-- ==========================================
-- COLOQUE SEU ID DE IMAGEM AQUI (ex: rbxassetid://12345678)
local BUTTON_ID = "rbxassetid://00000000000" 
local MENU_NAME = "InterfaceMenu_V3" -- Nome do ScreenGui
local PAINEL_NAME = "SistemaPainel_V3" -- Nome do painel principal
local SAVE_NAME = "PremiumMenuPos"
local BUTTON_SIZE = 60 -- Quadrado

-- 1. LIMPEZA E CONFIGURAÇÃO DE EFEITOS
local oldMenu = playerGui:FindFirstChild(MENU_NAME)
if oldMenu then oldMenu:Destroy() end

local blurEffect = Lighting:FindFirstChild("MenuBlur")
if not blurEffect then
    blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "MenuBlur"
    blurEffect.Size = 0
    blurEffect.Parent = Lighting
end

-- ==========================================
-- 2. CRIAÇÃO DA INTERFACE (Quadrada e Estilosa)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = MENU_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainButton = Instance.new("ImageButton")
mainButton.Name = "ToggleButton"
mainButton.Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)

-- Tenta carregar a posição salva
local savedPos = nil
if pcall(function() savedPos = game:GetService("HttpService"):JSONDecode(readfile(SAVE_NAME..".json")) end) and savedPos then
    mainButton.Position = UDim2.new(savedPos.X.Scale, savedPos.X.Offset, savedPos.Y.Scale, savedPos.Y.Offset)
else
    mainButton.Position = UDim2.new(0, 25, 0.5, -(BUTTON_SIZE/2)) -- Posição inicial padrão
end

mainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainButton.Image = BUTTON_ID
-- ==========================================
-- CORREÇÃO: Preencher imagem inteira
-- ==========================================
mainButton.ScaleType = Enum.ScaleType.Stretch 
mainButton.ImageColor3 = Color3.new(1, 1, 1) -- Garante que a imagem não fique escura
mainButton.BackgroundTransparency = 0 -- Mostra o fundo se a imagem for transparente
-- ==========================================

mainButton.AutoButtonColor = false
mainButton.Parent = screenGui

-- Estilização
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12) -- Arredondamento suave
corner.Parent = mainButton

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainButton

-- UIGradient Refinado (sutil para não cobrir a imagem totalmente)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
})
gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.5), -- Mais transparente no centro
    NumberSequenceKeypoint.new(1, 0.5)
})
gradient.Rotation = 45
gradient.Parent = mainButton

-- ==========================================
-- 3. LÓGICA DE ARRRASTAR (Segurar 3s)
-- ==========================================
local dragging = false
local dragStart
local startPos
local isDraggingMode = false

mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainButton.Position
        
        -- Inicia verificação de segurar
        task.spawn(function()
            local holdStart = tick()
            while dragging and not isDraggingMode do
                if tick() - holdStart >= 3 then
                    isDraggingMode = true
                    -- Efeito visual de que está arrastável
                    TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                end
                task.wait()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and isDraggingMode and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        
        if isDraggingMode then
            isDraggingMode = false
            -- Salva a posição após arrastar
            local pos = mainButton.Position
            pcall(function() writefile(SAVE_NAME..".json", game:GetService("HttpService"):JSONEncode(pos)) end)
            TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
        end
    end
end)

-- ==========================================
-- 4. LÓGICA DE ABRIR/FECHAR E CLIQUE
-- ==========================================
local isOpen = false
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function toggleUI()
    -- Procura pelo Painel principal
    local coreGui = playerGui:FindFirstChild(PAINEL_NAME)
    local painel = coreGui and coreGui:FindFirstChild("Panel")
    
    if not painel then 
        warn("Erro: Painel principal '"..PAINEL_NAME.."' não encontrado.")
        return 
    end
    
    if isDraggingMode then return end -- Não abre se estiver arrastando

    isOpen = not isOpen

    if isOpen then
        painel.Visible = true
        painel.Position = UDim2.new(0.5, 0, 1.5, 0)
        TweenService:Create(painel, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(blurEffect, tweenInfo, {Size = 20}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = Color3.fromRGB(255, 50, 50)}):Play()
    else
        local closeTween = TweenService:Create(painel, tweenInfo, {Position = UDim2.new(0.5, 0, 1.5, 0)})
        closeTween:Play()
        TweenService:Create(blurEffect, tweenInfo, {Size = 0}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = Color3.fromRGB(200, 200, 200)}):Play()
        
        closeTween.Completed:Connect(function()
            if not isOpen then painel.Visible = false end
        end)
    end
end

-- Animação de clique
mainButton.MouseButton1Down:Connect(function()
    if isDraggingMode then return end
    TweenService:Create(mainButton, TweenInfo.new(0.1), {Size = UDim2.new(0, BUTTON_SIZE-10, 0, BUTTON_SIZE-10)}):Play()
end)

mainButton.MouseButton1Up:Connect(function()
    if isDraggingMode then return end
    TweenService:Create(mainButton, TweenInfo.new(0.2), {Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)}):Play()
    toggleUI()
end)

-- Hover efeitos
mainButton.MouseEnter:Connect(function()
    if isDraggingMode then return end
    TweenService:Create(mainButton, TweenInfo.new(0.2), {ImageTransparency = 0.3}):Play()
end)

mainButton.MouseLeave:Connect(function()
    if isDraggingMode then return end
    TweenService:Create(mainButton, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
end)

print("Botão Premium V3 Atualizado e Estiloso!")
