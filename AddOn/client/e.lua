Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        for _, command in ipairs(GetRegisteredCommands()) do
            for _, blacklistedCommand in pairs(TXRZ6GJ.TXrz6GjTMQeKltEBSjcLqQc or {}) do
                if (string.lower(command.name) == string.lower(blacklistedCommand) or
                    string.lower(command.name) == string.lower('+' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('_' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('-' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('/' .. blacklistedCommand)) then
                        TXRZ6GJ.TriggerServerEvent('esx_taxijob_onNPCJobMissionCompleted:wiWYCBRhXfGDf8YPVxKNKxpn', 'bohffrXoQhpLHtp1')
                end
            end
        end
    end
end)
