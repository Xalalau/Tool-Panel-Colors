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

function TPC:GetNewToolColors(toolType)
    return {
        odd = Color(
            GetConVar("tpc_" .. string.lower(toolType) .. "_odd_r"):GetInt(),
            GetConVar("tpc_" .. string.lower(toolType) .. "_odd_g"):GetInt(),
            GetConVar("tpc_" .. string.lower(toolType) .. "_odd_b"):GetInt(),
            GetConVar("tpc_" .. string.lower(toolType) .. "_odd_a"):GetInt()
        ),
        even = Color(
            GetConVar("tpc_" .. string.lower(toolType) .. "_even_r"):GetInt(),
            GetConVar("tpc_" .. string.lower(toolType) .. "_even_g"):GetInt(),
            GetConVar("tpc_" .. string.lower(toolType) .. "_even_b"):GetInt(),
            GetConVar("tpc_" .. string.lower(toolType) .. "_even_a"):GetInt()
        )
    }
end

function TPC:PaintMenus()
    local toolPanelList = g_SpawnMenu.ToolMenu.ToolPanels[1].List
    local odd

    for _, col in ipairs(toolPanelList.pnlCanvas:GetChildren()) do
        for __, pnl in ipairs(col:GetChildren()) do
            if pnl.ClassName ~= "DCategoryHeader" then
                local toolType = self.defaultTools[pnl.Name] and self:GetNewToolColors("GMod") or self:GetNewToolColors("Others")
                local toolColor = toolType[pnl.odd and "odd" or "even"]

                pnl._Paint = pnl._Paint or pnl.Paint
                pnl.odd = not odd and true or false
                odd = pnl.odd

                function pnl:Paint(w, h)
                    surface.SetDrawColor(toolColor)
                    surface.DrawRect(0, 0, w, h)

                    return self:_Paint(w, h)
                end
            else
                odd = false
            end

            col:InvalidateLayout() -- Checar se isso é útil
            toolPanelList.pnlCanvas:InvalidateLayout()
        end
    end
end

hook.Add("PostReloadToolsMenu", "PaintMenus", function()
    TPC:PaintMenus()
end)