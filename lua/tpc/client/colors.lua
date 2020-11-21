--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

local svColors = CreateClientConVar("tpc_use_sv_colors", "1")
CreateClientConVar("tpc_gmod_bright_r_sv", "")
CreateClientConVar("tpc_gmod_bright_r_cl", "")
CreateClientConVar("tpc_gmod_bright_g_sv", "")
CreateClientConVar("tpc_gmod_bright_g_cl", "")
CreateClientConVar("tpc_gmod_bright_b_sv", "")
CreateClientConVar("tpc_gmod_bright_b_cl", "")
CreateClientConVar("tpc_gmod_bright_a_sv", "")
CreateClientConVar("tpc_gmod_bright_a_cl", "")
CreateClientConVar("tpc_gmod_dark_r_sv", "")
CreateClientConVar("tpc_gmod_dark_r_cl", "")
CreateClientConVar("tpc_gmod_dark_g_sv", "")
CreateClientConVar("tpc_gmod_dark_g_cl", "")
CreateClientConVar("tpc_gmod_dark_b_sv", "")
CreateClientConVar("tpc_gmod_dark_b_cl", "")
CreateClientConVar("tpc_gmod_dark_a_sv", "")
CreateClientConVar("tpc_gmod_dark_a_cl", "")
CreateClientConVar("tpc_gmod_font_r_sv", "")
CreateClientConVar("tpc_gmod_font_r_cl", "")
CreateClientConVar("tpc_gmod_font_g_sv", "")
CreateClientConVar("tpc_gmod_font_g_cl", "")
CreateClientConVar("tpc_gmod_font_b_sv", "")
CreateClientConVar("tpc_gmod_font_b_cl", "")
CreateClientConVar("tpc_gmod_font_a_sv", "")
CreateClientConVar("tpc_gmod_font_a_cl", "")
CreateClientConVar("tpc_addon_bright_r_sv", "")
CreateClientConVar("tpc_addon_bright_r_cl", "")
CreateClientConVar("tpc_addon_bright_g_sv", "")
CreateClientConVar("tpc_addon_bright_g_cl", "")
CreateClientConVar("tpc_addon_bright_b_sv", "")
CreateClientConVar("tpc_addon_bright_b_cl", "")
CreateClientConVar("tpc_addon_bright_a_sv", "")
CreateClientConVar("tpc_addon_bright_a_cl", "")
CreateClientConVar("tpc_addon_dark_r_sv", "")
CreateClientConVar("tpc_addon_dark_r_cl", "")
CreateClientConVar("tpc_addon_dark_g_sv", "")
CreateClientConVar("tpc_addon_dark_g_cl", "")
CreateClientConVar("tpc_addon_dark_b_sv", "")
CreateClientConVar("tpc_addon_dark_b_cl", "")
CreateClientConVar("tpc_addon_dark_a_sv", "")
CreateClientConVar("tpc_addon_dark_a_cl", "")
CreateClientConVar("tpc_addon_font_r_sv", "")
CreateClientConVar("tpc_addon_font_r_cl", "")
CreateClientConVar("tpc_addon_font_g_sv", "")
CreateClientConVar("tpc_addon_font_g_cl", "")
CreateClientConVar("tpc_addon_font_b_sv", "")
CreateClientConVar("tpc_addon_font_b_cl", "")
CreateClientConVar("tpc_addon_font_a_sv", "")
CreateClientConVar("tpc_addon_font_a_cl", "")
CreateClientConVar("tpc_highlight_dark_r_sv", "")
CreateClientConVar("tpc_highlight_dark_r_cl", "")
CreateClientConVar("tpc_highlight_dark_g_sv", "")
CreateClientConVar("tpc_highlight_dark_g_cl", "")
CreateClientConVar("tpc_highlight_dark_b_sv", "")
CreateClientConVar("tpc_highlight_dark_b_cl", "")
CreateClientConVar("tpc_highlight_dark_a_sv", "")
CreateClientConVar("tpc_highlight_dark_a_cl", "")
CreateClientConVar("tpc_highlight_bright_r_sv", "")
CreateClientConVar("tpc_highlight_bright_r_cl", "")
CreateClientConVar("tpc_highlight_bright_g_sv", "")
CreateClientConVar("tpc_highlight_bright_g_cl", "")
CreateClientConVar("tpc_highlight_bright_b_sv", "")
CreateClientConVar("tpc_highlight_bright_b_cl", "")
CreateClientConVar("tpc_highlight_bright_a_sv", "")
CreateClientConVar("tpc_highlight_bright_a_cl", "")
CreateClientConVar("tpc_highlight_font_r_sv", "")
CreateClientConVar("tpc_highlight_font_r_cl", "")
CreateClientConVar("tpc_highlight_font_g_sv", "")
CreateClientConVar("tpc_highlight_font_g_cl", "")
CreateClientConVar("tpc_highlight_font_b_sv", "")
CreateClientConVar("tpc_highlight_font_b_cl", "")
CreateClientConVar("tpc_highlight_font_a_sv", "")
CreateClientConVar("tpc_highlight_font_a_cl", "")

