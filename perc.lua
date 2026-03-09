local DISCORD_INVITE = "https://discord.gg/UkPDe8hF4p" 
local LOADSTRING_URL = "https://raw.githubusercontent.com/wEquals/sematarygoth/refs/heads/main/percnew.lua" 

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Subtitle = Instance.new("TextLabel")
local YesBtn = Instance.new("TextButton")
local NoBtn = Instance.new("TextButton")
local DiscordIcon = Instance.new("ImageLabel")

ScreenGui.Name = "SemataryFinal"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 0)
UIStroke.Transparency = 0.4

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.1, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "ACCESS REQUIRED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

Subtitle.Parent = MainFrame
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 0, 0.25, 0)
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Join the Discord to continue"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextSize = 12

DiscordIcon.Parent = MainFrame
DiscordIcon.AnchorPoint = Vector2.new(0.5, 0.5)
DiscordIcon.BackgroundTransparency = 1
DiscordIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
DiscordIcon.Size = UDim2.new(0, 85, 0, 85)
DiscordIcon.Image = "rbxassetid://76181608348088"
DiscordIcon.ImageColor3 = Color3.fromRGB(255, 255, 0)
DiscordIcon.ImageTransparency = 0.95

task.spawn(function()
    while DiscordIcon.Parent do
        TweenService:Create(DiscordIcon, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.88, Size = UDim2.new(0, 100, 0, 100)}):Play()
        task.wait(2)
        TweenService:Create(DiscordIcon, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.95, Size = UDim2.new(0, 85, 0, 85)}):Play()
        task.wait(2)
    end
end)

local function SetupButton(btn, text, pos, size, isMain)
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = size
    btn.BackgroundColor3 = isMain and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(25, 25, 25)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = isMain and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 200)
    btn.TextSize = isMain and 14 or 12
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local glow = Instance.new("UIStroke", btn)
    glow.Thickness = 0
    glow.Color = Color3.fromRGB(255, 255, 255)
    glow.Transparency = 1
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = isMain and Color3.fromRGB(220, 220, 0) or Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.3), {Thickness = 3, Transparency = 0.6}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = isMain and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(25, 25, 25)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.3), {Thickness = 0, Transparency = 1}):Play()
    end)
end

SetupButton(YesBtn, "I HAVE JOINED", UDim2.new(0.1, 0, 0.52, 0), UDim2.new(0, 256, 0, 40), true)
SetupButton(NoBtn, "COPY INVITE LINK", UDim2.new(0.1, 0, 0.75, 0), UDim2.new(0, 256, 0, 32), false)

NoBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_INVITE)
        local oldText = NoBtn.Text
        NoBtn.Text = "LINK COPIED!"
        task.wait(1.5)
        NoBtn.Text = oldText
    end
end)

YesBtn.MouseButton1Click:Connect(function()
    local hide = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    TweenService:Create(MainFrame, hide, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
    TweenService:Create(UIStroke, hide, {Transparency = 1}):Play()
    for _, v in pairs(MainFrame:GetChildren()) do if v:IsA("GuiObject") then v.Visible = false end end
    task.wait(0.4)
    ScreenGui:Destroy()
    loadstring(game:HttpGet(LOADSTRING_URL))()
end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MainFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
