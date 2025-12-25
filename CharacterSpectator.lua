local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HeadFinderUI"
screenGui.ResetOnSpawn = true

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "CHARACTER SPECTATOR - Найдено: 0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local searchButton = Instance.new("TextButton")
searchButton.Name = "RefreshButton"
searchButton.Size = UDim2.new(0, 120, 0, 30)
searchButton.Position = UDim2.new(0.5, -130, 0, 105)
searchButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
searchButton.Text = "Обновить"
searchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
searchButton.Font = Enum.Font.Gotham
searchButton.TextSize = 14
searchButton.Parent = mainFrame

local attachCameraButton = Instance.new("TextButton")
attachCameraButton.Name = "AttachCameraButton"
attachCameraButton.Size = UDim2.new(0, 120, 0, 30)
attachCameraButton.Position = UDim2.new(0.5, 10, 0, 70)
attachCameraButton.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
attachCameraButton.Text = "Прикрепить камеру"
attachCameraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
attachCameraButton.Font = Enum.Font.Gotham
attachCameraButton.TextSize = 12
attachCameraButton.Parent = mainFrame

local detachCameraButton = Instance.new("TextButton")
detachCameraButton.Name = "DetachCameraButton"
detachCameraButton.Size = UDim2.new(0, 120, 0, 30)
detachCameraButton.Position = UDim2.new(0.5, 10, 0, 105)
detachCameraButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
detachCameraButton.Text = "Отсоединить камеру"
detachCameraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
detachCameraButton.Font = Enum.Font.Gotham
detachCameraButton.TextSize = 12
detachCameraButton.Visible = false
detachCameraButton.Parent = mainFrame

local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "ListFrame"
listFrame.Size = UDim2.new(1, -20, 0, 250)
listFrame.Position = UDim2.new(0, 10, 0, 145)
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
infoFrame.Size = UDim2.new(1, -20, 0, 180)
infoFrame.Position = UDim2.new(0, 10, 1, -190)
infoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
infoFrame.BorderSizePixel = 1
infoFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
infoFrame.Parent = mainFrame

local infoTitle = Instance.new("TextLabel")
infoTitle.Name = "InfoTitle"
infoTitle.Size = UDim2.new(1, 0, 0, 30)
infoTitle.Position = UDim2.new(0, 0, 0, 0)
infoTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
infoTitle.Text = "Информация о выбранной голове"
infoTitle.TextColor3 = Color3.fromRGB(255, 255, 200)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 14
infoTitle.Parent = infoFrame

local infoText = Instance.new("TextLabel")
infoText.Name = "InfoText"
infoText.Size = UDim2.new(1, -10, 1, -40)
infoText.Position = UDim2.new(0, 5, 0, 35)
infoText.BackgroundTransparency = 1
infoText.Text = "Выберите голову из списка"
infoText.TextColor3 = Color3.fromRGB(220, 220, 220)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 12
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = infoFrame

local headsList = {}
local selectedHead = nil
local cameraAttached = false
local cameraConnection = nil
local originalCameraType = nil
local originalTransparency = {} 

local cameraOffset = Vector3.new(0, 0, 0) 
local cameraSmoothness = 0.1 

local function isInAnimation(object)
	local current = object

	while current ~= nil and current ~= game do
		local className = current.ClassName
		if className == "Keyframe" or
			className == "KeyframeSequence" or
			className == "Animation" or
			className == "AnimationTrack" or
			className == "Animator" or
			className == "AnimationController" or
			className == "CharacterRig" then
			return true
		end

		local lowerName = current.Name:lower()
		if lowerName:find("anim") or 
			lowerName:find("keyframe") or 
			lowerName:find("motion") or
			lowerName:find("rig") or
			lowerName:find("pose") then
			return true
		end

		current = current.Parent
	end

	return false
end

