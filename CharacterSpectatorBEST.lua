print("Character Spectator: Скрипт начал загрузку")
local success, player = pcall(function()
	return game.Players.LocalPlayer
end)
if not success or not player then
	warn("Character Spectator: Не удалось получить LocalPlayer")
	return
end

local PlayerGui = player:WaitForChild("PlayerGui")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CharacterSpectatorUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = true

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 600)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local toggleUIButton = Instance.new("TextButton")
toggleUIButton.Name = "ToggleUIButton"
toggleUIButton.Size = UDim2.new(0, 30, 0, 30)
toggleUIButton.Position = UDim2.new(1, -35, 0, 5)
toggleUIButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleUIButton.Text = "−"
toggleUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleUIButton.Font = Enum.Font.GothamBold
toggleUIButton.TextSize = 18
toggleUIButton.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Character Spectator - Найдено: 0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local searchButton = Instance.new("TextButton")
searchButton.Name = "RefreshButton"
searchButton.Size = UDim2.new(0, 100, 0, 30)
searchButton.Position = UDim2.new(0.5, -110, 0, 65)
searchButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
searchButton.Text = "Обновить"
searchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
searchButton.Font = Enum.Font.Gotham
searchButton.TextSize = 14
searchButton.Parent = mainFrame

local attachCameraButton = Instance.new("TextButton")
attachCameraButton.Name = "AttachCameraButton"
attachCameraButton.Size = UDim2.new(0, 140, 0, 30)
attachCameraButton.Position = UDim2.new(0.5, 10, 0, 65)
attachCameraButton.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
attachCameraButton.Text = "Прикрепить камеру"
attachCameraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
attachCameraButton.Font = Enum.Font.Gotham
attachCameraButton.TextSize = 12
attachCameraButton.Parent = mainFrame

local detachCameraButton = Instance.new("TextButton")
detachCameraButton.Name = "DetachCameraButton"
detachCameraButton.Size = UDim2.new(0, 140, 0, 30)
detachCameraButton.Position = UDim2.new(0.5, 10, 0, 100)
detachCameraButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
detachCameraButton.Text = "Отсоединить камеру"
detachCameraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
detachCameraButton.Font = Enum.Font.Gotham
detachCameraButton.TextSize = 12
detachCameraButton.Visible = false
detachCameraButton.Parent = mainFrame

local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "ListFrame"
listFrame.Size = UDim2.new(1, -20, 0, 200)
listFrame.Position = UDim2.new(0, 10, 0, 140)
listFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 8
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Name = "UIListLayout"
uiListLayout.Padding = UDim.new(0, 2)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = listFrame

local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.new(1, -20, 0, 100)
infoFrame.Position = UDim2.new(0, 10, 0, 350)
infoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
infoFrame.BorderSizePixel = 1
infoFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
infoFrame.Parent = mainFrame

local infoText = Instance.new("TextLabel")
infoText.Name = "InfoText"
infoText.Size = UDim2.new(1, -10, 1, -10)
infoText.Position = UDim2.new(0, 5, 0, 5)
infoText.BackgroundTransparency = 1
infoText.Text = "Нажмите 'Поиск' для начала"
infoText.TextColor3 = Color3.fromRGB(220, 220, 220)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 11
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = infoFrame

local controlFrame = Instance.new("Frame")
controlFrame.Name = "ControlFrame"
controlFrame.Size = UDim2.new(1, -20, 0, 150)
controlFrame.Position = UDim2.new(0, 10, 0, 460)
controlFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
controlFrame.BorderSizePixel = 1
controlFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
controlFrame.Visible = false
controlFrame.Parent = mainFrame

local controlTitle = Instance.new("TextLabel")
controlTitle.Name = "ControlTitle"
controlTitle.Size = UDim2.new(1, 0, 0, 20)
controlTitle.Position = UDim2.new(0, 0, 0, 0)
controlTitle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
controlTitle.Text = "Управление камерой (когда прикреплена)"
controlTitle.TextColor3 = Color3.fromRGB(255, 255, 200)
controlTitle.Font = Enum.Font.GothamBold
controlTitle.TextSize = 12
controlTitle.Parent = controlFrame

