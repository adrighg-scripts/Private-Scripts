local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- ============================================
-- >>> DEIN TOKEN (WIE IM TEST) <<<
-- ============================================
local MEIN_TOKEN = ""

-- ============================================
-- SCRIPT LISTE
-- ============================================
local SCRIPTS = {
    {
        name = "APOC ULTIMATIV.lua",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/APOC%20ULTIMATIV.lua",
        description = "Rain Hub + my Esp and Aimbot"
    },
    {
        name = "Aimbot Apocalypse Rising 2",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Aimbot%20Apocalypse%20Rising%202",
        description = "My Aimbot for Apocalypse Rising 2"
    },
    {
        name = "Aimbot und Esp Apocalypse Rising 2",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Aimbot%20und%20Esp%20Apocalypse%20Rising%202",
        description = "My Aimbot and Esp for Apocalypse Rising 2"
    },
    {
        name = "Anti Afk",
        url = "https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn",
        description = "Turns of the 20 Min Afk Kick"
    },
    {
        name = "Apocalypse Rising 2 (My)",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Apocalypse%20Rising%202%20(My)",
        description = "My own Apocalypse Rising 2 Script Hub (unfinished)"
    },
    {
        name = "Auto Execute Template",
        url = "",
        description = "My Template for Auto Executing File"
    },
    {
        name = "Brookhaven TROLL",
        url = "https://rawscripts.net/raw/Brookhaven-RP-C00LKIDD-HUB-atualizado-74293",
        description = "Script to Troll in Brookhaven"
    },
    {
        name = "Build a Boat for a Treasure",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Build%20a%20Boat%20for%20a%20Treasure",
        description = "Just a FREE Babft"
    },
    {
        name = "Build a Boat for a Treasure (Key)",
        url = "https://raw.githubusercontent.com/TheRealAsu/BABFT/refs/heads/main/Loader.lua",
        description = "A Babft Script but requieres a Key"
    },
    {
        name = "Car Crushers 2",
        url = "https://soggyhubv2.vercel.app",
        description = "Key Car Crushers 2 Script"
    },
        {
        name = "Car Crushers 2 Keyless",
        url = "https://raw.githubusercontent.com/Breadido/main_scripts/main/Car_Crushers_2.lua",
        description = "Basic Car Crushers 2 Script"
    },
    {
        name = "Coordinate",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Coordinate",
        description = "Shows your current Coordinates and you can copy them"
    },
    {
        name = "Delete Parts",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Delete%20Parts",
        description = "Lets you delete Parts and bring them back"
    },
    {
        name = "Esp Apocalypse Rising 2",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Esp%20Apocalypse%20Rising%202",
        description = "Esp for Apocalypse Rising 2"
    },
    {
        name = "Every Emote",
        url = "https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua",
        description = "Lets you use every Emote"
    },
    {
        name = "Fisch Script",
        url = "https://raw.githubusercontent.com/yolobradda/eclipsefisch/refs/heads/main/eclipsefisch",
        description = "A useful script for Fisch"
    },
    {
        name = "Fling Things and People",
        url = "https://rawscripts.net/raw/Fling-Things-and-People-FTAP-VHS-15769",
        description = "Pretty fun to use"
    },
    {
        name = "Game Id Teller",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Game%20Id%20Teller",
        description = "Tells you the current Game and Place Id"
    },
    {
        name = "Infinite Yield",
        url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
        description = "Lets you execute hundreds of commands"
    },
    {
        name = "Jerk Scripts",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Jerk%20Scripts",
        description = "Lets you jerk off in R6,R15 and R34"
    },
    {
        name = "Knockout",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Knockout",
        description = "A Knockout auto win script"
    },
    {
        name = "Limb Extender",
        url = "https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/UI_LimbExtender.lua",
        description = "Limb extender also a Head Expander"
    },
    {
        name = "Obby Creator",
        url = "https://raw.githubusercontent.com/Blocky69/boblus-scriptz/refs/heads/main/oc",
        description = "Obby Creator Troll Script"
    },
    {
        name = "Quiz Script",
        url = "https://raw.githubusercontent.com/Damian-11/quizbot/master/quizbot.luau",
        description = "Lets you do Quizes in the Chat"
    },
    {
        name = "Rain Hub Apocalypse Rising 2",
        url = "https://raiidev.xyz/rain/loader",
        description = "Best Apocalypse Rising 2 Script but with a Key"
    },
    {
        name = "Script Hub",
        url = "https://pastebin.com/raw/Wf9z70eE",
        description = "A very old Scripthub (not good)"
    },
    {
        name = "Slap Battles",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Slap%20Battles",
        description = "A useful Slap Battles Script"
    },
    {
        name = "Steal a Brainrot",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Steal%20a%20Brainrot",
        description = "Steal a Brainrot steal helper"
    },
    {
        name = "Steal a Brainrot Auto fuck off",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Steal%20a%20Brainrot%20Auto%20fuck%20off",
        description = "Auto Slaps selected Player and stuff"
    },
    {
        name = "Teleport Manager",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Teleport%20Manager",
        description = "Lets you teleport to players and copy Coordinates"
    },
    {
        name = "Uncopylocker Script",
        url = "https://" .. MEIN_TOKEN .. "@raw.githubusercontent.com/adrighg-scripts/Private-Scripts/refs/heads/main/Uncopylocker%20Script",
        description = "Lets you uncopylock every Game"
    },
    {
        name = "Universal Script",
        url = "https://pastebin.com/raw/Piw5bqGq",
        description = "Has many Scripts in it"
    },
}

