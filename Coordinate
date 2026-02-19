-- Coordinates GUI mit Copy-Buttons (X, Y, Z, All)
-- In LocalScript einfügen (z.B. StarterPlayerScripts)

local player = game.Players.LocalPlayer

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordinatesGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Hauptframe
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.35, 0, 0.12, 0)
frame.Position = UDim2.new(0.33, 0, 0.85, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Hilfsfunktion Button erstellen
local function makeButton(name, offsetX, sizeX, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(sizeX, -2, 0.5, -2)
    btn.Position = UDim2.new(offsetX, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Name = name.."Button"
    btn.Parent = parent
    return btn
end

-- Buttons: X, Y, Z (oben)
local xBtn = makeButton("X", 0, 0.33, frame)
local yBtn = makeButton("Y", 0.33, 0.33, frame)
local zBtn = makeButton("Z", 0.66, 0.33, frame)

-- Button: Copy All (unten)
local allBtn = Instance.new("TextButton")
allBtn.Size = UDim2.new(1, -2, 0.5, -2)
allBtn.Position = UDim2.new(0, 0, 0.5, 0)
allBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
allBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
allBtn.TextScaled = true
allBtn.Text = "Copy All"
allBtn.Name = "AllButton"
allBtn.Parent = frame

-- Clipboard helper
local function copyToClipboard(value)
    if setclipboard then
        setclipboard(tostring(value))
    else
        warn("setclipboard nicht verfügbar.")
    end
end

-- Update Funktion
local function updateCoordinates()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    while true do
        local pos = hrp.Position
        xBtn.Text = string.format("X: %.2f", pos.X)
        yBtn.Text = string.format("Y: %.2f", pos.Y)
        zBtn.Text = string.format("Z: %.2f", pos.Z)
        task.wait(0.1)
    end
end

-- Klick-Events → kopieren
xBtn.MouseButton1Click:Connect(function()
    local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if pos then copyToClipboard(pos.Position.X) end
end)

yBtn.MouseButton1Click:Connect(function()
    local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if pos then copyToClipboard(pos.Position.Y) end
end)

zBtn.MouseButton1Click:Connect(function()
    local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if pos then copyToClipboard(pos.Position.Z) end
end)

allBtn.MouseButton1Click:Connect(function()
    local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if pos then
        local coords = string.format("X: %.2f, Y: %.2f, Z: %.2f", pos.Position.X, pos.Position.Y, pos.Position.Z)
        copyToClipboard(coords)
    end
end)

-- Start updater
task.spawn(updateCoordinates)
