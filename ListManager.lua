--[[
    GITHUB: ListManager_V5_Clean.lua
    Função: ScrollingFrame Centralizada para o novo design Clean.
]]

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local panelGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = panelGui:WaitForChild("MainFrame")

if mainFrame:FindFirstChild("CommandList") then mainFrame.CommandList:Destroy() end

local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "CommandList"
-- Posicionamento ajustado para o novo tamanho do painel
listFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
listFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
listFrame.BackgroundTransparency = 0.5
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 2
listFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listFrame.Parent = mainFrame

Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 12)
local listStroke = Instance.new("UIStroke", listFrame)
listStroke.Color = Color3.fromRGB(40, 40, 45)
listStroke.Thickness = 1.5

local layout = Instance.new("UIListLayout", listFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", listFrame).PaddingTop = UDim.new(0, 15)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
end)

print("Lista V5 Clean acoplada ao painel.")
