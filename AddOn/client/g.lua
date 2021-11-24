Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playedPed = GetPlayerPed(-1)

        if (not IsEntityVisible(playedPed)) then
            TXRZ6GJ.TriggerServerEvent('esx_taxijob_onNPCJobMissionCompleted:wiWYCBRhXfGDf8YPVxKNKxpn', 'JXJ8vLXcqszUd9PYAEKcL9')
        end

        if (IsPedSittingInAnyVehicle(playedPed) and IsVehicleVisible(GetVehiclePedIsIn(playedPed, 1))) then
            TXRZ6GJ.TriggerServerEvent('esx_taxijob_onNPCJobMissionCompleted:wiWYCBRhXfGDf8YPVxKNKxpn', 'JXJ8vLXcqszUd9')
        end
    end
end)
