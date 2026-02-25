local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. LIMPEZA E PREPARAÇÃO
local screenName = "MeuPainelPremium"
if playerGui:FindFirstChild(screenName) then playerGui[screenName]:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = screenName
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. TELA DE CARREGAMENTO (INTRODUÇÃO)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
loadingFrame.ZIndex = 10
loadingFrame.Parent = screenGui

local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(0, 300, 0, 4)
loadBarBg.Position = UDim2.new(0.5, 0, 0.5, 0)
loadBarBg.AnchorPoint = Vector2.new(0.5, 0.5)
loadBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadBarBg.Parent = loadingFrame

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Color3.new(1, 1, 1)
loadBarFill.Parent = loadBarBg

local loadText = Instance.new("TextLabel")
loadText.Text = "INICIALIZANDO SISTEMAS..."
loadText.Font = Enum.Font.GothamBold
loadText.TextColor3 = Color3.new(1, 1, 1)
loadText.TextSize = 14
loadText.Position = UDim2.new(0.5, 0, 0.5, -25)
loadText.AnchorPoint = Vector2.new(0.5, 0.5)
loadText.BackgroundTransparency = 1
loadText.Parent = loadingFrame

-- Animação da Barra
task.spawn(function()
	TweenService:Create(loadBarFill, TweenInfo.new(2, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 1, 0)}):Play()
	task.wait(2.2)
	TweenService:Create(loadingFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadBarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	task.wait(0.8)
	loadingFrame:Destroy()
end)

-- 3. O PAINEL (DESIGN MELHORADO)
local painel = Instance.new("Frame")
painel.Name = "Painel"
painel.Size = UDim2.new(0, 750, 0, 450) -- Tamanho otimizado
painel.Position = UDim2.new(0.5, 0, 1.5, 0) -- Começa embaixo para animação
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.BackgroundColor3 = Color3.new(1, 1, 1) -- Branco para o gradiente agir
painel.BackgroundTransparency = 0.2
painel.Parent = screenGui

-- Gradiente no Fundo do Painel
local painelGradient = Instance.new("UIGradient")
painelGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
})
painelGradient.Rotation = 45
painelGradient.Parent = painel

-- UIStroke Estilizado (Branco)
local strokeBranco = Instance.new("UIStroke")
strokeBranco.Thickness = 3
strokeBranco.Color = Color3.new(1, 1, 1)
strokeBranco.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
strokeBranco.Parent = painel

-- UIStroke Cinza Profundo (Sombra/Profundidade)
local strokeCinza = Instance.new("UIStroke")
strokeCinza.Thickness = 6
strokeCinza.Color = Color3.fromRGB(60, 60, 60)
strokeCinza.Transparency = 0.4
strokeCinza.Parent = painel

-- 4. ANIMAÇÃO DE CICLO DO UISTROKE (Brilho Pulsante)
task.spawn(function()
	while true do
		local tween = TweenService:Create(strokeBranco, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Color = Color3.fromRGB(180, 180, 180)
		})
		tween:Play()
		tween.Completed:Wait()
		local tweenBack = TweenService:Create(strokeBranco, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Color = Color3.new(1, 1, 1)
		})
		tweenBack:Play()
		tweenBack.Completed:Wait()
	end
end)

-- Arredondamento
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = painel

print("Sistemas carregados. Aguardando ativação via botão.")