-- GUI Settings
local isOpen = true
local guiSize = UDim2.new(0, 380, 0, 450)
local minimizedSize = UDim2.new(0, 380, 0, 35)

-- ============================================
-- GUI ERSTELLEN
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptLoader"
screenGui.Parent = Player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Enabled = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = guiSize
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "📁 My Scripts"
titleText.TextColor3 = Color3.fromRGB(220, 220, 255)
titleText.Font = Enum.Font.GothamSemibold
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(0, 55, 1, 0)
buttonsFrame.Position = UDim2.new(1, -60, 0, 0)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(0, 0, 0.5, -12)
minimizeButton.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(220, 220, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = buttonsFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -24, 0.5, -12)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = buttonsFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Search Frame
local searchFrame = Instance.new("Frame")
searchFrame.Name = "SearchFrame"
searchFrame.Size = UDim2.new(1, -20, 0, 36)
searchFrame.Position = UDim2.new(0, 10, 0, 10)
searchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
searchFrame.BorderSizePixel = 0
searchFrame.Parent = contentFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchFrame

local searchIcon = Instance.new("TextLabel")
searchIcon.Name = "SearchIcon"
searchIcon.Size = UDim2.new(0, 32, 1, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "🔍"
searchIcon.TextColor3 = Color3.fromRGB(140, 140, 160)
searchIcon.TextSize = 16
searchIcon.Font = Enum.Font.GothamBold
searchIcon.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -32, 1, 0)
searchBox.Position = UDim2.new(0, 32, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Search scripts..."
searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextSize = 14
searchBox.Font = Enum.Font.Gotham
searchBox.ClearTextOnFocus = false
searchBox.Parent = searchFrame

-- File List Frame
local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "FileList"
listFrame.Size = UDim2.new(1, -20, 1, -60)
listFrame.Position = UDim2.new(0, 10, 0, 56)
listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 4
listFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
listFrame.Parent = contentFrame

-- Loading Frame
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
loadingFrame.BackgroundTransparency = 0.5
loadingFrame.Visible = false
loadingFrame.Parent = contentFrame

local loadingSpinner = Instance.new("ImageLabel")
loadingSpinner.Name = "Spinner"
loadingSpinner.Size = UDim2.new(0, 30, 0, 30)
loadingSpinner.Position = UDim2.new(0.5, -15, 0.5, -15)
loadingSpinner.BackgroundTransparency = 1
loadingSpinner.Image = "rbxassetid://6034502866"
loadingSpinner.ImageColor3 = Color3.fromRGB(100, 150, 255)
loadingSpinner.Parent = loadingFrame

-- Notification Frame
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(1, -40, 0, 50)
notificationFrame.Position = UDim2.new(0, 20, 1, -70)
notificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
notificationFrame.BackgroundTransparency = 1
notificationFrame.Visible = false
notificationFrame.Parent = contentFrame
notificationFrame.ZIndex = 10

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notificationFrame

local notifText = Instance.new("TextLabel")
notifText.Size = UDim2.new(1, -20, 1, 0)
notifText.Position = UDim2.new(0, 10, 0, 0)
notifText.BackgroundTransparency = 1
notifText.Text = ""
notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifText.TextSize = 13
notifText.Font = Enum.Font.Gotham
notifText.TextWrapped = true
notifText.Parent = notificationFrame

-- ============================================
-- INTRO ANIMATION
-- ============================================
local introFrame = Instance.new("Frame")
introFrame.Name = "IntroFrame"
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
introFrame.BackgroundTransparency = 1
introFrame.Parent = mainFrame
introFrame.ZIndex = 10

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 80)
introTitle.Position = UDim2.new(0, 0, 0.5, -40)
introTitle.BackgroundTransparency = 1
introTitle.Text = "SCRIPT LOADER"
introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
introTitle.TextStrokeTransparency = 0.5
introTitle.TextStrokeColor3 = Color3.fromRGB(100, 150, 255)
introTitle.Font = Enum.Font.GothamBold
introTitle.TextSize = 36
introTitle.TextTransparency = 1
introTitle.Parent = introFrame

