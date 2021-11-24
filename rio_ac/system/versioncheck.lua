if Anticheat.check_updates then
    log('[RioAnticheat] Checking for updates...')
    Citizen.CreateThread( function()
        local updatepath = '/ricardo13373/luaauthsystem/'
        local resourceName = 'esx_usefullitems (' ..GetCurrentResourceName()..')'
        function checkVersion(err, responseText, headers)
            local curVersion = LoadResourceFile(GetCurrentResourceName(), 'system/version')
            if not responseText then
                log('[RioAnticheat]: Update check failed, is new update is not finished yet!')
            elseif curVersion ~= responseText and tonumber(curVerison) < tonumber(responseText) then
                log("###############################")
                log("[RioAnticheat]:"..resourceName.." is outdated.")
                log("[RioAnticheat] Available version: " .. responseText)
                log("[RioAnticheat] Current Version: " .. curVersion)
                log("[RioAnticheat] Please update it from https://rioanticheatservices.com"..updatePath.."")
                log("###############################")
                log("[RioAnticheat] Or do /" .. GetCurrentResourceName() .. " autoupdate")
                log("[RioAnticheat] (This will not overwrite your config.lua file)")
                log("###############################")
                
            elseif tonumber(curVersion) > tonumber(responseText) then
                log("[RioAnticheat] You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update ( or downgrade? )")
            else
                log("[RioAnticheat]"..resourceName.." is up to date, have fun!")
            end
        end
        PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
    end)
end
RegisterCommand(GetCurrentResourceName(), function(_, args)
    if args[1] == "autoupdate" then
        log("###############################")
        log("[RioAnticheat] Updating resource")
        log("###############################")
        local updatePath = "/TheRealToxicDev/ToxicAntiCheat"
        PerformHttpRequest("https://raw.githubusercontent.com/TheRealToxicDev/ToxicAntiCheat/master/autoupdate", function(err, responseText, headers)
            local function updateFile(fileName)
                local ok = false
                local _l = false
                PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/" .. fileName, function(err, responseText, headers)
                    if err ~= 200 then
                        log("Failed to download file " .. fileName .. ": " .. err)
                    else
                        if LoadResourceFile(GetCurrentResourceName(), fileName) ~= responseText then
                            log("[RioAnticheat] Downloading file " .. fileName)
                            SaveResourceFile(GetCurrentResourceName(), fileName, responseText, -1)
                            if not LoadResourceFile(GetCurrentResourceName(), fileName) then
                                log("[RioAnticheat] Failed to save file " .. fileName.. ". Does the directory exist?")
                            else
                                ok = true
                            end
                        end
                    end
                    _l = true
                end)
                while not _l do Wait(0) end
                return ok
            end
            local files = 0
            for fileName in string.gmatch(responseText, "%S+") do
                if updateFile(fileName) then
                    files = files + 1
                end
            end
            if files > 0 then
                log("###############################")
                log("[RioAnticheat] Updated " .. files .. " files")
            else
                log("[RioAnticheat] No changes were made")
            end
            log("###############################")
            log("[RioAnticheat] Please /refresh then /restart " .. GetCurrentResourceName())
            end
            log("###############################")
        end, "GET")
    else
        log("[RioAnticheat] Did you mean to do /" .. GetCurrentResourceName() .. " autoupdate?")
    end
end, true)
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=

