-- LocalScript – Client Only
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- === GUI Setup ===
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "FollowAttackUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.ZIndex = 10

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.ZIndex = 11

local Dropdown = Instance.new("TextButton", Frame)
Dropdown.Size = UDim2.new(1, -20, 0, 30)
Dropdown.Position = UDim2.new(0, 10, 0, 40)
Dropdown.Text = "Select Player"
Dropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
Dropdown.TextColor3 = Color3.new(1,1,1)
Dropdown.ZIndex = 11

local PlayerListFrame = Instance.new("Frame", Frame)
PlayerListFrame.Size = UDim2.new(1, -20, 0, 100)
PlayerListFrame.Position = UDim2.new(0, 10, 0, 80)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 12

local UIListLayout = Instance.new("UIListLayout", PlayerListFrame)
UIListLayout.Padding = UDim.new(0,5)

local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 1, -40)
ToggleButton.Text = "Go"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.ZIndex = 11

-- === Variablen ===
local selectedPlayer = nil
local running = false
local followDistance = 3
local toolUseDistance = 5

-- === Dropdown Handling ===
local function refreshPlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", PlayerListFrame)
            btn.Size = UDim2.new(1, 0, 0, 25)

            -- Anzeige: DisplayName (Username)
            btn.Text = plr.DisplayName .. " (" .. plr.Name .. ")"

            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.ZIndex = 13
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                Dropdown.Text = "Target: " .. plr.DisplayName .. " (" .. plr.Name .. ")"
                PlayerListFrame.Visible = false
            end)
        end
    end
end

Dropdown.MouseButton1Click:Connect(function()
    if running then
        running = false
        ToggleButton.Text = "Go"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
    end
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then refreshPlayerList() end
end)

Players.PlayerRemoving:Connect(function(plr)
    if selectedPlayer == plr then
        running = false
        ToggleButton.Text = "Go"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
        selectedPlayer = nil
    end
end)

-- === Close Button ===
CloseBtn.MouseButton1Click:Connect(function()
    running = false
    task.wait(0.2)

    if LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if root then root.Anchored = false end
        if humanoid then humanoid:MoveTo(root.Position) end
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

-- === Tool Funktionen ===
local ToolSequence = {
    {Name = "Medusa's Head", Delay = 3},
    {Name = "Bee Launcher", Delay = 1},
    {Name = "Boogie Bomb", Delay = 5},
    {Name = "Trap", Delay = 0}, 
    {Name = "Rage Table", Delay = 2},
    {Name = "All Seeing Sentry", Delay = 0.5},
    {Name = "Taser Gun", Delay = 2.5}
}

local function equipTool(toolName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if not char then return nil end

    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") and item.Name ~= toolName then
            item.Parent = backpack
        end
    end

    local tool = backpack and backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = char
        task.wait(0.3)
        return tool
    end
end

local function unequipTool(toolName)
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChild(toolName)
    if tool then
        tool.Parent = LocalPlayer.Backpack
        task.wait(0.2)
    end
end

local function useToolWithCoil(toolName, target)
    unequipTool("Coil Combo")
    local tool = equipTool(toolName)
    if tool then
        local char = LocalPlayer.Character
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        local root = char:FindFirstChild("HumanoidRootPart")
        if tr and root then
            root.CFrame = CFrame.new(root.Position, tr.Position)
        end
        pcall(function() tool:Activate() end)
        task.wait(1)
        unequipTool(toolName)
    end
    equipTool("Coil Combo")
end

-- === Pathfinding optimiert ===
local function followTargetAI(target)
    spawn(function()
        while running do
            if not (target and target.Character and LocalPlayer.Character) then
                task.wait(0.1)
                continue
            end

            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")

            if targetHRP and localHRP and humanoid then
                local distance = (localHRP.Position - targetHRP.Position).Magnitude

                if distance > followDistance + 1 then
                    local path = PathfindingService:CreatePath({
                        AgentRadius = 2,
                        AgentHeight = 5,
                        AgentCanJump = true,
                        AgentJumpHeight = 10,
                        AgentMaxSlope = 45,
                    })
                    path:ComputeAsync(localHRP.Position, targetHRP.Position)
                    local waypoints = path:GetWaypoints()

                    for _, waypoint in ipairs(waypoints) do
                        if not running then break end
                        humanoid:MoveTo(waypoint.Position)
                        humanoid.MoveToFinished:Wait()
                        if (localHRP.Position - targetHRP.Position).Magnitude <= followDistance then
                            break
                        end
                    end
                else
                    humanoid:MoveTo(localHRP.Position + Vector3.new(0,0,0)) -- keine Zickzack-Bewegung
                end
            end
            task.wait(0.2)
        end
    end)
end

-- === Main Loop ===
local function startLoop()
    if not selectedPlayer then return end

    if LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name ~= "Coil Combo" then
                unequipTool(item.Name)
            end
        end
    end

    running = true
    ToggleButton.Text = "Stop"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(200,0,0)

    equipTool("Coil Combo")
    followTargetAI(selectedPlayer)

    spawn(function()
        while running do
            if selectedPlayer and LocalPlayer.Character then
                local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetHRP = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                if localHRP and targetHRP then
                    local distance = (localHRP.Position - targetHRP.Position).Magnitude
                    if distance <= toolUseDistance then
                        for _, step in ipairs(ToolSequence) do
                            if not running then break end
                            useToolWithCoil(step.Name, selectedPlayer)
                            task.wait(step.Delay)
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    if running then
        running = false
        ToggleButton.Text = "Go"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
    else
        if selectedPlayer then startLoop() end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if running and selectedPlayer then
        task.wait(1)
        startLoop()
    end
end)

loadstring(game:HttpGet('https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP'))()
