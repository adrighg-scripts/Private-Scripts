local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local PlayerWorthData = {}
local RichestPlayer = nil
local RichestWorth = 0

local CONFIG = {
    DISPLAY_HEIGHT_OFFSET = 2.5,         -- Height above player head
    UPDATE_INTERVAL = 30,                -- Seconds between worth updates
    HIGHLIGHT_COLOR = Color3.fromRGB(255, 215, 0),  -- Gold color
    HIGHLIGHT_TRANSPARENCY = 0.6,        -- Highlight transparency (0-1)
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),     -- White text
    RICHEST_TEXT_COLOR = Color3.fromRGB(255, 215, 0),  -- Gold text
    TEXT_STROKE_COLOR = Color3.fromRGB(0, 0, 0),    -- Black outline
    TEXT_STROKE_TRANSPARENCY = 0,        -- Text outline transparency
    TEXT_SIZE = 20,                      -- Billboard text size
    ANIMATE_HIGHLIGHT = true,            -- Whether to animate the highlight
    SHOW_COMMA_SEPARATORS = true,        -- Format numbers with commas
    MAX_RETRY_ATTEMPTS = 3,              -- Maximum number of retry attempts for worth calculation
    RETRY_DELAY = 2,                     -- Delay between retries in seconds
    USE_MARKETPLACE_API = true,          -- Use Marketplace API for more accurate pricing
    API_TIMEOUT = 10,                    -- API request timeout in seconds
    CACHE_DURATION = 3600,               -- How long to cache asset prices (in seconds)
    LIMITED_ITEM_PREMIUM = 1.0,          -- Multiplier for limited items to account for collector value
    RESALE_VALUE_PRIORITY = true,        -- Prioritize resale value over original price for limiteds
}

local AssetPriceCache = {}

local avatarWorthCache = {}

local function FormatNumber(number)
    if not CONFIG.SHOW_COMMA_SEPARATORS then
        return tostring(number)
    end

    local numStr = tostring(number)
    local sign, int, frac = string.match(numStr, "([+-]?)(%d+)(%.?%d*)")
    
    local formatted = int:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    
    if formatted:sub(1,1) == "," then
        formatted = formatted:sub(2)
    end

    return sign .. formatted .. frac
end


local function SafeHttpRequest(url, method)
    method = method or "GET"
    
    local success, result
    local requestComplete = false
    
    task.spawn(function()
        success, result = pcall(function()
            return HttpService:RequestAsync({
                Url = url,
                Method = method
            })
        end)
        requestComplete = true
    end)
    
    local startTime = os.clock()
    while not requestComplete and os.clock() - startTime < CONFIG.API_TIMEOUT do
        task.wait(0.1)
    end

    if not requestComplete then
        warn("HTTP request timed out: " .. url)
        return false, nil
    end
    
    if not success then
        warn("HTTP request failed: " .. tostring(result))
        return false, nil
    end
    
    if result.Success and result.StatusCode >= 200 and result.StatusCode < 300 then
        local jsonSuccess, jsonData = pcall(function()
            return HttpService:JSONDecode(result.Body)
        end)
        
        if jsonSuccess then
            return true, jsonData
        else
            warn("Failed to parse JSON response: " .. tostring(jsonData))
            return false, nil
        end
    else
        warn("HTTP request returned error status: " .. tostring(result.StatusCode) .. " - " .. tostring(result.StatusMessage))
        return false, nil
    end
end

local function IsLimitedItem(assetDetails)
    if assetDetails and assetDetails.itemRestrictions then
        for _, restriction in ipairs(assetDetails.itemRestrictions) do
            if restriction == "Limited" or restriction == "LimitedUnique" then
                return true
            end
        end
    end
    return false
end

local function GetAssetDetails(assetId)
    local apiUrl = "https://catalog.roblox.com/v1/search/items/details?Keyword=" .. assetId .. "&Category=1&Subcategory=1&Limit=1"
    
    local success, data = SafeHttpRequest(apiUrl)
    
    if success and data and data.data and #data.data > 0 then
        local itemDetails = data.data[0] or data.data[1]

        if itemDetails and tostring(itemDetails.id) == tostring(assetId) then
            return itemDetails
        end
    end
    
    return nil
