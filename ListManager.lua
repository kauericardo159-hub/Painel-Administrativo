--[[
    GITHUB: ListManager_V7_Core.lua
    Função: Transforma os Frames das abas em listas de rolagem automáticas.
    Sincronização: Trabalha em conjunto com o Painel V7 Clean.
]]

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Localização dos elementos criados no script anterior
local screenGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = screenGui:WaitForChild("MainFrame")
local pagesFolder = mainFrame.ContentArea.Pages

-- [FUNÇÃO DE CONVERSÃO PARA LISTA]
local function ConvertToScrollingList(page)
    -- Se já for um ScrollingFrame, não faz nada
    if page:IsA("ScrollingFrame") then return end

    -- Criar o ScrollingFrame no lugar do Frame simples
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = page.Name
    scroll.Size = page.Size
    scroll.Position = page.Position
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 155)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = page.Visible
    scroll.Parent = pagesFolder

    -- Layout de Lista (Organização vertical)
    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Espaçamento nas bordas (Padding)
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 10)

    -- Lógica de Auto-Ajuste do Tamanho da Rolagem
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    -- Deleta o frame antigo
    page:Destroy()
end

-- [APLICAR EM TODAS AS ABAS]
for _, page in ipairs(pagesFolder:GetChildren()) do
    if page:IsA("Frame") then
        ConvertToScrollingList(page)
    end
end

-- [OBSERVADOR] Se novas abas forem criadas dinamicamente
pagesFolder.ChildAdded:Connect(function(child)
    task.wait()
    if child:IsA("Frame") then
        ConvertToScrollingList(child)
    end
end)

print("ListManager V7: Canais de rolagem ativados.")