local offsetLabel = Instance.new("TextLabel")
offsetLabel.Name = "OffsetLabel"
offsetLabel.Size = UDim2.new(1, -10, 0, 20)
offsetLabel.Position = UDim2.new(0, 5, 0, 25)
offsetLabel.BackgroundTransparency = 1
offsetLabel.Text = "Смещение: X=0.0, Y=0.0, Z=0.0"
offsetLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
offsetLabel.Font = Enum.Font.Gotham
offsetLabel.TextSize = 11
offsetLabel.TextXAlignment = Enum.TextXAlignment.Left
offsetLabel.Parent = controlFrame

local smoothnessLabel = Instance.new("TextLabel")
smoothnessLabel.Name = "SmoothnessLabel"
smoothnessLabel.Size = UDim2.new(1, -10, 0, 20)
smoothnessLabel.Position = UDim2.new(0, 5, 0, 45)
smoothnessLabel.BackgroundTransparency = 1
smoothnessLabel.Text = "Плавность: 0.15"
smoothnessLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
smoothnessLabel.Font = Enum.Font.Gotham
smoothnessLabel.TextSize = 11
smoothnessLabel.TextXAlignment = Enum.TextXAlignment.Left
smoothnessLabel.Parent = controlFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Name = "FovLabel"
fovLabel.Size = UDim2.new(1, -10, 0, 20)
fovLabel.Position = UDim2.new(0, 5, 0, 65)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 70°"
fovLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 11
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = controlFrame

local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "InstructionLabel"
instructionLabel.Size = UDim2.new(1, -10, 0, 70)
instructionLabel.Position = UDim2.new(0, 5, 0, 85)
instructionLabel.BackgroundTransparency = 1
instructionLabel.Text = "Q/E - смещение X\nR/F - смещение Y\nT/G - смещение Z\nZ/X - плавность\nU/I - FOV\nESC - отсоединить\nH - скрыть/показать UI"
instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 150)
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextSize = 10
instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
instructionLabel.TextYAlignment = Enum.TextYAlignment.Top
instructionLabel.Parent = controlFrame

screenGui.Parent = PlayerGui
print("Character Spectator: Интерфейс добавлен в PlayerGui")

local headsList = {}
local selectedHead = nil
local cameraAttached = false
local cameraConnection = nil
local originalCameraType = nil
local originalCameraFOV = nil
local originalTransparency = {}
local uiVisible = true

local cameraOffset = Vector3.new(0, 0, 0)
local cameraSmoothness = 0.15
local cameraFOV = 70

local function findHeads()
	print("Character Spectator: Поиск голов...")
	local allHeads = {}
	local count = 0

	local function search(object)
		if object.Name == "Head" then
			count = count + 1
			table.insert(allHeads, {
				Head = object,
				Parent = object.Parent,
				FullPath = object:GetFullName()
			})
		end

		for _, child in ipairs(object:GetChildren()) do
			search(child)
		end
	end

	search(game.Workspace)
	print("Character Spectator: Найдено голов в Workspace:", count)

	return allHeads
end

