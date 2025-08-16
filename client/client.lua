local VORPcore = exports.vorp_core:GetCore()

local ShowText = false
local ShowOwnName = false

if Config.ShowTextOnStart then
    ShowText = true
end

if Config.ShowOwnNameOnStart then
    ShowOwnName = true
end

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(15000)
end)

VORPcore.Callback.Register('mms-shownames:callback:RecivePlayerPedID', function(cb)
    local MyPed = PlayerPedId()
    cb(MyPed)
end)

local AllPlayerData = {}

RegisterNetEvent('mms-shownames:client:UpdateAllPlayerData')
AddEventHandler('mms-shownames:client:UpdateAllPlayerData',function(ServerData)
    AllPlayerData = ServerData
    for h,v in ipairs(AllPlayerData) do
        local ServerID = tonumber(v.ServerID)
        local Index = h
        for h,ClientPlayer in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(ClientPlayer)
            local serverId = GetPlayerServerId(ClientPlayer)
            if ServerID == serverId then
                AllPlayerData[Index].Ped = ped
            end
        end
    end
end)

RegisterCommand(Config.ToggleCommand,function()
    if ShowText then
        ShowText = false
    else
        ShowText = true
    end
end)

RegisterCommand(Config.ToggleOwnNameCommand,function()
    if ShowOwnName then
        ShowOwnName = false
    else
        ShowOwnName = true
    end
end)

RegisterCommand(Config.ToggleAliasCommand,function()
    TriggerServerEvent('mms-shownames:server:ToggleAlias')
end)

RegisterCommand(Config.DeleteAliasCommand,function()
    TriggerServerEvent('mms-shownames:server:DeleteAlias')
end)

Citizen.CreateThread(function ()
    while true do
        local sleep = 500
        Citizen.Wait(sleep)
        while ShowText do
            Citizen.Wait(5)
            local MyPos = GetEntityCoords(PlayerPedId())
            for h,v in ipairs(AllPlayerData) do
                local PedPos = GetEntityCoords(v.Ped)
                local isPedCrouching = GetPedCrouchMovement(v.Ped)
                local isPedInCover = IsPedInCover(v.Ped)
                local isPedInRagdoll = IsPedRagdoll(v.Ped)
                local Distance = #(MyPos - PedPos)
                local Displaytext = ''
                local TextOffset = Config.TextOffset
                if Config.DisplayType == 1 then
                    Displaytext = v.Name
                elseif Config.DisplayType == 2 then
                    Displaytext = v.Name .. ' [' .. v.ServerID .. ']'
                elseif Config.DisplayType == 3 then
                    Displaytext = v.Name .. ' [' .. v.CharID .. ']'
                end
                if IsPedInAnyVehicle(v.Ped) then
                    TextOffset = TextOffset + 0.9
                end
                if IsPedOnMount(v.Ped) then
                    TextOffset = TextOffset + 0.9
                end
                if ShowOwnName and Distance <= Config.ShowNamesDistance and not isPedInCover and not isPedInRagdoll and isPedCrouching == 0 then
                    DrawText3D(PedPos.x, PedPos.y, PedPos.z + TextOffset, Displaytext, Config.TextColor)
                elseif not ShowOwnName and Distance > 0.2 and Distance <= Config.ShowNamesDistance and not isPedInCover and not isPedInRagdoll and isPedCrouching == 0 then
                    DrawText3D(PedPos.x, PedPos.y, PedPos.z + TextOffset, Displaytext, Config.TextColor)
                end
            end
        end
    end
end)

-- HotKey Function 

Citizen.CreateThread(function()
    if Config.UseToggleKey then
        while true do
            if IsControlPressed(0, Config.Key) then
                if ShowText then
                    ShowText = false
                else
                    ShowText = true
                end
            end
            Citizen.Wait(2)
        end
    end
end)

-- DrawText3D Function

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        SetTextScale(Config.Scale, Config.Scale)
        SetTextFontForCurrentCommand(Config.Textfont)
        SetTextColor(color[1], color[2], color[3], 255)
        SetTextCentre(1)
        DisplayText(CreateVarString(10, "LITERAL_STRING", text), _x, _y)
    end
end