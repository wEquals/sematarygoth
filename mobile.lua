local DISCORD_INVITE = "https://discord.gg/UkPDe8hF4p"

-- Notification Library Setup
local NotificationHolder = loadstring(game:HttpGet('https://raw.githubusercontent.com/DozeIsOkLol/NotificationLibs/refs/heads/main/BocusLukeNotif/ModuleSource.lua'))()
local Notification = loadstring(game:HttpGet('https://raw.githubusercontent.com/DozeIsOkLol/NotificationLibs/refs/heads/main/BocusLukeNotif/ClientSource.lua'))()

-- UI Construction
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local InfoLabel = Instance.new("TextLabel")
local DiscordBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "SemataryLoader"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
MainFrame.Size = UDim2.new(0, 280, 0, 150)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 84, 84)

-- Close Button (X) - Updated for top-right positioning
CloseBtn.Parent = MainFrame
-- UDim2.new(X Scale, X Offset, Y Scale, Y Offset)
-- 0.95 Scale + -25 Offset pushes it to the right corner
CloseBtn.Position = UDim2.new(0.95, -25, 0.05, 0)
CloseBtn.Size = UDim2.new(0, 25, 0, 20) -- Slightly smaller to fit the header
CloseBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 84, 84)
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "OUTDATED LOADER"
Title.TextColor3 = Color3.fromRGB(255, 84, 84)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

InfoLabel.Parent = MainFrame
InfoLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
InfoLabel.Size = UDim2.new(0.8, 0, 0, 40)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Please get the latest loader from our Discord server."
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextScaled = true

DiscordBtn.Parent = MainFrame
DiscordBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
DiscordBtn.Size = UDim2.new(0.8, 0, 0, 35)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(255, 84, 84)
DiscordBtn.Text = "COPY DISCORD INVITE"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)

-- Click Event
DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then 
        setclipboard(DISCORD_INVITE) 
        Notification:Notify(
            { Title = 'Success', Description = 'Link copied to clipboard!' },
            { OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = 'default' }
        )
    end
end)
