local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

--[[ 
===========================================================
       ⚙ GERENCIADOR DA LISTA DE OPÇÕES V4 ⚙
===========================================================
]]

-- 1. LOCALIZAÇÃO E LIMPEZA
local playerGui = player:WaitForChild("PlayerGui")
local coreGui = playerGui:WaitForChild("SistemaPainel_V3")
-- Busca o Painel principal
local painel = coreGui:WaitForChild("Panel")

-- Limpa a lista antiga se existir
if painel:FindFirstChild("ListaOpcoesContainer") then
    painel.ListaOpcoesContainer:Destroy()
end

-- 2. CONTAINER DA LISTA (ScrollingFrame)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"
-- Tamanho e posição ajustados para o novo painel
listaContainer.Size = UDim2.new(0.5, -30, 0.75, 0)
listaContainer.Position = UDim2.new(0.97, 0, 0.5, 0)
listaContainer.AnchorPoint = Vector2.new(1, 0.5)
listaContainer.BackgroundTransparency = 1
listaContainer.BorderSizePixel = 0
listaContainer.ScrollBarThickness = 6
listaContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 128, 0) -- Laranja Neon
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Automático
listaContainer.ClipsDescendants = true
listaContainer.Parent = painel

-- 3. BORDAS E ESTILIZAÇÃO DO CONTAINER
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = listaContainer

local strokeGradient = Instance.new("UIGradient")
-- Gradiente Laranja/Branco para a borda
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 128, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 128, 0))
})
strokeGradient.Parent = uiStroke

-- 4. ORGANIZAÇÃO AUTOMÁTICA DOS ITENS (O coração do problema)
local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 15) -- Espaçamento entre botões
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UIPadding para os botões não ficarem colados na borda
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingBottom = UDim.new(0, 15)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = listaContainer

-- 5. LÓGICA DE ANIMAÇÃO E CANVASSIZE
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    -- Calcula o tamanho total necessário para o scroll
    listaContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
end)

-- 6. FUNÇÃO PARA CRIAR BOTÕES ESTILIZADOS (UICorner + Stroke + Gradiente)
local function createStyledButton(name, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 50) -- Preenche a largura da lista
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.AutoButtonColor = false
    button.Parent = listaContainer

    -- UICorner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    -- UIStroke Laranja Estiloso
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(255, 128, 0)
    btnStroke.Parent = button

    -- UIGradient no botão
    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new(Color3.fromRGB(255, 160, 60), Color3.fromRGB(255, 100, 0))
    btnGradient.Rotation = 90
    btnGradient.Parent = button

    -- Efeitos de Hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return button
end

-- 7. EXEMPLO DE USO (Adicione seus botões aqui)
--[[
createStyledButton("Btn1", "Comando 1", function() print("Comando 1") end)
createStyledButton("Btn2", "Comando 2", function() print("Comando 2") end)
createStyledButton("Btn3", "Comando 3", function() print("Comando 3") end)
]]

-- 8. ANIMAÇÃO DE ENTRADA DA LISTA
local function animateListItems()
    for _, item in pairs(listaContainer:GetChildren()) do
        if item:IsA("GuiObject") then
            item.Position = item.Position + UDim2.new(0, 50, 0, 0) -- Vem da direita
            item.BackgroundTransparency = 1
            TweenService:Create(item, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = item.Position - UDim2.new(0, 50, 0, 0),
                BackgroundTransparency = 0
            }):Play()
        end
    end
end

-- Sincronização com a abertura do painel
painel:GetPropertyChangedSignal("Visible"):Connect(function()
    if painel.Visible then
        task.wait(0.2)
        animateListItems()
    end
end)

print("✅ Lista de Opções V4 (Estilizada e Organizada) Carregada!")