end

local function GetAssetPriceFromAPI(assetId)
    if AssetPriceCache[assetId] and os.time() - AssetPriceCache[assetId].timestamp < CONFIG.CACHE_DURATION then
        return AssetPriceCache[assetId].price, AssetPriceCache[assetId].isLimited
    end
    
    local assetDetailsUrl = "https://catalog.roblox.com/v1/search/items/details?Keyword=" .. assetId .. "&Category=1&Subcategory=1&Limit=1"
    
    local success, data = SafeHttpRequest(assetDetailsUrl)
    local price = 0
    local isLimited = false
    
    if success and data and data.data and #data.data > 0 then
        local itemDetails = data.data[1]
        
        if tostring(itemDetails.id) == tostring(assetId) then
            isLimited = IsLimitedItem(itemDetails)

            if isLimited and itemDetails.lowestPrice and CONFIG.RESALE_VALUE_PRIORITY then
                price = itemDetails.lowestPrice
            elseif itemDetails.price then
                price = itemDetails.price
            end
            
            if isLimited and CONFIG.LIMITED_ITEM_PREMIUM > 1 then
                price = price * CONFIG.LIMITED_ITEM_PREMIUM
            end
            AssetPriceCache[assetId] = {
                price = price,
                isLimited = isLimited,
                timestamp = os.time()
            }
            
            return price, isLimited
        end
    end
    
    local success2, productInfo = pcall(function()
        return MarketplaceService:GetProductInfo(assetId, Enum.InfoType.Asset)
    end)
    
    if success2 and productInfo then
        if productInfo.IsForSale and productInfo.PriceInRobux then
            price = productInfo.PriceInRobux
        end
        
        local isLimitedFallback = false
        if productInfo.IsLimited or productInfo.IsLimitedUnique then
            isLimitedFallback = true
            if CONFIG.LIMITED_ITEM_PREMIUM > 1 then
                price = price * CONFIG.LIMITED_ITEM_PREMIUM
            end
        end
        
        AssetPriceCache[assetId] = {
            price = price,
            isLimited = isLimitedFallback,
            timestamp = os.time()
        }
        
        return price, isLimitedFallback
    end
    
    AssetPriceCache[assetId] = {
        price = 0,
        isLimited = false,
        timestamp = os.time()
    }
    
    return 0, false
end

local limitedItemPriceCache = {}

local function GetLimitedItemRAP(assetId)
    local cached = limitedItemPriceCache[assetId]
    if cached then return cached end

    local success, productInfo = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId)
    if not success then
        warn("GetProductInfo failed: AssetID", assetId)
        return nil
    end

    local details = productInfo and productInfo.CollectiblesItemDetails
    local price = details and details.CollectibleLowestResalePrice

    if price and price > 0 then
        limitedItemPriceCache[assetId] = price
        return price
    end

    return nil
end

function GetLowestLimitedPrice(assetId)
	local url = string.format("https://economy.roblox.com/v1/assets/%d/resellers?limit=10", assetId)

	local success, result = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if not success then
		warn("Reseller API failed for asset:", assetId)
		return nil
	end

	local data = HttpService:JSONDecode(result)
	if data and data.data and #data.data > 0 then
		local lowestPrice = data.data[1].price
		for _, reseller in ipairs(data.data) do
			if reseller.price < lowestPrice then
				lowestPrice = reseller.price
			end
		end
		return lowestPrice
	else
		return nil
	end
end

