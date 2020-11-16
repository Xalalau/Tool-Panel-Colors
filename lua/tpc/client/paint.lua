--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

CreateClientConVar("tpc_first_run", "0")
CreateClientConVar("tpc_gmod_even_r", "")
CreateClientConVar("tpc_gmod_even_g", "")
CreateClientConVar("tpc_gmod_even_b", "")
CreateClientConVar("tpc_gmod_even_a", "")
CreateClientConVar("tpc_gmod_odd_r", "")
CreateClientConVar("tpc_gmod_odd_g", "")
CreateClientConVar("tpc_gmod_odd_b", "")
CreateClientConVar("tpc_gmod_odd_a", "")
CreateClientConVar("tpc_others_even_r", "")
CreateClientConVar("tpc_others_even_g", "")
CreateClientConVar("tpc_others_even_b", "")
CreateClientConVar("tpc_others_even_a", "")
CreateClientConVar("tpc_others_odd_r", "")
CreateClientConVar("tpc_others_odd_g", "")
CreateClientConVar("tpc_others_odd_b", "")
CreateClientConVar("tpc_others_odd_a", "")

function TPC:TableToColor(colorTable)
    return Color(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

function TPC:SetNewToolColors(toolType, lineType, colorTable)
    for k,v in pairs(colorTable) do
        RunConsoleCommand("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_" .. k, v)
    end

    self.colors[toolType][lineType] = self:TableToColor(colorTable)
end

-- Apply a preset if the addon is being initialized for the first time
function TPC:InitFirstRun()
    if not GetConVar("tpc_first_run"):GetBool() then
        for k,v in pairs(TPC.presets[self.defaultPreset]) do
            RunConsoleCommand(k, v)
        end

        RunConsoleCommand("tpc_first_run", "1")

        return true
    end
end

-- Load the colors from the cvars to self.colors
function TPC:InitToolColors()
    local function GetCurrentColors(toolType, lineType)
        return {
            r = GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_r"):GetInt(),
            g = GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_g"):GetInt(),
            b = GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_b"):GetInt(),
            a = GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_a"):GetInt()
        }
    end

    for toolType,lineTypeTable in pairs(self.colors) do
        for lineType,_ in pairs(lineTypeTable) do
            self.colors[toolType][lineType] = self:TableToColor(GetCurrentColors(toolType, lineType))
        end
    end
end

function TPC:SetPaint(pnl, toolType, lineType)
    pnl._Paint = pnl._Paint or pnl.Paint

    function pnl:Paint(w, h)
        surface.SetDrawColor(TPC.colors[toolType][lineType])
        surface.DrawRect(0, 0, w, h)

        return self:_Paint(w, h)
    end
end

function TPC:PaintToolPanel()
    local toolPanelList = g_SpawnMenu.ToolMenu.ToolPanels[1].List
    local odd = true

    for _, col in ipairs(toolPanelList.pnlCanvas:GetChildren()) do
        for __, pnl in ipairs(col:GetChildren()) do
            if pnl.ClassName ~= "DCategoryHeader" then
                local toolType = self.defaultTools[pnl.Name] and "GMod" or "Others"
                local lineType = odd and "odd" or "even"

                self:SetPaint(pnl, toolType, lineType)

                odd = not odd and true or false
            else
                odd = true
            end
        end

        col:InvalidateLayout() -- Checar se isso é útil
        toolPanelList.pnlCanvas:InvalidateLayout()
    end
end

hook.Add("PostReloadToolsMenu", "PaintMenus", function()
    TPC:PaintToolPanel()
    TPC:PaintToolPanel() -- HACK: this will force the menu to show the correct colors
end)