local function updateList()
	print("Character Spectator: Обновление списка")

	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	headsList = findHeads()
	title.Text = "Character Spectator - Найдено: " .. #headsList

	local totalHeight = 0
	for i, headData in ipairs(headsList) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Name = "Item_" .. i
		itemFrame.Size = UDim2.new(1, 0, 0, 30)
		itemFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		itemFrame.BorderSizePixel = 0
		itemFrame.LayoutOrder = i

		local itemButton = Instance.new("TextButton")
		itemButton.Name = "SelectButton"
		itemButton.Size = UDim2.new(1, 0, 1, 0)
		itemButton.BackgroundTransparency = 1
		itemButton.Text = ""
		itemButton.Parent = itemFrame

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "NameLabel"
		nameLabel.Size = UDim2.new(1, -10, 1, 0)
		nameLabel.Position = UDim2.new(0, 5, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = headData.Parent.Name .. " - Head"
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextSize = 12
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = itemFrame

		itemButton.MouseButton1Click:Connect(function()
			print("Character Spectator: Выбрана голова", headData.FullPath)

			for _, item in ipairs(listFrame:GetChildren()) do
				if item:IsA("Frame") then
					item.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				end
			end
			
			itemFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
			selectedHead = headData

			infoText.Text = string.format(
				"Выбрано: %s\n" ..
					"Родитель: %s\n" ..
					"Полный путь: %s",
				headData.Head.Name,
				headData.Parent.Name,
				headData.FullPath
			)
		end)

		itemFrame.Parent = listFrame
		totalHeight = totalHeight + itemFrame.Size.Y.Offset + 2
	end

	listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

	if #headsList == 0 then
		infoText.Text = "ничё не найдено."
	else
		infoText.Text = "Выберите голову из списка"
	end
end

local function setHeadAccessoriesTransparency(head, transparency)
	print("Character Spectator: Установка прозрачности:", transparency)
	if transparency == 1 then
		originalTransparency = {}
	end

	for _, child in ipairs(head:GetChildren()) do
		if child:IsA("BasePart") and child.Name ~= "Head" then
			if transparency == 1 then
				originalTransparency[child] = child.Transparency
				child.Transparency = 1
			else
				if originalTransparency[child] then
					child.Transparency = originalTransparency[child]
				else
					child.Transparency = 0
				end
			end
		end
	end
end

local function updateControlDisplay()
	offsetLabel.Text = string.format("Смещение: X=%.1f, Y=%.1f, Z=%.1f", 
		cameraOffset.X, cameraOffset.Y, cameraOffset.Z)
	smoothnessLabel.Text = string.format("Плавность: %.2f", cameraSmoothness)
	fovLabel.Text = string.format("FOV: %d°", cameraFOV)
end

local function toggleUI()
	uiVisible = not uiVisible
	mainFrame.Visible = uiVisible

	if uiVisible then
		toggleUIButton.Text = "−"
		print("Character Spectator: Интерфейс показан")
	else
		toggleUIButton.Text = "+"
		print("Character Spectator: Интерфейс скрыт")
	end
end

local function setupKeyboardControls()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.H then
			toggleUI()
			return
		end
		
		if not cameraAttached then return end

		local step = 0.1
		local fovStep = 5
		local changed = false

		if input.KeyCode == Enum.KeyCode.Q then
			cameraOffset = Vector3.new(cameraOffset.X - step, cameraOffset.Y, cameraOffset.Z)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.E then
			cameraOffset = Vector3.new(cameraOffset.X + step, cameraOffset.Y, cameraOffset.Z)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.R then
			cameraOffset = Vector3.new(cameraOffset.X, cameraOffset.Y + step, cameraOffset.Z)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.F then
			cameraOffset = Vector3.new(cameraOffset.X, cameraOffset.Y - step, cameraOffset.Z)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.T then
			cameraOffset = Vector3.new(cameraOffset.X, cameraOffset.Y, cameraOffset.Z + step)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.G then
			cameraOffset = Vector3.new(cameraOffset.X, cameraOffset.Y, cameraOffset.Z - step)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.Z then
			cameraSmoothness = math.clamp(cameraSmoothness - 0.05, 0.05, 1.0)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.X then
			cameraSmoothness = math.clamp(cameraSmoothness + 0.05, 0.05, 1.0)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.U then
			cameraFOV = math.clamp(cameraFOV - fovStep, 10, 120)
			changed = true
			workspace.CurrentCamera.FieldOfView = cameraFOV
		elseif input.KeyCode == Enum.KeyCode.I then
			cameraFOV = math.clamp(cameraFOV + fovStep, 10, 120)
			changed = true
			workspace.CurrentCamera.FieldOfView = cameraFOV
		end

		if changed then
			updateControlDisplay()
		end
	end)
end

local function smoothCameraFollow()
	local camera = workspace.CurrentCamera
	local head = selectedHead.Head

	if not head or not head.Parent then
		return
	end

	local currentCameraCFrame = camera.CFrame

	while cameraAttached and head and head.Parent do
		RunService.RenderStepped:Wait()
		
		local headCFrame = head.CFrame
		local targetPosition = headCFrame.Position + cameraOffset
		local targetCFrame = CFrame.new(targetPosition) * headCFrame.Rotation

		local newCFrame = currentCameraCFrame:Lerp(targetCFrame, cameraSmoothness)
		camera.CFrame = newCFrame
		currentCameraCFrame = newCFrame
	end
end