local function GetAvatarWorth(userId)
    if avatarWorthCache[userId] and avatarWorthCache[userId].timestamp > os.time() - 300 then
        return avatarWorthCache[userId].worth
    end

    local totalWorth = 0
    local limitedCount = 0
    local retryCount = 0

    repeat
        retryCount = retryCount + 1

        local success, appearanceInfo = pcall(function()
            return Players:GetCharacterAppearanceInfoAsync(userId)
        end)

        if not success or not appearanceInfo then
            warn("Failed to get avatar info for userId:", userId, "Attempt:", retryCount)
            task.wait(CONFIG.RETRY_DELAY)
        else
            for _, asset in ipairs(appearanceInfo.assets) do
                if asset and asset.id then
                    local assetWorth = 0
                    local isLimited = false
                    local rap = GetLimitedItemRAP(asset.id)
                    if rap then
                        assetWorth = rap
                        isLimited = true
                        limitedCount += 1
                    else
                        local productInfoSuccess, productInfo = pcall(function()
                            return MarketplaceService:GetProductInfo(asset.id, Enum.InfoType.Asset)
                        end)

                        if productInfoSuccess and productInfo then
                            if productInfo.IsLimited or productInfo.IsLimitedUnique then
                                isLimited = true
                                limitedCount += 1
                            end

                            if (not assetWorth or assetWorth == 0) and productInfo.IsForSale then
                                assetWorth = productInfo.PriceInRobux or 0
                            end

                            if isLimited and CONFIG.LIMITED_ITEM_PREMIUM > 1 then
                                assetWorth = assetWorth * CONFIG.LIMITED_ITEM_PREMIUM
                            end
                        end
                    end

                    totalWorth = totalWorth + assetWorth

                    if CONFIG.USE_MARKETPLACE_API then
                        task.wait(0.1)
                    end
                end
            end

            if appearanceInfo.equippedAssets then
                for _, equippedAsset in ipairs(appearanceInfo.equippedAssets) do
                    if equippedAsset.assetType and equippedAsset.assetType.name == "Bundle" then
                        local bundleWorth = 0

                        local bundleSuccess, bundleInfo = pcall(function()
                            return MarketplaceService:GetProductInfo(equippedAsset.id, Enum.InfoType.Bundle)
                        end)

                        if bundleSuccess and bundleInfo then
                            bundleWorth = bundleInfo.PriceInRobux or 0
                        end

                        totalWorth = totalWorth + bundleWorth
                    end
                end
            end

            break
        end
    until retryCount >= CONFIG.MAX_RETRY_ATTEMPTS
    if totalWorth == 0 and avatarWorthCache[userId] then
        print("Worth calculation returned 0 for player", userId, "- using cached value:", avatarWorthCache[userId].worth)
        return avatarWorthCache[userId].worth
    end

    avatarWorthCache[userId] = {
        worth = totalWorth,
        timestamp = os.time(),
        limitedCount = limitedCount
    }

    return totalWorth
end


local function CreatePlayerWorthUI(player)
    if not player.Character or not player.Character:FindFirstChild("Head") then 
        return nil, nil 
    end
    
    local existingBillboard = player.Character.Head:FindFirstChild("WorthDisplay")
    if existingBillboard then
        existingBillboard:Destroy()
    end
    
    local existingHighlight = player.Character:FindFirstChild("RichestHighlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "WorthDisplay"
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, CONFIG.DISPLAY_HEIGHT_OFFSET, 0)
    billboardGui.Adornee = player.Character.Head
    billboardGui.Parent = player.Character.Head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "WorthText"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = CONFIG.TEXT_COLOR
    textLabel.TextStrokeColor3 = CONFIG.TEXT_STROKE_COLOR
    textLabel.TextStrokeTransparency = CONFIG.TEXT_STROKE_TRANSPARENCY
    textLabel.TextSize = CONFIG.TEXT_SIZE
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = "Calculating..."
    textLabel.Parent = billboardGui
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "RichestHighlight"
    highlight.FillColor = CONFIG.HIGHLIGHT_COLOR
    highlight.OutlineColor = CONFIG.HIGHLIGHT_COLOR
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 1
    highlight.Parent = player.Character
    
    return billboardGui, highlight
end

