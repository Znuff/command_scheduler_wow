local frame = CreateFrame("Frame")
local timers = {}

-- Function to convert time string to seconds
local function ParseTime(timeStr)
    local number, suffix = timeStr:match("^(%d+%.?%d*)(%a?)$")
    if not number then return nil end
    
    number = tonumber(number)
    if not number then return nil end
    
    if suffix == "" or suffix == "s" then
        return number
    elseif suffix == "m" then
        return number * 60
    else
        return nil
    end
end

-- Function to schedule a slash command
local function ScheduleCommand(command, delay)
    if type(command) ~= "string" or type(delay) ~= "number" then return end
    table.insert(timers, {
        command = command,
        executeAt = GetTime() + delay
    })
end

frame:SetScript("OnUpdate", function(self, elapsed)
    local currentTime = GetTime()
    local i = 1
    while i <= #timers do
        local timer = timers[i]
        if currentTime >= timer.executeAt then
            -- Execute command
            local command = timer.command
            if command:match("^/") then
                -- Execute as slash command (already has /)
                pcall(function() 
                    RunScript(string.format([[
                        local commandText = %q
                        DEFAULT_CHAT_FRAME.editBox:SetText(commandText)
                        ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
                    ]], command))
                end)
            else
                -- Execute as Lua code
                pcall(function()
                    RunScript(command)
                end)
            end
            table.remove(timers, i)
        else
            i = i + 1
        end
    end
end)

SLASH_SCHEDULE1 = "/schedule"
SlashCmdList["SCHEDULE"] = function(msg)
    local timeStr, command = msg:match("^(%S+)%s+(.+)$")
    if not timeStr or not command then
        print("Usage: /schedule <time> <command>")
        print("Time format: number[s|m] (e.g., 30, 60s, 1m)")
        print("Commands starting with / are executed as slash commands")
        print("Commands without / are executed as Lua code")
        print("Examples:")
        print("  /schedule 30s /say Hello World")
        print("  /schedule 1m print('Lua code executed!')")
        return
    end
    
    local seconds = ParseTime(timeStr)
    if not seconds then
        print("Invalid time format. Use: number[s|m]")
        print("Examples: 30, 60s, 1m")
        return
    end
    
    ScheduleCommand(command, seconds)
    print(string.format("Scheduled '%s' to run in %.1f seconds", command, seconds))
end