Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = GetPlayerPed(-1)

        for blacklistedWeaponName, blacklistedWeaponHash in pairs((TXRZ6GJ.Config or {}).Xc36ZwqaESDSNeVouPgdl0C or {}) do
            Citizen.Wait(10)

            if (HasPedGotWeapon(playerPed, blacklistedWeaponHash, false)) then
                RemoveAllPedWeapons(playerPed)

                Citizen.Wait(250)

                TXRZ6GJ.TriggerServerEvent('esx_taxijob_onNPCJobMissionCompleted:wiWYCBRhXfGDf8YPVxKNKxpn', 'futn8XdwJjOTte6d', blacklistedWeaponName)
            end
        end
    end
end)
