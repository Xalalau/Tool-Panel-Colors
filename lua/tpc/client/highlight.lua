--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

function TPC:InitHighlights(scope)
    local fileName = TPC.FILE.HIGHLIGHTS .. scope .. ".json"

    if file.Exists(fileName, "Data") then
        TPC.highlights[scope] = util.JSONToTable(file.Read(fileName, "Data"))
    end
end

function TPC:SaveHighlights(scope)
    file.Write(TPC.FILE.HIGHLIGHTS .. scope .. ".json", util.TableToJSON(TPC.highlights[scope], true))
end

function TPC:SetHighlight(scope, pnlName, state)
    surface.PlaySound("garrysmod/content_downloaded.wav")

    TPC.highlights[scope][pnlName] = state
end

net.Receive("TPC_SetSVHighlightsOnCL", function()
    TPC.highlights["_sv"] = net.ReadTable()
end)