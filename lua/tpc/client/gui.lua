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
        surface.SetDrawColor(TPC.colors[highlight and "Highlight" or toolType][lineType])
        surface.DrawRect(0, 0, w, h)

        return self:_Paint(w, h)
    end

    if setRightClick then
        pnl._DoRightClick = pnl._DoRightClick or pnl.DoRightClick

        function pnl:DoRightClick()
            highlight = not highlight and true or false

            TPC:SetHighlight(pnl.Name, highlight)
            TPC:SaveHighlights()
            TPC:SetFontColor(highlight and "Highlight" or toolType)

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
                        TPC:SetFakeToolFontColor(toolType, lineType)
                    end
                end
            end)
        end
end

local function AddColorSelector(CPanel, colorControls, previewColors)
    local previewSize = 20
    local colorControlsPanel

    -- ---------------------
    -- Menu selectors
    -- ---------------------

    -- GMod tools / Custom tools
    local sectionHeaderHeight = 20
    local previewHeight = 28

    local previewColorsPanel = vgui.Create("DPanel", CPanel)
        previewColorsPanel:Dock(TOP)
        previewColorsPanel:SetTall(previewHeight * 3 + sectionHeaderHeight)
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

    local sectionTableWidth = 162
    local sectionHeaderLeft = sectionTableWidth + 10

    local column1 = vgui.Create( "DLabel", previewColorsPanel)
        column1:SetSize(previewSize * 2, previewSize)
        column1:SetPos(sectionHeaderLeft, sectionHeaderHeight + 3)
        column1:SetText("Dark")
        column1:SetTextColor(color_black)

    local column2 = vgui.Create( "DLabel", previewColorsPanel)
        column2:SetSize(previewSize * 2, previewSize)
        column2:SetPos(sectionHeaderLeft, sectionHeaderHeight * 2 + 12)
        column2:SetText("Bright")
        column2:SetTextColor(color_black)

    local column3 = vgui.Create( "DLabel", previewColorsPanel)
        column3:SetSize(previewSize * 2, previewSize)
        column3:SetPos(sectionHeaderLeft, sectionHeaderHeight * 3 + 19)
        column3:SetText("Font")
        column3:SetTextColor(color_black)

    local function SetColorButton(toolType, lineType, positionY, headerMarginLeft)
        local maxMixersPerSection = 3

        local columnParts = 3
        local columnSize = sectionTableWidth / 3

        local positionX = math.floor(positionY / maxMixersPerSection) * columnParts
        local sectionXIndex = positionX > 1 and (positionX / columnParts + 1) or 1
        positionX = (sectionXIndex - 1) * columnSize
        positionY = positionY % maxMixersPerSection

        -- legends
        if positionY == 0 then
            local backSectionHeader = vgui.Create( "DPanel", previewColorsPanel)
                backSectionHeader:SetSize(columnSize, sectionHeaderHeight - 1)
                backSectionHeader:SetPos(positionX, 0)
                backSectionHeader:SetBackgroundColor(Color(124, 190, 255, 130 * (sectionXIndex % 2 == 0 and 1.6 or 1)))

            local backSection = vgui.Create( "DPanel", previewColorsPanel)
                backSection:SetSize(columnSize, sectionHeaderHeight + previewHeight * 3)
                backSection:SetPos(positionX, 0)
                backSection:SetBackgroundColor(Color(0, 0, 0, 25 * (sectionXIndex % 2 == 0 and 2.4 or 1.2)))

            local section = vgui.Create( "DLabel", previewColorsPanel)
                section:SetSize(columnSize, sectionHeaderHeight)
                section:SetPos(positionX + headerMarginLeft, 0)
                section:SetText(toolType)
                section:SetTextColor(sectionXIndex % 2 == 1 and Color(0, 0, 0, 200) or color_white)
        end

        -- Selection box
        local background = vgui.Create("DPanel", previewColorsPanel)
            background:SetPos(positionX + 2, sectionHeaderHeight + positionY * previewHeight)
            background:SetSize(columnSize - 4, previewHeight)
            background:SetBackgroundColor(color_black)
            background:Hide()

        -- Applied color
        previewColors[toolType][lineType] = vgui.Create("DColorButton", previewColorsPanel)
            previewColors[toolType][lineType].background = background
            previewColors[toolType][lineType]:SetPos(positionX + 4, sectionHeaderHeight + positionY * previewHeight + 2)
            previewColors[toolType][lineType]:SetSize(columnSize - 8, previewHeight - 4)
            previewColors[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            previewColors[toolType][lineType].DoClick = function(self)
                SelectColorMixer(previewColors[toolType][lineType], colorControls[toolType][lineType])
            end
            local pnlAux = previewColors[toolType][lineType]
            pnlAux._Paint = pnlAux.Paint
            pnlAux.dark = lineType == "dark" and true
            function pnlAux:Paint(w, h)
                self:_Paint(w, h)

                if self.dark then
                    surface.SetDrawColor(Color(0, 0, 0, 27))
                    surface.DrawRect(0, 0, w, h)
                end
            end
    end

    local position = 0
    local headerMarginLeft = {
        ["GMod"] = 14,
        ["Custom"] = 12,
        ["Highlight"] = 7
    }
    for _,toolType in ipairs({ "GMod", "Custom", "Highlight" }) do
        for _,lineType in ipairs({ "dark", "bright", "font" }) do
            SetColorButton(toolType, lineType, position, headerMarginLeft[toolType])
            position = position + 1
        end
    end

    -- ---------------------
    -- Color mixer
    -- ---------------------
    local colorMixerHeight = 92
    colorControlsPanel = vgui.Create("DPanel", CPanel)
        colorControlsPanel:Dock(TOP)
        colorControlsPanel:SetTall(colorMixerHeight)
        colorControlsPanel:DockMargin(10, 10, 10, 0)
        colorControlsPanel:SetBackgroundColor(Color(0, 0, 0, 0))
        colorControlsPanel:Hide()

    local function SetColorMixer(toolType, lineType)
        colorControls[toolType][lineType] = vgui.Create("DColorMixer", colorControlsPanel)
            colorControls[toolType][lineType]:SetSize(200, colorMixerHeight)
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
                TPC:SetToolColors(toolType, lineType, colorTable)
                TPC:SetFakeToolFontColor(toolType, lineType)
                previewColors[toolType][lineType]:SetColor(TPC.colors[toolType][lineType])
            end
    end

    for toolType,typeTable in pairs(colorControls) do
        for lineType,_ in pairs(typeTable) do
            SetColorMixer(toolType, lineType)
        end
    end

    -- ---------------------
    -- Fake tool list
    -- ---------------------

    local toolEntryWidth = 162
    local toolEntryHeight = 17
    local extraDCollapsibleHeight = 3
    local fakeToolsPanelList = vgui.Create("DPanel", CPanel)
        fakeToolsPanelList:Dock(TOP)
        fakeToolsPanelList:SetTall(#TPC.fakeToolList * (toolEntryHeight + 1) + extraDCollapsibleHeight * 2)
        fakeToolsPanelList:DockMargin(10, 10, 10, 0)
        fakeToolsPanelList:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SimulateToolList(position, toolType, lineType, text, parent, highligthed)
        local posY = toolEntryHeight * position + extraDCollapsibleHeight
        local textColor = lineType == "bright" and Color(119, 119, 119, 255) or Color(135, 135, 135, 255)
        toolType = highligthed and "Highlight" or toolType

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
            toolName:SetTextColor(textColor)
            table.insert(TPC.fakeToolPanelList[toolType][lineType], toolName)

        if highligthed then
            local tool = vgui.Create( "DLabel", parent)
                tool:SetSize(10, 10)
                tool:SetPos((toolEntryWidth/5) * 5 + 3, posY + 5)
                tool:SetText("*")
                tool:SetTextColor(textColor)
        end

        local tool = vgui.Create( "DLabel", parent)
            tool:SetSize(toolEntryWidth/5, toolEntryHeight)
            tool:SetPos((toolEntryWidth/5) * 4 + 44, posY)
            tool:SetText(lineType == "bright" and "Bright" or "Dark")
            tool:SetTextColor(textColor)
    end

    local DCollapsible = vgui.Create("DCollapsibleCategory", fakeToolsPanelList)
        DCollapsible:SetLabel("Click on the tools")
        DCollapsible:SetWide(toolEntryWidth)
        DCollapsible:SetExpanded(true)

    for k,v in ipairs(TPC.fakeToolList) do
        local lineType = k % 2 == 0 and "bright" or "dark"

        SimulateToolList(k, v[1], lineType, v[2], fakeToolsPanelList, v[3] and true)
    end
end

function TPC:SetFakeToolFontColor(toolTypeIn, lineTypeIn)
    if lineTypeIn == "font" then
        for toolType,typeTable in pairs(self.fakeToolPanelList) do
            for lineType,panelTable in pairs(typeTable) do
                if lineType ~= "font" then
                    for _,panel in pairs(panelTable) do
                        panel:SetTextColor(TPC.colors[toolType]["font"])
                    end
                end
            end
        end
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