local function isInAccessory(object)
	local current = object

	while current ~= nil and current ~= game do
		local className = current.ClassName
		if className == "Accessory" or
			className == "Hat" or
			className == "HairAccessory" or
			className == "FaceAccessory" or
			className == "NeckAccessory" or
			className == "ShoulderAccessory" or
			className == "FrontAccessory" or
			className == "BackAccessory" or
			className == "WaistAccessory" or
			className == "Clothing" then
			return true
		end

		local lowerName = current.Name:lower()
		if lowerName:find("accessory") or 
			lowerName:find("hat") or 
			lowerName:find("hair") or
			lowerName:find("clothing") or
			lowerName:find("shirt") or
			lowerName:find("pants") or
			lowerName:find("tshirt") then
			return true
		end

		current = current.Parent
	end

	return false
end


local function findHeads()
	local allHeads = {}

	local function search(object)
		if object:IsA("BaseScript") or 
			object:IsA("CoreGui") or
			object:IsA("Plugin") or
			object:IsA("PackageLink") then
			return
		end

		if object.Name == "Head" then
			if not isInAnimation(object) and not isInAccessory(object) then
				table.insert(allHeads, {
					Head = object,
					Parent = object.Parent,
					ParentType = object.Parent.ClassName,
					FullPath = object:GetFullName(),
					ParentPath = object.Parent:GetFullName()
				})
			end
		end

		for _, child in ipairs(object:GetChildren()) do
			search(child)
		end
	end

	search(game.Workspace)
	search(game.ReplicatedStorage)
	search(game.ServerStorage)
	search(game.Lighting)
	search(game.SoundService)

	return allHeads
end

local function createListItem(headData, index)
	local itemFrame = Instance.new("Frame")
	itemFrame.Name = "Item_" .. index
	itemFrame.Size = UDim2.new(1, 0, 0, 30)
	itemFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	itemFrame.BorderSizePixel = 0
	itemFrame.LayoutOrder = index

	local itemButton = Instance.new("TextButton")
	itemButton.Name = "SelectButton"
	itemButton.Size = UDim2.new(1, 0, 1, 0)
	itemButton.BackgroundTransparency = 1
	itemButton.Text = ""
	itemButton.Parent = itemFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 5, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "Head #" .. index .. " (" .. headData.Parent.Name .. ")"
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 12
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = itemFrame

	local parentLabel = Instance.new("TextLabel")
	parentLabel.Name = "ParentLabel"
	parentLabel.Size = UDim2.new(0.25, -5, 1, 0)
	parentLabel.Position = UDim2.new(0.75, 0, 0, 0)
	parentLabel.BackgroundTransparency = 1
	parentLabel.Text = headData.ParentType
	parentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	parentLabel.Font = Enum.Font.Gotham
	parentLabel.TextSize = 11
	parentLabel.TextXAlignment = Enum.TextXAlignment.Right
	parentLabel.Parent = itemFrame

	itemButton.MouseButton1Click:Connect(function()
		for _, item in ipairs(listFrame:GetChildren()) do
			if item:IsA("Frame") then
				item.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			end
		end

		itemFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
		selectedHead = headData

		infoText.Text = string.format(
			"Объект: Head\n" ..
				"Полный путь: %s\n\n" ..
				"Родитель: %s\n" ..
				"Тип родителя: %s\n" ..
				"Путь к родителю: %s\n\n" ..
				"Дочерние объекты: %d",
			headData.FullPath,
			headData.Parent.Name,
			headData.ParentType,
			headData.ParentPath,
			#headData.Head:GetChildren()
		)
	end)

	return itemFrame
end

local function updateList()
	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	headsList = findHeads()
	title.Text = "CHARACTER SPECTATOR - Найдено: " .. #headsList

	local totalHeight = 0
	for i, headData in ipairs(headsList) do
		local item = createListItem(headData, i)
		item.Parent = listFrame
		totalHeight = totalHeight + item.Size.Y.Offset + 2
	end

	listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

	if #headsList == 0 then
		infoText.Text = "Головы не найдены"
	else
		infoText.Text = "Выберите голову из списка"
	end
	selectedHead = nil
end

