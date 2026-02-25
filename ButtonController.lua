local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CONFIGURAÇÃO DO BOTÃO
local screenGui = playerGui:WaitForChild("MeuPainelPremium")
local painel = screenGui:WaitForChild("Painel")

local btn = Instance.new("TextButton")
btn.Name = "ToggleBtn"
btn.Size = UDim2.new(0, 140, 0, 45)
btn.Position = UDim2.new(0, 50, 0.9, 0) -- Fica na parte inferior esquerda
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.Text = "ABRIR PAINEL"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.new(1, 1, 1)
btnStroke.Thickness = 2
btnStroke.Parent = btn

-- Gradiente no Botão
local btnGrad = Instance.new("UIGradient")
btnGrad.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(10, 10, 10))
btnGrad.Rotation = 90
btnGrad.Parent = btn

-- 2. LÓGICA DE TRANSIÇÃO
local blur = Instance.new("BlurEffect", lighting)
blur.Size = 0

local isOpen = false
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

btn.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	
	if isOpen then
		painel.Visible = true
		TweenService:Create(painel, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		TweenService:Create(blur, TweenInfo.new(0.5), {Size = 20}):Play()
		btn.Text = "FECHAR"
	else
		local closeTween = TweenService:Create(painel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1.5, 0)})
		closeTween:Play()
		TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
		btn.Text = "ABRIR PAINEL"
		closeTween.Completed:Connect(function()
			if not isOpen then painel.Visible = false end
		end)
	end
end)
