--[[
    ====================================================================
    PROJETO: Painel V7.0 - List Manager (Comandos & Funções)
    DESCRIÇÃO: Converte os containers de conteúdo em ScrollingFrames dinâmicos.
    ====================================================================
]]

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Localiza a pasta de páginas criada no layout base
local screenGui = playerGui:WaitForChild("PainelV7_ScreenGui")
local mainFrame = screenGui:WaitForChild("MainFrame")
local pagesFolder = mainFrame:WaitForChild("ContentBox"):WaitForChild("PagesFolder")

local BordaCinza = Color3.fromRGB(80, 80, 85)

-- Função que converte um Frame comum em uma Lista de Rolagem (ScrollingFrame)
local function ConfigurarListaDeComandos(paginaBase)
    -- Se já foi convertido, ignora
    if paginaBase:IsA("ScrollingFrame") then return end

    -- Cria o ScrollingFrame usando as dimensões da página original
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = paginaBase.Name
    scroll.Size = paginaBase.Size
    scroll.Position = paginaBase.Position
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Visible = paginaBase.Visible
    
    -- Configuração visual da barra de rolagem
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = BordaCinza
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Tamanho inicial zerado
    
    -- Substitui a página antiga pela nova
    scroll.Parent = pagesFolder
    paginaBase:Destroy()

    -- Sistema de Organização Automática (Empilha os comandos)
    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12) -- Espaço entre um comando e outro
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Espaçamento interno (Padding) para não colar nas bordas
    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 15)

    -- MÁGICA: Atualiza o tamanho da rolagem automaticamente quando adicionar itens
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 25)
    end)
end

-- Varre a pasta aguardando as páginas serem criadas pelo Script 1
local function IniciarGerenciador()
    -- Converte as páginas que já existem
    for _, child in ipairs(pagesFolder:GetChildren()) do
        if child:IsA("Frame") then
            ConfigurarListaDeComandos(child)
        end
    end

    -- Fica "vigiando" caso novas abas sejam adicionadas no futuro
    pagesFolder.ChildAdded:Connect(function(child)
        task.wait() -- Aguarda renderizar
        if child:IsA("Frame") then
            ConfigurarListaDeComandos(child)
        end
    end)
end

-- Executa o ListManager
IniciarGerenciador()

print("[Painel V7] ListManager (Área de Comandos) ativado!")
