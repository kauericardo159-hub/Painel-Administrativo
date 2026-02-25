--[[
    SCRIPT: Painel Automático Pro
    DESCRIÇÃO: Cria um painel transparente com borda dupla e design limpo.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Criação da ScreenGui Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PainelSistemaGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Criação do Frame Principal (Painel)
local painelPrincipal = Instance.new("Frame")
painelPrincipal.Name = "PainelPrincipal"
painelPrincipal.Size = UDim2.new(0, 400, 0, 250) -- Tamanho do painel
painelPrincipal.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centralizado
painelPrincipal.AnchorPoint = Vector2.new(0.5, 0.5)
painelPrincipal.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Preto
painelPrincipal.BackgroundTransparency = 0.3 -- Transparência solicitada
painelPrincipal.BorderSizePixel = 0
painelPrincipal.Parent = screenGui

-- 3. Adicionando Arredondamento (Opcional, mas fica lindo)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = painelPrincipal

-- 4. Borda INTERNA (Branca)
local bordaBranca = Instance.new("UIStroke")
bordaBranca.Name = "BordaInterna"
bordaBranca.Color = Color3.fromRGB(255, 255, 255) -- Branco
bordaBranca.Thickness = 2
bordaBranca.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
bordaBranca.Parent = painelPrincipal

-- 5. Borda EXTERNA (Preta)
-- Nota: Para duas bordas no Roblox, precisamos de um Frame invisível levemente maior atrás.
local outlineContainer = Instance.new("Frame")
outlineContainer.Name = "BordaExternaContainer"
outlineContainer.Size = UDim2.new(1, 4, 1, 4) -- Ligeiramente maior que o painel
outlineContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
outlineContainer.AnchorPoint = Vector2.new(0.5, 0.5)
outlineContainer.BackgroundTransparency = 1
outlineContainer.ZIndex = painelPrincipal.ZIndex - 1 -- Fica atrás
outlineContainer.Parent = painelPrincipal

local bordaPreta = Instance.new("UIStroke")
bordaPreta.Name = "BordaExterna"
bordaPreta.Color = Color3.fromRGB(0, 0, 0) -- Preto
bordaPreta.Thickness = 2
bordaPreta.Parent = outlineContainer

-- Adiciona UICorner na borda externa para acompanhar o painel
local uiCornerExtra = uiCorner:Clone()
uiCornerExtra.Parent = outlineContainer

---

-- Função para organizar o fechamento (Inicia invisível se quiser)
-- painelPrincipal.Visible = true 

print("✅ Painel criado com sucesso pelo Script!")
