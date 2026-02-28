local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- CONFIGURAÇÕES DO BOTÃO
-- ==========================================
-- <--- COLOQUE SEU ID DE IMAGEM AQUI (ex: rbxassetid://12345678)
local BUTTON_ID = "rbxassetid://15188057059" 
local MENU_NAME = "InterfaceMenu_V3"
local SAVE_NAME = "PremiumMenuPos"
local BUTTON_SIZE = 60 -- Tamanho do botão quadrado

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
    mainButton.Position = UDim2.new(0, 25, 0.5, -(BUTTON_SIZE/2)) -- Posição inicial
end

mainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainButton.Image = BUTTON_ID
-- ==========================================
-- CORREÇÃO: Preencher a imagem inteira
-- ==========================================
mainButton.ScaleType = Enum.ScaleType.Stretch 
-- ==========================================
mainButton.AutoButtonColor = false
mainButton.Parent = screenGui

-- Estilização
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12) -- Mais arredondado
corner.Parent = mainButton

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainButton

-- UIGradient Refinado
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
})
gradient.Rotation = 45
gradient.Parent = mainButton

-- ==========================================
-- 3. LÓGICA DE ARRRASTAR (Segurar 3s)
-- ==========================================
local dragging = false
local dragInput
local dragStart
local startPos
local holdTimer = 0
local isDraggingMode = false

mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainButton.Position
        holdTimer = tick()
        
        -- Inicia verificação de segurar
        task.spawn(function()
            while dragging and not isDraggingMode do
                if tick() - holdTimer >= 3 then
                    isDraggingMode = true
                    -- Efeito visual de que está arrastável
                    TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                end
                task.wait()
            end
        end)
    end
end)

mainButton.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDraggingMode then
        local delta = input.Position - dragStart
        mainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainButton.InputEnded:Connect(function(input)
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
    local coreGui = playerGui:FindFirstChild("SistemaPainel_V3")
    local painel = coreGui and coreGui:FindFirstChild("Panel") -- Corrigido para "Panel" conforme sistema funcional
    
    if not painel then return end
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
    TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
end)

mainButton.MouseLeave:Connect(function()
    if isDraggingMode then return end
    TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
end)

print("Botão Premium V3 Carregado!")
