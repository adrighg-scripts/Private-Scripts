-- Keybind Infos
print("Close Script = F8")
print("Enable Esp = F1")
print("Aimbot (Hold Right Click) = F2")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local running = true
local currentMode = "solo"
local aimbotActive = false
local f2Enabled = false
local targetPlayer = nil
local espLoaded = false

-------------------------------------------------
-- Hilfsfunktionen
-------------------------------------------------

-- Sucht den Spieler, dessen Kopf am nächsten zur Bildschirmmitte ist
local function getClosestEnemyToScreenCenter(maxDistance)
    local closestHead = nil
    local closestPlayer = nil
    local smallestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local isEnemy = true
                if currentMode == "team" and player.Team and otherPlayer.Team then
                    isEnemy = player.Team ~= otherPlayer.Team
                end
                
                if isEnemy then
                    local head = otherPlayer.Character.Head
                    local distanceToPlayer = (player.Character.HumanoidRootPart.Position - head.Position).Magnitude
                    if distanceToPlayer <= maxDistance then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if distFromCenter < smallestDistance then
                                smallestDistance = distFromCenter
                                closestHead = head
                                closestPlayer = otherPlayer
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- ESP Script laden
local function loadESPScript()
    if not espLoaded then
        espLoaded = true
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP'))()
        StarterGui:SetCore("SendNotification", {
            Title = "ESP Loaded";
            Text = "ESP features activated";
            Duration = 4
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "ESP Already Loaded";
            Text = "ESP is already running";
            Duration = 3
        })
    end
end

-------------------------------------------------
-- Kamera auf Ziel setzen (läuft jedes Frame)
-------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not running then return end
    
    if aimbotActive and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPlayer.Character.Head.Position)
    end
end)

-------------------------------------------------
-- Eingaben
-------------------------------------------------

-- F1: ESP Script laden
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        loadESPScript()
    end
end)

-- F2: Aimbot-Modus an/aus
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F2 then
        f2Enabled = not f2Enabled
        StarterGui:SetCore("SendNotification", {
            Title = "Aimbot Mode";
            Text = f2Enabled and "Enabled (Hold Right Click)" or "Disabled";
            Duration = 4
        })
    end
end)

-- Rechtsklick gedrückt = Lock auf Spieler (Screen-Center Auswahl)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if f2Enabled then
            local target = getClosestEnemyToScreenCenter(500) -- max Distanz z. B. 200 studs
            if target then
                targetPlayer = target
                aimbotActive = true
            end
        end
    end
end)

-- Rechtsklick loslassen = Lock lösen
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if f2Enabled then
            aimbotActive = false
            targetPlayer = nil
        end
    end
end)

-- F8: Script schließen
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        running = false
        aimbotActive = false
        targetPlayer = nil
        print("Script closed.")
        StarterGui:SetCore("SendNotification", {
            Title = "Script Closed";
            Text = "Closed Script Hub";
            Duration = 3
        })
    end
end)

-------------------------------------------------
-- Begrüßung
-------------------------------------------------
StarterGui:SetCore("SendNotification", {
    Title = "Script Hub Loaded";
    Text = "Hello, " .. player.DisplayName .. "!\nCheck F9 console for keybinds.";
    Icon = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=180&h=180";
    Duration = 8
})