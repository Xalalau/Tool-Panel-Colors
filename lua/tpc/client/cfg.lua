--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

TPC.version = "Pre 1.0"

TPC.defaultPreset = "Menta"

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

TPC.defaultTools = {
    ["axis"] = true,
    ["ballsocket"] = true,
    ["elastic"] = true,
    ["hydraulic"] = true,
    ["motor"] = true,
    ["muscle"] = true,
    ["pulley"] = true,
    ["rope"] = true,
    ["slider"] = true,
    ["weld"] = true,
    ["winch"] = true,
    ["balloon"] = true,
    ["button"] = true,
    ["duplicator"] = true,
    ["dynamite"] = true,
    ["emitter"] = true,
    ["hoverball"] = true,
    ["lamp"] = true,
    ["light"] = true,
    ["nocollide"] = true,
    ["physprop"] = true,
    ["remover"] = true,
    ["thruster"] = true,
    ["wheel"] = true,
    ["eyeposer"] = true,
    ["faceposer"] = true,
    ["finger"] = true,
    ["inflator"] = true,
    ["camera"] = true,
    ["colour"] = true,
    ["material"] = true,
    ["paint"] = true,
    ["trails"] = true
}

TPC.fakeToolsList = {
    { "GMod", "Axis" },
    { "GMod", "Ball Socket" },
    { "GMod", "Elastic" },
    { "GMod", "Hydraulic" },
    { "GMod", "Motor" },
    { "Custom", "Custom Tool 1" },
    { "Custom", "Custom Tool 2" },
    { "GMod", "Muscle" },
    { "GMod", "Pulley" },
    { "Custom", "Custom Tool 3" },
    { "GMod", "Rope" },
    { "Custom", "Custom Tool 4" },
    { "Custom", "Custom Tool 5" },
    { "Custom", "Custom Tool 6" },
    { "Custom", "Custom Tool 7" },
}

TPC.presets = {
    ["[Default]"] = {
        tpc_gmod_bright_r = "255",
        tpc_gmod_bright_g = "255",
        tpc_gmod_bright_b = "255",
        tpc_gmod_bright_a = "255",
        tpc_gmod_dark_r = "255",
        tpc_gmod_dark_g = "255",
        tpc_gmod_dark_b = "255",
        tpc_gmod_dark_a = "255",
        tpc_custom_bright_r = "255",
        tpc_custom_bright_g = "255",
        tpc_custom_bright_b = "255",
        tpc_custom_bright_a = "255",
        tpc_custom_dark_r = "255",
        tpc_custom_dark_g = "255",
        tpc_custom_dark_b = "255",
        tpc_custom_dark_a = "255"
    },
    ["Tutti Frutti"] = {
        tpc_gmod_bright_r = "255",
        tpc_gmod_bright_g = "255",
        tpc_gmod_bright_b = "255",
        tpc_gmod_bright_a = "255",
        tpc_gmod_dark_r = "255",
        tpc_gmod_dark_g = "255",
        tpc_gmod_dark_b = "255",
        tpc_gmod_dark_a = "255",
        tpc_custom_bright_r = "160",
        tpc_custom_bright_g = "97",
        tpc_custom_bright_b = "255",
        tpc_custom_bright_a = "67",
        tpc_custom_dark_r = "255",
        tpc_custom_dark_g = "116",
        tpc_custom_dark_b = "255",
        tpc_custom_dark_a = "85"
    },
    ["Saara"] = {
        tpc_gmod_bright_r = "255",
        tpc_gmod_bright_g = "255",
        tpc_gmod_bright_b = "255",
        tpc_gmod_bright_a = "255",
        tpc_gmod_dark_r = "255",
        tpc_gmod_dark_g = "255",
        tpc_gmod_dark_b = "255",
        tpc_gmod_dark_a = "255",
        tpc_custom_bright_r = "255",
        tpc_custom_bright_g = "255",
        tpc_custom_bright_b = "100",
        tpc_custom_bright_a = "50",
        tpc_custom_dark_r = "255",
        tpc_custom_dark_g = "255",
        tpc_custom_dark_b = "100",
        tpc_custom_dark_a = "63"
    },
    ["Menta"] = {
        tpc_gmod_bright_r = "255",
        tpc_gmod_bright_g = "255",
        tpc_gmod_bright_b = "255",
        tpc_gmod_bright_a = "255",
        tpc_gmod_dark_r = "255",
        tpc_gmod_dark_g = "255",
        tpc_gmod_dark_b = "255",
        tpc_gmod_dark_a = "255",
        tpc_custom_bright_r = "99",
        tpc_custom_bright_g = "255",
        tpc_custom_bright_b = "130",
        tpc_custom_bright_a = "50",
        tpc_custom_dark_r = "99",
        tpc_custom_dark_g = "255",
        tpc_custom_dark_b = "130",
        tpc_custom_dark_a = "70"
    },
    ["BSDO"] = {
        tpc_gmod_bright_r = "255",
        tpc_gmod_bright_g = "255",
        tpc_gmod_bright_b = "255",
        tpc_gmod_bright_a = "255",
        tpc_gmod_dark_r = "255",
        tpc_gmod_dark_g = "255",
        tpc_gmod_dark_b = "255",
        tpc_gmod_dark_a = "255",
        tpc_custom_bright_r = "96",
        tpc_custom_bright_g = "228",
        tpc_custom_bright_b = "255",
        tpc_custom_bright_a = "67",
        tpc_custom_dark_r = "115",
        tpc_custom_dark_g = "208",
        tpc_custom_dark_b = "255",
        tpc_custom_dark_a = "85"
    },
    ["Wine"] = {
        tpc_gmod_bright_r = "255",
        tpc_gmod_bright_g = "255",
        tpc_gmod_bright_b = "255",
        tpc_gmod_bright_a = "255",
        tpc_gmod_dark_r = "255",
        tpc_gmod_dark_g = "255",
        tpc_gmod_dark_b = "255",
        tpc_gmod_dark_a = "255",
        tpc_custom_bright_r = "255",
        tpc_custom_bright_g = "0",
        tpc_custom_bright_b = "0",
        tpc_custom_bright_a = "115",
        tpc_custom_dark_r = "255",
        tpc_custom_dark_g = "0",
        tpc_custom_dark_b = "0",
        tpc_custom_dark_a = "44"
    }
}
