--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

function TPC:InitHighlights()
    if file.Exists(TPC.FILE.HIGHLIGHTS, "Data") then
        TPC.highlights = util.JSONToTable(file.Read(TPC.FILE.HIGHLIGHTS, "Data"))
    end
end

function TPC:SaveHighlights()
    file.Write(TPC.FILE.HIGHLIGHTS, util.TableToJSON(TPC.highlights, true))
end

function TPC:SetHighlight(pnlName, state)
    surface.PlaySound("garrysmod/content_downloaded.wav")

    TPC.highlights[pnlName] = state
end