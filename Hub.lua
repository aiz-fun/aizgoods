local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
-- [Aiz Hu Theme]

WindUI:AddTheme({
    Name = "Modern-Purple",
    Accent = WindUI:Gradient({
        ["0"] = {
            Color = Color3.fromHex("#D27BFF"),
            Transparency = 1,
        },
        ["100"] = {
            Color = Color3.fromHex("#511069"), 
        },
    }, {
        Rotation = 135,
    }),
})
local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "door-open",
    Author = "by .ftgs and .ftgs",
    Folder = "MySuperHub",
    
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
         local player = game.Players.LocalPlayer
        setclipboard(player.Name)

        WindUI:Notify({
        Title = "Username Copied",
        Content = "Your username: " .. player.Name,
        Duration = 2,
        Icon = "solar:bell-bold-duotone",
    })
       end,
    },
})
-- [Custom Top Bar Button]
Window:CreateTopbarButton("Discord", "solar:login-2-broken",    function() setclipboard("https://discord.gg/ftgs") end,  990)
-- [End Custom Top Bar Button]

-- [User Tab]
local UserTab = Window:Tab({Title = "User",Icon = "solar:user-broken", Locked = false,})
-- [End User Tab]

-- [Update Tab]
local UpdateTab = Window:Tab({Title = "Update",Icon = "solar:smartphone-update-broken", Locked = false,})

local Paragraph = UpdateTab:Paragraph({
    Title = "Paragraph with Image, Thumbnail, Buttons",
    Desc = "Test Paragraph",
    Color = "Red",
    Locked = false,
    Buttons = {
        {
            Icon = "bird",
            Title = "Button",
            Callback = function() print("1 Button") end,
        }
    }
})
-- SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- DISCORD WEBHOOK
local WEBHOOK_URL = "https://discord.com/api/webhooks/1456545093140873250/uP8kVR4T44bvOmPpsqeabNnHzxv92tZV3r3FM28262As0mWzxUCSPL5eLGDs5-T0fb-T"

-- SECTION (UPDATE TAB, NO TITLE, BOX ON)
local ReportSection = UpdateTab:Section({ 
    Title = "", -- no title
    Box = true,
    Opened = true,
})

-- INPUT REPORT
ReportSection:Input({
    Title = "",
    Desc = "",
    Value = "",
    InputIcon = "solar:smartphone-update-broken",
    Type = "Textarea",
    Placeholder = "Describe the problem here...",
    Callback = function(text)
        _G.ReportText = text
    end
})

-- BUTTON SEND REPORT
ReportSection:Button({
    Title = "Send Report",
    Desc = "",
    Callback = function()

        if not _G.ReportText or _G.ReportText == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please write something before sending.",
                Duration = 3,
                Icon = "solar:bug-broken",
            })
            return
        end

        local data = {
            username = "Script Report Bot",
            embeds = {{
                title = "🛠 Script Problem Report",
                color = 0x8B5CF6,
                fields = {
                    {
                        name = "User",
                        value = player.Name .. " (" .. player.UserId .. ")",
                        inline = false
                    },
                    {
                        name = "Game",
                        value = MarketplaceService:GetProductInfo(game.PlaceId).Name,
                        inline = false
                    },
                    {
                        name = "Problem",
                        value = _G.ReportText,
                        inline = false
                    }
                },
                footer = {
                    text = "WindUI Report System"
                },
                timestamp = DateTime.now():ToIsoDate()
            }}
        }

        local req = (syn and syn.request) or request or http_request
        if req then
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(data)
            })

            WindUI:Notify({
                Title = "Sent",
                Content = "Your report has been sent.",
                Duration = 3,
                Icon = "solar:smartphone-update-broken",
            })
        else
            WindUI:Notify({
                Title = "Executor Error",
                Content = "HTTP request is not supported.",
                Duration = 4,
                Icon = "solar:shield-warning-broken",
            })
        end
    end
})

-- [End Update Tab]
