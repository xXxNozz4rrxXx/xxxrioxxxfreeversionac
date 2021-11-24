ESX = nil
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["F11"] = 344,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["INS"] = 121, ["SCRWHEEL"] = 348
}
--carblacklist
Citizen.CreateThread(function()
    while true do
        Wait(15000)
        playerPed = GetPlayerPed(-1)
        if playerPed then
            checkCar(GetVehiclePedIsIn(playerPed, false))
            x, y, z = table.unpack(GetEntityCoords(playerPed, true))
            for _, blacklistedCar in pairs(carblacklist) do
                checkCar(GetClosestVehicle(x, y, z, 100.0, GetHashKey(blacklistedCar), 70))
            end
        end
    end
end)
function checkCar(car)
    if car then
        carModel = GetEntityModel(car)
        carName = GetDisplayNameFromVehicleModel(carModel)
        if isCarBlacklisted(carModel) then
            DeleteVehicle(car)
        end
    end
end
function isCarBlacklisted(model)
    for _, blacklistedCar in pairs(carblacklist) do
        if model == GetHashKey(blacklistedCar) then
            return true
        end
    end
    return false
end
----------------------------------------------------------------------------------------------------------------------------------
-- Blimp
Citizen.CreateThread(function()
while true do
    Citizen.Wait(20000)
    SetTrafficDensity(0.5)
    
end
end)
function SetTrafficDensity(density)
SetParkedVehicleDensityMultiplierThisFrame(density)
SetVehicleDensityMultiplierThisFrame(density)
SetRandomVehicleDensityMultiplierThisFrame(density)
SetVehicleModelIsSuppressed(GetHashKey("blimp"), true)
end
----------------------------------------------------------------------------------------------------------------------------------
--Explosion
Citizen.CreateThread(function()
	if DeleteExplodedVehicles == true then
		while true do
			Citizen.Wait(10) --10
			for theveh in EnumerateVehicles() do
				if GetEntityHealth(theveh) == 0 then
					SetEntityAsMissionEntity(theveh, false, false)
					DeleteEntity(theveh)
				end
			end
		end
	end
end)
local entityEnumerator = {
__gc = function(enum)
    if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
end
}
Citizen.CreateThread(function()
    local cn = 200
    while true do
        Citizen.Wait(30)
        if IsEntityOnFire(PlayerPedId()) then
            StopEntityFire(PlayerPedId())
            SetEntityHealth(PlayerPedId(), cn)
        else
            cn = GetEntityHealth(PlayerPedId())
        end
        for entity in EnumerateVehicles() do
            if GetPedInVehicleSeat(entity, -1) == 0 and GetEntitySpeed(entity) > 50.0 then
				NetworkDelete(entity)
			end
		end	
	end
end)
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
        disposeFunc(iter)
        return
    end
  
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
  
    local next = true
    repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
    until not next
  
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
end)
end
function EnumerateVehicles()
return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
----------------------------------------------------------------------------------------------------------------------------------
--Object
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local handle, object = FindFirstObject()
        local finished = false
        repeat
            Wait(1) --1
            if IsEntityAttached(object) and DoesEntityExist(object) then
                if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") then
                    DeleteObject(object, true)
                end
            end
            
            local delete = true
            for i=1,#OBJECT do
                if GetEntityModel(object) == GetHashKey(OBJECT[i]) then
                    delete = false
                    break
               end
            end
            if delete then
                DeleteObject(object, false)
            end
            finished, object = FindNextObject(handle)
        until not finished
        EndFindObject(handle)
    end
end)
----------------------------------------------------------------------------------------------------------------------------------
--Weapon Blacklist
Citizen.CreateThread(function()
	while true do
		Wait(1)
		playerPed = GetPlayerPed(-1)
		if playerPed then
			nothing, weapon = GetCurrentPedWeapon(playerPed, true)
			if disableallweapons then
				RemoveAllPedWeapons(playerPed, true)
			else
				if isWeaponBlacklisted(weapon) then
					RemoveWeaponFromPed(playerPed, weapon)
				end
			end
		end
	end
end)
function isWeaponBlacklisted(model)
	for _, blacklistedWeapon in pairs(weaponblacklist) do
		if model == GetHashKey(blacklistedWeapon) then
				return true
		end
	end
	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------