local introSubtitle = Instance.new("TextLabel")
introSubtitle.Size = UDim2.new(1, 0, 0, 30)
introSubtitle.Position = UDim2.new(0, 0, 0.5, 30)
introSubtitle.BackgroundTransparency = 1
introSubtitle.Text = "by adrighg-scripts"
introSubtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
introSubtitle.TextSize = 16
introSubtitle.TextTransparency = 1
introSubtitle.Parent = introFrame

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 20)
versionText.Position = UDim2.new(0, 0, 1, -25)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.0.0 • loading scripts..."
versionText.TextColor3 = Color3.fromRGB(100, 100, 120)
versionText.Font = Enum.Font.Gotham
versionText.TextSize = 11
versionText.TextTransparency = 1
versionText.Parent = introFrame

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.6, 0, 0, 2)
progressBg.Position = UDim2.new(0.2, 0, 0.7, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
progressBg.BackgroundTransparency = 1
progressBg.Parent = introFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
progressBar.BackgroundTransparency = 1
progressBar.Parent = progressBg

-- ============================================
-- FUNKTIONEN
-- ============================================

local function showNotification(message, isError)
    notificationFrame.BackgroundTransparency = 0
    notificationFrame.Visible = true
    notifText.Text = message
    notifText.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
    
    task.wait(2)
    local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tween:Play()
    task.wait(0.3)
    notificationFrame.Visible = false
end

local function copyToClipboard(text)
    local clipboard = setclipboard or syn and syn.setclipboard or clipboard or function(t) warn("No clipboard function") end
    if clipboard then
        clipboard(text)
        showNotification("✅ Copied to clipboard!", false)
    else
        showNotification("❌ No clipboard function", true)
    end
end

-- ============================================
-- DIE KORRIGIERTE AUSFÜHRUNGSFUNKTION
-- ============================================
local function executeScript(scriptUrl, scriptName)
    if scriptUrl == "" then
        showNotification("❌ No URL for this script", true)
        return
    end
    
    print("▶️ Executing: " .. scriptName)
    showNotification("▶️ Running " .. scriptName .. "...", false)
    
    -- 1. DIREKT den Code laden und ausführen (wie im Test)
    local erfolg, ergebnis = pcall(function()
        -- GENAU wie in deinem Test, aber mit Ausführung!
        local inhalt = game:HttpGet(scriptUrl)
        print("✅ Downloaded! Länge: " .. #inhalt .. " bytes")
        
        -- Den Code ausführen (das ist der wichtige Teil!)
        loadstring(inhalt)()
    end)
    
    if erfolg then
        print("✅ Success: " .. scriptName)
        showNotification("✅ " .. scriptName .. " executed!", false)
    else
        warn("❌ Error: " .. tostring(ergebnis))
        showNotification("❌ Error: " .. tostring(ergebnis):sub(1, 50), true)
    end
end

-- ============================================
-- FILTER FUNKTION
-- ============================================
local function filterFiles()
    if not searchBox or not listFrame then 
        return 
    end
    
    local searchText = searchBox.Text:lower()
    local yPos = 0
    
    for _, fileFrame in ipairs(listFrame:GetChildren()) do
        if fileFrame:IsA("Frame") then
            fileFrame.Visible = false
        end
    end
    
    for _, fileFrame in ipairs(listFrame:GetChildren()) do
        if fileFrame:IsA("Frame") then
            local nameLabel = fileFrame:FindFirstChild("ScriptName")
            
            if nameLabel and nameLabel:IsA("TextLabel") then
                if searchText == "" or nameLabel.Text:lower():find(searchText, 1, true) then
                    fileFrame.Position = UDim2.new(0, 5, 0, yPos)
                    fileFrame.Visible = true
                    yPos = yPos + 64
                end
            end
        end
    end
    
    listFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
    listFrame.CanvasPosition = Vector2.new(0, 0)
end

-- ============================================
-- DISPLAY SCRIPTS
-- ============================================
local function displayScripts()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yPos = 0
    
    for i, script in ipairs(SCRIPTS) do
        local fileFrame = Instance.new("Frame")
        fileFrame.Name = "Script_" .. i
        fileFrame.Size = UDim2.new(1, -10, 0, 60)
        fileFrame.Position = UDim2.new(0, 5, 0, yPos)
        fileFrame.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(30, 30, 36) or Color3.fromRGB(28, 28, 34)
        fileFrame.BorderSizePixel = 0
        fileFrame.Parent = listFrame
        
        local fileCorner = Instance.new("UICorner")
        fileCorner.CornerRadius = UDim.new(0, 6)
        fileCorner.Parent = fileFrame
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 35, 1, 0)
        icon.Position = UDim2.new(0, 8, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "📜"
        icon.TextColor3 = Color3.fromRGB(100, 180, 255)
        icon.TextSize = 18
        icon.Font = Enum.Font.GothamBold
        icon.Parent = fileFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "ScriptName"
        nameLabel.Size = UDim2.new(1, -170, 0, 20)
        nameLabel.Position = UDim2.new(0, 48, 0, 6)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = script.name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = fileFrame
        
        if script.description then
            local descLabel = Instance.new("TextLabel")
            descLabel.Name = "ScriptDescription"
            descLabel.Size = UDim2.new(1, -170, 0, 18)
            descLabel.Position = UDim2.new(0, 48, 0, 26)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = script.description
            descLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
            descLabel.TextSize = 11
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextTruncate = Enum.TextTruncate.AtEnd
            descLabel.Parent = fileFrame
        end
        
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(0, 110, 1, 0)
        btnFrame.Position = UDim2.new(1, -115, 0, 0)
        btnFrame.BackgroundTransparency = 1
        btnFrame.Parent = fileFrame
        
        local execBtn = Instance.new("TextButton")
        execBtn.Size = UDim2.new(0, 50, 0, 28)
        execBtn.Position = UDim2.new(0, 0, 0.5, -14)
        execBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        execBtn.Text = "RUN"
        execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        execBtn.TextSize = 11
        execBtn.Font = Enum.Font.GothamBold
        execBtn.Parent = btnFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = execBtn
        
        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 50, 0, 28)
        copyBtn.Position = UDim2.new(1, -50, 0.5, -14)
        copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        copyBtn.Text = "COPY"
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.TextSize = 10
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.Parent = btnFrame
        
        local copyCorner = Instance.new("UICorner")
        copyCorner.CornerRadius = UDim.new(0, 4)
        copyCorner.Parent = copyBtn
        
        execBtn.MouseEnter:Connect(function()
            execBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
        end)
        execBtn.MouseLeave:Connect(function()
            execBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        end)
        
        copyBtn.MouseEnter:Connect(function()
            copyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        end)
        copyBtn.MouseLeave:Connect(function()
            copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        end)
        
        execBtn.MouseButton1Click:Connect(function()
            executeScript(script.url, script.name)
        end)
        
        copyBtn.MouseButton1Click:Connect(function()
            copyToClipboard(script.url)
        end)
        
        yPos = yPos + 64
    end
    
    listFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

-- ============================================
-- GUI FUNKTIONEN
-- ============================================
local function animateOpenClose(targetOpen)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if targetOpen then
        local goal = { Size = guiSize }
        local tween = TweenService:Create(mainFrame, tweenInfo, goal)
        tween:Play()
        contentFrame.Visible = true
        isOpen = true
        minimizeButton.Text = "−"
    else
        local goal = { Size = minimizedSize }
        local tween = TweenService:Create(mainFrame, tweenInfo, goal)
        tween:Play()
        contentFrame.Visible = false
        isOpen = false
        minimizeButton.Text = "+"
    end
end

-- Draggable
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    animateOpenClose(not isOpen)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        animateOpenClose(not isOpen)
    end
end)

