
local OPENQUESTIONMARK = false
--IMGUI:AntiStupiditySystem()

UI = UI or {}
Window = Window or {}

Globals = Globals or {}

function UI:Init()
    Window:FMMCM()
    Window:FMWindow()
end


function Window:FMMCM()
    local function CreateFMMCMTab(tab)
        local openButton = tab:AddButton("Open")
        openButton.OnClick = function()
            FMWindow.Open = not FMWindow.Open
        end
    end
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "FM", CreateFMMCMTab)
end


function Window:FMWindow()
    FMWindow = Ext.IMGUI.NewWindow("Fabric Manufacturer")
    FMWindow.Open = OPENQUESTIONMARK
    FMWindow.Closeable = true
    -- FMWindow.AlwaysAutoResize = true
    FMWindow:SetSize({643, 600})

    -- mainTabBar = FMWindow:AddTabBar("TabBar")

    -- p = mainTabBar:AddTabItem("Main")

    p = FMWindow

    StyleV2:RegisterWindow(FMWindow)

    ApplyStyle(FMWindow, 1)

    MCM.SetKeybindingCallback('fm_toggle_window', function()
        FMWindow.Open = not FMWindow.Open
    end)

    GlobalsIMGUI.checkAuto = p:AddCheckbox('Automatic re-equip', true)

    local btnUpdateEquipment = p:AddButton('Get cloth parameters')
    btnUpdateEquipment.OnClick = function ()
        UpdateElements()
        SaveInitialParameters()
    end

    GlobalsIMGUI.btnSaveInits = p:AddButton('Save parameters')
    GlobalsIMGUI.btnSaveInits.SameLine = true
    GlobalsIMGUI.btnSaveInits.OnClick = function ()
        SaveInitialParameters()
    end
    
    local btnLoadInits = p:AddButton('Load parameters')
    btnLoadInits.SameLine = true
    btnLoadInits.OnClick = function ()
        RestoreInitialParameters()
    end
    
    GlobalsIMGUI.group = p:AddGroup('xd')
    
    GlobalsIMGUI.groupText = p:AddGroup('Text')


end

UI:Init()