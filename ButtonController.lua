--[[
    GITHUB: ButtonController_V5_Final.lua
    Função: Botão Arrastável com Memória, Estética Premium e Animações de Painel.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [CONFIGURAÇÃO DE SALVAMENTO LOCAL]
local SAVE_FILE_NAME = "AdminPanel_ButtonPos.txt"

local function SavePosition(pos)
    -- No Roblox, usamos writefile apenas em Executors. Se não suportado, ele apenas ignora.
    if writefile then
        local data = {X_Scale = pos.X.Scale, X_Offset = pos.X.Offset, Y_Scale = pos.Y.Scale, Y_Offset = pos.Y.Offset}
        writefile(SAVE_FILE_NAME, HttpService:JSONEncode(data))
    end
end

local function LoadPosition()
    if isfile and isfile(SAVE_FILE_NAME) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(SAVE_FILE_NAME)) end)
        if success then
            return UDim2.new(data.X_Scale, data.X_Offset, data.Y_Scale, data.Y_Offset)
        end
    end
    return UDim2.new(0.05, 0, 0.4, 0) -- Posição padrão
end

-- [LIMPEZA]
if playerGui:FindFirstChild("MainButton_ScreenGui") then playerGui.MainButton_ScreenGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainButton_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- [BOTÃO ESTILIZADO]
local openBtn = Instance.new("TextButton")
openBtn.Name = "ToggleMenu"
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = LoadPosition()
openBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
openBtn.Text = "★" -- Ícone estiloso
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 24
openBtn.AutoButtonColor = false
openBtn.Parent = screenGui

local corner = Instance.new("UICorner", openBtn)
corner.CornerRadius = UDim.new(0, 15)

local stroke = Instance.new("UIStroke", openBtn)
stroke.Color = Color3.fromRGB(60, 60, 65)
stroke.Thickness = 2

-- [LÓGICA DE ARRASTAR OTIMIZADA]
local dragging, dragStart, startPos

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = openBtn.Position
        
        -- Feedback visual ao clicar
        TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        openBtn.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            dragging = false
            SavePosition(openBtn.Position) -- Salva quando soltar
            TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
        end
    end
end)

-- [ANIMAÇÃO DE ABRIR/FECHAR PAINEL]
local isAnimating = false
openBtn.MouseButton1Click:Connect(function()
    if isAnimating then return end
    
    local panelGui = playerGui:FindFirstChild("MainPanel_ScreenGui")
    if panelGui and panelGui:FindFirstChild("MainFrame") then
        local frame = panelGui.MainFrame
        isAnimating = true
        
        if not frame.Visible then
            -- ABRIR
            frame.Visible = true
            frame.Size = UDim2.new(0, 0, 0, 0) -- Começa pequeno
            frame.BackgroundTransparency = 1
            
            local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            TweenService:Create(frame, tweenInfo, {Size = UDim2.new(0, 650, 0, 420), BackgroundTransparency = 0.05}):Play()
            
            task.wait(0.6)
            isAnimating = false
        else
            -- FECHAR
            local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            local anim = TweenService:Create(frame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
            anim:Play()
            
            anim.Completed:Connect(function()
                frame.Visible = false
                isAnimating = false
            end)
        end
    end
end)

-- Efeito de Hover (Mouse em cima)
openBtn.MouseEnter:Connect(function()
    TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 255, 255)}):Play()
end)

openBtn.MouseLeave:Connect(function()
    TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(60, 60, 65)}):Play()
end)