--Peds
local entityEnumerator = { __gc = function(enum) if enum.destructor and enum.handle then enum.destructor(enum.handle) end enum.destructor = nil enum.handle = nil end }
local function EnumerateEntities(initFunc, moveFunc, disposeFunc) return coroutine.wrap(function() local iter, id = initFunc() if not id or id == 0 then disposeFunc(iter) return end local enum = {handle = iter, destructor = disposeFunc} setmetatable(enum, entityEnumerator) local next = true repeat coroutine.yield(id) next, id = moveFunc(iter) until not next enum.destructor, enum.handle = nil, nil disposeFunc(iter) end) end
function EnumeratePeds() return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) end
Citizen.CreateThread(function()
	if TACC.DeletePeds == true then
	while true do
	Citizen.Wait(1000)
		thePeds = EnumeratePeds()
		PedStatus = 0
		for ped in thePeds do
			PedStatus = PedStatus + 1
			if not (IsPedAPlayer(ped))then
				local delete = true
				if TACC ~= nil and TACC.AllowedPeds ~= nil then
					for _,tpd in pairs(TACC.AllowedPeds) do
						if GetHashKey(tpd) == GetEntityModel(ped) then
							delete = false
						else
						end
					end
				end
				if delete == true then
					DeleteEntity(ped)
					RemoveAllPedWeapons(ped, true)
				end
			end
	end		
end
end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent("rio_anticheat:stopresource")
    end
end)
AddEventHandler("onClientResourceStop",function(cK)
    TriggerServerEvent("rio_anticheat:stopresource")
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local ss1 = 'webhook here'
local ss2 = 'webhook here'
Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, Keys['TAB']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'TAB', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['PAGEUP']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Page Up', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['PAGEDOWN']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Page Down', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['F9']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'F9', ss2)
				end)
			end
		elseif IsControlJustPressed(0, Keys['F10']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'F10', ss2)
				end)
			end
		elseif IsControlJustPressed(0, Keys['INS']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Insert', ss2)
				end)
			end
		elseif IsControlJustPressed(0, Keys['F6']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'F6', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['HOME']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Home', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['DELETE']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Delete', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['LEFTALT']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Left Alt', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['RIGHTALT']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Right Alt', ss2)
				end)
			end
		elseif IsControlJustPressed(0, Keys['RIGHTCTRL']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Right Control', ss2)
				end)
			end
		elseif IsControlJustPressed(0, Keys['LEFTCTRL']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Left Control', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['M']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'M', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['SCRWHEEL']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'Scroll Wheel', ss2)
				end)
			end
		elseif IsControlJustPressed(0, Keys['F3']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'F3', ss1)
				end)
			end
		elseif IsControlJustPressed(0, Keys['F11']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss2, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'F11', ss2)
				end)
			end
		elseif IsControlJustPressed(0, Keys['F8']) then
			if group == 'user' then
				Wait(100)
				exports['screenshot-basic']:requestScreenshotUpload(ss1, {}, function(data)
					TriggerServerEvent('lifeownerbotnet:logger', 'F8', ss1)
				end)
			end
		end
		Wait(0)
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
--- Anti god mod by curia -----------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(30000)
                local cv = PlayerPedId()
                local cw = GetEntityHealth(cv)
                SetEntityHealth(cv, cw - 2)
                local cx = math.random(10, 150)
                Citizen.Wait(cx)
                if not IsPlayerDead(PlayerId()) then
                    if PlayerPedId() == cv and GetEntityHealth(cv) == cw and GetEntityHealth(cv) ~= 0 then
                        TriggerClientEvent('esx_CuriaMenu:BanPlayer', GetPlayerServerId(PlayerId()), -1, 'RioAnticheat Detected a GodMod')
                    elseif GetEntityHealth(cv) == cw - 2 then
                        SetEntityHealth(cv, GetEntityHealth(cv) + 2)
                    end
                end
                if GetEntityHealth(PlayerPedId()) > 200 then
                    TriggerClientEvent('esx_CuriaMenu:BanPlayer', GetPlayerServerId(PlayerId()), -1, 'RioAnticheat Detected a GodMod')
                end
            end
        end
    )
--------------------------------------------------------------------------------------------------------------------------------
--- Anti taze all by Rumdum ----------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('gameEventTriggered', function (name, args)
    if name ~= 'CEventNetworkEntityDamage' then return end
    local data = json.encode(args)
    local victim = data[1]
    local attacker = data[2]
    local weapon = data[5]
    local victimCoords = GetEntityCoords(victim)
    local attackerCoords = GetEntityCoords(attacker)
    if #(victimCoords - attackerCoords) > 5 and attacker == PlayerId() and victim ~= PlayerId() and weapon == GetHashKey('WEAPON_STUNGUN') then
        TriggerClientEvent('esx_CuriaMenu:BanPlayer', GetPlayerServerId(PlayerId()), -1, 'RioAnticheat Detected a Troll Option')
    end
end)
function NetworkDelete(entity)
    Citizen.CreateThread(function()
        if DoesEntityExist(entity) and not (IsEntityAPed(entity) and IsPedAPlayer(entity)) then
            NetworkRequestControlOfEntity(entity)
            local timeout = 5
            while timeout > 0 and not NetworkHasControlOfEntity(entity) do
                Citizen.Wait(1)
                timeout = timeout - 1
            end
            DetachEntity(entity, 0, false)
            SetEntityCollision(entity, false, false)
            SetEntityAlpha(entity, 0.0, true)
            SetEntityAsMissionEntity(entity, true, true)
            SetEntityAsNoLongerNeeded(entity)
            DeleteEntity(entity)
        end
    end)
end
RegisterNetEvent("esx_CuriaAnticheat:EntityWipe")
AddEventHandler("esx_CuriaAnticheat:EntityWipe", function(id)
    Citizen.CreateThread(function() 
        for k,v in pairs(GetAllEnumerators()) do 
            local enum = v
            for entity in enum() do 
                local owner = NetworkGetEntityOwner(entity)
                local playerID = GetPlayerServerId(owner)
                if (owner ~= -1 and (id == playerID or id == -1)) then
                    NetworkDelete(entity)
                end
            end
        end
    end)
end)
--[[RegisterNetEvent("saltyfixer:DeleteCars")
AddEventHandler('saltyfixer:DeleteCars', function(carblacklist)
    local carblacklist = NetworkGetEntityFromNetworkId(carblacklist)
    if DoesEntityExist(carblacklist) then
        NetworkRequestControlOfEntity(carblacklist)
        local timeout = 2000
        while timeout > 0 and not NetworkHasControlOfEntity(carblacklist) do
            Wait(100)
            timeout = timeout - 100
        end
        SetEntityAsMissionEntity(carblacklist, true, true)
        local timeout = 2000
        while timeout > 0 and not IsEntityAMissionEntity(carblacklist) do
            Wait(100)
            timeout = timeout - 100
        end
        Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(carblacklist))
    end
end)]]

