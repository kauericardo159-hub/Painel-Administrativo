local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. SISTEMA DE LIMPEZA E SUBSTITUIÇÃO
-- Garante que versões antigas sejam removidas para evitar sobreposição de scripts
local coreName = "InterfaceMenu_V3"
local oldGui = playerGui:FindFirstChild(coreName)
if oldGui then oldGui:Destroy() end

-- 2. ESTRUTURA BASE (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = coreName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Faz o Blur e o painel ocuparem a tela toda se necessário
screenGui.Parent = playerGui

-- 3. PAINEL PRINCIPAL (Tamanho Melhorado e Proporcional)
local painel = Instance.new("Frame")
painel.Name = "Painel"
-- Largura de 700px para um visual cinematográfico
painel.Size = UDim2.new(0, 700, 0, 420) 
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Inicia abaixo para a animação do botão
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
painel.BackgroundTransparency = 0.2 -- Conforme solicitado
painel.BorderSizePixel = 0
painel.Visible = false
painel.Parent = screenGui

-- Adicionando Gradiente ao Fundo do Painel
local painelGradient = Instance.new("UIGradient")
painelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
painelGradient.Rotation = 45
painelGradient.Parent = painel

-- 4. REFORMULAÇÃO DOS UISTROKES (Bordas Estilosas)

-- Stroke Interno (Preto Suave)
local strokeInterno = Instance.new("UIStroke")
strokeInterno.Thickness = 4
strokeInterno.Color = Color3.new(0, 0, 0)
strokeInterno.Transparency = 0.3
strokeInterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeInterno.Parent = painel

-- Stroke Externo (O "Brilho" com UIGradient Animado)
local strokeExterno = Instance.new("UIStroke")
strokeExterno.Thickness = 3
strokeExterno.Color = Color3.new(1, 1, 1) -- Base branca
strokeExterno.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeExterno.Parent = painel

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 100)), -- Cinza
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), -- Branco
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))  -- Cinza
})
strokeGradient.Parent = strokeExterno

-- 5. ANIMAÇÃO DE UISTROKE (Efeito de Brilho Pulsante)
local function startStrokeAnimation()
    task.spawn(function()
        while painel.Parent do
            -- Anima o deslocamento do gradiente na borda
            local tween = TweenService:Create(strokeGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
            strokeGradient.Offset = Vector2.new(-1, 0)
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end
startStrokeAnimation()

-- 6. ÁREA DA LISTA DE OPÇÕES (Integrada e Abaixada)
local listaContainer = Instance.new("ScrollingFrame")
listaContainer.Name = "ListaOpcoesContainer"
listaContainer.Size = UDim2.new(0, 350, 0, 280) 
listaContainer.Position = UDim2.new(1, -25, 0.62, 0) -- Mais baixo e à direita
listaContainer.AnchorPoint = Vector2.new(1, 0.5)
listaContainer.BackgroundTransparency = 1
listaContainer.ScrollBarThickness = 2
listaContainer.BorderSizePixel = 0
listaContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listaContainer.Parent = painel

local layout = Instance.new("UIListLayout")
layout.Parent = listaContainer
layout.Padding = UDim.new(0, 12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 7. CONEXÃO COM O BOTÃO (Lógica Global)
-- Este painel agora aguarda o sinal do LocalScript do Botão para subir/descer.
-- A tag "Painel" garante que o script anterior do botão o encontre via FindFirstChild.

print("Painel Premium recriado com Gradientes e Bordas Animadas!")
