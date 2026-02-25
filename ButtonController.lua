--[[
    GITHUB: ButtonController_Ultimate_V7.lua
    Versão: 7.0 (Premium Edition)
    Função: Botão flutuante com Bloom, UIStroke Animado e Deslize Vertical.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- [CONFIGURAÇÕES DE ESTILO V7]
local CORES = {
    Fundo = Color3.fromRGB(15, 15, 18),
    BordaInativa = Color3.fromRGB(80, 80, 85),
    BordaAtiva = Color3.fromRGB(255, 255, 255),
    Texto = Color3.fromRGB(255, 255, 255)
}

-- [EFEITO DE BLOOM 0.4]
local bloom = Lighting:FindFirstChild("ButtonBloom")
if not bloom then
    bloom = Instance.new("BloomEffect", Lighting)
    bloom.Name = "ButtonBloom"
end
bloom.Intensity = 0.4
bloom.Size = 10
bloom.Threshold = 0.8

-- [LIMPEZA]
if playerGui:FindFirstChild("MainButton_ScreenGui") then
    playerGui.MainButton_ScreenGui:Destroy()
end

-- [CRIAÇÃO DA INTERFACE]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainButton_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100
screenGui.Parent = playerGui

-- Botão Principal
local openBtn = Instance.new("TextButton")
openBtn.Name = "ToggleMenu"
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0.05, 0, 0.4, 0) -- Posição inicial lateral
openBtn.BackgroundColor3 = CORES.Fundo
openBtn.Text = ""
openBtn.AutoButtonColor = false
openBtn.Parent = screenGui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 12)

-- UIStroke em volta do BOTÃO (Não na fonte)
local btnStroke = Instance.new("UIStroke", openBtn)
btnStroke.Color = CORES.BordaInativa
btnStroke.Thickness = 2
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Ícone Interno
local btnIcon = Instance.new("TextLabel")
btnIcon.Size = UDim2.new(1, 0, 1, 0)
btnIcon.BackgroundTransparency = 1
btnIcon.Text = "V7"
btnIcon.TextColor3 = CORES.Texto
btnIcon.Font = Enum.Font.Jura -- Fonte estilosa combinando com o painel
btnIcon.TextSize = 20
btnIcon.Parent = openBtn

-- Gradiente para a Borda (UIStroke)
local strokeGradient = Instance.new("UIGradient", btnStroke)
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 100, 105)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})

--------------------------------------------------------------------
-- [ANIMAÇÃO DE ABRIR/FECHAR - SOBE E DESCE]
--------------------------------------------------------------------
local panelAtivo = false

local function TogglePanel()
    -- Localiza o Painel V7 (Certifique-se que o nome do ScreenGui do painel é este)
    local panelGui = playerGui:FindFirstChild("PainelV7_ScreenGui")
    if not panelGui then return end
    
    local mainFrame = panelGui:FindFirstChild("MainFrame")
    if not mainFrame then return end
    
    panelAtivo = not panelAtivo
    
    if panelAtivo then
        -- ANIMAÇÃO DE ABERTURA: Vem de baixo para o centro
        mainFrame.Visible = true
        mainFrame.Position = UDim2.new(0.5, -360, 1.5, 0) -- Começa bem abaixo
        
        TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -360, 0.5, -250)
        }):Play()
        
        -- Animação do Botão
        TweenService:Create(btnStroke, TweenInfo.new(0.4), {Color = CORES.BordaAtiva, Thickness = 3}):Play()
        TweenService:Create(openBtn, TweenInfo.new(0.4), {Rotation = 180}):Play()
    else
        -- ANIMAÇÃO DE FECHAMENTO: Desce até sumir
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -360, 1.5, 0)
        })
        
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not panelAtivo then mainFrame.Visible = false end
        end)
        
        -- Volta o botão ao normal
        TweenService:Create(btnStroke, TweenInfo.new(0.4), {Color = CORES.BordaInativa, Thickness = 2}):Play()
        TweenService:Create(openBtn, TweenInfo.new(0.4), {Rotation = 0}):Play()
    end
end

openBtn.MouseButton1Click:Connect(TogglePanel)

-- [EFEITOS DE HOVER]
openBtn.MouseEnter:Connect(function()
    TweenService:Create(btnStroke, TweenInfo.new(0.3), {Thickness = 4, Color = Color3.fromRGB(200, 200, 205)}):Play()
    TweenService:Create(openBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
end)

openBtn.MouseLeave:Connect(function()
    if not panelAtivo then
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Thickness = 2, Color = CORES.BordaInativa}):Play()
    end
    TweenService:Create(openBtn, TweenInfo.new(0.3), {BackgroundColor3 = CORES.Fundo}):Play()
end)

print("ButtonController V7: Bloom e Animação Sobe/Desce ativos.")
