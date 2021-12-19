--[[
    2020 - 2021 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

util.AddNetworkString("TPC_SetNewSchemeOnSV")
util.AddNetworkString("TPC_SetSVColorsOnCL")
util.AddNetworkString("TPC_SetSVHighlightsOnCL")
util.AddNetworkString("TPC_RefreshPanelColorsOnCL")

function TPC:SV_Save(highights, colors)
    local highlightsFileName = TPC.FILE.HIGHLIGHTS .. "_sv.json"
    local colorsFileName = TPC.FILE.SV_COLORS

    file.Write(highlightsFileName, util.TableToJSON(highights, true))
    file.Write(colorsFileName, util.TableToJSON(colors, true))
end

function TPC:SV_Load()
    local highlightsFileName = TPC.FILE.HIGHLIGHTS .. "_sv.json"
    local colorsFileName = TPC.FILE.SV_COLORS

    if file.Exists(highlightsFileName, "Data") then
        net.Start("TPC_SetSVColorsOnCL")
            net.WriteTable(util.JSONToTable(file.Read(highlightsFileName, "Data")))
        net.Broadcast()
    end

    if file.Exists(colorsFileName, "Data") then
        net.Start("TPC_SetSVHighlightsOnCL")
            net.WriteTable(util.JSONToTable(file.Read(colorsFileName, "Data")))
        net.Broadcast()
    end
end

net.Receive("TPC_SetNewSchemeOnSV", function(_, ply)
    if IsValid(ply) and ply:IsPlayer() and ply:IsAdmin() then
        local colors = net.ReadTable()
        local highights = net.ReadTable()

        TPC:SV_Save(highights, colors)

        net.Start("TPC_SetSVColorsOnCL")
            net.WriteTable(colors)
        net.Broadcast()

        net.Start("TPC_SetSVHighlightsOnCL")
            net.WriteTable(highights)
        net.Broadcast()

        net.Start("TPC_RefreshPanelColorsOnCL")
        net.Broadcast()
    end
end)
