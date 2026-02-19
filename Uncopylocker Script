local password = "Hydro_Premium"
local attempts = 0

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HYDRO_PREMIUM_DECOMPILER"
gui.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 440, 0, 280)
frame.Position = UDim2.new(0.5, -220, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Hydro DECOMPILER PREMIUM"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Input
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -40, 0, 35)
input.Position = UDim2.new(0, 20, 0, 65)
input.PlaceholderText = "🔒 Enter Password"
input.Text = ""
input.Font = Enum.Font.Gotham
input.TextSize = 16
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
input.ClearTextOnFocus = false
input.Parent = frame

local inputCorner = Instance.new("UICorner", input)
inputCorner.CornerRadius = UDim.new(0, 4)

-- Unlock Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -40, 0, 40)
button.Position = UDim2.new(0, 20, 0, 115)
button.Text = "🔓 Unlock"
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.Parent = frame

local buttonCorner = Instance.new("UICorner", button)
buttonCorner.CornerRadius = UDim.new(0, 4)

-- Copy Button (hidden)
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, -40, 0, 40)
copyButton.Position = UDim2.new(0, 20, 0, 165)
copyButton.Text = "📁 Copy with Scripts!"
copyButton.Font = Enum.Font.GothamBold
copyButton.TextSize = 18
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
copyButton.Visible = false
copyButton.Parent = frame

local copyCorner = Instance.new("UICorner", copyButton)
copyCorner.CornerRadius = UDim.new(0, 4)

-- Status Label
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 30)
status.Position = UDim2.new(0, 20, 0, 215)
status.BackgroundTransparency = 1
status.Text = "🔧 Status: Waiting for password..."
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1
footer.Text = "⚠️ 3 Attempts Only | Made by APZ.XX | Hydro_Premium "
footer.Font = Enum.Font.Gotham
footer.TextSize = 14
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.Parent = frame

-- Unlock Button Function
button.MouseButton1Click:Connect(function()
	if input.Text == password then
		title.Text = "✅ Access Granted"
		status.Text = "🔓 Unlocked. Click 'Copy with Scripts!'"
		button.Visible = false
		input.Visible = false
		copyButton.Visible = true
	else
		attempts += 1
		status.Text = "❌ Wrong Password ("..attempts.."/3)"
		if attempts >= 3 then
			title.Text = "⛔ Too Many Failed Attempts"
			wait(1)
			gui:Destroy()
		end
	end
end)

-- Copy Button Function
copyButton.MouseButton1Click:Connect(function()
	status.Text = "📁 Copying game with scripts..."

local success, err = pcall(function()
    local saveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"))()
    saveinstance({
        FileName = "UNCOPYLOCKED"..game.PlaceId..".rbxlx",
        Decompile = true,
        IncludeScripts = true,
        CreatorTag = "Thanks for buying!"
    })

    status.Text = "✅ Game copied & saved. Thank you for your support!"
end)

	if not success then
		status.Text = "❌ Failed to copy game: "..tostring(err)
	end

	wait(2)
	-- Optional shutdown if supported
	-- pcall(function() game:Shutdown() end)
end)
