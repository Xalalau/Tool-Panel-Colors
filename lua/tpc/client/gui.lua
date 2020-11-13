--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

function TPC:CreateMenu(CPanel)
    if CPanel.Help then -- Disabled if testing
        CPanel:Help("Customize your tool panel colors!")
    end

    local colorControls = {
        GMod = { 
            even = true,
            odd = true
        },
        Others = {
            even = true,
            odd = true
        }
    }

    local previewColors = table.Copy(colorControls)

    local presets = vgui.Create("ControlPresets", CPanel)
        presets:Dock(TOP)
        presets:DockMargin(10, 10, 10, 0)
        presets:SetPreset("tpc")
        for k, v in pairs(self.options) do
            presets:AddOption(k, v)
            presets:AddConVar(k)
        end
        presets.OnSelect = function(self, index, text, data)
            for k,v in pairs(data) do
                RunConsoleCommand(k, v)
            end

            for type,tpnl in pairs(previewColors) do
                for line,lpnl in pairs(tpnl) do
                    timer.Simple(0.1, function() -- Paint the previews in a later frame
                        lpnl:SetColor(TPC:GetNewToolColors(type)[line])
                    end)
                end
            end

            timer.Simple(0.1, function() -- Paint the tool panel in a later frame
                TPC:PaintMenus()
            end)
        end

    local previewSize = 50
    local previewColorsPanel = vgui.Create("DPanel", CPanel)
        previewColorsPanel:Dock(TOP)
        previewColorsPanel:SetSize(previewSize * 4, previewSize)
        previewColorsPanel:DockMargin(10, 10, 10, 0)
        previewColorsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SelectColorMixer(newPnl)
        for _,tpnl in pairs(colorControls) do
            for _,lpnl in pairs(tpnl) do
                if lpnl:IsVisible() then
                    lpnl:Hide()
                    break
                end
            end
        end

        newPnl:Show()
    end

    local function SetColorButton(type, line, position)
        previewColors[type][line] = vgui.Create("DColorButton", previewColorsPanel)
            previewColors[type][line]:SetPos(previewSize * position, 0)
            previewColors[type][line]:SetSize(previewSize, previewSize)
            previewColors[type][line]:Paint(previewSize, previewSize)
            previewColors[type][line]:SetText(" " .. type .. "\n " .. line)
            previewColors[type][line]:SetColor(self:GetNewToolColors(type)[line])
            previewColors[type][line].DoClick = function(self)
                SelectColorMixer(colorControls[type][line])
            end
    end

    SetColorButton("GMod", "even", 0)
    SetColorButton("GMod", "odd", 1)
    SetColorButton("Others", "even", 2)
    SetColorButton("Others", "odd", 3)

    local colorControlsPanel = vgui.Create("DPanel", CPanel)
        colorControlsPanel:Dock(TOP)
        colorControlsPanel:SetSize(previewSize * 4, 300)
        colorControlsPanel:DockMargin(10, 10, 10, 0)
        colorControlsPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    local function SetColorMixer(type, line)
        colorControls[type][line] = vgui.Create("DColorMixer", colorControlsPanel)
            colorControls[type][line]:SetSize(colorControlsPanel:GetWide(), 200)
            colorControls[type][line]:SetPalette(true)
            colorControls[type][line]:SetAlphaBar(true)
            colorControls[type][line]:SetWangs(true)
            colorControls[type][line]:SetConVarR("tpc_" .. type .. "_" .. line .. "_r")
            colorControls[type][line]:SetConVarG("tpc_" .. type .. "_" .. line .. "_g")
            colorControls[type][line]:SetConVarB("tpc_" .. type .. "_" .. line .. "_b")
            colorControls[type][line]:SetConVarA("tpc_" .. type .. "_" .. line .. "_a")
            colorControls[type][line]:SetColor(self:GetNewToolColors(type)[line])
            colorControls[type][line]:Hide()
            colorControls[type][line].ValueChanged = function()
                previewColors[type][line]:SetColor(self:GetNewToolColors(type)[line])
                self:PaintMenus()
            end
    end

    for type,tpnl in pairs(colorControls) do
        for line,lpnl in pairs(tpnl) do
            SetColorMixer(type, line)
        end
    end

    colorControls.GMod.even:Show()

    if CPanel.Help then -- Disabled if testing
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
    local test = vgui.Create("DFrame")
        test:SetPos(800, 400)
        test:SetSize(250, 500)
        test:SetDeleteOnClose(true)
        test:Center()
        test:SetDraggable(true)	
        test:MakePopup()

    self:CreateMenu(test)
end
--TPC:Test() -- Uncomment and save after the map loading