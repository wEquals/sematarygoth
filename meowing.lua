


local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "project_x",
    gamename = "universal",
})

library:init()

local Window1 = library.NewWindow({
    title = "Project X / V2 ",
    size = UDim2.new(0, 600, 0.5, 6)
})

local MainTab = Window1:AddTab("  Main  ")
local ESPTab = Window1:AddTab("  Visuals  ")
local PlayerTab = Window1:AddTab("  Player  ")
local MiscTab = Window1:AddTab("  Misc  ")
local SettingsTab = library:CreateSettingsTab(Window1)

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/bbcdemon445/dgrfgdfdasd/main/asdadda"))();

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

--// Functions

Environment.Functions = {}

function Environment.Functions:Exit()
    for _, connection in next, ServiceConnections do
        connection:Disconnect()
    end

    if Animation then Animation:Cancel() end

    Environment.FOVCircle:Remove()
end

Load()

local Decimals = 4
local Clock = os.clock()

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
    text = "Enabled",
    state = false,
    tooltip = "Enables ESP",
    flag = "ESPEnabled",
    callback = function(v)
        ESP.Enabled = v
        ESP.CharSize = Vector2.new(2.5, 2.5)
    end
})

ESPSection:AddToggle({
    text = "Boxes",
    state = false,
    tooltip = "Enables box ESP",
    flag = "BoxEnabled",
    callback = function(v)
        ESP.ShowBox = v
    end
})

ESPSection:AddToggle({
    text = "Health Bar",
    state = false,
    tooltip = "Enables HealthBar ESP",
    flag = "HealthbarEnabled",
    callback = function(v)
        ESP.ShowHealth = v
    end
})

ESPSection:AddToggle({
    text = "Names",
    state = false,
    tooltip = "Enables Name ESP",
    flag = "NameESPEnabled",
    callback = function(v)
        ESP.ShowName = v
    end
})

ESPSection:AddToggle({
    text = "Distance",
    state = false,
    tooltip = "Enables distance ESP",
    flag = "DistanceEnabled",
    callback = function(v)
        ESP.ShowDistance = v
    end
})

ESPSection:AddToggle({
    text = "Invisible Check",
    state = false,
    tooltip = "Stops ESP drawing on invisible players",
    flag = "ESPInvisibleCheck",
    callback = function(v)
        print("dont work rn chat")
    end
})


ESPSection:AddToggle({
    text = "Team Check",
    state = false,
    tooltip = "Stops ESP drawing onto teammates",
    flag = "ESPTeamCheck",
    callback = function(v)
        ESP.Teamcheck = v
    end
})

ESPSection:AddToggle({
    text = "Wall Check",
    state = false,
    tooltip = "Enables Wall Check",
    flag = "ESPWallCheck",
    callback = function(v)
        ESP.WallCheck = v
        updateIgnoreList()
    end
})

ESPSection:AddToggle({
    text = "Tracers",
    state = false,
    tooltip = "Enables Tracers (Laggy)",
    flag = "ESPTracers",
    callback = function(v)
        ESP.ShowTracer = v
    end
})

local XRaySection = ESPTab:AddSection("XRay", 3)

local function xray(xrayEnabled)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
            v.LocalTransparencyModifier = xrayEnabled and 0.5 or 0
        end
    end
end   

XRaySection:AddToggle({
    text = "XRay",
    state = false,
    risky = false,
    tooltip = "Enable XRay",
    flag = "XRay_toggle",
    callback = function(v)
        xray(v)
    end
})

local MovementSection = PlayerTab:AddSection("Movement", 1)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

getgenv().cframe12 = true
getgenv().cfrene12 = false
getgenv().Multiplier1 = 0
getgenv().ToggleKey12 = Enum.KeyCode.F