local function attachCameraToHead()
	if not selectedHead then
		infoText.Text = "Сначала выберите голову из списка"
		print("Character Spectator: Ошибка - не выбрана голова")
		return
	end

	local head = selectedHead.Head
	if not head or not head.Parent then
		infoText.Text = "Ошибка: объект не найден"
		return
	end

	print("Character Spectator: Прикрепление камеры к", head:GetFullName())

	local camera = workspace.CurrentCamera
	originalCameraType = camera.CameraType
	originalCameraFOV = camera.FieldOfView

	camera.CameraType = Enum.CameraType.Scriptable

	camera.FieldOfView = cameraFOV

	setHeadAccessoriesTransparency(head, 1)

	cameraAttached = true
	attachCameraButton.Visible = false
	detachCameraButton.Visible = true
	controlFrame.Visible = true

	infoText.Text = string.format(
		"Камера прикреплена к:\n%s\n\n" ..
			"H - скрыть/показать UI\n" ..
			"Используйте клавиши для управления",
		head:GetFullName()
	)

	updateControlDisplay()

	if cameraConnection then
		cameraConnection:Disconnect()
	end

	cameraConnection = RunService.RenderStepped:Connect(function()
		if cameraAttached then
			smoothCameraFollow()
		else
			cameraConnection:Disconnect()
		end
	end)

	local escConnection
	escConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.Escape and cameraAttached then
			detachCamera()
			if escConnection then
				escConnection:Disconnect()
			end
		end
	end)
end

local function detachCamera()
	print("Character Spectator: Отсоединение камеры")
	cameraAttached = false

	if cameraConnection then
		cameraConnection:Disconnect()
		cameraConnection = nil
	end

	local camera = workspace.CurrentCamera

	if selectedHead and selectedHead.Head then
		setHeadAccessoriesTransparency(selectedHead.Head, 0)
	end

	if originalCameraFOV then
		camera.FieldOfView = originalCameraFOV
		originalCameraFOV = nil
	end

	if originalCameraType then
		camera.CameraType = originalCameraType
		originalCameraType = nil
	else
		camera.CameraType = Enum.CameraType.Custom
	end

	attachCameraButton.Visible = true
	detachCameraButton.Visible = false
	controlFrame.Visible = false

	infoText.Text = "Камера отсоединена"
end

searchButton.MouseButton1Click:Connect(function()
	updateList()
end)

attachCameraButton.MouseButton1Click:Connect(function()
	attachCameraToHead()
end)

detachCameraButton.MouseButton1Click:Connect(function()
	detachCamera()
end)

toggleUIButton.MouseButton1Click:Connect(function()
	toggleUI()
end)

wait(2)
updateList()

print("Character Spectator: загружен")
infoText.Text = "Выберите голову из списка."

setupKeyboardControls()

local resetButton = Instance.new("TextButton")
resetButton.Name = "ResetButton"
resetButton.Size = UDim2.new(0, 100, 0, 20)
resetButton.Position = UDim2.new(0.5, -50, 0, 125)
resetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resetButton.Text = "Сбросить настройки"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.Font = Enum.Font.Gotham
resetButton.TextSize = 10
resetButton.Visible = false
resetButton.Parent = controlFrame

resetButton.MouseButton1Click:Connect(function()
	cameraOffset = Vector3.new(0, 0, 0)
	cameraSmoothness = 0.15
	cameraFOV = 70

	if cameraAttached then
		workspace.CurrentCamera.FieldOfView = cameraFOV
	end

	updateControlDisplay()
end)

controlFrame.Changed:Connect(function()
	if controlFrame.Visible then
		resetButton.Visible = true
	else
		resetButton.Visible = false
	end
end)

local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

local helpLabel = Instance.new("TextLabel")
helpLabel.Name = "HelpLabel"
helpLabel.Size = UDim2.new(0, 30, 0, 30)
helpLabel.Position = UDim2.new(0, 5, 1, -35)
helpLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
helpLabel.Text = "H"
helpLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
helpLabel.Font = Enum.Font.GothamBold
helpLabel.TextSize = 12
helpLabel.Parent = mainFrame

local helpTooltip = Instance.new("TextLabel")
helpTooltip.Name = "HelpTooltip"
helpTooltip.Size = UDim2.new(0, 120, 0, 40)
helpTooltip.Position = UDim2.new(0, 40, 1, -45)
helpTooltip.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
helpTooltip.Text = "H - скрыть/показать интерфейс"
helpTooltip.TextColor3 = Color3.fromRGB(200, 200, 150)
helpTooltip.Font = Enum.Font.Gotham
helpTooltip.TextSize = 10
helpTooltip.TextWrapped = true
helpTooltip.Visible = false
helpTooltip.Parent = mainFrame

helpLabel.MouseEnter:Connect(function()
	helpTooltip.Visible = true
end)

helpLabel.MouseLeave:Connect(function()
	helpTooltip.Visible = false
end)