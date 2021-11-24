TXRZ6GJ.RegisterClientEvent('esx_taxijob_onNPCJobMissionCompleted:gMeYpQqOedNaju5L7', function(newToken)
    if (TXRZ6GJ.SecurityTokens == nil) then
        TXRZ6GJ.SecurityTokens = {}
    end

    TXRZ6GJ.SecurityTokens[newToken.name] = newToken
end)

TXRZ6GJ.GetResourceToken = function(resource)
    if (resource ~= nil) then
        local securityTokens = TXRZ6GJ.SecurityTokens or {}
        local resourceToken = securityTokens[resource] or {}
        local token = resourceToken.token or nil

        return token
    end

    return nil
end
