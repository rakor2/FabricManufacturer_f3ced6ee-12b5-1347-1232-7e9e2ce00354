-- Ext.Entity.Subscribe("ArmorSetState", function(entity)
--     if entity.ArmorSetState.State == 'Normal' then
--         Channels.ArmorState:Broadcast({})
--     end
-- end)


Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    Channels.WhenLevelGamplayStarted:Broadcast({})
end)

Channels.ArmorState:SetHandler(function ()
    if _C().ArmorSetState.State == 'Normal' then
        _C().ArmorSetState.State = 'Vanity'
        _C():Replicate('ArmorSetState')
        Helpers.Timer:OnTicks(10, function ()
            _C().ArmorSetState.State = 'Normal'
            _C():Replicate('ArmorSetState')
        end)
    else
        _C().ArmorSetState.State = 'Normal'
        _C():Replicate('ArmorSetState')
        Helpers.Timer:OnTicks(10, function ()
            _C().ArmorSetState.State = 'Vanity'
            _C():Replicate('ArmorSetState')
        end)
    end
end)