-- ============================================
-- SEARCHBOX EVENTS
-- ============================================
local function setupSearchEvents()
    task.wait(0.1)
    
    if searchBox then
        searchBox.Changed:Connect(function(prop)
            if prop == "Text" then
                filterFiles()
            end
        end)
        
        searchBox.FocusLost:Connect(function()
            filterFiles()
        end)
        
        filterFiles()
    end
end

-- ============================================
-- INTRO ANIMATION STARTEN
-- ============================================
local function playIntro()
    screenGui.Enabled = true
    
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(introTitle, tweenInfo, {TextTransparency = 0}):Play()
    task.wait(0.2)
    
    TweenService:Create(introSubtitle, tweenInfo, {TextTransparency = 0}):Play()
    task.wait(0.2)
    
    TweenService:Create(versionText, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(progressBg, tweenInfo, {BackgroundTransparency = 0.7}):Play()
    
    local progress = 0
    while progress < 1 do
        progress = progress + 0.02
        progressBar.Size = UDim2.new(progress, 0, 1, 0)
        progressBar.BackgroundTransparency = 0
        task.wait(0.03)
    end
    
    task.wait(0.3)
    
    local fadeOutInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    TweenService:Create(introTitle, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(introSubtitle, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(versionText, fadeOutInfo, {TextTransparency = 1}):Play()
    TweenService:Create(progressBar, fadeOutInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(progressBg, fadeOutInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(introFrame, fadeOutInfo, {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    introFrame:Destroy()
    
    displayScripts()
    setupSearchEvents()
end

-- ============================================
-- START
-- ============================================
playIntro()

print("✨ My Scripts Loader started!")
print("📁 " .. #SCRIPTS .. " scripts loaded")
print("⌨️ RCtrl = Toggle window")
