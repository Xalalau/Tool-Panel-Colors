--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

function TPC:InitGui()
    local toolPanelList = g_SpawnMenu.ToolMenu.ToolPanels[1].List
    local dark = true

    for _, col in ipairs(toolPanelList.pnlCanvas:GetChildren()) do
        for __, pnl in ipairs(col:GetChildren()) do
            if pnl.ClassName == "DCategoryHeader" then
                dark = true
            else
                local toolType = self.defaultTools[pnl.Name] and "GMod" or "Custom"
                local lineType = dark and "dark" or "bright"

                self:SetPaint(pnl, toolType, lineType, true)

                dark = not dark and true or false
            end
        end
    end
end

function TPC:SetPaint(pnl, toolType, lineType, setRightClick, startHighlighted)
    local highlight = startHighlighted or TPC.highlights[pnl.Name]

    pnl._Paint = pnl._Paint or pnl.Paint

    function pnl:Paint(w, h)
        surface.SetDrawColor(TPC.colors[highlight and "Highlight" or toolType][highlight and 1 or lineType])
        surface.DrawRect(0, 0, w, h)

        return self:_Paint(w, h)
    end

    if setRightClick then
        pnl._DoRightClick = pnl._DoRightClick or pnl.DoRightClick

        function pnl:DoRightClick()
            highlight = not highlight and true or false

            TPC:SetHighlight(pnl.Name, highlight)
            TPC:SaveHighlights()

            return self:_DoRightClick()
        end
    end
end

