local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. LIMPEZA E CONFIGURAÇÃO DE EFEITOS
local menuName = "InterfaceMenu_V3"
local oldMenu = playerGui:FindFirstChild(menuName)
if oldMenu then oldMenu:Destroy() end

-- Criar ou Resetar o Blur no Lighting
local blurEffect = Lighting:FindFirstChild("MenuBlur")
if not blurEffect then
    blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "MenuBlur"
    blurEffect.Size = 0
    blurEffect.Parent = Lighting
end

-- 2. CRIAÇÃO DA INTERFACE DO BOTÃO
local screenGui = Instance.new("ScreenGui")
screenGui.Name = menuName
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainButton = Instance.new("TextButton")
mainButton.Name = "ToggleButton"
mainButton.Size = UDim2.new(0, 140, 0, 45)
mainButton.Position = UDim2.new(0, 25, 0.5, -22) -- Lateral esquerda
mainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainButton.BackgroundTransparency = 0.1
mainButton.Text = "ABRIR"
mainButton.TextColor3 = Color3.new(1, 1, 1)
mainButton.Font = Enum.Font.GothamBold
mainButton.TextSize = 14
mainButton.AutoButtonColor = false -- Desativado para usarmos animação customizada
mainButton.Parent = screenGui

-- Estilização do Botão
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainButton

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainButton

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 150))
gradient.Rotation = 90
gradient.Parent = mainButton

-- 3. LÓGICA DE ANIMAÇÃO E CONTROLO
local isOpen = false
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function toggleUI()
    -- Localiza o Painel Premium (usando o nome do script anterior)
    local coreGui = playerGui:FindFirstChild("SistemaPainel_V3")
    local painel = coreGui and coreGui:FindFirstChild("Painel")
    
    if not painel then
        warn("Erro: O Painel Premium não foi encontrado no PlayerGui.")
        return
    end

    isOpen = not isOpen

    if isOpen then
        -- AÇÃO: ABRIR (Painel Sobe)
        painel.Visible = true
        mainButton.Text = "FECHAR"
        
        -- Animar Painel (Sobe do fundo para o centro)
        painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Garante que começa em baixo
        TweenService:Create(painel, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        
        -- Animar Blur e Botão
        TweenService:Create(blurEffect, tweenInfo, {Size = 24}):Play()
        TweenService:Create(mainButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 10, 10)}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = Color3.fromRGB(255, 50, 50)}):Play()
    else
        -- AÇÃO: FECHAR (Painel Desce)
        mainButton.Text = "ABRIR"
        
        local closeTween = TweenService:Create(painel, tweenInfo, {Position = UDim2.new(0.5, 0, 1.5, 0)})
        closeTween:Play()
        
        -- Resetar Blur e Botão
        TweenService:Create(blurEffect, tweenInfo, {Size = 0}):Play()
        TweenService:Create(mainButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = Color3.fromRGB(200, 200, 200)}):Play()
        
        closeTween.Completed:Connect(function()
            if not isOpen then painel.Visible = false end
        end)
    end
end

-- 4. EFEITOS DE HOVER (Passar o Mouse)
mainButton.MouseEnter:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.3, TextSize = 16}):Play()
end)

mainButton.MouseLeave:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.1, TextSize = 14}):Play()
end)

mainButton.MouseButton1Down:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 130, 0, 40)}):Play()
end)

mainButton.MouseButton1Up:Connect(function()
    TweenService:Create(mainButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 140, 0, 45)}):Play()
    toggleUI()
end)

print("Botão Premium com Sistema de Animação Sobe/Desce Carregado!")
