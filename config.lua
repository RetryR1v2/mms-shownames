Config = {}

--- Language

Config.defaultlang = "de_lang" -- Set Language (Current Languages: "de_lang" German)

-- Webhook Settings

Config.EnableWebHook = true

Config.WHTitle = 'Alias Request: '
Config.WHLink = ''  -- Discord WH link Here
Config.WHColor = 16711680 -- red
Config.WHName = 'Alias Request: ' -- name
Config.WHLogo = 'https://i.postimg.cc/WbTd5ngd/Report-Icon.png' -- must be 30x30px
Config.WHFooterLogo = 'https://i.postimg.cc/WbTd5ngd/Report-Icon.png' -- must be 30x30px
Config.WHAvatar = 'https://i.postimg.cc/WbTd5ngd/Report-Icon.png' -- must be 30x30px

-- Script Settings

Config.ShowNamesDistance = 15
Config.UseToggleKey = true
Config.Key = 0x446258B6 -- pageup

Config.ToggleCommand = 'ToggleNames'
Config.ToggleAliasCommand = 'ToggleMyAlias'
Config.ToggleOwnNameCommand = 'ToggleMyName'

Config.ShowTextOnStart = true -- If by Default the Names should be there
Config.ShowOwnNameOnStart = true -- If by Default Own Name should be there

Config.TextColor = {125, 255, 125}  -- RGB Color Code
Config.Scale = 0.5
Config.TextOffset = 1.0 -- 0-2.0  0 is Mid of Fed 1.0 is Above Ped
Config.Textfont = 1 --0-5


Config.DisplayType = 2

-- DisplayType 1 = Only Player Name or Alias
-- DisplayType 2 = Player Name and ServerID
-- DisplayType 3 = Player Name and CharacterID

-- Alias System

Config.RequestAliasCommand = 'SetAlias'
Config.ApproveAliasCommand = 'Approve'
Config.DeleteAliasCommand = 'DeleteAlias'

Config.AdminGroups = {
    { Group = 'admin' },
    { Group = 'moderator' },
    { Group = 'supporter' },
}