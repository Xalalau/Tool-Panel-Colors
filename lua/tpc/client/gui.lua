--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

net.Receive("TPC_RefreshPanelColorsOnCL", function()
    TPC:RefreshPanelColors("_sv")
end)

local CLPanelsToHideOnMultiplayer = {
    ["_cl"] = {},
    ["_sv"] = {}
}

local adminButtons = {}

function TPC:InitGui()
    local toolPanelList = g_SpawnMenu.ToolMenu.ToolPanels[1].List
    local dark = true

    for _, col in ipairs(toolPanelList.pnlCanvas:GetChildren()) do
        for __, pnl in ipairs(col:GetChildren()) do
            if pnl.ClassName == "DCategoryHeader" then
                dark = true
            else
                local toolType = self.defaultTools[pnl.Name] and "GMod" or "Addon"
                local lineType = dark and "dark" or "bright"

                self:SetPaint(pnl, toolType, lineType, nil, true)

                dark = not dark and true or false
            end
        end
    end
end

function TPC:SetPaint(pnl, toolType, lineType, colorTable, setRightClick, startHighlighted)
    colorTable = colorTable
    pnl._Paint = pnl._Paint or pnl.Paint

    function pnl:Paint(w, h)
        local color = colorTable or TPC.colors[TPC:GetActiveColors()]
        color = color[TPC.highlights[TPC:GetActiveColors()][pnl.Name] and "Highlight" or toolType][lineType]

        if color == true then return self:_Paint(w, h) end

        surface.SetDrawColor(color)
        surface.DrawRect(0, 0, w, h)

        return self:_Paint(w, h)
    end

    if setRightClick then
        pnl._DoRightClick = pnl._DoRightClick or pnl.DoRightClick

        function pnl:DoRightClick()
            if TPC:GetActiveColors() == "_sv" and not LocalPlayer():IsAdmin() then return end

            TPC.highlights[TPC:GetActiveColors()][pnl.Name] = not TPC.highlights[TPC:GetActiveColors()][pnl.Name] and true or false

            TPC:SetHighlight(TPC:GetActiveColors(), pnl.Name, TPC.highlights[TPC:GetActiveColors()][pnl.Name])
            TPC:SaveHighlights(TPC:GetActiveColors())
            TPC:SetFontColor(TPC:GetActiveColors(), TPC.highlights[TPC:GetActiveColors()][pnl.Name] and "Highlight" or toolType)

            SetAdmButtonsEnabled(true)

            return self:_DoRightClick()
        end
    end
end

local previewColorsAux -- Ugly solution, I need to change this panel here
function TPC:RefreshPanelColors(scope)
    timer.Simple(0.1, function() -- Wait for RunConsoleCommand before init the colors
        TPC:InitColors(scope)

        if previewColorsAux and previewColorsAux[scope] then
            for toolType,tpnl in pairs(previewColorsAux[scope]) do
                for lineType,lpnl in pairs(tpnl) do
                    if lpnl and not isbool(lpnl) and IsValid(lpnl) then
                        lpnl:SetColor(TPC.colors[scope][toolType][lineType])
                    end
                    TPC:SetFakeToolFontColor(scope, lineType)
                end
            end
        end
    end)
end

function SetPanelsVisibility(val)
    for _,pnlTable in pairs(CLPanelsToHideOnMultiplayer) do
        for _,pnl in pairs(pnlTable) do
            if not val then
                pnl:Show()
            else
                pnl:Hide()
            end
        end

        val = not val
    end
end

function AddScopeCheckbox(CPanel)
    local checkboxPanel = vgui.Create("DPanel", CPanel)
        checkboxPanel:Dock(TOP)
        checkboxPanel:SetBackgroundColor(Color(0, 0, 0, 0))
        checkboxPanel:SizeToContents()

    local checkbox = vgui.Create("DCheckBoxLabel", checkboxPanel)
        checkbox:SetPos(10, 9)
        checkbox:SetText("Use server color scheme")
        checkbox:SetValue(TPC:AreSVColorsEnabled())
        checkbox:SetTextColor(color_black)
        function checkbox:OnChange(val)
            RunConsoleCommand("tpc_use_sv_colors", val and "1" or "0")
            SetPanelsVisibility(val)

            timer.Simple(0.1, function()
                local scope = TPC.GetActiveColors()

                TPC:InitHighlights(scope)
                TPC:InitColors(scope)                    
            end)
        end
end

function SetAdmButtonsEnabled(val)
    if adminButtons[1] then
        if val and not adminButtons[1]:IsEnabled() then
            adminButtons[1]:SetEnabled(true)
            adminButtons[2]:SetEnabled(true)
        elseif not val then
            adminButtons[1]:SetEnabled(false)
            adminButtons[2]:SetEnabled(false)
        end
    end
end