local function setHeadAccessoriesTransparency(head, transparency)
	if transparency == 1 then
		originalTransparency = {}
	end

	local function processObject(obj)
		if obj:IsA("BasePart") and obj.Name ~= "Head" then
			if transparency == 1 then
				originalTransparency[obj] = obj.Transparency
			end
			obj.Transparency = transparency

			if obj:IsA("MeshPart") and transparency == 1 then
				originalTransparency[obj.."_Texture"] = obj.TextureID
				obj.TextureID = ""
			elseif obj:IsA("MeshPart") and transparency == 0 and originalTransparency[obj.."_Texture"] then
				obj.TextureID = originalTransparency[obj.."_Texture"]
			end
		end
		for _, child in ipairs(obj:GetChildren()) do
			processObject(child)
		end
	end

	for _, child in ipairs(head:GetChildren()) do
		processObject(child)
	end

	if head.Parent and head.Parent:IsA("Model") then
		for _, accessory in ipairs(head.Parent:GetChildren()) do
			if accessory:IsA("Accessory") or accessory:IsA("Hat") then
				local handle = accessory:FindFirstChild("Handle")
				if handle then
					for _, weld in ipairs(handle:GetChildren()) do
						if (weld:IsA("WeldConstraint") or weld:IsA("Motor6D")) and 
							(weld.Part0 == head or weld.Part1 == head or 
								weld.Attachment0 and weld.Attachment0.Parent == head or
								weld.Attachment1 and weld.Attachment1.Parent == head) then
							processObject(accessory)
							break
						end
					end
				end
			end
		end
	end
end

local function restoreHeadAccessoriesTransparency(head)
	for obj, transparency in pairs(originalTransparency) do
		if type(obj) == "string" and obj:find("_Texture$") then
		else
			if obj and obj.Parent then
				pcall(function()
					obj.Transparency = transparency
				end)
			end
		end
	end
	originalTransparency = {}
end
local function smoothCameraFollow()
	local camera = workspace.CurrentCamera
	local head = selectedHead.Head
	if not head or not head.Parent then
		return
	end
	local currentCameraCFrame = camera.CFrame
	local smoothFactor = cameraSmoothness
	while cameraAttached and head and head.Parent do
		local dt = RunService.RenderStepped:Wait()
		local headCFrame = head.CFrame
		local targetPosition = headCFrame.Position + cameraOffset
		local targetCFrame = CFrame.new(targetPosition) * headCFrame.Rotation
		local newCFrame = currentCameraCFrame:Lerp(targetCFrame, smoothFactor)
		camera.CFrame = newCFrame
		currentCameraCFrame = newCFrame
	end
end
local function attachCameraToHead()
	if not selectedHead then
		infoText.Text = "Сначала выберите голову из списка"
		return
	end

	local head = selectedHead.Head
	head.Transparency=1
	if not head or not head.Parent then
		infoText.Text = "Голова не была найдена :с"
		return
	end

	local camera = workspace.CurrentCamera
	originalCameraType = camera.CameraType
	camera.CameraType = Enum.CameraType.Scriptable
	local headCFrame = head.CFrame
	local startPosition = headCFrame.Position + cameraOffset
	camera.CFrame = CFrame.new(startPosition) * headCFrame.Rotation
	setHeadAccessoriesTransparency(head, 1)
	cameraAttached = true
	attachCameraButton.Visible = false
	detachCameraButton.Visible = true
	infoText.Text = string.format(
		"Камера прикреплена к:\n%s\n\n" ..
			"Камера смотрит в ту же сторону, что и голова\n" ..
			"Сделано DingusSherry",
		head:GetFullName()
	)
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
	local escapeConnection = nil
	escapeConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.Escape and cameraAttached then
			detachCamera()
			if escapeConnection then
				escapeConnection:Disconnect()
			end
		end
	end)
end
local function detachCamera()
	cameraAttached = false

	if cameraConnection then
		cameraConnection:Disconnect()
		cameraConnection = nil
	end
	local head = selectedHead.Head
	head.Transparency=0
	local camera = workspace.CurrentCamera
	if selectedHead and selectedHead.Head then
		restoreHeadAccessoriesTransparency(selectedHead.Head)
	end
	if originalCameraType then
		camera.CameraType = originalCameraType
		originalCameraType = nil
	else
		camera.CameraType = Enum.CameraType.Custom
	end
	attachCameraButton.Visible = true
	detachCameraButton.Visible = false
	if selectedHead then
		infoText.Text = string.format(
			"Камера отсоединена\n\n" ..
				"Объект: %s\n" ..
				"Прозрачность аксессуаров восстановлена",
			selectedHead.Head:GetFullName()
		)
	else
		infoText.Text = "Камера отсоединена"
	end
