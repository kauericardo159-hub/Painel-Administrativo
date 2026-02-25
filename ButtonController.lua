local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local lighting = game:GetService("Lighting")

-- 1. SISTEMA DE LIMPEZA (Anti-duplicação)
local guiName = "InterfaceMenuEstilizada"
local existing = playerGui:FindFirstChild(guiName)
if existing then existing:Destroy() end

local blurName = "MenuBlurEffect"
local existingBlur = lighting:FindFirstChild(blurName)
if existingBlur then existingBlur:Destroy() end

-- 2. CRIAÇÃO DA INTERFACE E BLUR
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Name = blurName
blur.Size = 0
blur.Parent = lighting

-- 3. BOTÃO ESTILIZADO
local button = Instance.new("TextButton")
button.Name = "ControlBtn"
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0, 30, 0.5, -22)
button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
button.Text = "MENU"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.ClipsDescendants = true
button.Parent = screenGui

-- Arredondamento e Borda do Botão
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = button

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = button

-- 4. CONFIGURAÇÃO DAS ANIMAÇÕES
local isOpen = false
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function toggleMenu()
    -- Localiza o painel criado pelo outro script
    local painel = playerGui:FindFirstChild("MeuPainelAnimado", true) 
    if not painel or not painel:FindFirstChild("Painel") then 
        warn("Painel não encontrado!") 
        return 
    end
    
    local frame = painel.Painel
    isOpen = not isOpen

    if isOpen then
        -- ANIMAÇÃO DE ABRIR (Sobe)
        frame.Visible = true
        frame.Position = UDim2.new(0.5, 0, 1.5, 0) -- Começa fora da tela (baixo)
        
        TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(blur, tweenInfo, {Size = 20}):Play() -- Blur 0.5 equivalente
        button.Text = "FECHAR"
        button.TextColor3 = Color3.fromRGB(255, 80, 80) -- Fica vermelho ao abrir
    else
        -- ANIMAÇÃO DE FECHAR (Desce)
        local closeTween = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, 0, 1.5, 0)})
        closeTween:Play()
        
        TweenService:Create(blur, tweenInfo, {Size = 0}):Play()
        button.Text = "ABRIR"
        button.TextColor3 = Color3.new(1, 1, 1)
        
        closeTween.Completed:Connect(function()
            if not isOpen then frame.Visible = false end
        end)
    end
end

-- 5. EVENTOS
button.MouseButton1Click:Connect(toggleMenu)

-- Efeito visual ao passar o mouse
button.MouseEnter:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
end)

button.MouseLeave:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
end)

print("Botão com animações e Blur carregado!")
