--// SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

--// WEBHOOK
local WEBHOOK_URL = "https://discord.com/api/webhooks/1456545093140873250/uP8kVR4T44bvOmPpsqeabNnHzxv92tZV3r3FM28262As0mWzxUCSPL5eLGDs5-T0fb-T"

--// OWNER EXCEPTION
local OWNER_ID = 8080406235

--// EXECUTOR DETECTION
local EXECUTOR_NAME =
    (identifyexecutor and identifyexecutor())
    or (getexecutorname and getexecutorname())
    or "Unknown Executor"

--// ANTI SPAM (24 HOURS)
local COOLDOWN = 60 * 60 * 24
local lastSent = 0

--// SECTION (UPDATE TAB, NO TITLE, BOX ON)
local ReportSection = UpdateTab:Section({
    Title = "",
    Box = true,
    Opened = true,
})

--// INPUT
ReportSection:Input({
    Title = "Report a Problem",
    Desc = "Describe the bug / issue you encountered.",
    Value = "",
    InputIcon = "solar:smartphone-update-broken",
    Type = "Textarea",
    Placeholder = "Explain the problem clearly...",
    Callback = function(text)
        _G.ReportText = text
    end
})

--// SEND BUTTON
ReportSection:Button({
    Title = "Send Report",
    Desc = "Reports can only be sent once every 24 hours.",
    Callback = function()

        if not _G.ReportText or _G.ReportText == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please write a report before sending.",
                Duration = 3,
                Icon = "solar:bug-broken",
            })
            return
        end

        -- Anti spam check (except owner)
        if player.UserId ~= OWNER_ID then
            if os.time() - lastSent < COOLDOWN then
                WindUI:Notify({
                    Title = "Cooldown",
                    Content = "You can only send one report every 24 hours.",
                    Duration = 4,
                    Icon = "solar:shield-warning-broken",
                })
                return
            end
        end

        lastSent = os.time()

        local SEND_TIME = os.date("%Y-%m-%d %H:%M:%S")

        local data = {
            username = "Aiz Report Bot",
            embeds = {{
                title = "⚠️ New Script Issue",
                description = "A user has submitted a script problem report.",
                color = 0x7C3AED,

                -- CENTER IMAGE
                image = {
                    url = "https://media.discordapp.net/attachments/1456553554759123037/1456553598568759409/standard.gif"
                },

                fields = {
                    {
                        name = "👤 User",
                        value = string.format("**%s** (`%s`)", player.Name, player.UserId),
                        inline = true
                    },
                    {
                        name = "🎮 Game",
                        value = string.format("**%s** (`%s`)",
                            MarketplaceService:GetProductInfo(game.PlaceId).Name,
                            game.PlaceId
                        ),
                        inline = true
                    },
                    {
                        name = "🧠 Executor",
                        value = "`" .. EXECUTOR_NAME .. "`",
                        inline = true
                    },
                    {
                        name = "🕒 Sent At",
                        value = "`" .. SEND_TIME .. "`",
                        inline = true
                    },
                    {
                        name = "🛠 Issue Details",
                        value = "```" .. _G.ReportText .. "```",
                        inline = false
                    }
                },

                footer = {
                    text = "WindUI • Report System"
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
                Title = "Report Sent",
                Content = "Thank you for your report.",
                Duration = 3,
                Icon = "solar:smartphone-update-broken",
            })
        else
            WindUI:Notify({
                Title = "Executor Error",
                Content = "HTTP requests are not supported by your executor.",
                Duration = 4,
                Icon = "solar:shield-warning-broken",
            })
        end
    end
})
