--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

local function AddPresets(CPanel, previewColors)
    local presets = vgui.Create("ControlPresets", CPanel)
        presets:Dock(TOP)
        presets:DockMargin(10, 10, 10, 0)
        presets:SetPreset("tpc")
        for k, v in pairs(TPC.options) do
            presets:AddOption(k, v)

            for cvar,_ in pairs(v) do
                presets:AddConVar(cvar)
            end
        end
        presets.OnSelect = function(self, index, text, data)
            for k,v in pairs(data) do
                RunConsoleCommand(k, v)
            end

            timer.Simple(0.05, function() -- Paint the tool panel in a later frame
               TPC:SetNewToolColors()
            end)

            for toolType,tpnl in pairs(previewColors) do
                for lineType,lpnl in pairs(tpnl) do
                    timer.Simple(0.1, function() -- Paint the previews in a later frame
                        lpnl:SetColor(TPC.colors[toolType][lineType])
                    end)
                end
            end
        end
end

local function AddColorSelector(CPanel, colorControls, previewColors)
    local previewSize = 50
    local sectionHeight = 25
    local previewColorsPanel = vgui.Create("DPanel", CPanel)
        previewColorsPanel:Dock(TOP)
        previewColorsPanel:SetSize(previewSize * 4, previewSize + sectionHeight)
        previewColorsPanel:DockMargin(10, 10, 10, 0)
        previewColorsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SelectColorMixer(pressedButton, newMixer)
        for toolType,tpnl in pairs(colorControls) do
            for lineType,lpnl in pairs(tpnl) do
                if lpnl:IsVisible() then
                    lpnl:Hide() -- Old mixer
                    previewColors[toolType][lineType].background:Hide() -- Last pressed button background
                    break
                end
            end
        end

        newMixer:Show()
        pressedButton.background:Show()
    end

    local section1 = vgui.Create( "DLabel", previewColorsPanel)
        section1:SetSize(previewSize * 2, sectionHeight)
        section1:SetText("       Default tools")
        section1:SetTextColor(color_black)

    local divider = vgui.Create( "DLabel", previewColorsPanel)
        divider:SetSize(previewSize * 2, sectionHeight)
        divider:SetPos(section1:GetWide() - 4, 0)
        divider:SetText("||")
        divider:SetTextColor(color_black)

    local section2 = vgui.Create( "DLabel", previewColorsPanel)
        section2:SetSize(previewSize * 2, sectionHeight)
        section2:SetPos(section1:GetWide(), 0)
        section2:SetText("      Custom tools")
        section2:SetTextColor(color_black)

    local function SetColorButton(toolType, lineType, position)
        -- Selection box
        local background = vgui.Create("DPanel", previewColorsPanel)
            background:SetPos(previewSize * position, sectionHeight)
            background:SetSize(previewSize, previewSize)
            background:SetBackgroundColor(Color(0, 0, 0, 255))
            background:Hide()

        -- Applied color
        previewColors[toolType][lineType] = vgui.Create("DColorButton", previewColorsPanel)
            previewColors[toolType][lineType].background = background
            previewColors[toolType][lineType]:SetPos(previewSize * position + 2, sectionHeight + 2)
            previewColors[toolType][lineType]:SetSize(previewSize - 4, previewSize - 4)
            previewColors[toolType][lineType]:Paint(previewSize, previewSize)
            previewColors[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            previewColors[toolType][lineType].DoClick = function(self)
                SelectColorMixer(previewColors[toolType][lineType], colorControls[toolType][lineType])
            end

        return previewColors[toolType][lineType]
    end

    SetColorButton("GMod", "odd", 0).background:Show()
    SetColorButton("GMod", "even", 1)
    SetColorButton("Others", "odd", 2)
    SetColorButton("Others", "even", 3)

    local colorMixerHeight = 165
    local colorControlsPanel = vgui.Create("DPanel", CPanel)
        colorControlsPanel:Dock(TOP)
        colorControlsPanel:SetSize(previewSize * 4, colorMixerHeight)
        colorControlsPanel:DockMargin(10, 10, 10, 0)
        colorControlsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SetColorMixer(toolType, lineType)
        colorControls[toolType][lineType] = vgui.Create("DColorMixer", colorControlsPanel)
            colorControls[toolType][lineType]:SetSize(colorControlsPanel:GetWide(), colorMixerHeight)
            colorControls[toolType][lineType]:SetPalette(true)
            colorControls[toolType][lineType]:SetAlphaBar(true)
            colorControls[toolType][lineType]:SetWangs(true)
            colorControls[toolType][lineType]:SetConVarR("tpc_" .. toolType .. "_" .. lineType .. "_r")
            colorControls[toolType][lineType]:SetConVarG("tpc_" .. toolType .. "_" .. lineType .. "_g")
            colorControls[toolType][lineType]:SetConVarB("tpc_" .. toolType .. "_" .. lineType .. "_b")
            colorControls[toolType][lineType]:SetConVarA("tpc_" .. toolType .. "_" .. lineType .. "_a")
            colorControls[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            colorControls[toolType][lineType]:Hide()
            colorControls[toolType][lineType].ValueChanged = function()
                previewColors[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
                TPC:SetNewToolColors()
            end
    end

    for toolType,tpnl in pairs(colorControls) do
        for lineType,lpnl in pairs(tpnl) do
            SetColorMixer(toolType, lineType)
        end
    end

    colorControls.GMod.even:Show()

    local toolEntryWidth = 161
    local toolEntryHeight = 17
    local fakeToolsListPanel = vgui.Create("DPanel", CPanel)
        fakeToolsListPanel:Dock(TOP)
        fakeToolsListPanel:SetTall(#TPC.fakeToolsList * toolEntryHeight)
        fakeToolsListPanel:DockMargin(10, 10, 10, 0)
        fakeToolsListPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    if not CPanel.Help then -- If testing
        local realWhiteBackground = vgui.Create("DColorButton", fakeToolsListPanel)
            realWhiteBackground:SetSize(toolEntryWidth, fakeToolsListPanel:GetTall())
            realWhiteBackground:SetColor(Color(255, 255, 255, 255))
    end

    local function SimulateToolList(position, toolType, lineType, text, parent)
        local posY = toolEntryHeight * position + 3

        local toolEntry = vgui.Create("DPanel", parent)
            toolEntry:SetPos(0, posY)
            toolEntry:SetSize(toolEntryWidth, toolEntryHeight)
            toolEntry:SetBackgroundColor(lineType == "even" and Color(0, 0, 0, 0) or Color(0, 0, 0, 27))
            toolEntry.OnMousePressed = function(...)
                previewColors[toolType][lineType]:DoClick(...)
            end
            TPC:SetPaint(toolEntry, toolType, lineType)

        local toolName = vgui.Create( "DLabel", parent)
            toolName:SetSize(toolEntryWidth, toolEntryHeight)
            toolName:SetPos(5, posY)
            toolName:SetText(text)
            toolName:SetTextColor(lineType == "even" and Color(119, 119, 119, 255) or Color(135, 135, 135, 255))
    end

    local DCollapsible = vgui.Create("DCollapsibleCategory", fakeToolsListPanel)
        DCollapsible:SetLabel("Click on the tools")
        DCollapsible:SetWide(toolEntryWidth)
        DCollapsible:SetExpanded(true)

    for k,v in ipairs(TPC.fakeToolsList) do
        local lineType = k % 2 == 0 and "even" or "odd"

        SimulateToolList(k, v[1], lineType, v[2], fakeToolsListPanel)
    end
end

function TPC:CreateMenu(CPanel)
    if CPanel.Help then -- If testing
        CPanel:Help("Customize your tool panel colors!")
    end

    local colorControls = table.Copy(TPC.colors)
    local previewColors = table.Copy(TPC.colors)

    AddPresets(CPanel, previewColors)
    AddColorSelector(CPanel, colorControls, previewColors)

    if CPanel.Help then -- If testing
        CPanel:Help("")
    end
end

hook.Add("PopulateToolMenu", "CreateCMenu", function()
    local function wrapper(...)
        TPC:CreateMenu(...)
    end

    spawnmenu.AddToolMenuOption("Utilities", "Admin", "TPC", "Tool Panel Colors", "", "", wrapper)
end)

function TPC:Test()
    TPC:SetNewToolColors()

    local test = vgui.Create("DFrame")
        test:SetPos(800, 400)
        test:SetSize(250, 700)
        test:SetDeleteOnClose(true)
        test:Center()
        test:SetDraggable(true)	
        test:MakePopup()

    self:CreateMenu(test)
end
--TPC:Test() -- Uncomment and save after the map loads