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

            timer.Simple(0.05, function() -- Wait the RunConsoleCommand before init the colors
               TPC:InitToolColors()

                for toolType,tpnl in pairs(previewColors) do
                    for lineType,lpnl in pairs(tpnl) do
                        lpnl:SetColor(TPC.colors[toolType][lineType])
                    end
                end
            end)
        end
end

local function AddColorSelector(CPanel, colorControls, previewColors)
    local previewSize = 50
    local colorControlsPanel

    -- ---------------------
    -- Menu selectors
    -- ---------------------
    local sectionHeight = 25
    local previewColorsPanel = vgui.Create("DPanel", CPanel)
        previewColorsPanel:Dock(TOP)
        previewColorsPanel:SetTall(previewSize + sectionHeight)
        previewColorsPanel:DockMargin(10, 10, 10, 0)
        previewColorsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SelectColorMixer(pressedButton, newMixer)
        if not colorControlsPanel:IsVisible() then
            colorControlsPanel:Show()
        end

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

    local back1 = vgui.Create( "DPanel", previewColorsPanel)
        back1:SetSize(previewSize * 2, sectionHeight + previewSize)
        back1:SetBackgroundColor(Color(0, 0, 0, 80))

    local section1 = vgui.Create( "DLabel", previewColorsPanel)
        section1:SetSize(previewSize * 2, sectionHeight)
        section1:SetText("  GMod default tools")
        section1:SetTextColor(color_black)

    local back2 = vgui.Create( "DPanel", previewColorsPanel)
        back2:SetSize(previewSize * 2, sectionHeight + previewSize)
        back2:SetPos(previewSize * 2, 0)
        back2:SetBackgroundColor(Color(0, 0, 0, 170))

    local section2 = vgui.Create( "DLabel", previewColorsPanel)
        section2:SetSize(previewSize * 2, sectionHeight)
        section2:SetPos(section1:GetWide(), 0)
        section2:SetText("      Custom tools")
        section2:SetTextColor(color_white)

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
            local pnlAux = previewColors[toolType][lineType]
            pnlAux._Paint = pnlAux.Paint
            pnlAux.odd = lineType == "odd" and true or false
            function pnlAux:Paint(w, h)
                self:_Paint(w, h)

                if pnlAux.odd then
                    surface.SetDrawColor(Color(0, 0, 0, 27))
                    surface.DrawRect(0, 0, w, h)
                end
            end
    end

    SetColorButton("GMod", "odd", 0)
    SetColorButton("GMod", "even", 1)
    SetColorButton("Others", "odd", 2)
    SetColorButton("Others", "even", 3)

    -- ---------------------
    -- Color mixer
    -- ---------------------
    local colorMixerHeight = 92
    colorControlsPanel = vgui.Create("DPanel", CPanel)
        colorControlsPanel:Dock(TOP)
        colorControlsPanel:SetSize(previewSize * 4, colorMixerHeight)
        colorControlsPanel:DockMargin(10, 10, 10, 0)
        colorControlsPanel:SetBackgroundColor(Color(0, 0, 0, 0))
        colorControlsPanel:Hide()

    local function SetColorMixer(toolType, lineType)
        colorControls[toolType][lineType] = vgui.Create("DColorMixer", colorControlsPanel)
            colorControls[toolType][lineType]:SetSize(colorControlsPanel:GetWide(), colorMixerHeight)
            colorControls[toolType][lineType]:SetPalette(false)
            colorControls[toolType][lineType]:SetAlphaBar(true)
            colorControls[toolType][lineType]:SetWangs(true)
            colorControls[toolType][lineType]:SetConVarR("tpc_" .. toolType .. "_" .. lineType .. "_r")
            colorControls[toolType][lineType]:SetConVarG("tpc_" .. toolType .. "_" .. lineType .. "_g")
            colorControls[toolType][lineType]:SetConVarB("tpc_" .. toolType .. "_" .. lineType .. "_b")
            colorControls[toolType][lineType]:SetConVarA("tpc_" .. toolType .. "_" .. lineType .. "_a")
            colorControls[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            colorControls[toolType][lineType]:Hide()
            colorControls[toolType][lineType].ValueChanged = function(self, colorTable)
                -- Note: SetConVar"RGBA" is applying past values instead of current ones, so I'm doing a convar refresh here
                TPC:SetNewToolColors(toolType, lineType, colorTable)
                previewColors[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            end
    end

    for toolType,tpnl in pairs(colorControls) do
        for lineType,lpnl in pairs(tpnl) do
            SetColorMixer(toolType, lineType)
        end
    end

    -- ---------------------
    -- Fake tool list
    -- ---------------------

    local toolEntryWidth = 161
    local toolEntryHeight = 17
    local extraDCollapsibleHeight = 3
    local fakeToolsListPanel = vgui.Create("DPanel", CPanel)
        fakeToolsListPanel:Dock(TOP)
        fakeToolsListPanel:SetTall(#TPC.fakeToolsList * (toolEntryHeight + 1) + extraDCollapsibleHeight * 2)
        fakeToolsListPanel:DockMargin(30, 10, 10, 0)
        fakeToolsListPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SimulateToolList(position, toolType, lineType, text, parent)
        local posY = toolEntryHeight * position + extraDCollapsibleHeight

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

        local tool = vgui.Create( "DLabel", parent)
            tool:SetSize(toolEntryWidth/5, toolEntryHeight)
            tool:SetPos((toolEntryWidth/5) * 4, posY)
            tool:SetText(lineType == "even" and "bright" or "dark")
            tool:SetTextColor(lineType == "even" and Color(119, 119, 119, 255) or Color(135, 135, 135, 255))
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
    TPC:InitToolColors()

    local test = vgui.Create("DFrame")
        test:SetPos(800, 400)
        test:SetSize(250, 700)
        test:SetDeleteOnClose(true)
        test:Center()
        test:SetDraggable(true)	
        test:MakePopup()

    local realWhiteBackground = vgui.Create("DColorButton", test)
        realWhiteBackground:Dock(FILL)
        realWhiteBackground:SetColor(color_white)

    self:CreateMenu(realWhiteBackground)
end
--TPC:Test() -- Uncomment and save after the map loads