function TPC:AreSVColorsEnabled()
    return not game.SinglePlayer() and svColors:GetBool()
end

function TPC:GetActiveColors()
    return not game.SinglePlayer() and TPC:AreSVColorsEnabled() and "_sv" or "_cl"
end

function TPC:TableToColor(colorTable)
    return Color(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

function TPC:SetToolColors(scope, toolType, lineType, colorTable)
    for k,v in pairs(colorTable) do
        RunConsoleCommand("tpc_" .. toolType .. "_" .. lineType .. "_" .. k .. scope, v)
    end

    self.colors[scope][toolType][lineType] = self:TableToColor(colorTable)

    if lineType == "font" then
        self:SetFontColor(scope, toolType)
    end
end

function TPC:SetFontColor(scope, toolTypeIn)
    if scope ~= self.GetActiveColors() then return end

    local toolPanelList = g_SpawnMenu.ToolMenu.ToolPanels[1].List

    for _, col in ipairs(toolPanelList.pnlCanvas:GetChildren()) do
        for __, pnl in ipairs(col:GetChildren()) do
            if pnl.ClassName ~= "DCategoryHeader" then
                local toolType = self.highlights[scope] and self.highlights[scope][pnl.Name] and "Highlight" or self.defaultTools[pnl.Name] and "GMod" or "Addon"

                if toolTypeIn == toolType then
                    pnl:SetTextColor(self.colors[scope][toolType].font)
                end
            end
        end
    end
end

-- Apply a preset if the addon is being initialized for the first time
function TPC:InitColorsFirstRun(scope)
    local preset = TPC.presets[scope == "_sv" and #self.serverPreset > 0 and self.serverPreset or self.defaultPresets[scope]]

    for k,v in pairs(preset) do
        k = k:sub(1, -4) .. scope
        RunConsoleCommand(k, v)
    end
end

-- Load the colors from the cvars to self.colors
function TPC:InitColors(scope)
    local function GetCurrentColors(scope, toolType, lineType)
        return {
            r = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_r" .. scope):GetInt(),
            g = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_g" .. scope):GetInt(),
            b = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_b" .. scope):GetInt(),
            a = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_a" .. scope):GetInt()
        }
    end

    for toolType,lineTypeTable in pairs(self.colors[scope]) do
        for lineType,_ in pairs(lineTypeTable) do
            self.colors[scope][toolType][lineType] = self:TableToColor(GetCurrentColors(scope, toolType, lineType))
        end

        self:SetFontColor(scope, toolType)
    end
end

function TPC:GetCurrentColorCvars(scope)
    return {
        ["tpc_gmod_dark_r" .. scope] = GetConVar("tpc_gmod_dark_r" .. scope):GetInt(),
        ["tpc_gmod_dark_g" .. scope] = GetConVar("tpc_gmod_dark_g" .. scope):GetInt(),
        ["tpc_gmod_dark_b" .. scope] = GetConVar("tpc_gmod_dark_b" .. scope):GetInt(),
        ["tpc_gmod_dark_a" .. scope] = GetConVar("tpc_gmod_dark_a" .. scope):GetInt(),
        ["tpc_gmod_bright_r" .. scope] = GetConVar("tpc_gmod_bright_r" .. scope):GetInt(),
        ["tpc_gmod_bright_g" .. scope] = GetConVar("tpc_gmod_bright_g" .. scope):GetInt(),
        ["tpc_gmod_bright_b" .. scope] = GetConVar("tpc_gmod_bright_b" .. scope):GetInt(),
        ["tpc_gmod_bright_a" .. scope] = GetConVar("tpc_gmod_bright_a" .. scope):GetInt(),
        ["tpc_gmod_font_r" .. scope] = GetConVar("tpc_gmod_font_r" .. scope):GetInt(),
        ["tpc_gmod_font_g" .. scope] = GetConVar("tpc_gmod_font_g" .. scope):GetInt(),
        ["tpc_gmod_font_b" .. scope] = GetConVar("tpc_gmod_font_b" .. scope):GetInt(),
        ["tpc_gmod_font_a" .. scope] = GetConVar("tpc_gmod_font_a" .. scope):GetInt(),
        ["tpc_addon_dark_r" .. scope] = GetConVar("tpc_addon_dark_r" .. scope):GetInt(),
        ["tpc_addon_dark_g" .. scope] = GetConVar("tpc_addon_dark_g" .. scope):GetInt(),
        ["tpc_addon_dark_b" .. scope] = GetConVar("tpc_addon_dark_b" .. scope):GetInt(),
        ["tpc_addon_dark_a" .. scope] = GetConVar("tpc_addon_dark_a" .. scope):GetInt(),
        ["tpc_addon_bright_r" .. scope] = GetConVar("tpc_addon_bright_r" .. scope):GetInt(),
        ["tpc_addon_bright_g" .. scope] = GetConVar("tpc_addon_bright_g" .. scope):GetInt(),
        ["tpc_addon_bright_b" .. scope] = GetConVar("tpc_addon_bright_b" .. scope):GetInt(),
        ["tpc_addon_bright_a" .. scope] = GetConVar("tpc_addon_bright_a" .. scope):GetInt(),
        ["tpc_addon_font_r" .. scope] = GetConVar("tpc_addon_font_r" .. scope):GetInt(),
        ["tpc_addon_font_g" .. scope] = GetConVar("tpc_addon_font_g" .. scope):GetInt(),
        ["tpc_addon_font_b" .. scope] = GetConVar("tpc_addon_font_b" .. scope):GetInt(),
        ["tpc_addon_font_a" .. scope] = GetConVar("tpc_addon_font_a" .. scope):GetInt(),
        ["tpc_highlight_dark_r" .. scope] = GetConVar("tpc_highlight_dark_r" .. scope):GetInt(),
        ["tpc_highlight_dark_g" .. scope] = GetConVar("tpc_highlight_dark_g" .. scope):GetInt(),
        ["tpc_highlight_dark_b" .. scope] = GetConVar("tpc_highlight_dark_b" .. scope):GetInt(),
        ["tpc_highlight_dark_a" .. scope] = GetConVar("tpc_highlight_dark_a" .. scope):GetInt(),
        ["tpc_highlight_bright_r" .. scope] = GetConVar("tpc_highlight_bright_r" .. scope):GetInt(),
        ["tpc_highlight_bright_g" .. scope] = GetConVar("tpc_highlight_bright_g" .. scope):GetInt(),
        ["tpc_highlight_bright_b" .. scope] = GetConVar("tpc_highlight_bright_b" .. scope):GetInt(),
        ["tpc_highlight_bright_a" .. scope] = GetConVar("tpc_highlight_bright_a" .. scope):GetInt(),
        ["tpc_highlight_font_r" .. scope] = GetConVar("tpc_highlight_font_r" .. scope):GetInt(),
        ["tpc_highlight_font_g" .. scope] = GetConVar("tpc_highlight_font_g" .. scope):GetInt(),
        ["tpc_highlight_font_b" .. scope] = GetConVar("tpc_highlight_font_b" .. scope):GetInt(),
        ["tpc_highlight_font_a" .. scope] = GetConVar("tpc_highlight_font_a" .. scope):GetInt()
    }
end

function TPC:LoadColorCvarsTable(cvarsTable)
    for k,v in pairs(cvarsTable) do
        RunConsoleCommand(k, v)
    end
end

net.Receive("TPC_SetSVColorsOnCL", function()
    local cvarsTable = net.ReadTable()

    TPC.serverPreset = cvarsTable

    timer.Simple(0.05, function() -- Wait for a possible InitColorsFirstRun() execution
        TPC:LoadColorCvarsTable(cvarsTable)
    end)
end)
