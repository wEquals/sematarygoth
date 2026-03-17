local NotificationHolder = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/DozeIsOkLol/NotificationLibs/refs/heads/main/BocusLukeNotif/ModuleSource.lua'
    )
)()
local Notification = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/DozeIsOkLol/NotificationLibs/refs/heads/main/BocusLukeNotif/ClientSource.lua'
    )
)()

Notification:Notify(
    { Title = 'perc.hook', Description = 'script is currently down' },
    { OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = 'default' }
)
