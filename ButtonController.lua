local botao = script.Parent
local screenGui = botao.Parent
local painel = screenGui:WaitForChild("PainelPrincipal") -- Procura o painel que o script criou

-- Função para abrir/fechar
botao.MouseButton1Click:Connect(function()
    if painel then
        -- Inverte o estado atual: se for true vira false, se for false vira true
        painel.Visible = not painel.Visible
        
        -- Feedback visual no console (opcional)
        if painel.Visible then
            print("Painel Aberto")
        else
            print("Painel Fechado")
        end
    end
end)

-- --- SISTEMA DE ARRASTAR O BOTÃO ---
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

botao.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = botao.Position
    end
end)

botao.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        botao.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