function AddAdmButtons(CPanel, previewColors, scope)
    local adminButtonsPanel = vgui.Create("DPanel", CPanel)
        table.insert(CLPanelsToHideOnMultiplayer[scope], adminButtonsPanel)
        adminButtonsPanel:Dock(TOP)
        adminButtonsPanel:DockMargin(10, 10, 10, 0)
        adminButtonsPanel:SetBackgroundColor(Color(0, 0, 0, 0))
        adminButtonsPanel:SizeToContents()

    local applyButton = vgui.Create("DButton", adminButtonsPanel)
        adminButtons[1] = applyButton
        applyButton:SetText("Apply to server")
        applyButton:SetSize(140, 24)
        applyButton:SetEnabled(false)
        applyButton.DoClick = function()
            net.Start("TPC_SetNewSchemeOnSV")
                net.WriteTable(TPC:GetCurrentColorCvars("_sv"))
                net.WriteTable(TPC.highlights["_sv"])
            net.SendToServer()

            timer.Simple(0.1, function()
                SetAdmButtonsEnabled(false)
            end)
        end

    local clearButton = vgui.Create("DButton", adminButtonsPanel)
        adminButtons[2] = clearButton
        clearButton:SetText("Clear")
        clearButton:SetPos(150, 0)
        clearButton:SetEnabled(false)
        clearButton:SetSize(50, 24)
        clearButton.DoClick = function()
            for k,v in pairs(TPC.serverPreset) do
                RunConsoleCommand(k, v)
            end

            TPC:RefreshPanelColors("_sv")

            timer.Simple(0.1, function()
                SetAdmButtonsEnabled(false)
            end)
        end
end

local function AddPresets(CPanel, previewColors, scope)
    local presets = vgui.Create("ControlPresets", CPanel)
        table.insert(CLPanelsToHideOnMultiplayer[scope], presets)
        presets:Dock(TOP)
        presets:DockMargin(10, 10, 10, 0)
        presets:SetPreset(TPC.FOLDER.DATA)
        for k, v in pairs(TPC.presets) do
            presets:AddOption(k, v)

            for cvar,_ in pairs(v) do
                cvar = cvar:sub(1, -4) .. scope

                presets:AddConVar(cvar)
            end
        end
        presets.OnSelect = function(self, index, text, data)
            for k,v in pairs(data) do
                k = k:sub(1, -4) .. scope
                RunConsoleCommand(k, v)
            end

            TPC:RefreshPanelColors(scope)
        end
end

local function AddColorSelector(CPanel, colorControls, previewColors, scope)
    local previewSize = 20
    local colorControlsPanel

    -- ---------------------
    -- Menu selectors
    -- ---------------------

    -- GMod / Addon tools
    local sectionHeaderHeight = 20
    local previewHeight = 28

    local previewColorsPanel = vgui.Create("DPanel", CPanel)
        table.insert(CLPanelsToHideOnMultiplayer[scope], previewColorsPanel)
        previewColorsPanel:Dock(TOP)
        previewColorsPanel:SetTall(previewHeight * 3 + sectionHeaderHeight)
        previewColorsPanel:DockMargin(10, 10, 10, 0)
        previewColorsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SelectColorMixer(pressedButton, newMixer)
        local oldMixer
        local mixerHeight = 92

        -- Get last mixer
        for toolType,tpnl in pairs(colorControls[scope]) do
            for lineType,lpnl in pairs(tpnl) do
                if lpnl:GetTall() > 0 then
                    oldMixer = lpnl -- Old mixer
                    previewColors[scope][toolType][lineType].background:Hide() -- Last pressed button background
                    break
                end
            end
        end

        -- Show back panel if any mixer is selected
        if not oldMixer and newMixer:GetParent():GetTall() == 0 then
            newMixer:GetParent():SizeTo(newMixer:GetWide(), mixerHeight, 0.2, 0, -1)
        end

        -- Hide old mixer and show new mixer
        if oldMixer then
            oldMixer:SizeTo(oldMixer:GetWide(), 0, 0.2, 0, -1)
        end
        if not oldMixer or oldMixer ~= newMixer then
            newMixer:SizeTo(newMixer:GetWide(), mixerHeight, 0.2, 0, -1)
            pressedButton.background:Show()
        end

        -- Hide back panel if no mixer is selected
        if oldMixer == newMixer then
            newMixer:GetParent():SizeTo(newMixer:GetWide(), 0, 0.2, 0, -1)
        end
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
        previewColors[scope][toolType][lineType] = vgui.Create("DColorButton", previewColorsPanel)
            previewColors[scope][toolType][lineType].background = background
            previewColors[scope][toolType][lineType]:SetPos(positionX + 4, sectionHeaderHeight + positionY * previewHeight + 2)
            previewColors[scope][toolType][lineType]:SetSize(columnSize - 8, previewHeight - 4)
            previewColors[scope][toolType][lineType]:SetColor(TPC.colors[scope][toolType][lineType])
            previewColors[scope][toolType][lineType].DoClick = function(self)
                SelectColorMixer(previewColors[scope][toolType][lineType], colorControls[scope][toolType][lineType])
            end
            local pnlAux = previewColors[scope][toolType][lineType]
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
        ["Addon"] = 12,
        ["Highlight"] = 7
    }
    for _,toolType in ipairs({ "GMod", "Addon", "Highlight" }) do
        for _,lineType in ipairs({ "dark", "bright", "font" }) do
            SetColorButton(toolType, lineType, position, headerMarginLeft[toolType])
            position = position + 1
        end
    end

    -- ---------------------
    -- Color mixer
    -- ---------------------
    colorControlsPanel = vgui.Create("DPanel", CPanel)
        table.insert(CLPanelsToHideOnMultiplayer[scope], colorControlsPanel)
        colorControlsPanel:Dock(TOP)
        colorControlsPanel:SetTall(0)
        colorControlsPanel:DockMargin(10, 10, 10, 0)
        colorControlsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SetColorMixer(toolType, lineType)
        colorControls[scope][toolType][lineType] = vgui.Create("DColorMixer", colorControlsPanel)
            colorControls[scope][toolType][lineType]:SetPalette(false)
            colorControls[scope][toolType][lineType]:SetAlphaBar(true)
            colorControls[scope][toolType][lineType]:SetWangs(true)
            colorControls[scope][toolType][lineType]:SetConVarR("tpc_" .. toolType .. "_" .. lineType .. "_r" .. scope)
            colorControls[scope][toolType][lineType]:SetConVarG("tpc_" .. toolType .. "_" .. lineType .. "_g" .. scope)
            colorControls[scope][toolType][lineType]:SetConVarB("tpc_" .. toolType .. "_" .. lineType .. "_b" .. scope)
            colorControls[scope][toolType][lineType]:SetConVarA("tpc_" .. toolType .. "_" .. lineType .. "_a" .. scope)
            colorControls[scope][toolType][lineType]:SetColor(TPC.colors[scope][toolType][lineType])
            colorControls[scope][toolType][lineType]:SizeToChildren(false, true)
            colorControls[scope][toolType][lineType]:SetSize(200, 0)
            colorControls[scope][toolType][lineType].ValueChanged = function(self, colorTable)
                -- Note: SetConVar"RGBA" is applying past values instead of current ones, so I'm doing a convar refresh here
                TPC:SetToolColors(scope, toolType, lineType, colorTable)
                TPC:SetFakeToolFontColor(scope, lineType)
                SetAdmButtonsEnabled(true)
                previewColors[scope][toolType][lineType]:SetColor(TPC.colors[scope][toolType][lineType])
            end
    end

    for toolType,typeTable in pairs(colorControls[scope]) do
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
        table.insert(CLPanelsToHideOnMultiplayer[scope], fakeToolsPanelList)
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
                previewColors[scope][toolType][lineType]:DoClick(...)
            end
            TPC:SetPaint(toolEntry, toolType, lineType, TPC.colors[scope], false, highligthed)

        local toolName = vgui.Create( "DLabel", parent)
            toolName:SetSize(toolEntryWidth, toolEntryHeight)
            toolName:SetPos(5, posY)
            toolName:SetText(text)
            toolName:SetTextColor(textColor)
            table.insert(TPC.fakeToolPanelList[scope][toolType][lineType], toolName)

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