local function UpdatePlayerWorth(player)
    if not player or not player.Character then return end
    
    task.spawn(function()
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = player.Character.Head:FindFirstChild("WorthDisplay")
            
            if not billboard then
                billboard, _ = CreatePlayerWorthUI(player)
            end
            
            if billboard and billboard:FindFirstChild("WorthText") then
                local worthText = billboard.WorthText
                worthText.Text = "Calculating..."
            end
        end
        
        local previousWorth = PlayerWorthData[player] and PlayerWorthData[player].Worth or 0
        local worth = GetAvatarWorth(player.UserId)
        
        if worth == 0 and previousWorth > 0 then
            print("Worth calculation returned 0 for " .. player.Name .. " - keeping previous worth: " .. previousWorth)
            worth = previousWorth
        end
        
        local limitedCount = 0
        if avatarWorthCache[player.UserId] and avatarWorthCache[player.UserId].limitedCount then
            limitedCount = avatarWorthCache[player.UserId].limitedCount
        end
        
        PlayerWorthData[player] = {
            Worth = worth,
            LastUpdated = os.time(),
            LimitedCount = limitedCount
        }
        
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = player.Character.Head:FindFirstChild("WorthDisplay")
            
            if not billboard then
                billboard, _ = CreatePlayerWorthUI(player)
            end
            
            if billboard and billboard:FindFirstChild("WorthText") then
                local worthText = billboard.WorthText
                if worth > 0 or worthText.Text == "Calculating..." then
                    local displayText = FormatNumber(worth) .. " R$"
                    if limitedCount > 0 then
                        displayText = displayText .. " (" .. limitedCount .. " Limited)"
                    end
                    
                    worthText.Text = displayText
                    print("Updated worth for " .. player.Name .. ": " .. FormatNumber(worth) .. " R$")
                else
                    print("Skipped updating display for " .. player.Name .. " because worth is 0")
                    if worthText.Text == "Calculating..." then
                        worthText.Text = "Value Unavailable"
                    end
                end
            end
        end
        if worth > RichestWorth then
            if RichestPlayer and RichestPlayer.Character then
                local oldHighlight = RichestPlayer.Character:FindFirstChild("RichestHighlight")
                if oldHighlight then
                    oldHighlight.FillTransparency = 1
                    oldHighlight.OutlineTransparency = 1
                end
                if RichestPlayer.Character:FindFirstChild("Head") then
                    local oldBillboard = RichestPlayer.Character.Head:FindFirstChild("WorthDisplay")
                    if oldBillboard and oldBillboard:FindFirstChild("WorthText") then
                        oldBillboard.WorthText.TextColor3 = CONFIG.TEXT_COLOR
                    end
                end
            end
            RichestPlayer = player
            RichestWorth = worth
            
            if player.Character then
                local highlight = player.Character:FindFirstChild("RichestHighlight")
                if not highlight then
                    _, highlight = CreatePlayerWorthUI(player)
                end
                
                if highlight then
                    highlight.FillTransparency = CONFIG.HIGHLIGHT_TRANSPARENCY
                    highlight.OutlineTransparency = CONFIG.HIGHLIGHT_TRANSPARENCY
                end
                
                if player.Character:FindFirstChild("Head") then
                    local worthBillboard = player.Character.Head:FindFirstChild("WorthDisplay")
                    if worthBillboard and worthBillboard:FindFirstChild("WorthText") then
                        worthBillboard.WorthText.TextColor3 = CONFIG.RICHEST_TEXT_COLOR
                    end
                end
            end
        end
    end)
end

local function OnCharacterAdded(player, character)
    repeat task.wait() until character:FindFirstChild("Head")
    local billboardGui, highlight = CreatePlayerWorthUI(player)
    if not billboardGui then
        task.wait(1)
        billboardGui, highlight = CreatePlayerWorthUI(player)
    end
    task.wait(0.5)
    UpdatePlayerWorth(player)
    task.delay(5, function()
        if player and player.Character then
            local playerData = PlayerWorthData[player]
            if playerData and playerData.Worth == 0 then
                print("Detected 0 worth for " .. player.Name .. " after initial calculation, retrying...")
                UpdatePlayerWorth(player)
            end
        end
    end)
    if RichestPlayer == player and highlight then
        highlight.FillTransparency = CONFIG.HIGHLIGHT_TRANSPARENCY
        highlight.OutlineTransparency = CONFIG.HIGHLIGHT_TRANSPARENCY
        
        if billboardGui and billboardGui:FindFirstChild("WorthText") then
            billboardGui.WorthText.TextColor3 = CONFIG.RICHEST_TEXT_COLOR
        end
    end
