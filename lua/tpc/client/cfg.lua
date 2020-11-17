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
    },
    Highlight = {
        [1] = true
    }
}

-- ["panel"] = true
TPC.highlights = {}

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

-- { "toolType", "toolName", "highlight" or nil }
TPC.fakeToolsList = {
    { "GMod", "Axis" },
    { "GMod", "Ball Socket" },
    { "GMod", "Elastic" },
    { "GMod", "Hydraulic" },
    { "GMod", "Motor (highlighted)", "highlight" },
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
    { "GMod", "Slider (highlighted)", "highlight" },
    { "GMod", "Weld" },
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
        tpc_custom_dark_a = "255",
        tpc_highlight_r = "255",
        tpc_highlight_g = "255",
        tpc_highlight_b = "255",
        tpc_highlight_a = "255"
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
        tpc_custom_dark_a = "85",
        tpc_highlight_r = "250",
        tpc_highlight_g = "157",
        tpc_highlight_b = "255",
        tpc_highlight_a = "255"
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
        tpc_custom_dark_a = "63",
        tpc_highlight_r = "255",
        tpc_highlight_g = "255",
        tpc_highlight_b = "62",
        tpc_highlight_a = "255"
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
        tpc_custom_dark_a = "70",
        tpc_highlight_r = "0",
        tpc_highlight_g = "255",
        tpc_highlight_b = "110",
        tpc_highlight_a = "255"
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
        tpc_custom_dark_a = "85",
        tpc_highlight_r = "65",
        tpc_highlight_g = "198",
        tpc_highlight_b = "255",
        tpc_highlight_a = "180"
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
        tpc_custom_dark_a = "44",
        tpc_highlight_r = "255",
        tpc_highlight_g = "136",
        tpc_highlight_b = "136",
        tpc_highlight_a = "255"
    }
}
