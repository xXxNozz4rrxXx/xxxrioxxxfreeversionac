local CGB = {}

AddEventHandler("cgb:getLibraryTIGOVERSION",function(cb) cb(CGB) end)

SetConvarServerInfo("✖ Global BanSystem ✖", "active")



CGB.PlayerJoinEvent = function(source,deferrals)

    name = GetPlayerName(source)

    deferrals.defer()

    local player,reason,banid,banned,playerinfo = source,AntiCheat.Locale.Translate('empty_reason'),0,false,{name=name}

    Wait(0)

    deferrals.update(AntiCheat.Locale.Translate('globalbans_checkingmessage'))

    Wait(0)



    status = {checked=false,identamount=0,steamset=false,licenseset=false}

    checkwebsite = "https://license.carste.de/checkban.php?"

    for _,ident in pairs(GetPlayerIdentifiers(player)) do

        if string.sub(ident, 1, string.len("steam:"))   == "steam:"   then checkwebsite = checkwebsite.."steam="..ident.."&" status.identamount = status.identamount + 1 status.steamset = true end

        if string.sub(ident, 1, string.len("license:"))   == "license:"   then checkwebsite = checkwebsite.."license="..ident.."&" status.identamount = status.identamount + 1 status.licenseset = true end

        if string.sub(ident, 1, string.len("xbl:"))     == "xbl:"      then checkwebsite = checkwebsite.."xbl="..ident.."&" status.identamount = status.identamount + 1 end

        if string.sub(ident, 1, string.len("live:"))     == "live:"      then checkwebsite = checkwebsite.."live="..ident.."&" status.identamount = status.identamount + 1 end

        if string.sub(ident, 1, string.len("discord:")) == "discord:" then checkwebsite = checkwebsite.."discord="..ident.."&" status.identamount = status.identamount + 1 end

        if string.sub(ident, 1, string.len("ip:")) == "ip:" then checkwebsite = checkwebsite.."ip="..ident.."&" status.identamount = status.identamount + 1 end

    end

    checkwebsite = checkwebsite.."byscript=true"

    if status.identamount ~= 0 and status.steamset == true and status.licenseset == true then

        PerformHttpRequest(checkwebsite, function (errorCode, resultData, resultHeaders)

            info = json.decode(tostring(resultData))

            if info ~= nil then

                if type(info) == "table" then

                    status.checked = true

                end

            end



            if status.checked == true then

                if info.banned == true then

                    if info.global == true then

                        CGB.SendDiscordMessage("connect",{pname=name,global=true,banid=info.banid,reason=info.reason,expires=info.expires,server=info.server})

                        print("^1GlobalBans | A globally banned player tried to join your server. Name: "..name.." BanID: "..info.banid.."^7")

                        deferrals.done(string.format(AntiCheat.Locale.Translate('globalbans_bannedglobal'),info.reason,info.expires,info.banid,info.server))

                    else

                        CGB.SendDiscordMessage("connect",{pname=name,global=false,banid=info.banid,reason=info.reason,expires=info.expires})

                        print("^1GlobalBans | A locally banned player tried to join your server. Name: "..name.." BanID: "..info.banid.."^7")

                        deferrals.done(string.format(AntiCheat.Locale.Translate('globalbans_bannedlocal'),info.reason,info.expires,info.banid))

                    end

                else

                    if info.whitelisted then

                        print("^1GlobalBans | A globally banned player is joining your Server (Whitelisted) Name: "..name.." BanID: "..info.banid.." - '/gwhitelist "..info.banid.."' to revoke this privilege.^7")

                    end

                    deferrals.done()

                end

            else

                deferrals.done("\n🚨 Connection failed 🚨\n\nAn error occurred.\nPlease contact support@carste.de\n\n🚨 Connection failed 🚨")

            end

        end)

    else

        deferrals.done(AntiCheat.Locale.Translate('globalbans_noidentifiers'))

    end



end



CGB.CurrentlyTryingToBan = {}

--

-- Banns a Player. (Globally/Locally)

--

-- @param source PlayerID Integer

-- @param reason Grund String

-- @param time Bantime Table

-- @param global Boolean

-- @param kick Boolean

--

-- return: true / false / error message

--

