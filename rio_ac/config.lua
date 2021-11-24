AntiCheat.Language                  = 'en' -- Only 'en' !!!! Send your Translation to my Discord for more translation
AntiCheat.GlobalBanSystem           = true
AntiCheat.LogObject                 = true
AntiCheat.UpdateIdentifiers         = true -- `true` When a banned players joined with new identifiers is also immediately banned as soon one identifier match banned identifiers
AntiCheat.BypassEnabled             = false -- `true` Players that has the permission `tigoanticheat.bypass` will never be banned by 
AntiCheat.DiscordWebhook            = 'webhook here' -- Webhook to report new bans to
AntiCheat.DiscordWebhook2           = 'webhook here' -- Webhook to report players trying to join
AntiCheat.VPNCheckEnabled           = false -- `true` Determines if player's IP is possibly VPN and blocks access to your server.
AntiCheat.VPNAPIKey                 = 'MTE4MTg6N1ZXQVZZd1luNWYzVlRxUFh3VVh1UXBFVmc1blQzSUY=' -- https://iphub.info/apiKey/newFree Generate an API key to use VPN Check in 
AntiCheat.RunningOS                 = 'win' -- For OS specific operations, options: `win` for 'Windows' and `lux` for `Linux`
AntiCheat.BypassAce                 = 'tigoanticheat.bypass' -- The permission ace a player must have to be ignored (example: add_ace group.admin tigoanticheat.bypass allow)
AntiCheat.EnableCountryWhitelist    = false -- When `true` only IP's from countries described in CountryWhitelist can join
AntiCheat.CountryWhitelist          = { 'GR', 'CY' } -- Alpha-2 country codes -> https://www.iban.com/country-codes
AntiCheat.hourausgleich = 15
AntiCheat.discordhourausgleich = 3
