local VORPcore = exports.vorp_core:GetCore()

local ShowText = false
local Alias = ''

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(15000)
    local GetAlias =  VORPcore.Callback.TriggerAwait('mms-shownames:callback:GetCurrentName')
    if GetAlias ~= '' then
        Alias = GetAlias
    end
end)

VORPcore.Callback.Register('mms-shownames:callback:RecivePlayerPedID', function(cb)
    local MyPed = PlayerPedId()
    cb(MyPed)
end)

local AllPlayerData = {}

RegisterNetEvent('mms-shownames:client:UpdateAllPlayerData')
AddEventHandler('mms-shownames:client:UpdateAllPlayerData',function(ServerData)
    AllPlayerData = ServerData
end)

RegisterCommand(Config.ToggleCommand,function()
    if ShowText then
        ShowText = false
    else
        ShowText = true
    end
end)

RegisterCommand(Config.ToggleAliasCommand,function()
    local GetAlias =  VORPcore.Callback.TriggerAwait('mms-shownames:callback:ToggleAlias')
    if GetAlias ~= '' then
        Alias = GetAlias
    end
end)

RegisterCommand(Config.DeleteAliasCommand,function()
    local GetAlias =  VORPcore.Callback.TriggerAwait('mms-shownames:callback:DeleteMyAlias')
    if GetAlias ~= '' then
        Alias = GetAlias
    end
end)

Citizen.CreateThread(function ()
    while true do
        local sleep = 500
        Citizen.Wait(sleep)
        while ShowText do
            Citizen.Wait(3)
            local MyPos = GetEntityCoords(PlayerPedId())
            for h,v in ipairs(AllPlayerData) do
                local PedPos = GetEntityCoords(v.Ped)
                local isPedCrouching = GetPedCrouchMovement(v.Ped)
                local isPedInCover = IsPedInCover(v.Ped)
                local isPedInRagdoll = IsPedRagdoll(v.Ped)
                local Distance = #(MyPos - PedPos)
                local Name = v.Name
                if Alias ~= '' then
                    Name = Alias
                end
                local Displaytext = ''
                if Config.DisplayType == 1 then
                    Displaytext = v.Name
                elseif Config.DisplayType == 2 then
                    Displaytext = Name .. ' [' .. v.ServerID .. ']'
                elseif Config.DisplayType == 3 then
                    Displaytext = Name .. ' [' .. v.CharID .. ']'
                end
                if Distance <= Config.ShowNamesDistance and not isPedInCover and not isPedInRagdoll and isPedCrouching == 0 then
                    DrawText3D(PedPos.x, PedPos.y, PedPos.z + Config.TextOffset, Displaytext, Config.TextColor)
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