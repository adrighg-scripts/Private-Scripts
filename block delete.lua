-- Lokalisieren der wichtigsten Dienste
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Spieler und Charakter referenzieren
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variablen für das System
local selectedPart = nil
local originalColor = nil
local originalMaterial = nil
local deletedParts = {} -- Stack für gelöschte Parts
local maxHistory = 20 -- Maximale Anzahl gespeicherter gelöschter Parts

-- UI erstellen
local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Name = "RaycastTool"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

TextLabel.Name = "ToolInfo"
TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(0, 320, 0, 70)
TextLabel.Position = UDim2.new(0, 10, 1, -80)
TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TextLabel.BackgroundTransparency = 0.3
TextLabel.BorderSizePixel = 0
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 14
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextYAlignment = Enum.TextYAlignment.Top
TextLabel.Font = Enum.Font.Code
TextLabel.Text = "Raycast Tool - Kein Hit\nF8: Rückgängig | F9: Alles | F10: Schließen"
TextLabel.RichText = true

-- UI-Elemente hinzufügen
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = TextLabel

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 80)
UIStroke.Thickness = 1
UIStroke.Parent = TextLabel

ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Liste von verbotenen Parts (Humanoid Body Parts)
local FORBIDDEN_PARTS = {
    "Head",
    "Torso",
    "Left Arm", "Right Arm",
    "Left Leg", "Right Leg",
    "LeftFoot", "RightFoot",
    "LeftHand", "RightHand",
    "HumanoidRootPart"
}

-- Funktion zum Überprüfen, ob ein Part ein Body Part ist
local function isBodyPart(part)
    if not part then return false end
    
    -- Name in der verbotenen Liste prüfen
    for _, forbiddenName in ipairs(FORBIDDEN_PARTS) do
        if part.Name == forbiddenName then
            return true
        end
    end
    
    -- Prüfen, ob das Part zu einem Humanoid gehört
    local character = part:FindFirstAncestorOfClass("Model")
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Wenn das Part direkt im Character ist (nicht in Accessories etc.)
            if part.Parent == character then
                return true
            end
            
            -- Prüfen, ob es Teil eines speziellen Humanoid-Systems ist
            if part:IsDescendantOf(character) and part:IsA("BasePart") then
                -- Spezielle Humanoid-Parts erkennen
                local partType = part:GetAttribute("BodyPartType")
                if partType then
                    return true
                end
            end
        end
    end
    
    return false
end

-- Raycast-Funktion
local function performRaycast()
    local origin = mouse.UnitRay.Origin
    local direction = mouse.UnitRay.Direction * 1000
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {player.PlayerGui}
    
    local rayResult = workspace:Raycast(origin, direction, raycastParams)
    
    return rayResult, origin
end

-- Funktion zum Markieren eines Parts (rot machen)
local function markPart(part)
    if selectedPart and selectedPart.Parent then
        -- Altes Part zurücksetzen
        resetPart(selectedPart)
    end
    
    selectedPart = part
    if part then
        -- Originalwerte speichern
        originalColor = part.Color
        originalMaterial = part.Material
        
        -- Part rot markieren
        part.Color = Color3.fromRGB(255, 50, 50)
        part.Material = Enum.Material.Neon
    end
end

-- Funktion zum Zurücksetzen eines Parts
local function resetPart(part)
    if part and part.Parent then
        if originalColor then
            part.Color = originalColor
        end
        if originalMaterial then
            part.Material = originalMaterial
        end
    end
    selectedPart = nil
    originalColor = nil
    originalMaterial = nil
end

-- Funktion zum Löschen eines Parts (mit Body Part Check)
local function deletePart(part)
    if not part or not part.Parent then
        return false
    end
    
    -- Prüfen, ob es ein Body Part ist
    if isBodyPart(part) then
        print("Kann nicht löschen: " .. part.Name .. " ist ein Body Part!")
        return false
    end
    
    -- Zurücksetzen, falls das Part markiert war
    if part == selectedPart then
        resetPart(part)
    end
    
    -- Originale Eigenschaften speichern
    local originalProperties = {
        Color = part.Color,
        Material = part.Material,
        Transparency = part.Transparency,
        Reflectance = part.Reflectance
    }
    
    -- Part-Informationen speichern
    local partClone = part:Clone()
    
    -- Originale Eigenschaften auf den Clone anwenden
    partClone.Color = originalProperties.Color
    partClone.Material = originalProperties.Material
    partClone.Transparency = originalProperties.Transparency
    partClone.Reflectance = originalProperties.Reflectance
    
    local partInfo = {
        Part = partClone,
        Parent = part.Parent,
        Position = part.Position,
        Orientation = part.Orientation,
        Size = part.Size,
        Name = part.Name,
        Properties = originalProperties
    }
    
    -- Zur History hinzufügen
    table.insert(deletedParts, 1, partInfo)
    
    -- History auf maximale Größe beschränken
    if #deletedParts > maxHistory then
        table.remove(deletedParts, maxHistory + 1)
    end
    
    -- Part aus Workspace entfernen
    part:Destroy()
    
    return true
end

