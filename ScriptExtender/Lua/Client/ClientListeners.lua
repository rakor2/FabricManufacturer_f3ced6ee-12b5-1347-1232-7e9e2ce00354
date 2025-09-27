-- Channels.WhenLevelGamplayStarted:SetHandler(function (payload)
--     UpdateElements()
-- end)



Ext.Entity.OnCreate('ClientControl', function(entity, ct, c)
    UpdateElements()
end)


Channels.ArmorState:SetHandler(function (payload)
    UpdateElements()
end)


