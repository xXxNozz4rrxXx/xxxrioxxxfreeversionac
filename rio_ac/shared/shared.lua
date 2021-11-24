local eventPrefix = GetCurrentResourceName() .. "rio:"
if IsDuplicityVersion() then
	local registerServerEvent, registerNetEvent, addEventHandler = RegisterServerEvent, RegisterNetEvent, AddEventHandler
	local events = {}
	function RegisterNetEvent(event)
		events[event] = math.random(0xBAFF1ED)
		return registerNetEvent(event)
	end
	RegisterServerEvent = RegisterNetEvent
	function AddEventHandler(event, func)
		if events[event] then
			return addEventHandler(event, function(code, ...)
				if code ~= events[event] then
					DropPlayer(source, "Invalid code.")
					return CancelEvent()
				end
				return func(...)
			end)
		end
		return addEventHandler(event, func)
	end
	registerNetEvent(eventPrefix .. "getEvents")
	addEventHandler(eventPrefix .. "getEvents", function()
		TriggerClientEvent(eventPrefix .. "recieveEvents", source, events)
	end)
else
	local triggerServerEvent = TriggerServerEvent
	local events
	RegisterNetEvent(eventPrefix .. "recieveEvents")
	AddEventHandler(eventPrefix .. "recieveEvents", function(_events)
		events = _events
	end)
	function TriggerServerEvent(event, ...)
		while not events do
			Citizen.Wait(25)
		end
		
		return triggerServerEvent(event, events[event], ...)
	end
	triggerServerEvent(eventPrefix .. "getEvents")
end

