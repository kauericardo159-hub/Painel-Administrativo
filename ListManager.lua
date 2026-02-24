--[[
    GITHUB: ListManager_V5_Tabs.lua
    Função: Gerenciar o conteúdo interno de cada Aba no Painel V5.5.
]]

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Localiza a área de conteúdo que criamos no script do Painel
local panelGui = playerGui:WaitForChild("MainPanel_ScreenGui")
local mainFrame = panelGui:WaitForChild("MainFrame")
local contentArea = mainFrame:WaitForChild("ContentArea")
local pagesFolder = contentArea:WaitForChild("Pages")

-- [FUNÇÃO PARA ORGANIZAR CADA PÁGINA]
local function SetupPage(page)
    -- Layout para empilhar os botões de comando
    local layout = page:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Espaçamento interno (Padding)
    local padding = page:FindFirstChildOfClass("UIPadding") or Instance.new("UIPadding", page)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)

    -- Sincronizar o tamanho da rolagem (Canvas) automaticamente
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
end

-- [APLICAR CONFIGURAÇÃO EM TODAS AS ABAS EXISTENTES]
for _, page in ipairs(pagesFolder:GetChildren()) do
    if page:IsA("ScrollingFrame") then
        SetupPage(page)
    end
end

-- [OBSERVADOR] Caso você adicione abas novas via script depois, ele as organiza
pagesFolder.ChildAdded:Connect(function(child)
    if child:IsA("ScrollingFrame") then
        SetupPage(child)
    end
end)

print("Gerenciador de Listas por Aba atualizado.")
