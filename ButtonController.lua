-- Criação da Interface Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InterfaceMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Configuração do Botão
local button = Instance.new("TextButton")
button.Name = "AbrirFecharBtn"
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0.5, -25) -- Posicionado no centro à esquerda
button.BackgroundColor3 = Color3.new(0, 0, 0) -- Preto
button.TextColor3 = Color3.new(1, 1, 1) -- Branco
button.Text = "ABRIR/FECHAR"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.BorderSizePixel = 2
button.Parent = screenGui

-- Arredondar os cantos (opcional, para estética)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = button

-- Lógica de Clique
button.MouseButton1Click:Connect(function()
    -- Procura pelo seu script/painel dentro da ScreenGui
    -- Certifique-se de que o objeto do seu painel se chame "Painel"
    local painel = screenGui:FindFirstChild("Painel")
    
    if painel then
        painel.Visible = not painel.Visible
    else
        warn("Aviso: O objeto chamado 'Painel' não foi encontrado dentro da ScreenGui.")
    end
end)
