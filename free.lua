local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
local notifications = notificationLibrary.new({            
    NotificationLifetime = 10, 
    NotificationPosition = "Middle",
    
    TextFont = Enum.Font.Code,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 30,
    
    TextStrokeTransparency = 0, 
    TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

notifications:BuildNotificationUI();
notifications:Notify("Please purchase Project X. Auth Failed.");

local playerName = game.Players.LocalPlayer.Name
local timestamp = getTimeWithTimezone()
local gameLink = "https://www.roblox.com/games/" .. tostring(game.PlaceId)
local version = "Project X Ended Trial"
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
