--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

CreateClientConVar("tpc_gmod_bright_r", "")
CreateClientConVar("tpc_gmod_bright_g", "")
CreateClientConVar("tpc_gmod_bright_b", "")
CreateClientConVar("tpc_gmod_bright_a", "")
CreateClientConVar("tpc_gmod_dark_r", "")
CreateClientConVar("tpc_gmod_dark_g", "")
CreateClientConVar("tpc_gmod_dark_b", "")
CreateClientConVar("tpc_gmod_dark_a", "")
CreateClientConVar("tpc_gmod_font_r", "")
CreateClientConVar("tpc_gmod_font_g", "")
CreateClientConVar("tpc_gmod_font_b", "")
CreateClientConVar("tpc_gmod_font_a", "")
CreateClientConVar("tpc_custom_bright_r", "")
CreateClientConVar("tpc_custom_bright_g", "")
CreateClientConVar("tpc_custom_bright_b", "")
CreateClientConVar("tpc_custom_bright_a", "")
CreateClientConVar("tpc_custom_dark_r", "")
CreateClientConVar("tpc_custom_dark_g", "")
CreateClientConVar("tpc_custom_dark_b", "")
CreateClientConVar("tpc_custom_dark_a", "")
CreateClientConVar("tpc_custom_font_r", "")
CreateClientConVar("tpc_custom_font_g", "")
CreateClientConVar("tpc_custom_font_b", "")
CreateClientConVar("tpc_custom_font_a", "")
CreateClientConVar("tpc_highlight_dark_r", "")
CreateClientConVar("tpc_highlight_dark_g", "")
CreateClientConVar("tpc_highlight_dark_b", "")
CreateClientConVar("tpc_highlight_dark_a", "")
CreateClientConVar("tpc_highlight_bright_r", "")
CreateClientConVar("tpc_highlight_bright_g", "")
CreateClientConVar("tpc_highlight_bright_b", "")
CreateClientConVar("tpc_highlight_bright_a", "")
CreateClientConVar("tpc_highlight_font_r", "")
CreateClientConVar("tpc_highlight_font_g", "")
CreateClientConVar("tpc_highlight_font_b", "")
CreateClientConVar("tpc_highlight_font_a", "")

function TPC:TableToColor(colorTable)
    return Color(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

function TPC:SetToolColors(toolType, lineType, colorTable)
    for k,v in pairs(colorTable) do
        RunConsoleCommand("tpc_" .. toolType .. "_" .. lineType .. "_" .. k, v)
    end

    self.colors[toolType][lineType] = self:TableToColor(colorTable)

    if lineType == "font" then
        self:SetFontColor(toolType)
    end
end

function TPC:SetFontColor(toolTypeIn)
    local toolPanelList = g_SpawnMenu.ToolMenu.ToolPanels[1].List

    for _, col in ipairs(toolPanelList.pnlCanvas:GetChildren()) do
        for __, pnl in ipairs(col:GetChildren()) do
            if pnl.ClassName ~= "DCategoryHeader" then
                local toolType = self.highlights[pnl.Name] and "Highlight" or self.defaultTools[pnl.Name] and "GMod" or "Custom"

                if toolTypeIn == toolType then
                    pnl:SetTextColor(self.colors[toolType].font)
                end
            end
        end
    end
end

-- Apply a preset if the addon is being initialized for the first time
function TPC:InitColorsFirstRun()
    for k,v in pairs(TPC.presets[self.defaultPreset]) do
        RunConsoleCommand(k, v)
    end
end

-- Load the colors from the cvars to self.colors
function TPC:InitColors()
    local function GetCurrentColors(toolType, lineType)
        return {
            r = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_r"):GetInt(),
            g = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_g"):GetInt(),
            b = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_b"):GetInt(),
            a = GetConVar("tpc_" .. toolType .. "_" .. lineType .. "_a"):GetInt()
        }
    end

    for toolType,lineTypeTable in pairs(self.colors) do
        for lineType,_ in pairs(lineTypeTable) do
            self.colors[toolType][lineType] = self:TableToColor(GetCurrentColors(toolType, lineType))
        end

        if g_SpawnMenu then
            self:SetFontColor(toolType)
        else
            hook.Add("OnSpawnMenuOpen", "SpawnMenuNotReady", function()
                self:SetFontColor(toolType)

                hook.Remove("OnSpawnMenuOpen", "SpawnMenuNotReady")
            end)
        end
    end
end
