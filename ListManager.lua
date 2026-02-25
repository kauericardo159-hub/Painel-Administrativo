--[[
    GITHUB: ListManager_V7_Centered.lua
    Versão: 7.1 (Layout Sync)
    Função: Centraliza e gerencia a lista dentro de "Comandos & Funções".
]]

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Localização baseada no seu novo Layout V7
local screenGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = screenGui:WaitForChild("MainFrame")
local contentArea = mainFrame:WaitForChild("ContentArea")
local pagesFolder = contentArea:WaitForChild("Pages")

-- [CONFIGURAÇÃO DE CENTRALIZAÇÃO]
local function SetupCenteredList(page)
    if not page:IsA("Frame") and not page:IsA("ScrollingFrame") then return end
    
    -- Se for o Frame antigo, transformamos em Scrolling para ter rolagem
    if not page:IsA("ScrollingFrame") then
        local oldPage = page
        local newPage = Instance.new("ScrollingFrame")
        newPage.Name = oldPage.Name
        newPage.Visible = oldPage.Visible
        newPage.Parent = pagesFolder
        oldPage:Destroy()
        page = newPage
    end

    -- Ajuste de Posição: Centralizado no Comandos & Funções
    page.Size = UDim2.new(0.92, 0, 0.85, 0) -- Deixa margens nas bordas
    page.Position = UDim2.new(0.04, 0, 0.12, 0) -- Desce um pouco para não cobrir o título "Comandos & Funções"
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- Organizador de Itens (UIListLayout)
    local layout = page:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12) -- Espaço entre um comando e outro
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Auto-ajuste do tamanho da lista
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
end

-- [INICIALIZAÇÃO]
for _, page in ipairs(pagesFolder:GetChildren()) do
    SetupCenteredList(page)
end

-- Mantém as fontes bonitas sincronizadas na lista
local function ApplyListFonts()
    for _, item in ipairs(pagesFolder:GetDescendants()) do
        if item:IsA("TextLabel") or item:IsA("TextButton") then
            item.RichText = true
            -- Aplica JetBrainsMono para comandos na lista (estilo hacker)
            if item.Parent:IsA("ScrollingFrame") or item.Parent.Parent:IsA("ScrollingFrame") then
                item.Font = Enum.Font.JetBrainsMono
            end
        end
    end
end

ApplyListFonts()
print("ListManager V7.1: Lista centralizada em 'Comandos & Funções' pronta.")
