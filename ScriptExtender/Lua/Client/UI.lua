
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
    FMWindow = Ext.IMGUI.NewWindow("quick small animation thingy")
    FMWindow.Open = OPENQUESTIONMARK
    FMWindow.Closeable = true
    -- FMWindow.AlwaysAutoResize = true
    FMWindow:SetSize({643, 700})

    mainTabBar = FMWindow:AddTabBar("LL")

    p = mainTabBar:AddTabItem("Animations")

    StyleV2:RegisterWindow(FMWindow)

    ApplyStyle(FMWindow, 1)


    MCM.SetKeybindingCallback('FM_toggle_window', function()
        FMWindow.Open = not FMWindow.Open
    end)


    


end

UI:Init()