-- Funktion zum Wiederherstellen des letzten gelöschten Parts
local function restoreLastPart()
    if #deletedParts > 0 then
        local partInfo = table.remove(deletedParts, 1)
        
        -- Neues Part erstellen
        local newPart = partInfo.Part:Clone()
        
        -- Originale Eigenschaften anwenden
        newPart.Color = partInfo.Properties.Color
        newPart.Material = partInfo.Properties.Material
        newPart.Transparency = partInfo.Properties.Transparency
        newPart.Reflectance = partInfo.Properties.Reflectance
        
        -- Position und andere Eigenschaften setzen
        newPart.Position = partInfo.Position
        newPart.Orientation = partInfo.Orientation
        newPart.Size = partInfo.Size
        newPart.Name = partInfo.Name
        newPart.Parent = workspace
        
        print("Part wiederhergestellt: " .. partInfo.Name)
        return true
    end
    return false
end

-- Funktion zum Wiederherstellen aller gelöschten Parts
local function restoreAllParts()
    local restoredCount = 0
    for i = #deletedParts, 1, -1 do
        local partInfo = deletedParts[i]
        local newPart = partInfo.Part:Clone()
        
        -- Originale Eigenschaften anwenden
        newPart.Color = partInfo.Properties.Color
        newPart.Material = partInfo.Properties.Material
        newPart.Transparency = partInfo.Properties.Transparency
        newPart.Reflectance = partInfo.Properties.Reflectance
        
        newPart.Position = partInfo.Position
        newPart.Orientation = partInfo.Orientation
        newPart.Size = partInfo.Size
        newPart.Name = partInfo.Name
        newPart.Parent = workspace
        
        table.remove(deletedParts, i)
        restoredCount = restoredCount + 1
    end
    return restoredCount
end

-- Funktion zum Aktualisieren der UI (mit Body Part Warnung)
local function updateDisplay()
    local rayResult, origin = performRaycast()
    
    if rayResult and rayResult.Instance then
        local part = rayResult.Instance
        local distance = (rayResult.Position - origin).Magnitude
        
        -- Prüfen, ob es ein Body Part ist
        local isForbidden = isBodyPart(part)
        
        -- Statusanzeige
        local statusText = ""
        if part == selectedPart then
            statusText = "<font color=\"#FF3333\">[MARKIERT]</font> "
        end
        
        -- Warnung für Body Parts
        local warningText = ""
        if isForbidden then
            warningText = "\n<font color=\"#FF5555\">⚠ Body Part - Kann nicht gelöscht werden!</font>"
        end
        
        TextLabel.Text = string.format(
            "%s%s%s\n" ..
            "Distance: %.2f studs\n" ..
            "ENTF: Markieren/Löschen | BACKSPACE: Zurücksetzen\n" ..
            "F8: Letztes (1) | F9: Alle (%d) | F10: Schließen",
            statusText,
            part.Name,
            warningText,
            distance,
            #deletedParts
        )
    else
        TextLabel.Text = string.format(
            "Kein Hit\n" ..
            "Gelöschte Parts: %d\n" ..
            "F8: Letztes zurück | F9: Alle zurück | F10: Schließen",
            #deletedParts
        )
    end
end

-- Tastatureingaben verarbeiten (mit Body Part Schutz)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Delete then
        local rayResult = performRaycast()
        
        if rayResult and rayResult.Instance then
            local part = rayResult.Instance
            
            -- Prüfen, ob es ein Body Part ist
            if isBodyPart(part) then
                print("Kann nicht löschen: " .. part.Name .. " ist ein Body Part!")
                -- Visuelles Feedback (kurzes Blinken)
                local original = part.Color
                for i = 1, 3 do
                    task.wait(0.1)
                    part.Color = Color3.fromRGB(255, 100, 100)
                    task.wait(0.1)
                    part.Color = original
                end
                return
            end
            
            if selectedPart == part then
                -- Part löschen, wenn es bereits markiert ist
                if deletePart(part) then
                    print("Part gelöscht: " .. part.Name)
                end
            else
                -- Originaleigenschaften speichern
                -- Part markieren
                markPart(part)
                print("Part markiert: " .. part.Name)
            end
        end
        
    elseif input.KeyCode == Enum.KeyCode.Backspace then
        -- Markierung zurücksetzen
        if selectedPart then
            resetPart(selectedPart)
            print("Markierung zurückgesetzt")
        end
        
    elseif input.KeyCode == Enum.KeyCode.F8 then
        -- Letztes gelöschtes Part wiederherstellen
        if restoreLastPart() then
            print("Letztes Part wiederhergestellt")
        else
            print("Keine gelöschten Parts verfügbar")
        end
        
    elseif input.KeyCode == Enum.KeyCode.F9 then
        -- Alle gelöschten Parts wiederherstellen
        local count = restoreAllParts()
        if count > 0 then
            print(count .. " Parts wiederhergestellt")
        else
            print("Keine gelöschten Parts verfügbar")
        end
        
    elseif input.KeyCode == Enum.KeyCode.F10 then
        -- Script komplett schließen
        ScreenGui:Destroy()
        if connection then
            connection:Disconnect()
        end
        print("Script geschlossen")
    end
end)

-- Haupt-Update-Schleife
local connection
connection = RunService.RenderStepped:Connect(function()
    if ScreenGui and ScreenGui.Parent then
        updateDisplay()
    end
end)

-- Initialisierung
print([[
=== Raycast Tool Geladen ===
Steuerung:
- Entf: Part markieren (rot)
- Entf (auf markiertem Part): Part löschen
- Backspace: Markierung zurücksetzen
- F8: Letztes gelöschtes Part zurückholen
- F9: Alle gelöschten Parts zurückholen
- F10: Script schließen

SICHERHEIT:
- Body Parts können NICHT gelöscht werden
- UI zeigt Warnung bei Body Parts an
=========================
]])

-- Cleanup
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if connection then
        connection:Disconnect()
    end
end)