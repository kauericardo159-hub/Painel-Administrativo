--[[
    GITHUB: ButtonController.lua
    Função: Criar botão interativo, arrastável e funcional.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [LIMPEZA DE DUPLICATAS]
if playerGui:FindFirstChild("MainButton_ScreenGui") then
    playerGui.MainButton_ScreenGui:Destroy()
end

-- [CRIAÇÃO DE ELEMENTOS]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainButton_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local openBtn = Instance.new("TextButton")
openBtn.Name = "ToggleMenu"
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
openBtn.Text = "MENU"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = openBtn

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1.5
stroke.Parent = openBtn

-- [LÓGICA DE ARRASTAR (DRAGGABLE)]
local dragging, dragInput, dragStart, startPos

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = openBtn.Position
    end
end)

openBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        openBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- [FUNCIONALIDADE DE ABRIR/FECHAR]
openBtn.MouseButton1Click:Connect(function()
    local panelGui = playerGui:FindFirstChild("MainPanel_ScreenGui")
    if panelGui and panelGui:FindFirstChild("MainFrame") then
        local frame = panelGui.MainFrame
        frame.Visible = not frame.Visible
    end
end)
