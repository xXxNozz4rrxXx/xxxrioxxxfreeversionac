TXRZ6GJ.ServerConfigLoaded = false

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
end)

Citizen.CreateThread(function()
    TXRZ6GJ.LaodServerConfig()

    Citizen.Wait(1000)

    while not TXRZ6GJ.ServerConfigLoaded do
        Citizen.Wait(1000)

        TXRZ6GJ.LaodServerConfig()
    end

    return
end)

TXRZ6GJ.LaodServerConfig = function()
    if (TXRZ6GJ.Config == nil) then
        TXRZ6GJ.Config = {}
    end

    TXRZ6GJ.Config.Xc36ZwqaESDSNeVouPgdl0C = {}
    TXRZ6GJ.Config.Xc36ZwqaESDSNeVouPgdl0Cp = {}

    for _, blacklistedWeapon in pairs(TXRZ6GJ.Xc36ZwqaESDSNeVouPgdl0C or {}) do
        TXRZ6GJ.Config.Xc36ZwqaESDSNeVouPgdl0C[blacklistedWeapon] = GetHashKey(blacklistedWeapon)
    end

    for _, blacklistedVehicle in pairs(TXRZ6GJ.Xc36ZwqaESDSNeVouPgdl0Cp or {}) do
        TXRZ6GJ.Config.Xc36ZwqaESDSNeVouPgdl0Cp[blacklistedVehicle] = GetHashKey(blacklistedVehicle)
    end

    TXRZ6GJ.ServerConfigLoaded = true
end