local function onKeyPress(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == getgenv().ToggleKey then
        getgenv().cfrene1 = not getgenv().cfrene1
    end
end

local function moveCharacter()
    while true do
        RunService.Stepped:wait()
        if getgenv().cframe12 and getgenv().cfrene12 then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + character.Humanoid.MoveDirection * getgenv().Multiplier1
            end
        end
    end
end

UserInputService.InputBegan:Connect(onKeyPress)

coroutine.wrap(moveCharacter)()

MovementSection:AddToggle({
    text = "CFrame Walk",
    state = false,
    risky = false,
    tooltip = "Enable CFrame Walk",
    flag = "Toggle_131",
    risky = false,
    callback = function(v)
        getgenv().cfrene12 = v
    end
}):AddBind({
    enabled = false,
    text = "CFrame Walk",
    tooltip = "Change keybind",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_123123",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
    end,
    keycallback = function(v)
        getgenv().ToggleKey12 = v
    end
})

MovementSection:AddSlider({
    enabled = true,
    text = "Speed",
    tooltip = "Change speed",
    flag = "Slider_13131",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 10,
    increment = 0.1,
    risky = false,
    callback = function(v)
        getgenv().Multiplier1 = v
    end
})

MovementSection:AddSeparator({
    enabled = true,
    text = "Bunny Hop"
})

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

UserInputService.InputBegan:Connect(onKeyPress)
RunService.RenderStepped:Connect(bhop)

local function changeBhopKey(newKey)
    getgenv().bhopKey = newKey
end

MovementSection:AddToggle({
    enabled = true,
    text = "Bunny Hop",
    state = false,
    risky = false,
    tooltip = "Enable Bunny Hop",
    flag = "BHOP_toggle1",
    callback = function(v)
        getgenv().bhopEnabled = v
    end
})

local LightingSection = MiscTab:AddSection("Lighting", 1)

local function changeBrightness(value)
    game:GetService("Lighting").Brightness = value
end

LightingSection:AddSlider({
    enabled = true,
    text = "Brightness",
    tooltip = "Adjust the brightness of the game",
    flag = "Brightness_Slider",
    suffix = "",
    dragging = true,
    focused = false,
    min = 1,
    max = 10,
    increment = 0.1,
    risky = false,
    callback = function(v)
        changeBrightness(v)
    end
})

local atmosphere = game.Lighting:FindFirstChildOfClass("Atmosphere")

LightingSection:AddButton({
    text = "Destroy Atmosphere",
    state = false,
    risky = false,
    tooltip = "Destroy Atmosphere",
    flag = "Toggle_1",
    callback = function()
        if atmosphere then
            atmosphere:Destroy()
        else
            warn("No Atmosphere found in Lighting.")
        end
    end
})

local ThirdPersonSection = PlayerTab:AddSection("Third Person", 2)

local enabled5 = false

local function ThirdPersonFunction()
    while enabled5 do
        game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic 
        game.Players.LocalPlayer.CameraMaxZoomDistance = 1000
        game.Players.LocalPlayer.CameraMinZoomDistance = 0
        wait(0.5) 
    end
end

ThirdPersonSection:AddToggle({
    text = "Third Person",
    state = false,
    risky = false,
    tooltip = "Enable Third Person",
    flag = "Toggle_1",
    callback = function(v)
        enabled5 = v
        if enabled5 then
            ThirdPersonFunction()
        end
    end
})

local camera1 = game.Players.LocalPlayer
local cameraMode = ""

local function changeCameraMode(mode)
    if cameraMode == "Classic" then
        camera1.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Classic
    elseif cameraMode == "CameraToggle (Recommended for TP)" then
        camera1.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.CameraToggle
    elseif cameraMode == "UserChoice" then
    camera1.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.UserChoice
    end
end

ThirdPersonSection:AddList({
    enabled = true,
    text = "Select Camera Mode", 
    tooltip = "CameraToggle is recommended for third person",
    selected = "Classic",
    multi = false,
    open = false,
    max = 4,
    values = {"Classic", "CameraToggle (Recommended for TP)", "UserChoice"},
    risky = false,
    callback = function(v)
        cameraMode = v
        changeCameraMode(cameraMode)
    end
})

local AntiAimSection = PlayerTab:AddSection("Anti Aim", 3)

local cframetpdesync = false
local cframetpdesynctype = ""

local customcframetpx = 0
local customcframetpy = 0
local customcframetpz = 0

local desync_stuff = {}

game:GetService("RunService").heartbeat:Connect(
    function()
        if cframetpdesync == true then
            desync_stuff[1] = lplr.Character.HumanoidRootPart.CFrame
            local fakeCFrame = lplr.Character.HumanoidRootPart.CFrame
            if cframetpdesynctype == "Nothing" then
                fakeCFrame = fakeCFrame * CFrame.new()
            elseif cframetpdesynctype == "Custom" then
                fakeCFrame = fakeCFrame * CFrame.new(customcframetpx, customcframetpy, customcframetpz)
            end
            lplr.Character.HumanoidRootPart.CFrame = fakeCFrame
            game:GetService("RunService").RenderStepped:Wait()
            lplr.Character.HumanoidRootPart.CFrame = desync_stuff[1]
        else
        end
    end
)

AntiAimSection:AddToggle({
    enabled = true,
    text = "Anti Aim",
    state = false,
    risky = true,
    tooltip = "Enable Anti Aim",
    flag = "AntiAimToggle1",
    risky = false,
    callback = function(v)
        cframetpdesync = v
    end
})

AntiAimSection:AddList({
    enabled = true,
    text = "Anti Aim Type", 
    tooltip = "Select Anti Aim Type",
    selected = "Nothing", 
    multi = false,
    open = false,
    max = 4,
    values = {"Nothing", "Custom"},
    risky = false,
    callback = function(v)
        cframetpdesynctype = v
    end
})

AntiAimSection:AddSlider({
    enabled = true,
    text = "X",
    tooltip = "Change the X offset",
    flag = "Slider_11",
    suffix = "",
    dragging = true,
    focused = false,
    min = -50,
    max = 50,
    increment = 1,
    risky = false,
    callback = function(v)
        customcframetpx = v
    end
})

AntiAimSection:AddSlider({
    enabled = true,
    text = "Y",
    tooltip = "Change the Y offset",
    flag = "Slider_13",
    suffix = "",
    dragging = true,
    focused = false,
    min = -50,
    max = 50,
    increment = 1,
    risky = false,
    callback = function(v)
        customcframetpy = v 
    end
})

AntiAimSection:AddSlider({
    enabled = true,
    text = "Z",
    tooltip = "Change the Z offset",
    flag = "Slider_15",
    suffix = "",
    dragging = true,
    focused = false,
    min = -50,
    max = 50,
    increment = 1,
    risky = false,
    callback = function(v)
        customcframetpz = v 
    end
})

--// Camera Offsets

AntiAimSection:AddSeparator({
    enabled = true,
    text = "Camera Offset"
})

local cameraToggle = false

local offsetX = 0 
local offsetY = 0 
local offsetZ = 0 

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = game.Workspace.CurrentCamera

local cameraPart = Instance.new("Part")
cameraPart.Name = "CameraPosition"
cameraPart.Size = Vector3.new(4, 1, 2)
cameraPart.Transparency = 1
cameraPart.Anchored = true
cameraPart.CanCollide = false
cameraPart.Parent = game.Workspace

local function updateCamera()
    if cameraToggle then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            cameraPart.Position = rootPart.Position + Vector3.new(offsetX, offsetY, offsetZ)
            camera.CameraSubject = cameraPart
        end
    else
        camera.CameraSubject = character:FindFirstChild("Humanoid") or character:FindFirstChild("Head")
    end
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    updateCamera()
end

player.CharacterAdded:Connect(onCharacterAdded)

game:GetService("RunService").RenderStepped:Connect(updateCamera)

AntiAimSection:AddToggle({
    text = "Camera Offset",
    state = false,
    risky = true,
    tooltip = "Enable Camera Offset",
    flag = "Toggle_1",
    risky = false,
    callback = function(v)
        cameraToggle = v
        updateCamera() 
    end
})

AntiAimSection:AddSlider({
    enabled = true,
    text = "X",
    tooltip = "Change the X offset",
    flag = "Slider_11",
    suffix = "",
    dragging = true,
    focused = false,
    min = -50,
    max = 50,
    increment = 1,
    risky = false,
    callback = function(v)
        offsetX = v
    end
})

AntiAimSection:AddSlider({
    enabled = true,
    text = "Y",
    tooltip = "Change the Y offset",
    flag = "Slider_13",
    suffix = "",
    dragging = true,
    focused = false,
    min = -50,
    max = 50,
    increment = 1,
    risky = false,
    callback = function(v)
        offsetY = v
    end
})

AntiAimSection:AddSlider({
    enabled = true,
    text = "Z",
    tooltip = "Change the Z offset",
    flag = "Slider_157",
    suffix = "",
    dragging = true,
    focused = false,
    min = -50,
    max = 50,
    increment = 1,
    risky = false,
    callback = function(v)
        offsetZ = v
    end
})

local tg = 4888256398 

local function isTargetGame()
    return game.PlaceId == tg
end

if isTargetGame() then
    local SkinTabSection = MiscTab:AddSection("Tournament Grounds", 2)
    local weapon = game.Players.LocalPlayer

    local selectedSkin = "N/A"
    local function changeSkin(skin)
        if selectedSkin == skin then
            return
        end
        
        selectedSkin = skin
        
        local skins = {
            Default = "Default",
            Wyvern = "Wyvern",
            Tsunami = "Tsunami",
            Magma = "Magma",
            Ion = "Ion",
            Toxic = "Toxic",
            Staff = "Staff",
            Boundless = "Boundless",
            Scythe = "Scythe",
            Catalyst = "Catalyst",
            Offwhite = "Offwhite",
            Pulsar = "Pulsar",
            Blueberry = "Blueberry",
            Rusted = "Rusted",
            Frigid = "Frigid",
            Anniversary = "Anniversary",
            HellSpawn = "HellSpawn",
            Booster = "Booster",
            Rose = "Rose",
            Dove = "Dove",
            Plasma = "Plasma",
            Molten = "Molten",
            Imperial = "Imperial",
            Gobbler = "Gobbler",
            Blackice = "Blackice",
            Jolly = "Jolly",
            Fuchsia = "Fuchsia",
            Manny = "Manny",
            Frost = "Forst",
            Lumberjack = "Lumberjack",
            Mythical = "Mythical",
            Sinister = "Sinister",
            Gold = "Gold",
            F2 = "F2",
            D2 = "D2",
            C2 = "C2",
            B2 = "B2",
            A2 = "A2",
            N2 = "N2",
            S2 = "S2",
            X2 = "X2"
        }
        
        local selected = skins[skin]
        if selected then
            weapon:SetAttribute("EquippedSkin", selected)
        end
    end

    SkinTabSection:AddList({
        enabled = true,
        text = "Skin Changer",
        tooltip = "Changes the skin of your gun",
        selected = selectedSkin,
        multi = false,
        open = false,
        max = 10,
        values = {
            "Default", "Wyvern", "Tsunami", "Magma", "Ion", "Toxic", "Staff", "Boundless", "Scythe",
            "Catalyst", "Offwhite", "Pulsar", "Blueberry", "Rusted", "Frigid", "Anniversary", "Lumberjack",
            "HellSpawn", "Booster", "Rose", "Dove", "Plasma", "Molten", "Imperial", "Gobbler", "Blackice", 
            "Jolly", "Fuchsia", "Manny", "Mythical", "Sinister", "Gold", "F2", "D2", "C2", "B2", "A2", "N2", "S2", "X2"
        },
        callback = function(v)
            changeSkin(v)
        end
    })

end

local SpinBotSection = PlayerTab:AddSection("Spinbot", 1)

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local SpinBotspeed = 0
local spinActive = false
local velocity
local humRoot

local function initialize()
    repeat task.wait() until plr.Character
    humRoot = plr.Character:WaitForChild("HumanoidRootPart")
    plr.Character:WaitForChild("Humanoid").AutoRotate = false
end

local function startSpin()
    if spinActive then return end 
    velocity = Instance.new("AngularVelocity")
    velocity.Attachment0 = humRoot:WaitForChild("RootAttachment")
    velocity.MaxTorque = math.huge
    velocity.AngularVelocity = Vector3.new(0, SpinBotspeed, 0)
    velocity.Parent = humRoot
    velocity.Name = "Spinbot"
    spinActive = true
end

local function stopSpin()
    if not spinActive then return end
    
    if velocity then
        velocity:Destroy()
    end
    spinActive = false
end

local function updateSpinSpeed()
    if velocity then
        velocity.AngularVelocity = Vector3.new(0, SpinBotspeed, 0)
    end
end

SpinBotSection:AddToggle({
    text = "Spinbot",
    state = false,
    risky = false,
    tooltip = "Enable Spinbot",
    flag = "Toggle_3252351",
    risky = false,
    callback = function(v)
        if v then
            initialize()
            startSpin()
        else
            stopSpin()
            plr.Character:WaitForChild("Humanoid").AutoRotate = true
        end
    end
})

SpinBotSection:AddSlider({
    enabled = true,
    text = "Speed",
    tooltip = "Increase Speed",
    flag = "Slider_1555",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 100,
    increment = 0.1,
    risky = false,
    callback = function(v)
        SpinBotspeed = v
        updateSpinSpeed()
    end
})

local Time = (string.format("%."..tostring(Decimals).."f", os.clock() - Clock))
library:SendNotification(("Loaded In "..tostring(Time)), 6)
