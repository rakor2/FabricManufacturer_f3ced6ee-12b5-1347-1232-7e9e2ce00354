Channels.WhenLevelGamplayStarted:SetHandler(function (payload)

    CreateClothParameterSliders(GlobalsIMGUI.group)
    
end)

function UpdateElements()
    if GlobalsIMGUI.group then
    GlobalsIMGUI.group:Destroy()
        GlobalsIMGUI.group = FMWindow:AddGroup('xd')
        Helpers.Timer:OnTicks(40, function ()
            CreateClothParameterSliders(GlobalsIMGUI.group)
        end)
    end
end

Ext.Entity.OnCreate('ClientControl', function(entity, ct, c)
    UpdateElements()
end)


Channels.ArmorState:SetHandler(function (payload)
    UpdateElements()
end)


