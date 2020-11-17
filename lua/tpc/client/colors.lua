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
CreateClientConVar("tpc_custom_bright_r", "")
CreateClientConVar("tpc_custom_bright_g", "")
CreateClientConVar("tpc_custom_bright_b", "")
CreateClientConVar("tpc_custom_bright_a", "")
CreateClientConVar("tpc_custom_dark_r", "")
CreateClientConVar("tpc_custom_dark_g", "")
CreateClientConVar("tpc_custom_dark_b", "")
CreateClientConVar("tpc_custom_dark_a", "")
CreateClientConVar("tpc_highlight_r", "")
CreateClientConVar("tpc_highlight_g", "")
CreateClientConVar("tpc_highlight_b", "")
CreateClientConVar("tpc_highlight_a", "")

function TPC:TableToColor(colorTable)
    return Color(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

function TPC:SetToolColors(toolType, lineType, colorTable)
    local isHighlight = toolType == "Highlight"

    for k,v in pairs(colorTable) do
        RunConsoleCommand("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_" .. k, v)
    end

    self.colors[toolType][lineType] = self:TableToColor(colorTable)
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
        local isHighlight = toolType == "Highlight"

        return {
            r = GetConVar("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_r"):GetInt(),
            g = GetConVar("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_g"):GetInt(),
            b = GetConVar("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_b"):GetInt(),
            a = GetConVar("tpc_" .. toolType .. (isHighlight and "" or ("_" .. lineType)) .. "_a"):GetInt()
        }
    end

    for toolType,lineTypeTable in pairs(self.colors) do
        for lineType,_ in pairs(lineTypeTable) do
            self.colors[toolType][lineType] = self:TableToColor(GetCurrentColors(toolType, lineType))
        end
    end
end
