AddEventHandler('onResourceStart',function(resource)

    if resource == GetCurrentResourceName() then



        local f = io.popen('wmic bios get serialnumber')

        local t = tostring(f:read('*a'))

        local serial = t:gsub('%s+', '')





        local ipwithspaces = 'http://samethub.com/check.php'

        local ip = ipwithspaces:gsub('%s+', '')

        local ipaddress = nil

        local DISCORD_WEBHOOK = 'webhook here'

        local DISCORD_NAME = 'Source License Systems'

        local DISCORD_IMAGE = 'https://samethub.com/amkayisi.jpeg'

        PerformHttpRequest('http://bot.whatismyipaddress.com/', function (errorCode, resultDataa, resultHeaders)

			ipaddress = resultDataa

        end)



        PerformHttpRequest(ipwithspaces, function (errorCode, resultData, resultHeaders)

            Citizen.Wait(500)

            if resultData ~= 'TRUE' then

                local connect = {

                    {

                        ['color'] = 15466505,

                        ['title'] = '**['..resource..'] Unlicensed Server Detected!**',

                        ['description'] = 'Server shut down. Server Details ↙',

                        ['footer'] = {

                        ['text'] = 'Source License | Macius#8300',

                        ['icon_url'] = 'https://samethub.com/amkayisi.jpeg',

                        }, 

                        ['image'] = {

                        ['url'] = 'http://samethub.com/reden.png',

                        },

                        ['fields'] = 

                        {

                            {

                                ['name'] = '**Bios Serial Number**',

                                ['value'] = '*' .. serial .. '*' ,

                            },

                            {

                                ['name'] = '**IP Adres**',

                                ['value'] = '*' .. ipaddress .. '*',

                            }

                        },

                    }

                }

                Citizen.Wait(200)

                PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })

                Citizen.Wait(500)

                os.exit()

            else

                local connect = {

                    { 

                        ['color'] = 5111572,

                        ['title'] = '**['..resource..'] Server has been started!**',

                        ['description'] = 'Server Details ↙',

                        ['footer'] = {

                        ['text'] = 'Source License | Macius#8300',

                        ['icon_url'] = 'https://samethub.com/amkayisi.jpeg',

                        },

                        ['image'] = {

                        ['url'] = 'http://samethub.com/onayen.png',

                        },

                        ['fields'] =

                        {

                            {

                                ['name'] = '**Serial Number**',

                                ['value'] = '*' .. serial .. '*' ,

                            },

                            {

                                ['name'] = '**IP ADDRESS**',

                                ['value'] = '*' .. ipaddress .. '*',

                            }

                        },

                    }

                }

                Citizen.Wait(200)

                PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })

            end

        end)

    end

end)
