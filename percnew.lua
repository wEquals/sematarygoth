local DISCORD_INVITE = "https://discord.gg/UkPDe8hF4p" 
local PC_LOADSTRING = "https://raw.githubusercontent.com/wEquals/sematarygoth/refs/heads/main/percpc.lua" 
local MOBILE_LOADSTRING = "https://raw.githubusercontent.com/wEquals/sematarygoth/refs/heads/main/mobile.lua" 
local CORRECT_KEY = "RELEASE"
local KEY_FILE = "perckey.txt" -- Updated filename

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Function to handle execution based on device type
local function ExecuteScript()
    local targetURL = PC_LOADSTRING
    -- Detects if user is on a mobile/touch device without a physical keyboard
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        targetURL = MOBILE_LOADSTRING
    end
    loadstring(game:HttpGet(targetURL))()
end

-- Check workspace for existing key file
if isfile and isfile(KEY_FILE) then
    if readfile(KEY_FILE) == CORRECT_KEY then
        ExecuteScript()
        return -- Exit the loader since they already have the key
    end
end

-- UI Construction
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local SubmitBtn = Instance.new("TextButton")
local DiscordBtn = Instance.new("TextButton")

ScreenGui.Name = "SemataryLoader"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
MainFrame.Size = UDim2.new(0, 280, 0, 200)

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 0)
UIStroke.Transparency = 0.5

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "SYSTEM ACCESS"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextSize = 16

-- Key Input Field with improved text sizing
KeyInput.Parent = MainFrame
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyInput.Position = UDim2.new(0.1, 0, 0.32, 0) -- Adjusted position
KeyInput.Size = UDim2.new(0.8, 0, 0, 38) -- Slightly taller for better text fit
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.GothamSemibold -- Slightly thicker font for clarity
KeyInput.TextScaled = true -- Makes the text fill the box

-- Limits the text size so it doesn't touch the edges
local TextConstraint = Instance.new("UITextSizeConstraint", KeyInput)
TextConstraint.MaxTextSize = 16
TextConstraint.MinTextSize = 12

Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

-- Updated SetupButton to also use better text sizing
local function SetupButton(btn, text, pos, isMain)
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(0.8, 0, 0, 32)
    btn.BackgroundColor3 = isMain and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = isMain and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    
    -- Added text scaling to buttons for mobile/PC consistency
    btn.TextScaled = true
    local BtnConstraint = Instance.new("UITextSizeConstraint", btn)
    BtnConstraint.MaxTextSize = 14
    BtnConstraint.MinTextSize = 10
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
end

SetupButton(SubmitBtn, "VERIFY KEY", UDim2.new(0.1, 0, 0.55, 0), true)
SetupButton(DiscordBtn, "COPY DISCORD (GET KEY)", UDim2.new(0.1, 0, 0.75, 0), false)

-- Click Events
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        -- Save to perckey.txt in workspace
        if writefile then
            writefile(KEY_FILE, CORRECT_KEY)
        end
        
        SubmitBtn.Text = "ACCESS GRANTED"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(0.5)
        ScreenGui:Destroy()
        ExecuteScript()
    else
        SubmitBtn.Text = "INVALID KEY"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1)
        SubmitBtn.Text = "VERIFY KEY"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_INVITE) end
    DiscordBtn.Text = "COPIED TO CLIPBOARD"
    task.wait(1)
    DiscordBtn.Text = "COPY DISCORD (GET KEY)"
end)

-- Mobile & PC Dragging Logic
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true 
        dragStart = input.Position 
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MainFrame.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end 
end)
