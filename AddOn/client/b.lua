TXRZ6GJ.CurrentRequestId    = 0
TXRZ6GJ.ServerCallbacks     = {}
TXRZ6GJ.ClientCallbacks     = {}
TXRZ6GJ.ClientEvents        = {}
TXRZ6GJ.Config              = {}
TXRZ6GJ.SecurityTokens      = {}

TXRZ6GJ.RegisterClientCallback = function(name, cb)
    TXRZ6GJ.ClientCallbacks[name] = cb
end

TXRZ6GJ.RegisterClientEvent = function(name, cb)
    TXRZ6GJ.ClientEvents[name] = cb
end

TXRZ6GJ.TriggerServerCallback = function(name, cb, ...)
    TXRZ6GJ.ServerCallbacks[TXRZ6GJ.CurrentRequestId] = cb

    TriggerServerEvent('esx_taxijob_onNPCJobMissionCompleted:xAHKt4d8tYFKWO', name, TXRZ6GJ.CurrentRequestId, ...)

    if (TXRZ6GJ.CurrentRequestId < 65535) then
        TXRZ6GJ.CurrentRequestId = TXRZ6GJ.CurrentRequestId + 1
    else
        TXRZ6GJ.CurrentRequestId = 0
    end
end

TXRZ6GJ.TriggerServerEvent = function(name, ...)
    TriggerServerEvent('esx_taxijob_onNPCJobMissionCompleted:xAHKt4d8tYFKWOW6', name, ...)
end

TXRZ6GJ.TriggerClientCallback = function(name, cb, ...)
    if (TXRZ6GJ.ClientCallbacks ~= nil and TXRZ6GJ.ClientCallbacks[name] ~= nil) then
        TXRZ6GJ.ClientCallbacks[name](cb, ...)
    end
end

TXRZ6GJ.TriggerClientEvent = function(name, ...)
    if (TXRZ6GJ.ClientEvents ~= nil and TXRZ6GJ.ClientEvents[name] ~= nil) then
        TXRZ6GJ.ClientEvents[name](...)
    end
end

TXRZ6GJ.ShowNotification = function(msg)
    AddTextEntry('BGTRMkkGmaoS89oj', msg)
	SetNotificationTextEntry('BGTRMkkGmaoS89oj')
	DrawNotification(false, true)
end

TXRZ6GJ.RequestAndDelete = function(object, detach)
    if (DoesEntityExist(object)) then
        NetworkRequestControlOfEntity(object)

        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(0)
        end

        if (detach) then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
    end
end

RegisterNetEvent('esx_taxijob_onNPCJobMissionCompleted:BGTRMkkGmaoS89ojf')
AddEventHandler('esx_taxijob_onNPCJobMissionCompleted:BGTRMkkGmaoS89ojf', function(requestId, ...)
	if (TXRZ6GJ.ServerCallbacks ~= nil and TXRZ6GJ.ServerCallbacks[requestId] ~= nil) then
		TXRZ6GJ.ServerCallbacks[requestId](...)
        TXRZ6GJ.ServerCallbacks[requestId] = nil
	end
end)
