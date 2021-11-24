AntiCheat.Locales['en'] = {
    ['checking'] = ' [🛡️RioClient-VPNCheck🛡️] | Proxy Resolver...',
    ['empty_reason'] = '[🛡️RioClient-AC]:No Reseaon Given',
    ['resource_starting'] = '[🛡️RioClient-AC🛡️] | Server is Restarting....RioClient Can Authorize a Connection',
    ['unknown_error'] = ' [🛡️RioClient-AC🛡️] | You can\'t join due to an unknown error, try again.',
    ['country_not_allowed'] = '[🛡️RioClient-AC🛡️] | Your country {{{country}}} is not allowed to join this server',
    ['blocked_ip'] = '[🛡️RioClient-AC🛡️] | Your IP is on a blacklist, this may be because you are using a VPN or your IP is involved in suspicious activities.',
    ['banned'] = '[🛡️RioClient-AC🛡️] | You are banned from this server ( 𝗨𝘀𝗲𝗿𝗻𝗮𝗺𝗲: {{{username}}} )',
    ['new_identifiers'] = '[🛡️RioClient-AC🛡️] | New identifiers found',
    ['ban_type_godmode'] = '[🛡️RioClient-AC🛡️] | Godmode detected on player',
    ['ban_type_injection'] = '[🛡️RioClient-AC🛡️] | layer has injected commands (Injection)',
    ['ban_type_blacklisted_weapon'] = '[🛡️RioClient-AC🛡️] | Player had a blacklisted weapon: {{{item}}}',
    ['ban_type_blacklisted_key'] = '[🛡️RioClient-AC🛡️] | Player had pressed a key that was blacklisted: {{{item}}}',
    ['ban_type_hash'] = '[🛡️RioClient-AC🛡️] | Player had modified a hash',
    ['ban_type_esx_shared'] = '[🛡️RioClient-AC🛡️] | Player has triggered esx:getSharedObject event',
    ['ban_type_superjump'] = '[🛡️RioClient-AC🛡️] | The player had adjusted his jump height',
    ['ban_type_client_files_blocked'] = '[🛡️RioClient-AC🛡️] | Player did not respond after asking 5 times if he was still alive (Client Files Blocked)',
    ['ban_type_event'] = '[🛡️RioClient-AC🛡️] | The player has tried to call \'{{{event}}}\' event',
    ['none'] = 'It could not be detected!',
    -- Discord
    ['discord_title'] = '🛡️🛡️🛡️🛡️[RioAntiCheat 4.0] Banned a player🛡️🛡️🛡️🛡️',
    ['discord_description'] = '**Name:** {{{name}}}\n **Reason:** {{{reason}}}\n **Identifiers:**\n {{{identifiers}}}\n **Matching Identifiers:**\n {{{matchingIdentifiers}}}',
    -- GlobalBans
    ['globalbans_noperms'] = "No Permission.",
    ['globalbans_checkingmessage'] = "[🛡️Global Ban Checker🛡️] 🚨 Checking Account Status 🚨",
    ['globalbans_noidentifiers'] = "\n[🛡️RioClient-AC🛡️] 🚨 Connection failed 🚨\n\nNo Identifiers found.\nPlease restart Steam and FiveM.\n\n🚨 Connection failed 🚨",
    ['globalbans_bannedlocal'] = "\n[🛡️RioClient-AC🛡️] 🚨 Connection failed 🚨\n\nYou are banned from this Server.\nReason: %s\nUntil: %s\nBanID: %s\nDiscord: <MYDISCORD>\n\n🚨 Connection failed 🚨",
    ['globalbans_bannedglobal'] = "\n[🛡️RioClient-AC🛡️] 🚨 Connection failed 🚨\n\nYou are globally banned.\nReason: %s\nUntil: %s\nBanID: %s\nServer: %s\n\n🚨 Connection failed 🚨\n\n⛔️ You were wrongly banned globally? ⛔️ \n RioAntiCheat Support: Contact With Rio",
    ['globalbans_bankick'] = "\n[🛡️RioClient-AC🛡️] 🚨 Connection ended 🚨\n\nYou have been banned from this Server.\nReason: %s\nUntil: %s\n\n🚨 Connection ended 🚨\n\n⛔️ You were wrongly banned globally? ⛔️ \n RioAntiCheat Support: hContact With Rio",
    ['globalbans_unbanned'] = "[🛡️RioClient-AC🛡️] Ban has successfully been revoked. (BanID: %s)",
    ['globalbans_unbanerror'] = "[🛡️RioClient-AC🛡️] Ban could not be revoked. Reason: %s",
    ['globalbans_unbanusage'] = "[🛡️RioClient-AC🛡️] Usage: /unban <banid>",
    ['globalbans_banned'] = "[🛡️RioClient-AC🛡️] Local Ban has successfully been created. (BanID: %s, Name: %s)",
    ['globalbans_banerror'] = "[🛡️RioClient-AC🛡️] Ban could not be created. Reason: %s",
    ['globalbans_banusage'] = "[🛡️RioClient-AC🛡️] Usage: /ban <id> <days> <reason>",
    ['globalbans_bannotonline'] = "[🛡️RioClient-AC🛡️] Player not online.",
    ['globalbans_gbanusage'] = "[🛡️RioClient-AC🛡️] Usage: /gban <id> <days> <reason>",
    ['globalbans_gbanned'] = "[🛡️RioClient-AC🛡️] Global Ban has successfully been created. (BanID: %s, Name: %s)",
    ['globalbans_discordbanheading'] = "[🛡️RioClient-AC🛡️] BanSystem - New Ban",
    ['globalbans_discordbanmessage'] = "[🛡️RioClient-AC🛡️] **Player: **(%s) %s\n**Executor: **%s\n**Until: **%s\n**Reason: **%s\n**BanType: **%s\n**BanID: **%s",
    ['globalbans_gwhitelistyes'] = "[🛡️RioClient-AC🛡️] BanID %s is now whitelisted and ignores his global ban on your Server.",
    ['globalbans_gwhitelistno'] = "[🛡️RioClient-AC🛡️] BanID %s is not whitelisted anymore and will not be able to play on your Server.",
    ['globalbans_gwhitelistusage'] = "[🛡️RioClient-AC🛡️] Usage: /gwhitelist <banid>",
    ['globalbans_gwhitelisterror'] = "[🛡️RioClient-AC🛡️] WhitelistSetting could not be changed. Reason: %s",
    ['globalbans_discordjoinheading'] = "[🛡️RioClient-AC🛡️] BanSystem - Connection failed",
    ['globalbans_discordname'] = "[🛡️RioClient-AC🛡️] Ban System",
    ['globalbans_discordconnectglobal'] = "**Name: **%s\n**Reason: **%s\n**Until: **%s\n**BanType: **%s\n**BanID: **%s\n**Server: **%s\n(Use /gwhitelist %s to remove the gban for this Server)",
    ['globalbans_discordconnectlocal'] = "**Name: **%s\n**Reason: **%s\n**Until: **%s\n**BanType: **%s\n**BanID: **%s",
}
