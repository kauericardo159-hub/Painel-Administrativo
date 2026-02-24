--[[
    GITHUB: PanelInterface_V5_Tabs.lua
    Função: Painel Expandido com Sidebar, Sistema de Abas e Transições Suaves.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [LIMPEZA]
if playerGui:FindFirstChild("MainPanel_ScreenGui") then
    playerGui.MainPanel_ScreenGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainPanel_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- [PAINEL PRINCIPAL]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 420) 
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Controlado pelo ButtonController
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(60, 60, 65)
mainStroke.Thickness = 2

--------------------------------------------------------------------
-- [SIDEBAR - BARRA LATERAL]
--------------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner", sidebar)
sideCorner.CornerRadius = UDim.new(0, 15)

-- Linha divisória vertical
local div = Instance.new("Frame", sidebar)
div.Size = UDim2.new(0, 1, 1, -40)
div.Position = UDim2.new(1, 0, 0, 20)
div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
div.BackgroundTransparency = 0.9
div.BorderSizePixel = 0

local tabContainer = Instance.new("Frame", sidebar)
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0.7, 0)
tabContainer.Position = UDim2.new(0, 0, 0.25, 0)
tabContainer.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--------------------------------------------------------------------
-- [CONTAINER DE CONTEÚDO (DIREITA)]
--------------------------------------------------------------------
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(0, 470, 0, 320)
contentArea.Position = UDim2.new(0, 170, 0, 85)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Pasta para guardar as páginas das abas
local pages = Instance.new("Folder", contentArea)
pages.Name = "Pages"

--------------------------------------------------------------------
-- [LÓGICA DO SISTEMA DE ABAS]
--------------------------------------------------------------------
local function CreateTab(name, icon, isDefault)
    -- 1. Criar Botão na Sidebar
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(0.85, 0, 0, 35)
    tabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(25, 25, 28)
    tabBtn.BackgroundTransparency = isDefault and 0 or 1
    tabBtn.Text = icon .. "  " .. name
    tabBtn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.Parent = tabContainer
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    -- 2. Criar Página de Conteúdo (ScrollingFrame)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = isDefault
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    page.Parent = pages

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Evento de Clique para trocar de aba
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in ipairs(pages:GetChildren()) do p.Visible = false end
        for _, b in ipairs(tabContainer:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end
        end
        
        page.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    return page
end

-- [CRIANDO AS ABAS]
local homePage = CreateTab("INÍCIO", "🏠", true)
local espPage = CreateTab("VISUAIS", "👁️", false)
local itemPage = CreateTab("ITENS", "📦", false)
local settingsPage = CreateTab("AJUSTES", "⚙️", false)

-- Exemplo: Como adicionar um botão à aba de Visuais
-- Seu script de View Players deve agora usar `espPage` como Parent em vez de `listFrame`.

print("Sistema de Abas V5.5 Carregado.")