end
local function updateCameraParamsDisplay()
	if cameraOffsetLabel then
		cameraOffsetLabel.Text = string.format("Смещение: X=%.1f, Y=%.1f, Z=%.1f", 
			cameraOffset.X, cameraOffset.Y, cameraOffset.Z)
	end
	if smoothnessLabel then
		smoothnessLabel.Text = string.format("Плавность: %.2f", cameraSmoothness)
	end
end
local paramsFrame = Instance.new("Frame")
paramsFrame.Name = "ParamsFrame"
paramsFrame.Size = UDim2.new(1, -20, 0, 80)
paramsFrame.Position = UDim2.new(0, 10, 0, 400)
paramsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
paramsFrame.BorderSizePixel = 1
paramsFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
paramsFrame.Parent = mainFrame

local paramsTitle = Instance.new("TextLabel")
paramsTitle.Name = "ParamsTitle"
paramsTitle.Size = UDim2.new(1, 0, 0, 20)
paramsTitle.Position = UDim2.new(0, 0, 0, 0)
paramsTitle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
paramsTitle.Text = "Параметры камеры"
paramsTitle.TextColor3 = Color3.fromRGB(255, 255, 200)
paramsTitle.Font = Enum.Font.GothamBold
paramsTitle.TextSize = 12
paramsTitle.Parent = paramsFrame

cameraOffsetLabel = Instance.new("TextLabel")
cameraOffsetLabel.Name = "CameraOffsetLabel"
cameraOffsetLabel.Size = UDim2.new(1, -10, 0, 20)
cameraOffsetLabel.Position = UDim2.new(0, 5, 0, 25)
cameraOffsetLabel.BackgroundTransparency = 1
cameraOffsetLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
cameraOffsetLabel.Font = Enum.Font.Gotham
cameraOffsetLabel.TextSize = 11
cameraOffsetLabel.TextXAlignment = Enum.TextXAlignment.Left
cameraOffsetLabel.Parent = paramsFrame

smoothnessLabel = Instance.new("TextLabel")
smoothnessLabel.Name = "SmoothnessLabel"
smoothnessLabel.Size = UDim2.new(1, -10, 0, 20)
smoothnessLabel.Position = UDim2.new(0, 5, 0, 45)
smoothnessLabel.BackgroundTransparency = 1
smoothnessLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
smoothnessLabel.Font = Enum.Font.Gotham
smoothnessLabel.TextSize = 11
smoothnessLabel.TextXAlignment = Enum.TextXAlignment.Left
smoothnessLabel.Parent = paramsFrame

local function createParamButton(name, text, position, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 80, 0, 20)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 11
	button.Parent = paramsFrame

	button.MouseButton1Click:Connect(callback)
	return button
end

createParamButton("ResetOffsetBtn", "Сброс смещения", UDim2.new(0, 5, 0, 65), function()
	cameraOffset = Vector3.new(0, 0, 0)
	updateCameraParamsDisplay()
end)

createParamButton("ResetSmoothBtn", "Сброс плавности", UDim2.new(0.5, -40, 0, 65), function()
	cameraSmoothness = 0.1
	updateCameraParamsDisplay()
end)

local function setupKeyboardControls()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or not cameraAttached then return end

		local step = 0.1
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
			cameraSmoothness = math.clamp(cameraSmoothness - 0.05, 0.05, 0.5)
			changed = true
		elseif input.KeyCode == Enum.KeyCode.X then
			cameraSmoothness = math.clamp(cameraSmoothness + 0.05, 0.05, 0.5)
			changed = true
		end

		if changed then
			updateCameraParamsDisplay()
		end
	end)
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
screenGui.Parent = PlayerGui
updateCameraParamsDisplay()
setupKeyboardControls()
wait(1)
updateList()

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

screenGui.Destroying:Connect(function()
	if cameraAttached then
		detachCamera()
	end
end)
