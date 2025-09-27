local function getMeshName(clothAttachment)
    return _C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.SourceFile:match('([^/\\]+)%.GR2$')
end



local function reEquip()
    Utils:AntiSpam(300, function ()
        if GlobalsIMGUI.checkAuto.Checked then
            Channels.ArmorState:SendToServer({})
        end
    end)
end



function FindAttachmentsWithClothParameters()
    local ClothAttachments = {}
    if _C().Visual.Visual then
        for attachmentNumber, attachment in pairs(_C().Visual.Visual.Attachments) do
            if  attachment.Visual.VisualResource and attachment.Visual.VisualResource.Cloth and
                not attachment.Visual.VisualResource.Template:lower():find('nkd_body')
            then
                local ClothParameters = attachment.Visual.VisualResource.Cloth
                -- DPrint('-------------------------')
                -- DPrint('Attachment number: ' .. attachmentNumber)
                -- DPrint(attachment.Visual.VisualResource.Template)
                -- DDump(ClothParameters)
                table.insert(ClothAttachments, attachmentNumber)
            end
        end
        return ClothAttachments
    end
end



local nospammerino = false
function UpdateElements()
    if nospammerino then return end
    Imgui.ClearChildren(GlobalsIMGUI.group)
    nospammerino = true
    Helpers.Timer:OnTicks(40, function ()
        CreateClothParameterSliders(GlobalsIMGUI.group)
        nospammerino = false
    end)
end



function CreateClothParameterSliders(parent)
    local default = 30
    local collapseMain


    local function applyParameter(clothAttachment, parameterNumber, parameterName, value)
        pcall(function () _C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params[parameterNumber][parameterName] = value end)
        reEquip()
    end


    local xdd = parent:AddSeparator('')

    local ClothAttachments = FindAttachmentsWithClothParameters()
    if ClothAttachments then 
        for _, clothAttachment in pairs(ClothAttachments) do
            local meshName = getMeshName(clothAttachment)

            if _C().Visual.Visual.Attachments[clothAttachment] and _C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params[1] ~= nil then
                collapseMain = parent:AddCollapsingHeader(meshName)
                collapseMain.IDContext = Ext.Math.Random(1,10000)

                for parameterNumber, Parameters in pairs(_C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params) do
                    local collapse = collapseMain:AddTree(Parameters.UUID)
                    collapse.IDContext = Ext.Math.Random(1,10000)

                    for parameterName, value in pairs(Parameters) do
                        if parameterName ~= 'UUID' then
                            if type(value) == 'table' then
                                local slElement = collapse:AddSlider(parameterName, value[1],-default, default,0)
                                slElement.IDContext = Ext.Math.Random(1,10000)
                                slElement.Logarithmic = true
                                slElement.OnChange = function ()
                                    applyParameter(clothAttachment, parameterNumber, parameterName, {slElement.Value[1], slElement.Value[1], slElement.Value[1]})
                                end
                            elseif type(value) == 'boolean' then
                                local slElement = collapse:AddCheckbox(parameterName)
                                slElement.IDContext = Ext.Math.Random(1,10000)
                                slElement.Checked = value
                                slElement.OnChange = function ()
                                    applyParameter(clothAttachment, parameterNumber, parameterName, slElement.Checked)
                                end
                            else
                                local slElement = collapse:AddSlider(parameterName, value,-default, default,0)
                                slElement.IDContext = Ext.Math.Random(1,10000)
                                slElement.Logarithmic = true
                                slElement.OnChange = function ()
                                    applyParameter(clothAttachment, parameterNumber, parameterName, slElement.Value[1])
                                end
                            end
                        end
                    end
                    
                    local btnExport = collapse:AddButton('Export')
                    btnExport.IDContext = Ext.Math.Random(1,1000000)
                    btnExport.OnClick = function ()
                        local Params = _C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params[parameterNumber]
                        local xml = exportParams(Params)
                        Ext.IO.SaveFile('FabricManufacturer/_' .. Params.UUID .. '.json', xml)
                    end
                end
                collapseMain:AddSeparator('')
            else
                parent:AddCollapsingHeader(meshName .. ' has no physics')
            end
        end
    end
end



