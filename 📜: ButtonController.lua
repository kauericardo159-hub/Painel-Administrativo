local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ CONTROLADOR DO BOTÃO PREMIUM V4 ⚙
===========================================================
]]

local BUTTON_ID_CLOSED = "rbxassetid://16007391180" 
local MENU_NAME = "InterfaceMenu_V4"
local PAINEL_CORE_NAME = "SistemaPainel_V3" -- Nome que usamos no script do Painel
local BUTTON_SIZE = 60

-- 1. CONFIGURAÇÃO DE EFEITOS
local blurEffect = Lighting:FindFirstChild("MenuBlur")
if not blurEffect then
    blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "MenuBlur"
    blurEffect.Size = 0
    blurEffect.Parent = Lighting
end

-- Limpeza
local oldMenu = playerGui:FindFirstChild(MENU_NAME)
if oldMenu then oldMenu:Destroy() end

-- 2. CRIAÇÃO DA INTERFACE DO BOTÃO
local screenGui = Instance.new("ScreenGui")
screenGui.Name = MENU_NAME
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainButton = Instance.new("ImageButton") 
mainButton.Name = "ToggleButton"
mainButton.Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)
mainButton.Position = UDim2.new(0, 25, 0.5, -(BUTTON_SIZE/2))
mainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainButton.BackgroundTransparency = 0.2
mainButton.Image = BUTTON_ID_CLOSED
mainButton.ScaleType = Enum.ScaleType.Crop
mainButton.AutoButtonColor = false
mainButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainButton

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainButton

-- 3. LÓGICA DE ABRIR/FECHAR (Sincronizada com o Painel)
local isOpen = false
local isAnimating = false -- Evita bugs de spam de clique

local function toggleUI()
    local coreGui = playerGui:FindFirstChild(PAINEL_CORE_NAME)
    local painel = coreGui and coreGui:FindFirstChild("Panel")
    
    if not painel or isAnimating then return end
    
    isAnimating = true
    isOpen = not isOpen

    -- Configurações de animação (EasingStyle.Quart para combinar com o painel)
    local tInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tInfoBlur = TweenInfo.new(0.6, Enum.EasingStyle.Linear)

    if isOpen then
        -- ABRIR
        painel.Visible = true
        painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Garante que começa embaixo
        
        local openTween = TweenService:Create(painel, tInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
        local blurTween = TweenService:Create(blurEffect, tInfoBlur, {Size = 15})
        local strokeTween = TweenService:Create(stroke, tInfo, {Color = Color3.fromRGB(0, 255, 200)}) -- Feedback visual no botão
        
        openTween:Play()
        blurTween:Play()
        strokeTween:Play()
        
        openTween.Completed:Wait()
    else
        -- FECHAR
        local closeTween = TweenService:Create(painel, tInfo, {Position = UDim2.new(0.5, 0, 1.6, 0)})
        local blurTween = TweenService:Create(blurEffect, tInfoBlur, {Size = 0})
        local strokeTween = TweenService:Create(stroke, tInfo, {Color = Color3.fromRGB(255, 255, 255)})
        
        closeTween:Play()
        blurTween:Play()
        strokeTween:Play()
        
        closeTween.Completed:Wait()
        if not isOpen then 
            painel.Visible = false 
        end
    end
    
    isAnimating = false
end

-- 4. INTERAÇÕES DO BOTÃO
mainButton.MouseButton1Click:Connect(toggleUI)

-- Efeito de "Apertar"
mainButton.MouseButton1Down:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.1), {Size = UDim2.new(0, BUTTON_SIZE-8, 0, BUTTON_SIZE-8)}):Play()
end)

mainButton.MouseButton1Up:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)}):Play()
end)

-- Hover (Brilho suave ao passar o mouse)
mainButton.MouseEnter:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

mainButton.MouseLeave:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
end)

print("✅ Controlador do Botão V4 Sincronizado!")
