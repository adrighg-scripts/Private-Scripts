-- ===== SERVICES =====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ===== STATE =====
local running = false
local positions = {}
local currentIndex = 1
local delay = 0.1
local lastCFrame
local uiVisible = true

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "AdvancedTeleportUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromOffset(480, 380)
frame.Position = UDim2.fromOffset(100, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 10

-- ===== DRAG BAR =====
local dragBar = Instance.new("TextLabel")
dragBar.Parent = frame
dragBar.Size = UDim2.new(1, 0, 0, 28)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
dragBar.Text = "Drag Me | Right Ctrl = Toggle UI"
dragBar.TextColor3 = Color3.new(1,1,1)
dragBar.Font = Enum.Font.SourceSansBold
dragBar.TextSize = 16
dragBar.TextXAlignment = Enum.TextXAlignment.Center
dragBar.TextYAlignment = Enum.TextYAlignment.Center
dragBar.Active = true
dragBar.ZIndex = 20

local dragging = false
local dragStart
local startPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

dragBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
	end
end)

-- ===== POSITION TEXTBOX =====
local positionBox = Instance.new("TextBox")
positionBox.Parent = frame
positionBox.Position = UDim2.fromOffset(10, 40)
positionBox.Size = UDim2.fromOffset(460, 160)
positionBox.MultiLine = true
positionBox.ClearTextOnFocus = false
positionBox.TextXAlignment = Enum.TextXAlignment.Left
positionBox.TextYAlignment = Enum.TextYAlignment.Top
positionBox.Font = Enum.Font.Code
positionBox.TextSize = 14
positionBox.TextColor3 = Color3.new(1,1,1)
positionBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
positionBox.Text = "-- Vector3.new(x,y,z)\n"
positionBox.ZIndex = 11

-- ===== BUTTON CREATOR =====
local function makeButton(text, x, y, w)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.fromOffset(w or 110, 30)
	b.Position = UDim2.fromOffset(x, y)
	b.Text = text
	b.Font = Enum.Font.SourceSans
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.AutoButtonColor = true
	b.Active = true
	b.ZIndex = 12
	return b
end

-- ===== BUTTONS =====
local startBtn   = makeButton("Start", 10, 210)
local stopBtn    = makeButton("Stop", 130, 210)
local closeBtn   = makeButton("Close", 370, 210, 100)
local importBtn  = makeButton("Clipboard Import", 10, 250, 180)
local delBtn     = makeButton("Delete Last TP", 200, 250, 150)

-- ===== SLIDER =====
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Parent = frame
sliderLabel.Position = UDim2.fromOffset(10, 295)
sliderLabel.Size = UDim2.fromOffset(200, 20)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Delay: 0.10s"
sliderLabel.TextColor3 = Color3.new(1,1,1)
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 16
sliderLabel.ZIndex = 11

local sliderBar = Instance.new("Frame")
sliderBar.Parent = frame
sliderBar.Position = UDim2.fromOffset(10, 320)
sliderBar.Size = UDim2.fromOffset(460, 6)
sliderBar.BackgroundColor3 = Color3.fromRGB(80,80,80)
sliderBar.ZIndex = 11
sliderBar.Active = true

local sliderKnob = Instance.new("Frame")
sliderKnob.Parent = sliderBar
sliderKnob.Size = UDim2.fromOffset(12, 14)
sliderKnob.Position = UDim2.new(0.01, -6, -0.7, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(220,220,220)
sliderKnob.ZIndex = 12
sliderKnob.Active = true

local draggingKnob = false
sliderKnob.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingKnob = true
	end
end)
sliderKnob.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingKnob = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if draggingKnob and i.UserInputType == Enum.UserInputType.MouseMovement then
		local scale = math.clamp((i.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		sliderKnob.Position = UDim2.new(scale, -6, -0.7, 0)
		delay = math.floor((scale * 10) * 100) / 100
		if delay < 0.01 then delay = 0.01 end
		sliderLabel.Text = "Delay: "..delay.."s"
	end
end)

-- ===== FUNCTIONS =====
local function parsePositionsFromBox()
	positions = {}
	for line in positionBox.Text:gmatch("[^\r\n]+") do
		local f = loadstring("return "..line)
		if f then
			local ok, v = pcall(f)
			if ok and typeof(v) == "Vector3" then
				table.insert(positions, v)
			end
		end
	end
	currentIndex = 1
end

-- ===== CTRL+CLICK TELEPORT (No TextBox Update) =====
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	-- Toggle UI visibility with Right Ctrl
	if input.KeyCode == Enum.KeyCode.RightControl then
		uiVisible = not uiVisible
		frame.Visible = uiVisible
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1
	and (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)) then
		local mousePos = UIS:GetMouseLocation()
		local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
		local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
		if result then
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				lastCFrame = hrp.CFrame
				hrp.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0))
				table.insert(positions, result.Position)
				-- TextBox NOT updated
			end
		end
	end
end)

-- ===== TELEPORT LOOP =====
task.spawn(function()
	while task.wait(delay) do
		if running and positions[currentIndex] then
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				lastCFrame = hrp.CFrame
				hrp.CFrame = CFrame.new(positions[currentIndex] + Vector3.new(0,3,0))
				currentIndex += 1
			end
			if currentIndex > #positions then
				running = false
			end
		end
	end
end)

-- ===== BUTTON LOGIC =====
startBtn.MouseButton1Click:Connect(function()
	parsePositionsFromBox()
	if #positions > 0 then running = true end
end)

stopBtn.MouseButton1Click:Connect(function()
	running = false
end)

importBtn.MouseButton1Click:Connect(function()
	if getclipboard then
		positionBox.Text = getclipboard() -- replaces all previous content
	end
end)

delBtn.MouseButton1Click:Connect(function()
	if #positions > 0 then
		local lastPos = table.remove(positions, #positions)
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp and lastCFrame then
			hrp.CFrame = lastCFrame
		end
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	running = false
	gui:Destroy()
end)

print("✅ Advanced Teleport UI loaded | CTRL+Click Teleport without TextBox update | Dragbar active | Slider 0-10s | Clipboard Import replaces content")