SavedParameters = SavedParameters or {}
function SaveInitialParameters()
    local meshName
    local xd1
    local ClothAttachments = FindAttachmentsWithClothParameters()
    if ClothAttachments then
        for _, clothAttachment in pairs(ClothAttachments) do
            meshName = getMeshName(clothAttachment)
            if not SavedParameters[meshName] then
                SavedParameters[meshName] = SavedParameters[meshName] or {}
                if _C().Visual.Visual.Attachments[clothAttachment] and _C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params[1] ~= nil then
                    for parameterNumber, Parameters in pairs(_C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params) do
                        SavedParameters[meshName][Parameters.UUID] = SavedParameters[meshName][Parameters.UUID] or {}
                        for parameterName, value in pairs(Parameters) do
                            SavedParameters[meshName][Parameters.UUID][parameterName] = value
                        end
                    end
                end
            else
                if not xd1 then
                    xd1 = GlobalsIMGUI.groupText:AddText('Parameters already saved for:')
                end
                GlobalsIMGUI.groupText:AddText(meshName)
                Helpers.Timer:OnTicks(200, function ()
                    Imgui.ClearChildren(GlobalsIMGUI.groupText)
                end)
            end
        end
        GlobalsIMGUI.btnSaveInits:SetColor('ButtonHovered', {0.1 ,0.6 ,0.1 ,1})
        Helpers.Timer:OnTicks(200, function ()
            GlobalsIMGUI.btnSaveInits:SetColor('ButtonHovered', {0.25, 0.25, 0.25, 1.00})
        end)
    end
end



function RestoreInitialParameters()
    reEquip()
    Helpers.Timer:OnTicks(10, function ()
    local ClothAttachments = FindAttachmentsWithClothParameters()
    if ClothAttachments then
        for _, clothAttachment in pairs(ClothAttachments) do
            for parameterNumber, Parameters in pairs(_C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params) do
                for parameterName, value in pairs(Parameters) do
                    for _, SubMeshes in pairs(SavedParameters) do
                        for subMesh, Parameters2 in pairs(SubMeshes) do
                            if Parameters.UUID == Parameters2.UUID then
                                for parameterName2, value2 in pairs(Parameters2) do
                                    _C().Visual.Visual.Attachments[clothAttachment].Visual.VisualResource.Cloth.Params[parameterNumber][parameterName2] = value2
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    UpdateElements()
    end)
end



Ext.RegisterConsoleCommand('fms', function ()
    DDump(SavedParameters)
end)


Ext.RegisterConsoleCommand('fmd', function ()
    for k, v in pairs(_C().Visual.Visual.Attachments) do
        if v.Visual.VisualResource then
            DPrint('------------------------------------------------------')
            DPrint(k)
            DDump(v.Visual.VisualResource.Template)
        end
    end
end)


Ext.RegisterConsoleCommand('fma', function (_, x)
    local xd = _C().Visual.Visual.Attachments[x].Visual
    DDump(xd)
    Utils:Dump(xd, 'FabricManufacturer/fma_dump')
end)



-- function getClothParametersBySourceFile(sourceFile)
--     for attachmentNumber, attachment in pairs(_C().Visual.Visual.Attachments) do
--         if attachment.Visual.VisualResource and attachment.Visual.VisualResource.Cloth then
--             if attachment.Visual.VisualResource.SourceFile:find(sourceFile) then
--                 return attachment.Visual.VisualResource.Cloth
--             end
--         end
--     end
-- end    



---slopped

local function toAttribute(id, value)
    
    local function formatNumber(n)
        local s = string.format("%.6f", n)
        s = s:gsub("0+$", ""):gsub("%.$", "")
        return s
    end

    local attrType, attrValue

    if type(value) == "number" then
        attrType = "float"
        attrValue = formatNumber(value)
    elseif type(value) == "boolean" then
        attrType = "bool"
        attrValue = value and "True" or "False"
    elseif type(value) == "string" then
        attrType = "FixedString"
        attrValue = value
    elseif type(value) == "table" then
        local parts = {}
        for i = 1, #value do
            parts[#parts+1] = formatNumber(value[i])
        end
        if #value == 3 then
            attrType = "fvec3"
        elseif #value == 4 then
            attrType = "fvec4"
        else
            attrType = "array"
        end
        attrValue = table.concat(parts, " ")
    end
    return string.format(
        '    <attribute id="%s" type="%s" value="%s" />',
        id, attrType, attrValue
    )
end

function exportParams(params)
    local lines = {}
    table.insert(lines, '<node id="ClothParams">')
    for k,v in pairs(params) do
        table.insert(lines, toAttribute(k, v))
    end
    table.insert(lines, '</node>')
    return table.concat(lines, "\n")
end




