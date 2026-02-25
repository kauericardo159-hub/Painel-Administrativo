local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. SISTEMA DE LIMPEZA (Anti-Duplicação)
local oldGuis = {"InterfacePrincipal", "LoadingSystem", "MenuBlurEffect"}
for _, name in ipairs(oldGuis) do
    local existing = playerGui:FindFirstChild(name) or Lighting:FindFirstChild(name)
    if existing then existing:Destroy() end
end

-- 2. TELA DE CARREGAMENTO (INTRODUÇÃO)
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingSystem"
loadingGui.Parent = playerGui

local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 300, 0, 100)
loadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
loadFrame.Parent = loadingGui

local loadBarBack = Instance.new("Frame")
loadBarBack.Size = UDim2.new(0.8, 0, 0.1, 0)
loadBarBack.Position = UDim2.new(0.5, 0, 0.7, 0)
loadBarBack.AnchorPoint = Vector2.new(0.5, 0.5)
loadBarBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadBarBack.Parent = loadFrame

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadBarFill.Parent = loadBarBack

local loadLabel = Instance.new("TextLabel")
loadLabel.Size = UDim2.new(1, 0, 0.4, 0)
loadLabel.Text = "CARREGANDO SISTEMAS..."
loadLabel.TextColor3 = Color3.new(1, 1, 1)
loadLabel.Font = Enum.Font.GothamBold
loadLabel.BackgroundTransparency = 1
loadLabel.Parent = loadFrame

-- 3. CRIAÇÃO DO PAINEL PRINCIPAL (MELHORADO)
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "InterfacePrincipal"
mainGui.ResetOnSpawn = false
mainGui.Parent = playerGui

local painel = Instance.new("Frame")
painel.Name = "Painel"
painel.Size = UDim2.new(0, 750, 0, 450) -- Tamanho otimizado e amplo
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Começa embaixo para animação
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.new(0, 0, 0)
painel.BackgroundTransparency = 0.2
painel.BorderSizePixel = 0
painel.Visible = false
painel.Parent = mainGui

-- Gradiente para o Fundo do Painel
local gradientePainel = Instance.new("UIGradient")
gradientePainel.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradientePainel.Rotation = 45
gradientePainel.Parent = painel

-- 4. UISTROKE AVANÇADO (DUPLA CAMADA E ANIMAÇÃO)
local strokeBranco = Instance.new("UIStroke")
strokeBranco.Thickness = 3
strokeBranco.Color = Color3.new(1, 1, 1)
strokeBranco.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeBranco.Parent = painel

local strokeCinza = Instance.new("UIStroke")
strokeCinza.Thickness = 6
strokeCinza.Color = Color3.fromRGB(50, 50, 50)
strokeCinza.Transparency = 0.4
strokeCinza.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeCinza.Parent = painel

-- Animação do Stroke (Efeito Rainbow/Brilho Suave)
task.spawn(function()
    local t = 0
    while painel.Parent do
        t = t + 0.01
        local color = Color3.fromHSV(0, 0, (math.sin(t * 2) + 1) / 2 * 0.5 + 0.5)
        strokeBranco.Color = color -- Oscila entre cinza claro e branco
        task.wait(0.03)
    end
end)

-- 5. BOTÃO DE CONTROLE ESTILIZADO
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 150, 0, 45)
btn.Position = UDim2.new(0, 20, 0.5, 0)
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.Text = "INICIAR"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.Parent = mainGui

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.new(1, 1, 1)
btnStroke.Thickness = 2
btnStroke.Parent = btn

-- 6. LÓGICA DE CARREGAMENTO E TRANSIÇÃO
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local function executeLoading()
    loadBarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 2)
    task.wait(2.1)
    loadingGui:Destroy()
    btn.Visible = true
end

local isOpen = false
btn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    local targetPos = isOpen and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 1.5, 0)
    local targetBlur = isOpen and 18 or 0
    
    if isOpen then painel.Visible = true end
    
    TweenService:Create(painel, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
    TweenService:Create(blur, TweenInfo.new(0.6), {Size = targetBlur}):Play()
    
    btn.Text = isOpen and "FECHAR" or "ABRIR"
end)

-- Inicia o processo
btn.Visible = false
executeLoading()
