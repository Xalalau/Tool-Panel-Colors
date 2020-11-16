--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

TPC = {}

TPC.VERSION = "Pre 1.0"

TPC.FOLDER = {}
TPC.FOLDER.LUA = "tpc/"
TPC.FOLDER.DATA = "tpc"
TPC.FOLDER.SV_MODULES = TPC.FOLDER.LUA .. "server/"
TPC.FOLDER.CL_MODULES = TPC.FOLDER.LUA .. "client/"

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

TPC.colors = {
    GMod = { 
        bright = true,
        dark = true
    },
    Custom = {
        bright = true,
        dark = true
    }
}

if SERVER then
    includeModules(TPC.FOLDER.SV_MODULES)
end
includeModules(TPC.FOLDER.CL_MODULES, true)

if CLIENT then
    if TPC:InitFirstRun() then
        local name = "tpc" .. tostring(LocalPlayer())

        hook.Add("OnSpawnMenuOpen", name, function()
            TPC:InitToolColors()
            hook.Remove(name)
        end)
    else
        TPC:InitToolColors()
    end
end