CGB.BanPlayer = function(playerId,reason,time,global,kick,adminlabel,cb)

    playername = GetPlayerName(playerId)



    for _,v in pairs(CGB.CurrentlyTryingToBan) do

        if v == playername then

            return true

        end

    end

    table.insert(CGB.CurrentlyTryingToBan,playername)



    -- {year=,month=,day=,hour=,min=,sec=}

    if type(time) == "table" then

        if time.year == nil then time.year = 0 end if time.month == nil then time.month = 0 end

        if time.day == nil then time.day = 0 end if time.hour == nil then time.hour = 0 end

        if time.min == nil then time.min = 0 end if time.sec == nil then time.sec = 0 end

        if time.year < 0 then time.year = 0 end if time.month < 0 then time.month = 0 end

        if time.day < 0 then time.day = 0 end if time.hour < 0 then time.hour = 0 end

        if time.min < 0 then time.min = 0 end if time.sec < 0 then time.sec = 0 end



    --print(os.time{year=time.year,month=time.month,day=time.day,hour=time.hour,min=time.min,sec=time.sec})



    else

        time = {year=0,month=0,day=1,hour=0,min=0,sec=0}

    end

    firstime = os.time{year=2000+time.year, month=time.month, day=time.day,hour=time.hour,min=time.min,sec=time.sec}

    if firstime == nil then

        firstime = os.time{year=2035, month=1, day=1,hour=0,min=0,sec=0}

    end

    addtime =  firstime - os.time{year=2000,month=0,day=0}



    currentdate = os.date("!*t", os.time(os.date("!*t"))+(AntiCheat.hourausgleich*3600)+addtime)

    if currentdate.month < 10 then currentdate.month = "0"..currentdate.month end

    if currentdate.day < 10 then currentdate.day = "0"..currentdate.day end

    if currentdate.hour < 10 then currentdate.hour = "0"..currentdate.hour end

    if currentdate.min < 10 then currentdate.min = "0"..currentdate.min end

    if currentdate.sec < 10 then currentdate.sec = "0"..currentdate.sec end

    timestamp_day = currentdate.year.."-"..currentdate.month.."-"..currentdate.day

    timestamp_time = currentdate.hour..":"..currentdate.min..":"..currentdate.sec



    if addtime > 157636800 then

        timestamp_day = "2035-01-01"

        timestamp_time = "00:00:00"

    end



    if reason == "nil" or reason == "" then

        reason = AntiCheat.Locale.Translate('empty_reason')

    end

    reason = reason:gsub(' ','_')

    print("^1GlobalBans | Trying to ban "..playername.." until "..timestamp_day.." "..timestamp_time.." for "..reason:gsub('_',' ').."^7")

    if global == nil then global = false end

    banwebsite = "https://licence.carste.de/addban.php?global="..tostring(global)

    identamount = 0

    checked = false

    for _,ident in pairs(GetPlayerIdentifiers(playerId)) do

        if string.sub(ident, 1, string.len("steam:"))   == "steam:"   then banwebsite = banwebsite.."&steam="..ident identamount = identamount + 1 end

        if string.sub(ident, 1, string.len("license:"))   == "license:"   then banwebsite = banwebsite.."&license="..ident identamount = identamount + 1 end

        if string.sub(ident, 1, string.len("xbl:"))     == "xbl:"      then banwebsite = banwebsite.."&xbl="..ident identamount = identamount + 1 end

        if string.sub(ident, 1, string.len("live:"))     == "live:"      then banwebsite = banwebsite.."&live="..ident identamount = identamount + 1 end

        if string.sub(ident, 1, string.len("discord:")) == "discord:" then banwebsite = banwebsite.."&discord="..ident identamount = identamount + 1 end

        if string.sub(ident, 1, string.len("ip:")) == "ip:" then banwebsite = banwebsite.."&ip="..ident identamount = identamount + 1 end

    end

    banwebsite = banwebsite .. "&reason="..reason

    banwebsite = banwebsite .. "&day="..timestamp_day

    banwebsite = banwebsite .. "&time="..timestamp_time

    banwebsite = banwebsite .. "&byscript=true"

    if kick ~= nil and kick == true then

        DropPlayer(playerId, string.format(AntiCheat.Locale.Translate('globalbans_bankick'),reason:gsub('_',' '),timestamp_day.." "..timestamp_time))

    end

    PerformHttpRequest(banwebsite, function (errorCode, resultData, resultHeaders)

        info = json.decode(tostring(resultData))

        if info ~= nil then

            if type(info) == "table" then

                checked = true

            end

        end

        for ____,pn in pairs(CGB.CurrentlyTryingToBan) do

            if pn == playername then

                table.remove(CGB.CurrentlyTryingToBan,____)

            end

        end

        if checked then

            if info.status then

                CGB.SendDiscordMessage("ban",{pname=playername,pid=playerId,aname=adminlabel,banid=info.banid,global=info.global,reason=reason:gsub('_',' '),unbandate=timestamp_day.." "..timestamp_time})

                cb(true,info.banid,info.global)

            else cb(info.message) end

        else

            cb(false)

        end

    end)

