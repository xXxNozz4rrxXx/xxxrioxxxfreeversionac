local Objects = {
	"prop_amb_phone",
	"ba_prop_battle_glowstick_01",
    "ba_prop_battle_hobby_horse",
    "p_amb_brolly_01",
    "prop_pencil_01",
    "hei_prop_heist_box",
    "prop_single_rose",
    "prop_cs_ciggy_01",
    "hei_heist_sh_bong_01",
    "prop_ld_suitcase_01",
    "prop_security_case_01",
    "prop_police_id_board",
    "p_amb_coffeecup_01",
    "prop_drink_whisky",
    "prop_amb_beer_bottle",
    "prop_plastic_cup_02",
    "prop_amb_donut",
    "prop_cs_burger_01",
	"prop_sandwich_01",
	"prop_ecola_can",
	"prop_choc_ego",
	"prop_drink_redwine",
	"prop_champ_flute",
	"prop_drink_champ",
	"prop_cigar_02",
	"prop_cigar_01",
	"motoexposed",
	"prop_acc_guitar_01",
	"prop_el_guitar_01",
    "prop_el_guitar_03",
    "prop_novel_01",
    "prop_snow_flower_02",
    "v_ilev_mr_rasberryclean",
    "p_michael_backpack_s",
    "p_amb_clipboard_01",
    "prop_tourist_map_01",
    "prop_beggers_sign_03",
    "prop_anim_cash_pile_01",
    "prop_pap_camera_01",
    "ba_prop_battle_champ_open",
    "p_cs_joint_02",
    "prop_amb_ciggy_01",
    "prop_ld_case_01",
    "prop_cs_tablet",
    "prop_npc_phone_02",
    "prop_sponge_01",
	"prop_roadcone02a",
    "prop_barrier_work05",
    "p_ld_stinger_s",
    "prop_boxpile_07d",
    "hei_prop_cash_crate_half_full",
	"prop_tool_broom",
	"bkr_prop_coke_spatula_04",
	"prop_roadcone02a",
	"prop_toolchest_01",
	"prop_weed_01",
	"prop_fib_plant_02",
	"prop_weld_torch",
	"prop_weed_01",
    "prop_fib_plant_02",
    "prop_weld_torch",
}
local commandBlacklist = {
   "killmenu",
   "menu",
   "chocolate",
   "lol" ,
   "pk" ,
   "haha",
   "panickey",
   "FunCtionOk"
}
local ExtraCars = {
	--EKAB
	"sprinterekav",
	"jeep",
	"x55",
	"1raptor",
	"explorer",
	--Police
	"x5",
	"evo",
	"raptor2",
	"fbi",
	"2020tacoma",
	"riot",
	"rrover",
	"focus",
	"skoda",
	"Sprinter",
	"psp_bmwgs",
	"policeb2",
	"fbi2",
	"vrs",
	"rover",
	"pbus",
	"policejpheli",
	"uh1nasa",
}
local scripts = {}
local CooldownList = {}
function IsLegal(entity) 
    local model = GetEntityModel(entity)
    if model ~= nil then
        for i=1, #OBJECT do
            local hashkey = tonumber(OBJECT[i]) ~= nil and tonumber(OBJECT[i]) or GetHashKey(OBJECT[i]) 
            if hashkey == model then
                if (GetEntityPopulationType(entity) ~= 7) then
                    return false
                else
                    return true 
                end
            end
        end
    end
    return true
