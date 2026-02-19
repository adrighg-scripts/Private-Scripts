loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
-- LocalScript in StarterGui

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local uis = game:GetService("UserInputService")

-- GUI erstellen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BackpackUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0.8, 0)
frame.Position = UDim2.new(1, -190, 0.1, 0)
frame.BackgroundTransparency = 1
frame.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = frame

-- Hilfsfunktion
local function createCorner(parent)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = parent
end

-- Variablen
local equipped = nil
local buttons = {}
local slotMap = {} -- [ItemName] = SlotNumber (1–10)

-- Feste Slot-Reihenfolge
local function getFreeSlot()
	for i = 1, 10 do
		local found = false
		for _, slot in pairs(slotMap) do
			if slot == i then
				found = true
				break
			end
		end
		if not found then
			return i
		end
	end
	return nil
end

-- UI aktualisieren
local function refreshUI()
	for _, b in pairs(buttons) do
		b:Destroy()
	end
	buttons = {}

	local items = backpack:GetChildren()
	for _, tool in ipairs(items) do
		if tool:IsA("Tool") then
			-- Wenn Item noch keinen festen Slot hat, einen zuweisen
			if not slotMap[tool.Name] then
				local free = getFreeSlot()
				if free then
					slotMap[tool.Name] = free
				end
			end

			local slot = slotMap[tool.Name]
			local displayNum = (slot == 10) and 0 or slot

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -20, 0, 34)
			btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
			btn.TextColor3 = Color3.fromRGB(30, 30, 30)
			btn.Font = Enum.Font.GothamSemibold
			btn.TextSize = 16
			btn.Text = string.format("[%d] %s", displayNum, tool.Name)
			btn.AutoButtonColor = false
			btn.Parent = frame
			createCorner(btn)

			-- Hover-Highlight
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
			end)
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
			end)

			-- Equip/Unequip beim Klick
			btn.MouseButton1Click:Connect(function()
				if equipped == tool then
					tool.Parent = backpack
					equipped = nil
				else
					if equipped then equipped.Parent = backpack end
					tool.Parent = player.Character
					equipped = tool
				end
			end)

			buttons[slot] = btn
		end
	end
end

-- Zahlentasten für Equip
uis.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		local index
		if key == Enum.KeyCode.Zero then index = 10 end
		for i = 1, 9 do
			if key == Enum.KeyCode["" .. i] then
				index = i
				break
			end
		end

		if index then
			for name, slot in pairs(slotMap) do
				if slot == index then
					local tool = backpack:FindFirstChild(name)
					if tool and tool:IsA("Tool") then
						if equipped == tool then
							tool.Parent = backpack
							equipped = nil
						else
							if equipped then equipped.Parent = backpack end
							tool.Parent = player.Character
							equipped = tool
						end
					end
					break
				end
			end
		end
	end
end)

-- Backpack-Änderungen erkennen
backpack.ChildAdded:Connect(refreshUI)
backpack.ChildRemoved:Connect(refreshUI)

refreshUI()