function TPC:SetFakeToolFontColor(scope, lineTypeIn)
    if lineTypeIn == "font" then
        for toolType,typeTable in pairs(self.fakeToolPanelList[scope]) do
            for lineType,panelTable in pairs(typeTable) do
                if lineType ~= "font" then
                    for _,panel in pairs(panelTable) do
                        if panel and panel:IsValid() then
                            panel:SetTextColor(TPC.colors[scope][toolType]["font"])
                        end
                    end
                end
            end
        end
    end
end

function TPC:CreateMenu(CPanel, buildServerCPanel)
    local scope = buildServerCPanel and "_sv" or "_cl"

    if CPanel.Help and scope == "_cl" then
        CPanel:Help("Customize your tool panel colors!")
    end

    local colorControls = table.Copy(TPC.baseReference)
    local previewColors = table.Copy(TPC.baseReference)
    previewColorsAux = previewColors

    if not game.SinglePlayer() and scope == "_cl" then
        AddScopeCheckbox(CPanel)
    end

    AddPresets(CPanel, previewColors, scope)

    if not game.SinglePlayer() and scope == "_sv" then
        AddAdmButtons(CPanel, previewColors, scope)
    end

    AddColorSelector(CPanel, colorControls, previewColors, scope)

    self:SetFakeToolFontColor(scope, "font")

    if not game.SinglePlayer() then
        SetPanelsVisibility(self:AreSVColorsEnabled())
    end
end

hook.Add("PopulateToolMenu", "CreateCMenu", function()
    spawnmenu.AddToolMenuOption("Utilities", "Customization", "TPC", "Tool Panel Colors", "", "", function(CPanel)
        TPC:CreateMenu(CPanel)

        if not game.SinglePlayer() and LocalPlayer():IsAdmin() then
            TPC:CreateMenu(CPanel, true)
        end
    end)
end)

hook.Add("PostReloadToolsMenu", "PaintMenus", function()
    TPC:InitGui()
    TPC:InitGui() -- HACK: this will force the menu to show the correct colors
end)

function TPC:Test()
    TPC:InitColors("_cl")
    TPC:InitColors("_sv")

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

    self:CreateMenu(realWhiteBackground, true)
end
--TPC:Test() -- Uncomment and save after the map loads