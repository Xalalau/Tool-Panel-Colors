--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

CreateClientConVar("tpc_gmod_even_r", "255")
CreateClientConVar("tpc_gmod_even_g", "255")
CreateClientConVar("tpc_gmod_even_b", "255")
CreateClientConVar("tpc_gmod_even_a", "255")
CreateClientConVar("tpc_gmod_odd_r", "255")
CreateClientConVar("tpc_gmod_odd_g", "255")
CreateClientConVar("tpc_gmod_odd_b", "255")
CreateClientConVar("tpc_gmod_odd_a", "255")
CreateClientConVar("tpc_others_even_r", "160")
CreateClientConVar("tpc_others_even_g", "97")
CreateClientConVar("tpc_others_even_b", "255")
CreateClientConVar("tpc_others_even_a", "67")
CreateClientConVar("tpc_others_odd_r", "255")
CreateClientConVar("tpc_others_odd_g", "116")
CreateClientConVar("tpc_others_odd_b", "255")
CreateClientConVar("tpc_others_odd_a", "85")

-- Store the new color completely in an internal variable for easy access
function TPC:SetNewToolColors()
    local function GetCurrentColors(toolType, lineType)
        return Color(
                GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_r"):GetInt(),
                GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_g"):GetInt(),
                GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_b"):GetInt(),
                GetConVar("tpc_" .. string.lower(toolType) .. "_" .. lineType .. "_a"):GetInt()
        )
    end

    for toolType,lineTypeTable in pairs(self.colors) do
        for lineType,_ in pairs(lineTypeTable) do
            self.colors[toolType][lineType] = GetCurrentColors(toolType, lineType)
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
