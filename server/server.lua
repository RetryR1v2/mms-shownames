-- Server Side
local VORPcore = exports.vorp_core:GetCore()

-- PlayerData Updater
local AllPlayerData = {}

Citizen.CreateThread(function ()
    while true do
        AllPlayerData = {}
        if #GetPlayers() > 0 then
            for h,v in ipairs(GetPlayers()) do
                local Character = VORPcore.getUser(v).getUsedCharacter
                if Character ~= nil then
                    if Character.firstname ~= nil and Character.lastname ~= nil then
                        local PlayerPed = GetPlayerPed(v)
                        local Coords = GetEntityCoords(PlayerPed)
                        local Name = Character.firstname .. ' ' .. Character.lastname
                        local CharID = Character.charIdentifier
                        local ServerID = v
                        local SteamID = Character.identifier
                        local Alias = ''
                        local result = MySQL.query.await("SELECT * FROM mms_shownames WHERE charidentifier=@charidentifier", { ["@charidentifier"] = CharID})
                        if #result > 0 then
                            if result[1].aliasactive == 1 then
                                Alias = result[1].alias
                            end
                        end
                        if Alias ~= '' then
                            Name = Alias
                        end
                        local PlayerData = { Ped = PlayerPed, Coords = Coords, Name = Name, CharID = CharID, ServerID = ServerID, SteamID = SteamID }
                        table.insert(AllPlayerData,PlayerData)
                    end
                end
            end
        end
        Citizen.Wait(1000)
        for h,v in ipairs(GetPlayers()) do
            TriggerClientEvent('mms-shownames:client:UpdateAllPlayerData',v,AllPlayerData)
        end

        Citizen.Wait(5000)
    end
end)

-- Get Alias Callback

VORPcore.Callback.Register('mms-shownames:callback:GetCurrentName', function(source,cb)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local CharID = Character.charIdentifier
    local Alias = ''
    local result = MySQL.query.await("SELECT * FROM mms_shownames WHERE charidentifier=@charidentifier", { ["@charidentifier"] = CharID})
    if #result > 0 then
        if result[1].aliasactive == 1 then
            Alias = result[1].alias
        end
    end
    cb(Alias)
end)

-- Toggle Alias

RegisterServerEvent('mms-shownames:server:ToggleAlias',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local CharID = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_shownames WHERE charidentifier=@charidentifier", { ["@charidentifier"] = CharID})
    if #result > 0 then
        if result[1].aliasactive == 1 then
            MySQL.update('UPDATE `mms_shownames` SET aliasactive = ?  WHERE charidentifier = ?',{0, CharID})
        elseif result[1].aliasactive == 0 then
            MySQL.update('UPDATE `mms_shownames` SET aliasactive = ?  WHERE charidentifier = ?',{1, CharID})
        end
    end
end)

-- Delete Alias

RegisterServerEvent('mms-shownames:server:DeleteAlias',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local CharID = Character.charIdentifier
    local result = MySQL.query.await("SELECT * FROM mms_shownames WHERE charidentifier=@charidentifier", { ["@charidentifier"] = CharID})
    if #result > 0 then
        if result[1].aliasactive == 1 then
            MySQL.update('UPDATE `mms_shownames` SET aliasactive = ?  WHERE charidentifier = ?',{0, CharID})
        end
    end
    MySQL.execute('DELETE FROM mms_shownames WHERE charidentifier = ?', { CharID }, function()
    end)
end)

-- Request Alias Command

RegisterCommand(Config.RequestAliasCommand, function(source, args, rawcommand)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Name = Character.firstname .. ' ' .. Character.lastname
    local CharID = Character.charIdentifier
    local AliasFirstname = args[1]
    local AliasLastname = args[2]
    local Alias = AliasFirstname .. ' ' .. AliasLastname
    local Identifier = Character.identifier
    local result = MySQL.query.await("SELECT * FROM mms_shownames WHERE charidentifier=@charidentifier", { ["@charidentifier"] = CharID})
    if #result > 0 then
        if result[1].approved == 0 then
            VORPcore.NotifyRightTip(src,_U('AliasAlreadyRequested'),5000)
        else
            VORPcore.NotifyRightTip(src,_U('AliasAlreadyApproved'),5000)
        end
    else
        MySQL.insert('INSERT INTO `mms_shownames` (identifier,charidentifier,name,alias,aliasactive,approved) VALUES (?, ?, ?, ?, ?, ?)',
        {Identifier,CharID,Name,Alias,0,0}, function()end)
    end

    local AdminsOnline = 0

    for h,v in ipairs(GetPlayers()) do
        local Character = VORPcore.getUser(v).getUsedCharacter
        local Group = Character.group
        for h,v in ipairs(Config.AdminGroups) do
            if Group == v.Group then
                AdminsOnline = AdminsOnline + 1
                VORPcore.NotifyRightTip(src,_U('Player') .. Name .. _U('RequestedAlias') .. Alias,50000)
                VORPcore.NotifyRightTip(src,_U('PleaseUse') .. Config.ApproveAliasCommand .. ' ' .. CharID .. _U('ToApproveRequest'),50000)
            end
        end
    end

    if AdminsOnline > 0 then
        VORPcore.NotifyRightTip(src,'Request send to Admin',5000)
        if Config.EnableWebHook then
            VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,_U('Player') .. Name .. _U('RequestedAlias') .. Alias, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
            VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,_U('PleaseUse') .. Config.ApproveAliasCommand .. ' ' .. CharID .. _U('ToApproveRequest'), Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
        end
    else
        VORPcore.NotifyRightTip(src,_U('NoAdminsOnline'),5000)
    end

end)

RegisterCommand(Config.ApproveAliasCommand, function(source, args, rawcommand)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Group = Character.group
    local ApproveID = args[1]
    local ImAdmin = false
    for h,v in ipairs(Config.AdminGroups) do
        if Group == v.Group then
            ImAdmin = true
        end
    end
    if ImAdmin then
        MySQL.update('UPDATE `mms_shownames` SET approved = ?  WHERE charidentifier = ?',{1, ApproveID})
    end
end)