end



--

-- UnBanns a Player.

--

-- @param banid BanID Integer

--

-- return: true / false / error message

--

CGB.UnbanPlayer = function(banid,cb)

    checked = false

    unbanwebsite = "https://licence.carste.de/delban.php?byscript=true&banid="..banid

    PerformHttpRequest(unbanwebsite, function (errorCode, resultData, resultHeaders)

        info = json.decode(tostring(resultData))

        if info ~= nil then

            if type(info) == "table" then

                checked = true

            end

        end

        if checked then

            if info.status then

                cb(true)

            else

                cb(info.message)

            end

        else

            cb(false)

        end

    end)

end



RegisterCommand("unban", function (source,args,rawCommand)

    UnbanPlayerFunction(source,args,rawCommand)

end)



RegisterCommand("gunban", function (source,args,rawCommand)

    UnbanPlayerFunction(source,args,rawCommand)

end)





function UnbanPlayerFunction (source, args, rawCommand)

    if CGB.CheckPerm(source,"tigoanticheat.unban") then

        banid = tonumber(args[1])

        if(banid and banid ~= 0) then

            CGB.UnbanPlayer(banid,function(res)

                if res == true then

                    if (source > 0) then

                        TriggerClientEvent('chat:addMessage', source, {

                            color = { 255, 0, 0},

                            multiline = true,

                            args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_unbanned'),banid).."^7"}

                        })

                    else

                        print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_unbanned'),banid).."^7")

                    end

                else

                    if (source > 0) then

                        TriggerClientEvent('chat:addMessage', source, {

                            color = { 255, 0, 0},

                            multiline = true,

                            args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_unbanerror'),res).."^7"}

                        })

                    else

                        print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_unbanerror'),res).."^7")

                    end

                end

            end)

        else

            if (source > 0) then

                TriggerClientEvent('chat:addMessage', source, {

                    color = { 255, 0, 0},

                    multiline = true,

                    args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_unbanusage').."^7"}

                })

            else

                print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_unbanusage').."^7")

            end



        end

    else

        if (source > 0) then

            TriggerClientEvent('chat:addMessage', source, {

                color = { 255, 0, 0},

                multiline = true,

                args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_noperms').."^7"}

            })

        else

            print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_noperms').."^7")

        end

    end

end





