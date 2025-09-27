-- Ext.Entity.Subscribe("ArmorSetState", function(entity)
--     if entity.ArmorSetState.State == 'Normal' then
--         Channels.ArmorState:Broadcast({})
--     end
-- end)


-- Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
--     Channels.WhenLevelGamplayStarted:Broadcast({})
-- end)

Channels.ArmorState:SetHandler(function ()
    -- if _C().ArmorSetState.State == 'Normal' then
    --     _C().ArmorSetState.State = 'Vanity'
    --     _C():Replicate('ArmorSetState')
    --     Helpers.Timer:OnTicks(10, function ()
    --         _C().ArmorSetState.State = 'Normal'
    --         _C():Replicate('ArmorSetState')
    --     end)
    -- else
    --     _C().ArmorSetState.State = 'Normal'
    --     _C():Replicate('ArmorSetState')
    --     Helpers.Timer:OnTicks(10, function ()
    --         _C().ArmorSetState.State = 'Vanity'
    --         _C():Replicate('ArmorSetState')
    --     end)
    -- end

    local state = _C().ArmorSetState.State == 'Normal' and 'Vanity' or 'Normal'
    local state2 = state == 'Normal' and 'Vanity' or 'Normal'

    _C().ArmorSetState.State = state
    _C():Replicate('ArmorSetState')

    Helpers.Timer:OnTicks(10, function ()
        _C().ArmorSetState.State = state2
        _C():Replicate('ArmorSetState')
    end)

end)



---Today I learned ternary thing (I will fortget it tomorrow FeelsGoodMan Clap)
-- Ext.RegisterConsoleCommand('fmter', function ()
--     DPrint('Current state: %s', _C().ArmorSetState.State)
--     local state = _C().ArmorSetState.State == 'Normal' and 'Vanity' or 'Normal'
--     local state2 = state == 'Normal' and 'Vanity' or 'Normal'
--     DPrint('State: %s, State2: %s', state, state2)

-- end)
--Vanity/ Normal-Vanity
--Normal/ Vanity-Normal

