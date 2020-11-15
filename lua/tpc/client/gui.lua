--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

function TPC:CreateMenu(CPanel)
    if CPanel.Help then -- If testing
        CPanel:Help("Customize your tool panel colors!")
    end

    local colorControls = table.Copy(self.colors)
    local previewColors = table.Copy(self.colors)

    local presets = vgui.Create("ControlPresets", CPanel)
        presets:Dock(TOP)
        presets:DockMargin(10, 10, 10, 0)
        presets:SetPreset("tpc")
        for k, v in pairs(self.options) do
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

            for type,tpnl in pairs(previewColors) do
                for line,lpnl in pairs(tpnl) do
                    timer.Simple(0.1, function() -- Paint the previews in a later frame
                        lpnl:SetColor(TPC.colors[type][line])
                    end)
                end
            end
        end

    local previewSize = 50
    local sectionHeight = 25
    local previewColorsPanel = vgui.Create("DPanel", CPanel)
        previewColorsPanel:Dock(TOP)
        previewColorsPanel:SetSize(previewSize * 4, previewSize + sectionHeight)
        previewColorsPanel:DockMargin(10, 10, 10, 0)
        previewColorsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SelectColorMixer(pressedButton, newMixer)
        for type,tpnl in pairs(colorControls) do
            for line,lpnl in pairs(tpnl) do
                if lpnl:IsVisible() then
                    lpnl:Hide() -- Old mixer
                    previewColors[type][line].background:Hide() -- Last pressed button background
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

    local function SetColorButton(type, line, position)
        -- Selection box
        local background = vgui.Create("DPanel", previewColorsPanel)
            background:SetPos(previewSize * position, sectionHeight)
            background:SetSize(previewSize, previewSize)
            background:SetBackgroundColor(Color(0, 0, 0, 255))
            background:Hide()

        -- Applied color
        previewColors[type][line] = vgui.Create("DColorButton", previewColorsPanel)
            previewColors[type][line].background = background
            previewColors[type][line]:SetPos(previewSize * position + 2, sectionHeight + 2)
            previewColors[type][line]:SetSize(previewSize - 4, previewSize - 4)
            previewColors[type][line]:Paint(previewSize, previewSize)
            previewColors[type][line]:SetColor(self.colors[type][line])
            previewColors[type][line].DoClick = function(self)
                SelectColorMixer(previewColors[type][line], colorControls[type][line])
            end

        return previewColors[type][line]
    end

    SetColorButton("GMod", "even", 0).background:Show()
    SetColorButton("GMod", "odd", 1)
    SetColorButton("Others", "even", 2)
    SetColorButton("Others", "odd", 3)

    local colorMixerHeight = 165
    local colorControlsPanel = vgui.Create("DPanel", CPanel)
        colorControlsPanel:Dock(TOP)
        colorControlsPanel:SetSize(previewSize * 4, colorMixerHeight)
        colorControlsPanel:DockMargin(10, 10, 10, 0)
        colorControlsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SetColorMixer(type, line)
        colorControls[type][line] = vgui.Create("DColorMixer", colorControlsPanel)
            colorControls[type][line]:SetSize(colorControlsPanel:GetWide(), colorMixerHeight)
            colorControls[type][line]:SetPalette(true)
            colorControls[type][line]:SetAlphaBar(true)
            colorControls[type][line]:SetWangs(true)
            colorControls[type][line]:SetConVarR("tpc_" .. type .. "_" .. line .. "_r")
            colorControls[type][line]:SetConVarG("tpc_" .. type .. "_" .. line .. "_g")
            colorControls[type][line]:SetConVarB("tpc_" .. type .. "_" .. line .. "_b")
            colorControls[type][line]:SetConVarA("tpc_" .. type .. "_" .. line .. "_a")
            colorControls[type][line]:SetColor(self.colors[type][line])
            colorControls[type][line]:Hide()
            colorControls[type][line].ValueChanged = function()
                previewColors[type][line]:SetColor(self.colors[type][line])
                TPC:SetNewToolColors()
            end
    end

    for type,tpnl in pairs(colorControls) do
        for line,lpnl in pairs(tpnl) do
            SetColorMixer(type, line)
        end
    end

    colorControls.GMod.even:Show()

    local toolEntryWidth = 161
    local toolEntryHeight = 17
    local fakeToolsListPanel = vgui.Create("DPanel", CPanel)
        fakeToolsListPanel:Dock(TOP)
        fakeToolsListPanel:SetTall(#self.fakeToolsList * toolEntryHeight)
        fakeToolsListPanel:DockMargin(10, 10, 10, 0)
        fakeToolsListPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    if not CPanel.Help then -- If testing
        local realWhiteBackground = vgui.Create("DColorButton", fakeToolsListPanel)
            realWhiteBackground:SetSize(toolEntryWidth, fakeToolsListPanel:GetTall())
            realWhiteBackground:SetColor(Color(255, 255, 255, 255))
    end

    local function SimulateToolList(position, type, line, text, parent)
        local posY = toolEntryHeight * position + 3

        local toolEntry = vgui.Create("DPanel", parent)
            toolEntry:SetPos(0, posY)
            toolEntry:SetSize(toolEntryWidth, toolEntryHeight)
            toolEntry:SetBackgroundColor(line == "even" and Color(0, 0, 0, 0) or Color(0, 0, 0, 27)) -- This line odd + white = Color(243, 243, 243, 255) = darker tool line
            toolEntry.OnMousePressed = function(...)
                previewColors[type][line]:DoClick(...)
            end
            TPC:SetPaint(toolEntry, type, line)

        local toolName = vgui.Create( "DLabel", parent)
            toolName:SetSize(toolEntryWidth, toolEntryHeight)
            toolName:SetPos(5, posY)
            toolName:SetText(text)
            toolName:SetTextColor(line == "even" and Color(119, 119, 119, 255) or Color(135, 135, 135, 255))
    end

    local DCollapsible = vgui.Create("DCollapsibleCategory", fakeToolsListPanel)
        DCollapsible:SetLabel("Click on the tools")
        DCollapsible:SetWide(toolEntryWidth)
        DCollapsible:SetExpanded(true)

    for k,v in ipairs(self.fakeToolsList) do
        local line = k % 2 == 0 and "even" or "odd"

        SimulateToolList(k, v[1], line, v[2], fakeToolsListPanel)
    end

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
--TPC:Test() -- Uncomment and save after the map loading