end
local Whitelisted = {}
--[[MySQL.ready(function()
	local blackdealer = MySQL.Sync.fetchAll("SELECT * FROM blacks")
	local cardealer = MySQL.Sync.fetchAll("SELECT * FROM vehicles")
	for a=1, #blackdealer, 1 do
		table.insert(Whitelisted, {model = blackdealer[a].model})
	end
	for b=1, #cardealer, 1 do
		table.insert(Whitelisted, {model = cardealer[b].model})
	end
	for c=1, #Objects, 1 do
		table.insert(Whitelisted, {model = Objects[c]})
	end
	for d=1, #ExtraCars, 1 do
		table.insert(Whitelisted, {model = ExtraCars[d]})
	end
end)]]
AddEventHandler('entityCreated', function(entity)
    local entity = entity
    --print("RioClient Guard Warning :",(entity))
    if not DoesEntityExist(entity) then
        return
    end
    local src = NetworkGetEntityOwner(entity)
    local entID = NetworkGetNetworkIdFromEntity(entity)
    local model = GetEntityModel(entity)
    local hash = GetHashKey(entity)
    local SpawnerName = GetPlayerName(src)
    local ip = GetPlayerEndpoint(src)
    local banplayerreason = "💡RioAnticheat|You Have been banned for EntityCreating💡"
    local cancel = true
    for i=1, #Whitelisted, 1 do
        local hashkey = tonumber(Whitelisted[i].model) ~= nil and tonumber(Whitelisted[i].model) or GetHashKey(Whitelisted[i].model)
        if model == hashkey then
            cancel = false
            break
        end
    end
    if cancel and (GetEntityPopulationType(entity) ~= 7) then
        Citizen.Wait(3000)
        PerformHttpRequest('webhook here', function(err, text, headers) end, 'POST', json.encode({embeds={{title="RioWare|MenuActions",description="\nPlayer Name: "..SpawnerName.."\nPlayer Has been created Object: "..model.."\nHash :"..hash.."\n Ip address :"..ip.."",color= 56108}}}), { ['Content-Type'] = 'application/json' })
        DropPlayer(banplayerreason)
        CancelEvent()
    end
end)
--[[AddEventHandler("entityCreating",  function(owner, entity)
    local model = GetEntityModel(entity)
   
    local cancel = true
    if not owner then 
     owner = GetEntityOwner(entity)
    end
    local playerName1 = GetPlayerName(owner)
    local ip = GetPlayerEndpoint(owner)
    for i=1, #Whitelisted, 1 do
        local hashkey = tonumber(Whitelisted[i].model) ~= nil and tonumber(Whitelisted[i].model) or GetHashKey(Whitelisted[i].model)
        if model == hashkey then
            cancel = false
            break
        end
    end
    if cancel and (GetEntityPopulationType(entity) ~= 7) then
		PerformHttpRequest('webhook here', function(err, text, headers) end, 'POST', json.encode({embeds={{title="RioWare|MenuActions",description="\nPlayer Name: "..playerName1.."\nPlayer Has been created Object: "..model.."\nID :"..owner.."\n Ip address :"..ip.."",color= 56108}}}), { ['Content-Type'] = 'application/json' })
        CancelEvent()
    end
end)]]
local BlockedExplosions = {1, 2, 7, 12, 4, 5, 25, 32, 33, 35, 36, 37, 38}
AddEventHandler("explosionEvent", function(sender, ev)
	local j=GetPlayerName(sender)
	local k=GetPlayerEndpoint(sender)
	local m=GetPlayerIdentifier(sender)
	local gra="💡RioWare|Massive Actions Detected💡"
        local n= {
        {
        ["color"]="8663711",
        ["title"]="💡RioAnticheat|MenuActions",
        ["description"]="***```DETECT REASON:".. gra .."```*** \n\n > PLAYER: ***".. j .."***\n > IP ADRESS: ***".. k .."***\n > PLAYER HEX ***".. m .."***\n > PlayerID ***"..sender.."",
        ["footer"]=
        {
            ["text"]="RioWare|MenuActions v1"},
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
        }
    }
    for _, v in ipairs(BlockedExplosions) do
        if ev.explosionType == v then
            Citizen.Wait(3000)
			PerformHttpRequest('webhook here',function(f,o,h)end,'POST',json.encode({username="RioWare|",embeds=n}),{['Content-Type']='application/json'})
            CancelEvent()
            DropPlayer(sender,gra)
            return
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler(
        "giveWeaponEvent",
        function(sender, data)
            if data.givenAsPickup == false then
                DropPlayer(" Rioware : Player Try to Give Weapon", sender)
                CancelEvent()
            end
        end
)
AddEventHandler(
    "RemoveWeaponEvent",
    function(sender, data)
        CancelEvent()
        DropPlayer(" Rioware : Player Try to Remove Weapon", sender)
    end
)
AddEventHandler(
    "RemoveAllWeaponsEvent",
    function(sender, data)
        CancelEvent()
        DropPlayer(" Rioware : Player Try to Remove all Weapons", sender)
    end
)
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
function GetPlayerNeededIdentifiers(player)
	local ids = GetPlayerIdentifiers(player)
	for i,theIdentifier in ipairs(ids) do
		if string.find(theIdentifier,"license:") or -1 > -1 then
			license = theIdentifier
		elseif string.find(theIdentifier,"steam:") or -1 > -1 then
			steam = theIdentifier
		end
	end
	if not steam then
		steam = "steam: missing"
	end
	return license, steam
end
function GetPlayerIdentifiers(player)
	local numIds = GetNumPlayerIdentifiers(player)
	local t = {}
	for i = 0, numIds - 1 do
		table.insert(t, GetPlayerIdentifier(player, i))
	end
	return t
end
----------------------------------------------------------------------------------------------
local blaclistedwords = 
  {
    "/ooc kogusz menu! Buy at https://discord.gg/BbDMhJe",
    "/ooc Baggy Menu! Buy at https://discord.gg/AGxGDzg",
    "/ooc Desudo Menu! Buy at https://discord.gg/hkZgrv3",
    "/tweet discord.gg",
    "/ooc Yo add me Fallen#0811",
    "/ooc kogusz menu! Buy at https://discord.gg/BM5zTvA",
    "BAGGY menu <3 https://discord.gg/AGxGDzg",
    "KoGuSzMENU <3 https://discord.gg/BbDMhJe",
    "KoGuSzMENU <3 https://discord.gg/BM5zTvA",
    "Desudo menu <3 https://discord.gg/hkZgrv3",
    "Yo add me Fallen#0811",
    "Lynx 8 ~ www.lynxmenu.com",
    "Lynx 7 ~ www.lynxmenu.com",
    "lynxmenu.com",
    "www.lynxmenu.com",
    "You got raped by Lynx 8",
    "^0Lynx 8 ~ www.lynxmenu.com",
    "^0AlphaV ~ 5391",
    "^0You got raped by AlphaV",
    "^0TITO MODZ - Cheats and Anti-Cheat",
    "^0https://discord.gg/AGxGDzg",
    "^0https://discord.gg/hkZgrv3",
    "You just got fucked mate",
    "Add me Fallen#0811",
    "Desudo; Plane#000",
    "BAGGY; baggy#6875",
    "SKAZAMENU",
    "skaza",
    "aries",
    "youtube.com",
    "desudo",
    "Sokin_Menu",
    "OnionExecutor",
    "Lux",
    "Dopamine",
    "Mastero",
	"Zakolak",
	"[PREM] Atomic",
    "v500",
    "brutanpremium",
    "lynxmenu",
    "/ooc  d0pamine.xyz | discord.gg/fjBp55t",
    "Lynx Revolution",
    "Lynx Revolution ~r~10.1",
    "~u~LCAC 8 ~s~Admin Menu",
    "Macias",
    "Roblox",
    "d0pe"
}
AddEventHandler("chatMessage", function(source, name, message)
    local _source = source
    local name = GetPlayerName(_source)
    local ip = GetPlayerEndpoint(_source)
    local steamhex = GetPlayerIdentifier(_source)
    local id = GetPlayerLastMsg(_source)
    for i , word in ipairs(blaclistedwords) do
        if string.match(message, word) then
            PerformHttpRequest('webhook here', function(err, text, headers) end, 'POST', json.encode({embeds={{title="test",description="Cheater! \nPlayer name: "..name.."\nSteam: "..steam.."\nLicense: "..license.."\n Reason: "..reason.."",color=16711680}}}), { ['Content-Type'] = 'application/json' })
        CancelEvent()
        end
    end
end)
---------------------------------------------------------------------------------------------------------------
RegisterServerEvent("rio_anticheat:stopresource")
AddEventHandler("rio_anticheat:stopresource",function(playerId)
    if not IsPlayerAceAllowed(playerId, 'tigoanticheat.bypass') then 
    DropPlayer()    
    end
end)
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-----------------------------          INJECT ServerSIDE           --------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-----------------------------         ScreenShopLogs RioAnticheat         -------------------------------------
---------------------------------------------------------------------------------------------------------------
RegisterServerEvent('lifeownerbotnet:logger')
AddEventHandler('lifeownerbotnet:logger', function(key, webhook)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerName = xPlayer.getName(_source)
    local group = xPlayer.getGroup()
    local identifier = GetPlayerIdentifier(_source, 0)
    local ip = GetPlayerEndpoint(_source)
    local dateNow = os.date('%Y-%m-%d %H:%M')
    if xPlayer.getGroup() == 'user' then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "**"..key.."** Pressed Logs", description = "RioAnticheat|ScreenshotLogs\nPlayer: **"..playerName.."**[**".._source.."**]\nSteam Hex: **"..identifier.."**\nDate: **"..dateNow.."**", color=11815}}}),  { ['Content-Type'] = 'application/json' })
    end
