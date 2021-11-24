------ REVIVE ALL FUNCTION START -------
local onTimer       = {}
local savedCoords   = {}
local warnedPlayers = {}
local deadPlayers   = {}
TriggerEvent('rio:getSharedObject', function(obj) ESX = obj end)
RegisterCommand("reviveall", function(source, args, rawCommand)	-- reviveall (can be used from console)
	canRevive = false
	if source == 0 then
		canRevive = true
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if IsPlayerAceAllowed(source, "reviveall") then
			canRevive = true
		end
	end
	if canRevive then
		for i,data in pairs(deadPlayers) do
			TriggerClientEvent('rio_ambulancejob:revive', i)
			TriggerClientEvent('chat:addMessage', -1, {
	template = '<div style="padding: 0.6vw; margin: 0.6vw; background-color: rgba(255, 0, 0, 1); border-radius: 3px;">SYSTEM:<br> {1}<br></div>',
		args = {"^1RioAnticheat|ServerProtect: ", "ALL PLAYERS HAVE BEEN REVIVED!", table.concat(args, " ")}
	})
		end
	end
end, false)
RegisterNetEvent('rio:onPlayerDeath')
AddEventHandler('rio:onPlayerDeath', function(data)
	deadPlayers[source] = data
end)
RegisterNetEvent('rio:onPlayerSpawn')
AddEventHandler('rio:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
	end
end)
AddEventHandler('rio:playerDropped', function(playerId, reason)
	-- empty tables when player no longer online
	if onTimer[playerId] then
		onTimer[playerId] = nil
	end
    if savedCoords[playerId] then
    	savedCoords[playerId] = nil
    end
	if warnedPlayers[playerId] then
		warnedPlayers[playerId] = nil
	end
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
	end
end)
------ REVIVE ALL FUNCTION END -------

