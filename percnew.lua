local DISCORD_INVITE = "https://discord.gg/UkPDe8hF4p" 
local LOADSTRING_URL = "https://raw.githubusercontent.com/wEquals/sematarygoth/refs/heads/main/percpc.lua" 
local CORRECT_KEY = "RELEASE" -- Your set key

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Subtitle = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox") -- Added TextBox
local SubmitBtn = Instance.new("TextButton")
local DiscordBtn = Instance.new("TextButton")

ScreenGui.Name = "SemataryKeySystem"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.Size = UDim2.new(0, 320, 0, 240) -- Made slightly taller
MainFrame.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 0)
UIStroke.Transparency = 0.4

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.05, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "KEY REQUIRED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

Subtitle.Parent = MainFrame
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 0, 0.18, 0)
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Get the key from our Discord server"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextSize = 11

-- Key Input Field
KeyInput.Name = "KeyInput"
KeyInput.Parent = MainFrame
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Font = Enum.Font.Gotham
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
local KeyCorner = Instance.new("UICorner", KeyInput)
KeyCorner.CornerRadius = UDim.new(0, 8)
local KeyStroke = Instance.new("UIStroke", KeyInput)
KeyStroke.Color = Color3.fromRGB(255, 255, 0)
KeyStroke.Transparency = 0.8

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
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = isMain and Color3.fromRGB(220, 220, 0) or Color3.fromRGB(40, 40, 40)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = isMain and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(25, 25, 25)}):Play()
    end)
end

SetupButton(SubmitBtn, "CHECK KEY", UDim2.new(0.1, 0, 0.58, 0), UDim2.new(0.8, 0, 0, 35), true)
SetupButton(DiscordBtn, "COPY DISCORD INVITE", UDim2.new(0.1, 0, 0.78, 0), UDim2.new(0.8, 0, 0, 30), false)

DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_INVITE)
        DiscordBtn.Text = "COPIED TO CLIPBOARD!"
        task.wait(1.5)
        DiscordBtn.Text = "COPY DISCORD INVITE"
    end
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        SubmitBtn.Text = "CORRECT! LOADING..."
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        local hide = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(MainFrame, hide, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
        loadstring(game:HttpGet(LOADSTRING_URL))()
    else
        SubmitBtn.Text = "INVALID KEY"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1)
        SubmitBtn.Text = "CHECK KEY"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    end
end)

-- Dragging Logic
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
