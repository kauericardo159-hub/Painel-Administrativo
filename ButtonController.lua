--[[
    GITHUB: ButtonController_Ultimate_V5.lua
    Função: Botão interativo Premium, Arrastável, Salvamento de Posição e Animação de Abertura.
    Sistema: UX Avançado com Elastic Tweens e Persistência de Dados.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [CONFIGURAÇÕES DE ESTILO]
local CORES = {
    Fundo = Color3.fromRGB(15, 15, 18),
    Borda = Color3.fromRGB(70, 70, 75),
    Ativo = Color3.fromRGB(255, 255, 255),
    Brilho = Color3.fromRGB(255, 255, 255)
}

-- [LIMPEZA DE DUPLICATAS]
if playerGui:FindFirstChild("MainButton_ScreenGui") then
    playerGui.MainButton_ScreenGui:Destroy()
end

-- [CRIAÇÃO DA INTERFACE]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainButton_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100 -- Garante que o botão fique acima de tudo
screenGui.Parent = playerGui

local openBtn = Instance.new("TextButton")
openBtn.Name = "ToggleMenu"
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.BackgroundColor3 = CORES.Fundo
openBtn.BackgroundTransparency = 0.1
openBtn.Text = "" -- Usaremos uma Label separada para melhor controle
openBtn.AutoButtonColor = false
openBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 15)
btnCorner.Parent = openBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = CORES.Borda
btnStroke.Thickness = 2
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnStroke.Parent = openBtn

local btnIcon = Instance.new("TextLabel")
btnIcon.Size = UDim2.new(1, 0, 1, 0)
btnIcon.BackgroundTransparency = 1
btnIcon.Text = "M" -- Ícone estilizado
btnIcon.TextColor3 = CORES.Ativo
btnIcon.Font = Enum.Font.GothamBold
btnIcon.TextSize = 22
btnIcon.Parent = openBtn

-- [EFEITO DE REFLEXO INTERNO]
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
gradient.Rotation = 45
gradient.Parent = btnStroke

--------------------------------------------------------------------
-- [SISTEMA DE SALVAMENTO DE POSIÇÃO]
--------------------------------------------------------------------
--[[ local function SavePosition()
    local pos = {
        X_Scale = openBtn.Position.X.Scale,
        X_Offset = openBtn.Position.X.Offset,
        Y_Scale = openBtn.Position.Y.Scale,
        Y_Offset = openBtn.Position.Y.Offset
    }
    -- No Roblox Client, usamos SetAttribute para persistência rápida na sessão atual
    -- Para salvar entre dias diferentes em servidores diferentes, seria necessário DataStore (Server-side)
    player:SetAttribute("MenuButtonPos", HttpService:JSONEncode(pos))
end

local function LoadPosition()
    local saved = player:GetAttribute("MenuButtonPos")
    if saved then
        local pos = HttpService:JSONDecode(saved)
        openBtn.Position = UDim2.new(pos.X_Scale, pos.X_Offset, pos.Y_Scale, pos.Y_Offset)
    else
        openBtn.Position = UDim2.new(0.05, 0, 0.4, 0) -- Padrão
    end
end

LoadPosition() 

--------------------------------------------------------------------
-- [LÓGICA DE ARRASTAR (SMOOTH DRAGGING)]
--------------------------------------------------------------------
local dragging, dragInput, dragStart, startPos

local function UpdateDrag(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    
    -- Interpolação suave para o movimento de arrastar (Lerp)
    TweenService:Create(openBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = openBtn.Position
        
        -- Efeito visual de clique
        TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50), BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                SavePosition()
                TweenService:Create(openBtn, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 55, 0, 55), BackgroundColor3 = CORES.Fundo}):Play()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        UpdateDrag(dragInput)
    end
end)
]]
--------------------------------------------------------------------
-- [ANIMAÇÃO DE ABRIR/FECHAR O PAINEL]
--------------------------------------------------------------------
local panelAtivo = false

local function TogglePanel()
    local panelGui = playerGui:FindFirstChild("MainPanel_ScreenGui")
    if not panelGui then return end
    
    local mainFrame = panelGui:FindFirstChild("MainFrame")
    if not mainFrame then return end
    
    panelAtivo = not panelAtivo
    
    if panelAtivo then
        -- ANIMAÇÃO DE ABERTURA (EFEITO POP-UP ELASTIC)
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0) -- Começa do zero
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainFrame.BackgroundTransparency = 1
        
        TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 650, 0, 420),
            Position = UDim2.new(0.5, -325, 0.5, -210),
            BackgroundTransparency = 0.05
        }):Play()
        
        -- Rotaciona levemente o ícone do botão
        TweenService:Create(btnIcon, TweenInfo.new(0.4), {Rotation = 90, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    else
        -- ANIMAÇÃO DE FECHAMENTO (SUAVE)
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 500, 0, 300),
            Position = UDim2.new(0.5, -250, 0.55, -150),
            BackgroundTransparency = 1
        })
        
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not panelAtivo then mainFrame.Visible = false end
        end)
        
        TweenService:Create(btnIcon, TweenInfo.new(0.4), {Rotation = 0, TextColor3 = CORES.Ativo}):Play()
    end
end

openBtn.MouseButton1Click:Connect(TogglePanel)

-- [EFEITOS DE HOVER]
openBtn.MouseEnter:Connect(function()
    TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = CORES.Ativo, Thickness = 3}):Play()
end)

openBtn.MouseLeave:Connect(function()
    TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = CORES.Borda, Thickness = 2}):Play()
end)

print("ButtonController V5.2 carregado com Persistência e Tweens Elásticos.")
