--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

TPC = {}

TPC.FOLDER = {}
TPC.FOLDER.LUA = "tpc"
TPC.FOLDER.DATA = "tpc"
TPC.FOLDER.SV_MODULES = TPC.FOLDER.LUA .. "/server/"
TPC.FOLDER.CL_MODULES = TPC.FOLDER.LUA .. "/client/"
TPC.FILE = {}
TPC.FILE.HIGHLIGHTS = TPC.FOLDER.DATA .. "/" .. "highlights.json"

if CLIENT then
    local function CreateDir(path)
        if not file.Exists(path, "Data") then
            file.CreateDir(path)
        end
    end

    CreateDir(TPC.FOLDER.DATA)
end

local function includeModules(dir, isClientModule)
    local files, dirs = file.Find( dir.."*", "LUA" )

    if not dirs then return end

    for _, fdir in ipairs(dirs) do
        includeModules(dir .. fdir .. "/", isClientModule)
    end

    for k,v in ipairs(files) do
        if SERVER and isClientModule then
            AddCSLuaFile(dir .. v)
        else
            include(dir .. v)
        end
    end 
end

if SERVER then
    includeModules(TPC.FOLDER.SV_MODULES)
end
includeModules(TPC.FOLDER.CL_MODULES, true)

if CLIENT then
    local function InitColors()
        local name = "tpc" .. tostring(LocalPlayer())

        hook.Add("OnSpawnMenuOpen", name, function()
            timer.Simple(0.2, function()
                TPC:InitColors()
            end)
            hook.Remove(name)
        end)
    end

    local firstRun = CreateClientConVar("tpc_first_run", "1")

    if firstRun:GetInt() == 1 then
        TPC:InitColorsFirstRun()
        RunConsoleCommand("tpc_first_run", "0")
    end

    TPC:InitHighlights()
    InitColors()
end