function BanPlayerFunction(source, args, rawCommand,global)

    perm = "tigoanticheat.ban"

    if global then

        perm = "tigoanticheat.gban"

    end

    if CGB.CheckPerm(source,perm) then

        playerid = tonumber(args[1])

        days = tonumber(args[2])

        reason = AntiCheat.Locale.Translate('empty_reason')



        if(playerid and playerid ~= 0) and (days and days ~= 0)then

            for _,v in pairs(args) do

                if _ ~= 1 and _ ~= 2 then

                    if _ == 3 then

                        reason = v

                    else

                        reason = reason .." "..v

                    end

                end

            end

            if GetPlayerPing(playerid) ~= 0 then

                playername = GetPlayerName(playerid)

                if source == 0 then

                    adminname = "CONSOLE"

                else

                    adminname = GetPlayerName(source)

                end

                CGB.BanPlayer(playerid,reason,{day=days},global,true,adminname,function(res,banid)

                    if res == true then

                        if global then

                            if (source > 0) then

                                TriggerClientEvent('chat:addMessage', source, {

                                    color = { 255, 0, 0},

                                    multiline = true,

                                    args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_gbanned'),banid,playername).."^7"} --res,banid

                                })

                            else

                                print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_gbanned'),banid,playername).."^7")

                            end

                        else

                            if (source > 0) then

                                TriggerClientEvent('chat:addMessage', source, {

                                    color = { 255, 0, 0},

                                    multiline = true,

                                    args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_banned'),banid,playername).."^7"}

                                })

                            else

                                print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_banned'),banid,playername).."^7")

                            end

                        end

                    else

                        if (source > 0) then

                            TriggerClientEvent('chat:addMessage', source, {

                                color = { 255, 0, 0},

                                multiline = true,

                                args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_banerror'),res).."^7"}

                            })

                        else

                            print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_banerror'),res).."^7")

                        end

                    end

                end)

            else

                if (source > 0) then

                    TriggerClientEvent('chat:addMessage', source, {

                        color = { 255, 0, 0},

                        multiline = true,

                        args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_bannotonline').."^7"}

                    })

                else

                    print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_bannotonline').."^7")

                end

            end

        else

            if global then

                if (source > 0) then

                    TriggerClientEvent('chat:addMessage', source, {

                        color = { 255, 0, 0},

                        multiline = true,

                        args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_gbanusage').."^7"}

                    })

                else

                    print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_gbanusage').."^7")

                end

            else

                if (source > 0) then

                    TriggerClientEvent('chat:addMessage', source, {

                        color = { 255, 0, 0},

                        multiline = true,

                        args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_banusage').."^7"}

                    })

                else

                    print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_banusage').."^7")

                end



            end

        end

    else

        if (source > 0) then

            TriggerClientEvent('chat:addMessage', source, {

                color = { 255, 0, 0},

                multiline = true,

                args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_noperms').."^7"}

            })

        else

            print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_noperms').."^7")

        end

    end



end



RegisterCommand("gban",function(source,args,rawCommand)

    BanPlayerFunction(source,args,rawCommand,true)

end)



RegisterCommand("lban", function(source,args,rawCommand)

    BanPlayerFunction(source,args,rawCommand,false)

end)



RegisterCommand("gwhitelist", function(source, args, rawCommand)

    if CGB.CheckPerm(source,"tigoanticheat.gwhitelist") then

        banid = tonumber(args[1])

        if(banid and banid ~= 0) then

            CGB.GlobalWhitelist(banid,function(durch,msgorstatus,newstatus)

                if durch then

                    if msgorstatus then

                        if newstatus then

                            if (source > 0) then

                                TriggerClientEvent('chat:addMessage', source, {

                                    color = { 255, 0, 0},

                                    multiline = true,

                                    args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_gwhitelistyes'),banid).."^7"}

                                })

                            else

                                print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_gwhitelistyes'),banid).."^7")

                            end

                        else

                            if (source > 0) then

                                TriggerClientEvent('chat:addMessage', source, {

                                    color = { 255, 0, 0},

                                    multiline = true,

                                    args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_gwhitelistno'),banid).."^7"}

                                })

                            else

                                print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_gwhitelistno'),banid).."^7")

                            end

                        end

                    else

                        if (source > 0) then

                            TriggerClientEvent('chat:addMessage', source, {

                                color = { 255, 0, 0},

                                multiline = true,

                                args = {"GlobalBans | ", string.format(AntiCheat.Locale.Translate('globalbans_gwhitelisterror'),newstatus).."^7"}

                            })

                        else

                            print("^1GlobalBans | "..string.format(AntiCheat.Locale.Translate('globalbans_gwhitelisterror'),newstatus).."^7")

                        end

                    end

                else

                    if (source > 0) then

                        TriggerClientEvent('chat:addMessage', source, {

                            color = { 255, 0, 0},

                            multiline = true,

                            args = {"GlobalBans | ", msgorstatus.."^7"}

                        })

                    else

                        print("^1GlobalBans | "..msgorstatus.."^7")

                    end

                end

            end)

        else

            if (source > 0) then

                TriggerClientEvent('chat:addMessage', source, {

                    color = { 255, 0, 0},

                    multiline = true,

                    args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_gwhitelistusage').."^7"}

                })

            else

                print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_gwhitelistusage').."^7")

            end

        end

    else

        if (source > 0) then

            TriggerClientEvent('chat:addMessage', source, {

                color = { 255, 0, 0},

                multiline = true,

                args = {"GlobalBans | ", AntiCheat.Locale.Translate('globalbans_noperms').."^7"}

            })

        else

            print("^1GlobalBans | "..AntiCheat.Locale.Translate('globalbans_noperms').."^7")

        end

    end

end)



