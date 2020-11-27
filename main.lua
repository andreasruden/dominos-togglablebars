-- local AddonName, ThisAddon = ... -- Addon Name, Addon-wide Unique Table
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local ActionBarsModule = Dominos:GetModule('ActionBars')
local TogglableBars = Dominos:NewModule('TogglableBars', 'AceConsole-3.0')

function TogglableBars:OnInitialize()
    if DTB_ActionBarGroupings == nil then
        -- Defaults
        DTB_ActionBarGroupings = {}
        DTB_ActionBarGroupings['0'] = {}
        DTB_ActionBarGroupings['0'][1] = true
        DTB_ActionBarGroupings['0'][5] = true
        DTB_ActionBarGroupings['0'][6] = true
    end
end

function TogglableBars:OnEnable()
    self:RegisterChatCommand('dtb', 'ParseCmd')
    self:RegisterChatCommand('dominostogglablebars', 'ParseCmd')
end

function TogglableBars:OnDisable()
end

function TogglableBars:ParseCmd(paramStr)
    cmd, arg1, arg2 = strsplit(' ', paramStr)
    
    if cmd == '' then
        self:ToggleBars('0')
    elseif tonumber(cmd) ~= nil then
        self:ToggleBars(cmd)
    elseif cmd == 'help' then
        self:ShowHelp()
    elseif cmd == 'add' then
        self:AddBar(arg1, arg2)
    elseif cmd == 'rm' then
        self:RemoveBar(arg1, arg2)
    elseif cmd == 'list' then
        self:ShowToggleGroups()
    else
        self:ShowCmdErr('Invalid command')
    end
end

function TogglableBars:ShowCmdErr(err)
    print('Error: ' .. err .. '. Type "/dtb help" for help.')
end

function TogglableBars:ToggleBars(group)
    if DTB_ActionBarGroupings[group] == nil then
        self:ShowCmderr('No such group')
        return
    end
    
    bars = DTB_ActionBarGroupings[group]

    local items = {}
    for _, bar in pairs(ActionBarsModule.active) do
        if bars[bar['id']] ~= nil then
            bar:CallMethod('ToggleFrame')
        end
    end
    return items
end

function TogglableBars:AddBar(group, bar)
    barNum = tonumber(bar)
    if barNum == nil or not (1 <= barNum and barNum <= 10) then
        self:ShowCmdErr('Invalid actionbar number')
        return
    end
    
    if DTB_ActionBarGroupings[group] == nil then
        DTB_ActionBarGroupings[group] = {}
    end
    
    if DTB_ActionBarGroupings[group][barNum] ~= nil then
        self:ShowCmdErr('Actionbar already belons to group')
        return
    end
    
    DTB_ActionBarGroupings[group][barNum] = true
end

function TogglableBars:RemoveBar(group, bar)
    barNum = tonumber(bar)
    if barNum == nil or not (1 <= barNum and barNum <= 10) then
        self:ShowCmdErr('Invalid actionbar number')
        return
    end
    
    if DTB_ActionBarGroupings[group] == nil then
        self:ShowCmdErr('No such group')
        return
    end
    
    if DTB_ActionBarGroupings[group][barNum] == nil then
        self:ShowCmdErr('That actionbar does not belong to that group')
        return
    end
    
    DTB_ActionBarGroupings[group][barNum] = nil
    if #DTB_ActionBarGroupings[group] == 0 then
        DTB_ActionBarGroupings[group] = nil
    end
end

function TogglableBars:ShowToggleGroups()
    for k, v in pairs(DTB_ActionBarGroupings) do
        local s = 'Group "' ..  k .. '": '
        
        local tmp = {}
        local i = 1
        for ik, _ in pairs(v) do
            tmp[i] = 'ActionBar #' .. ik
            i = i + 1
        end
        s = s .. table.concat(tmp, ', ')
        
        print(s)
    end
end

function TogglableBars:ShowHelp()
    print('Dominos Togglable Bars:')
    print('"/dtb id": Toggle all actionbars with matching toggle group (id).')
    print('"/dtb" is shorthand for "/dtb 0."')
    print('"/dtb add <group> <barIndex>": Add actionbar (barIndex) to toggle group."')
    print('"/dtb rm <group> <barIndex>": Remove actionbar (barIndex) from toggle group (id)."')
    print('"/dtb list": List all toggle groups.')
end

-- SlashCmdList['DTB'] = DTB_ParseCmd
-- SLASH_DTB1 = '/dtb'
-- SLASH_DTB2 = '/dominostogglablebars'