end

local function OnPlayerAdded(player)
    print("New player joined:", player.Name)
    PlayerWorthData[player] = {
        Worth = 0,
        LastUpdated = 0,
        LimitedCount = 0
    }
    task.spawn(function()
        GetAvatarWorth(player.UserId)
    end)

    if player.Character then
        OnCharacterAdded(player, player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        OnCharacterAdded(player, character)
    end)
end

local function OnPlayerRemoving(player)
    print("Player leaving:", player.Name)
    PlayerWorthData[player] = nil
    if player == RichestPlayer then
        RichestPlayer = nil
        RichestWorth = 0
        for p, data in pairs(PlayerWorthData) do
            if data.Worth > RichestWorth then
                RichestPlayer = p
                RichestWorth = data.Worth
            end
        end
        if RichestPlayer and RichestPlayer.Character then
            local highlight = RichestPlayer.Character:FindFirstChild("RichestHighlight")
            if highlight then
                highlight.FillTransparency = CONFIG.HIGHLIGHT_TRANSPARENCY
                highlight.OutlineTransparency = CONFIG.HIGHLIGHT_TRANSPARENCY
            end
            
            if RichestPlayer.Character:FindFirstChild("Head") then
                local billboard = RichestPlayer.Character.Head:FindFirstChild("WorthDisplay")
                if billboard and billboard:FindFirstChild("WorthText") then
                    billboard.WorthText.TextColor3 = CONFIG.RICHEST_TEXT_COLOR
                end
            end
        end
    end
end

local function RetrySetupForPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player and player.Character and player.Character:FindFirstChild("Head") then
            local hasDisplay = player.Character.Head:FindFirstChild("WorthDisplay")
            if not hasDisplay then
                local billboardGui, highlight = CreatePlayerWorthUI(player)
                if billboardGui then
                    UpdatePlayerWorth(player)
                end
            else
                local playerData = PlayerWorthData[player]
                if playerData and playerData.Worth == 0 then
                    print("Found player with 0 worth during retry check:", player.Name)
                    UpdatePlayerWorth(player)
                end
            end
        end
    end
end

local function Initialize()
    print("Initializing avatar worth system with improved Limited Item support")

    Players.PlayerAdded:Connect(OnPlayerAdded)
    Players.PlayerRemoving:Connect(OnPlayerRemoving)

    for _, player in pairs(Players:GetPlayers()) do
        OnPlayerAdded(player)
    end

    task.spawn(function()
        while true do
            task.wait(CONFIG.UPDATE_INTERVAL)
            RetrySetupForPlayers()
            for player, data in pairs(PlayerWorthData) do
                if player and player.Parent and player.Character then
                    if os.time() - data.LastUpdated >= CONFIG.UPDATE_INTERVAL then
                        UpdatePlayerWorth(player)
                    end
                else
                    PlayerWorthData[player] = nil
                end
            end
        end
    end)
    
    if CONFIG.ANIMATE_HIGHLIGHT then
        RunService.Heartbeat:Connect(function()
            if RichestPlayer and RichestPlayer.Character then
                local highlight = RichestPlayer.Character:FindFirstChild("RichestHighlight")
                if highlight then
                    local pulse = (math.sin(os.clock() * 2) + 1) / 4
                    highlight.FillTransparency = CONFIG.HIGHLIGHT_TRANSPARENCY + pulse
                end
            end
        end)
    end
end

Initialize()

game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "MADE BY MZEEN",
	Text = "Avatar Worth Calculator by MZEEN"
})