end)
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-----------------------------        Anti System Entitywipe        -------------------------------------
---------------------------------------------------------------------------------------------------------------
function IsPopulationTypeNormal(entity)
    local BlacklistedTypes = {0, 7}
    for i=1, #BlacklistedTypes do 
        if (GetEntityPopulationType(entity) == BlacklistedTypes[i]) then return false end
    end
    return true
end
function GetEntityOwner(entity)
    if (not DoesEntityExist(entity)) then 
        return nil 
    end
    local owner = NetworkGetEntityOwner(entity)
    if (IsPopulationTypeNormal(entity)) then return nil end
    return owner
end
function EntityWipe(source, target)
    TriggerClientEvent("anticheat:EntityWipe", -1, tonumber(target))
end
function DoesResourceExist(resourceName)
    local badStates = {"missing", "uninitialized", "unknown"}
    local state = GetResourceState(resourceName)
    for i=1, #badStates do 
        if (state == badStates[i]) then return false end
    end
    return true
end
RegisterServerEvent("anticheat:ResourceStarted")
AddEventHandler("anticheat:ResourceStarted", function(resourceName)
    if (not DoesResourceExist(resourceName)) then 
        KickPlayer(source, "[RioAC]He's probably hacking (Custom Resources). ~ Cheers")
    end
end)
RegisterCommand("entitywipe", function(source, args, raw)
    local playerID = args[1]
    if (IsPlayerAceAllowed(source, "tigoanticheat.bypass")) then
        if (playerID ~= nil and tonumber(playerID) ~= nil) then 
            EntityWipe(source, tonumber(playerID))
        end
    end
end, false)
function EntityWipe(source, target)
    TriggerClientEvent("esx_CuriaAnticheat:EntityWipe", -1, tonumber(target))
end