local function AddPresets(CPanel, previewColors)
    local presets = vgui.Create("ControlPresets", CPanel)
        presets:Dock(TOP)
        presets:DockMargin(10, 10, 10, 0)
        presets:SetPreset(TPC.FOLDER.DATA)
        for k, v in pairs(TPC.presets) do
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
               TPC:InitColors()

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

    -- GMod tools / Custom tools
    local sectionHeight = 20
    local previewColorsPanel = vgui.Create("DPanel", CPanel)
        previewColorsPanel:Dock(TOP)
        previewColorsPanel:SetTall(previewSize + sectionHeight * 3)
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
        back1:SetSize(previewSize * 2, sectionHeight * 2 + previewSize)
        back1:SetBackgroundColor(Color(0, 0, 0, 80))

    local section1 = vgui.Create( "DLabel", previewColorsPanel)
        section1:SetSize(previewSize * 2, sectionHeight)
        section1:SetText("  GMod default tools")
        section1:SetTextColor(color_black)

    local subSection1 = vgui.Create( "DLabel", previewColorsPanel)
        subSection1:SetSize(previewSize * 2, sectionHeight)
        subSection1:SetPos(0, sectionHeight)
        subSection1:SetText("     Dark        Bright")
        subSection1:SetTextColor(color_black)

    local back2 = vgui.Create( "DPanel", previewColorsPanel)
        back2:SetSize(previewSize * 2, sectionHeight * 2 + previewSize)
        back2:SetPos(previewSize * 2, 0)
        back2:SetBackgroundColor(Color(0, 0, 0, 145))

    local section2 = vgui.Create( "DLabel", previewColorsPanel)
        section2:SetSize(previewSize * 2, sectionHeight)
        section2:SetPos(section1:GetWide(), 0)
        section2:SetText("      Custom tools")
        section2:SetTextColor(color_white)

    local subSection2 = vgui.Create( "DLabel", previewColorsPanel)
        subSection2:SetSize(previewSize * 2, sectionHeight)
        subSection2:SetPos(section1:GetWide(), sectionHeight)
        subSection2:SetText("     Dark        Bright")
        subSection2:SetTextColor(color_white)

    local function SetColorButton(toolType, lineType, position)
        -- Selection box
        local background = vgui.Create("DPanel", previewColorsPanel)
            background:SetPos(previewSize * position, sectionHeight * 2)
            background:SetSize(previewSize, previewSize)
            background:SetBackgroundColor(Color(0, 0, 0, 255))
            background:Hide()

        -- Applied color
        previewColors[toolType][lineType] = vgui.Create("DColorButton", previewColorsPanel)
            previewColors[toolType][lineType].background = background
            previewColors[toolType][lineType]:SetPos(previewSize * position + 2, sectionHeight * 2 + 2)
            previewColors[toolType][lineType]:SetSize(previewSize - 4, previewSize - 4)
            previewColors[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            previewColors[toolType][lineType].DoClick = function(self)
                SelectColorMixer(previewColors[toolType][lineType], colorControls[toolType][lineType])
            end
            local pnlAux = previewColors[toolType][lineType]
            pnlAux._Paint = pnlAux.Paint
            pnlAux.dark = lineType == "dark" and true or false
            function pnlAux:Paint(w, h)
                self:_Paint(w, h)

                if pnlAux.dark then
                    surface.SetDrawColor(Color(0, 0, 0, 27))
                    surface.DrawRect(0, 0, w, h)
                end
            end
    end

    SetColorButton("GMod", "dark", 0)
    SetColorButton("GMod", "bright", 1)
    SetColorButton("Custom", "dark", 2)
    SetColorButton("Custom", "bright", 3)

    -- Highlight
    local _, back3Pos = previewColors["GMod"]["dark"]:GetPos()
    back3Pos = back3Pos + previewColors["GMod"]["dark"]:GetTall() + 2
    local highlightHeight = sectionHeight - 4
    local back3 = vgui.Create( "DPanel", previewColorsPanel)
        back3:SetSize(previewSize * 4, highlightHeight)
        back3:SetPos(0, back3Pos)
        back3:SetBackgroundColor(Color(0, 0, 0, 180))

    local section3 = vgui.Create( "DLabel", previewColorsPanel)
        section3:SetSize(previewSize, highlightHeight)
        section3:SetPos(6, back3Pos)
        section3:SetText("Highlight")
        section3:SetTextColor(color_white)

    -- Selection box
    local backgroundPreview3 = vgui.Create("DPanel", previewColorsPanel)
        backgroundPreview3:SetPos(previewSize, back3Pos)
        backgroundPreview3:SetSize(previewSize * 3, highlightHeight)
        backgroundPreview3:SetBackgroundColor(Color(0, 0, 0, 255))
        backgroundPreview3:Hide()

    -- Applied color
    previewColors["Highlight"][1] = vgui.Create("DColorButton", previewColorsPanel)
        previewColors["Highlight"][1].background = backgroundPreview3
        previewColors["Highlight"][1]:SetPos(previewSize + 2, back3Pos + 2)
        previewColors["Highlight"][1]:SetSize(previewSize * 3 - 4, highlightHeight - 4)
        previewColors["Highlight"][1]:SetColor(TPC.colors["Highlight"][1])
        previewColors["Highlight"][1].DoClick = function(self)
            SelectColorMixer(previewColors["Highlight"][1], colorControls["Highlight"][1])
        end
        local pnlAux2 = previewColors["Highlight"][1]
        pnlAux2._Paint = pnlAux2.Paint
        function pnlAux2:Paint(w, h)
            self:_Paint(w, h)
            surface.SetDrawColor(Color(0, 0, 0, 27))
            surface.DrawRect(0, 0, w/2, h)
        end

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
        local isHighlight = toolType == "Highlight"
        colorControls[toolType][lineType] = vgui.Create("DColorMixer", colorControlsPanel)
            colorControls[toolType][lineType]:SetSize(colorControlsPanel:GetWide(), colorMixerHeight)
            colorControls[toolType][lineType]:SetPalette(false)
            colorControls[toolType][lineType]:SetAlphaBar(true)
            colorControls[toolType][lineType]:SetWangs(true)
            colorControls[toolType][lineType]:SetConVarR("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_r")
            colorControls[toolType][lineType]:SetConVarG("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_g")
            colorControls[toolType][lineType]:SetConVarB("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_b")
            colorControls[toolType][lineType]:SetConVarA("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_a")
            colorControls[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            colorControls[toolType][lineType]:Hide()
            colorControls[toolType][lineType].ValueChanged = function(self, colorTable)
                -- Note: SetConVar"RGBA" is applying past values instead of current ones, so I'm doing a convar refresh here
                TPC:SetToolColors(toolType, lineType, colorTable)
                previewColors[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            end
    end

    for toolType,typeTable in pairs(colorControls) do
        if istable(typeTable) then
            for lineType,_ in pairs(typeTable) do
                SetColorMixer(toolType, lineType)
            end
        else
            SetColorMixer(toolType, 1)
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

    local function SimulateToolList(position, toolType, lineType, text, parent, highligthed)
        local posY = toolEntryHeight * position + extraDCollapsibleHeight

        local toolEntry = vgui.Create("DPanel", parent)
            toolEntry:SetPos(0, posY)
            toolEntry:SetSize(toolEntryWidth, toolEntryHeight)
            toolEntry:SetBackgroundColor(lineType == "bright" and Color(0, 0, 0, 0) or Color(0, 0, 0, 27))
            toolEntry.OnMousePressed = function(...)
                previewColors[toolType][lineType]:DoClick(...)
            end
            TPC:SetPaint(toolEntry, toolType, lineType, false, highligthed)

        local toolName = vgui.Create( "DLabel", parent)
            toolName:SetSize(toolEntryWidth, toolEntryHeight)
            toolName:SetPos(5, posY)
            toolName:SetText(text)
            toolName:SetTextColor(lineType == "bright" and Color(119, 119, 119, 255) or Color(135, 135, 135, 255))

        local tool = vgui.Create( "DLabel", parent)
            tool:SetSize(toolEntryWidth/5, toolEntryHeight)
            tool:SetPos((toolEntryWidth/5) * 4, posY)
            tool:SetText(lineType == "bright" and "Bright" or "Dark")
            tool:SetTextColor(lineType == "bright" and Color(119, 119, 119, 255) or Color(135, 135, 135, 255))
    end

    local DCollapsible = vgui.Create("DCollapsibleCategory", fakeToolsListPanel)
        DCollapsible:SetLabel("Click on the tools")
        DCollapsible:SetWide(toolEntryWidth)
        DCollapsible:SetExpanded(true)

    for k,v in ipairs(TPC.fakeToolsList) do
        local lineType = k % 2 == 0 and "bright" or "dark"

        SimulateToolList(k, v[1], lineType, v[2], fakeToolsListPanel, v[3] and true)
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

hook.Add("PostReloadToolsMenu", "PaintMenus", function()
    TPC:InitGui()
    TPC:InitGui() -- HACK: this will force the menu to show the correct colors
end)

function TPC:Test()
    TPC:InitColors()

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