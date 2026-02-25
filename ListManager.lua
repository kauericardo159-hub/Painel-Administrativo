-- --- CONFIGURAÇÃO DA LISTA DE COMANDOS ---

-- 1. Criar o ScrollingFrame (A lista onde os comandos ficarão)
local listaComandos = Instance.new("ScrollingFrame")
listaComandos.Name = "ListaComandos"
-- Ajuste de Tamanho e Posição para ficar igual à sua imagem:
listaComandos.Size = UDim2.new(0.6, 0, 0.8, 0) -- Ocupa 60% da largura e 80% da altura
listaComandos.Position = UDim2.new(0.35, 0, 0.5, 0) -- Posicionado à direita
listaComandos.AnchorPoint = Vector2.new(0, 0.5)
listaComandos.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Um preto levemente diferente para contraste
listaComandos.BackgroundTransparency = 0.2 -- Pouco mais opaco que o painel principal
listaComandos.BorderSizePixel = 0
listaComandos.ScrollBarThickness = 4
listaComandos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listaComandos.Parent = painel -- Coloca dentro do Painel Principal

-- 2. Aplicar Borda Dupla na Lista (Mesmo estilo do painel)
aplicarBordaDupla(listaComandos, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0))

-- 3. Organização Automática (UIListLayout)
-- Isso fará com que, quando você adicionar comandos, eles fiquem um embaixo do outro sozinho.
local layout = Instance.new("UIListLayout")
layout.Parent = listaComandos
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5) -- Espaço entre cada comando

-- 4. Margem interna (UIPadding)
local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingTop = UDim.new(0, 8)
padding.Parent = listaComandos

print("📋 Lista de Comandos pronta para receber itens!")
