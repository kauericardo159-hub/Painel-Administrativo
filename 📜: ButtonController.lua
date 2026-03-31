local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ 
===========================================================
       ⚙ CONTROLADOR DO BOTÃO PREMIUM V5 (DRAGGABLE) ⚙
===========================================================
]]

local BUTTON_ID_CLOSED = "rbxassetid://16007391180" 
local MENU_NAME = "InterfaceMenu_V5"
local PAINEL_CORE_NAME = "SistemaPainel_V3"
local BUTTON_SIZE = 60
local HOLD_TIME = 2 -- Tempo em segundos para liberar o arraste

-- 1. CONFIGURAÇÃO DE EFEITOS
local blurEffect = Lighting:FindFirstChild("MenuBlur") or Instance.new("BlurEffect", Lighting)
blurEffect.Name = "MenuBlur"
blurEffect.Size = 0

-- Limpeza de versões antigas
local oldMenu = playerGui:FindFirstChild(MENU_NAME)
if oldMenu then oldMenu:Destroy() end

-- 2. CRIAÇÃO DA INTERFACE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = MENU_NAME
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainButton = Instance.new("ImageButton") 
mainButton.Name = "ToggleButton"
mainButton.Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)
-- POSIÇÃO: Ajustada para 0.4 (mais para cima)
mainButton.Position = UDim2.new(0, 25, 0.4, -(BUTTON_SIZE/2))
mainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainButton.BackgroundTransparency = 0.2
mainButton.Image = BUTTON_ID_CLOSED
mainButton.ScaleType = Enum.ScaleType.Crop
mainButton.AutoButtonColor = false
mainButton.Parent = screenGui

Instance.new("UICorner", mainButton).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", mainButton)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 3. VARIÁVEIS DE CONTROLE
local isOpen = false
local isAnimating = false
local dragging = false
local canDrag = false
local dragInput, dragStart, startPos
local holdTimer = 0

-- 4. FUNÇÃO TOGGLE (ABRIR/FECHAR)
local function toggleUI()
    if dragging or canDrag then return end -- Não abre se estiver arrastando
    local coreGui = playerGui:FindFirstChild(PAINEL_CORE_NAME)
    local painel = coreGui and coreGui:FindFirstChild("Panel")
    if not painel or isAnimating then return end
    
    isAnimating = true
    isOpen = not isOpen
    local tInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    if isOpen then
        painel.Visible = true
        TweenService:Create(painel, tInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(blurEffect, TweenInfo.new(0.6), {Size = 15}):Play()
        TweenService:Create(stroke, tInfo, {Color = Color3.fromRGB(0, 255, 200)}):Play()
    else
        local closeTween = TweenService:Create(painel, tInfo, {Position = UDim2.new(0.5, 0, 1.6, 0)})
        closeTween:Play()
        TweenService:Create(blurEffect, TweenInfo.new(0.6), {Size = 0}):Play()
        TweenService:Create(stroke, tInfo, {Color = Color3.fromRGB(255, 255, 255)}):Play()
        closeTween.Completed:Connect(function() if not isOpen then painel.Visible = false end end)
    end
    task.wait(0.8)
    isAnimating = false
end

-- 5. LÓGICA DE ARRASTAR (DRAG)
local function updateDrag(input)
    local delta = input.Position - dragStart
    mainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local currentHold = true
        holdTimer = tick()
        
        -- Efeito visual de clique
        TweenService:Create(mainButton, TweenInfo.new(0.1), {Size = UDim2.new(0, BUTTON_SIZE-8, 0, BUTTON_SIZE-8)}):Play()

        -- Checar se segurou por 2 segundos
        task.delay(HOLD_TIME, function()
            if (tick() - holdTimer) >= HOLD_TIME and currentHold then
                canDrag = true
                stroke.Color = Color3.fromRGB(255, 200, 0) -- Muda cor para avisar que pode arrastar
                print("Modo arraste ativado")
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                currentHold = false
                if not canDrag then
                    toggleUI() -- Se soltou antes dos 2s, ele clica
                end
                canDrag = false
                dragging = false
                stroke.Color = isOpen and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(255, 255, 255)
                TweenService:Create(mainButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)}):Play()
            end
        end)
        
        dragStart = input.Position
        startPos = mainButton.Position
    end
end)

mainButton.InputChanged:Connect(function(input)
    if canDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Hover Effects
mainButton.MouseEnter:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

mainButton.MouseLeave:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
end)

print("✅ Botão V5: Segure 2s para mover | Posição Ajustada")