CGB.CheckPerm = function(playerID,perm)

    if playerID == 0 then

        return true

    else

        if IsPlayerAceAllowed(playerID,perm) then

            return true

        else

            return false

        end

    end

end





CGB.SendDiscordMessage = function(type,data)

    if type == "ban" then

        if data.global == true then

            bantype = "GLOBAL"

        else

            bantype = "LOCAL"

        end

        date = os.date("!*t", os.time(os.date("!*t"))+AntiCheat.discordhourausgleich*3600)

        local discordInfo = {

            ["color"] = tostring(12068133),

            ["type"] = "rich",

            ["description"] = string.format(AntiCheat.Locale.Translate('globalbans_discordbanmessage'),data.pid,data.pname,data.aname,data.unbandate,data.reason,bantype,data.banid),

            ["author"] = {

                ["name"] = AntiCheat.Locale.Translate('globalbans_discordbanheading'),

                ["url"] = "https://license.carste.de",



            },

            ["footer"] = {

                ["text"] =  "GlobalBan System | 1.0.0 @ "..date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec,

                ["icon_url"] = "https://license.carste.de/discordicon.png",

            }

        }

        PerformHttpRequest(AntiCheat.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({ username = AntiCheat.Locale.Translate('globalbans_discordname'), embeds = { discordInfo }, --[[avatar_url="https://license.carste.de/discorduserimage.png" ]]}), { ['Content-Type'] = 'application/json' })

    elseif type == "connect" then

        if data.global == true then

            --name,reason,until,type,id,server,id | name,reason,until,type,id

            description = string.format(AntiCheat.Locale.Translate('globalbans_discordconnectglobal'),data.pname,data.reason,data.expires,"GLOBAL",data.banid,data.server,data.banid)

        else

            description = string.format(AntiCheat.Locale.Translate('globalbans_discordconnectlocal'),data.pname,data.reason,data.expires,"LOCAL",data.banid)

        end

        date = os.date("!*t", os.time(os.date("!*t"))+AntiCheat.discordhourausgleich*3600)

        local discordInfo = {

            ["color"] = tostring(12068133),

            ["type"] = "rich",

            ["description"] = description,

            ["author"] = {

                ["name"] = AntiCheat.Locale.Translate('globalbans_discordjoinheading'),

                ["url"] = "https://license.carste.de",



            },

            ["footer"] = {

                ["text"] =  "GlobalBan System | 1.0.0 @ "..date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec,

                ["icon_url"] = "https://license.carste.de/discordicon.png",

            }

        }

        PerformHttpRequest(AntiCheat.DiscordWebhook2, function(err, text, headers) end, 'POST', json.encode({ username = AntiCheat.Locale.Translate('globalbans_discordname'), embeds = { discordInfo }, --[[avatar_url="https://license.carste.de/discorduserimage.png" ]]}), { ['Content-Type'] = 'application/json' })

    else



    end

end



-- came trough, now status, opt: message

-- status true: whitelisted, status false: not whitelisted

CGB.GlobalWhitelist = function(banid,cb)

    if type(banid) == "number" then

        checked = false

        PerformHttpRequest("https://license.carste.de/fivemsetwhitelisted.php?byscript=true&banid="..banid, function (errorCode, resultData, resultHeaders)

            info = json.decode(tostring(resultData))

            if info ~= nil then

                if type(info) == "table" then

                    if info.status then

                        cb(true,true,info.nowstatus)

                    else

                        cb(true,false,info.message)

                    end

                else

                    cb(false,"Error Occurred in Script. Please contact an Administrator.")

                end

            else

                cb(false,"Error Occurred in Script. Please contact an Administrator.")

            end

        end)

    else

        print("error: banid is "..type(banid))

    end

end
