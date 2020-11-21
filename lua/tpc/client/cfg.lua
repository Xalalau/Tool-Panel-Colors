--[[
    2020 Xalalau Xubilozo. MIT License
    https://xalalau.com/
--]]

TPC.version = "Pre 1.0"
TPC.baseReference = {
    ["_sv"] = {
        GMod = {
            bright = true,
            dark = true,
            font = true
        },
        Addon = {
            bright = true,
            dark = true,
            font = true
        },
        Highlight = {
            bright = true,
            dark = true,
            font = true
        }
    }
}
TPC.baseReference["_cl"] = table.Copy(TPC.baseReference["_sv"])

TPC.colors = table.Copy(TPC.baseReference)

-- ["panel"] = true
TPC.highlights = {
    ["_sv"] = {},
    ["_cl"] = {}
}

TPC.fakeToolPanelList = {
    ["_sv"] = {
        GMod = {
            dark = {},
            bright = {}
        },
        Addon = {
            dark = {},
            bright = {}
        },
        Highlight = {
            dark = {},
            bright = {}
        }
    }
}
TPC.fakeToolPanelList["_cl"] = table.Copy(TPC.fakeToolPanelList["_sv"])

-- { "toolType", "toolName", "highlight" or nil }
TPC.fakeToolList = {
    { "GMod", "Axis" },
    { "GMod", "Ball Socket" },
    { "GMod", "Elastic" },
    { "GMod", "Hydraulic" },
    { "GMod", "Weld", "highlight" },
    { "Addon", "Addon Tool 1" },
    { "Addon", "Addon Tool 2" },
    { "GMod", "Muscle" },
    { "GMod", "Pulley", "highlight" },
    { "Addon", "Addon Tool 3", "highlight" },
    { "GMod", "Rope" },
    { "Addon", "Addon Tool 4" },
    { "Addon", "Addon Tool 5" },
    { "Addon", "Addon Tool 6" },
    { "Addon", "Addon Tool 7" },
    { "Addon", "Addon Tool 8", "highlight" },
    { "Addon", "Addon Tool 9" }
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

TPC.defaultPresets = {
    ["_sv"] = "Menta",
    ["_cl"] = "Saara"
}

TPC.serverPreset = {}

TPC.presets = {
    ["[Default]"] = {
        tpc_gmod_dark_r_cl = "255",
        tpc_gmod_dark_g_cl = "255",
        tpc_gmod_dark_b_cl = "255",
        tpc_gmod_dark_a_cl = "255",
        tpc_gmod_bright_r_cl = "255",
        tpc_gmod_bright_g_cl = "255",
        tpc_gmod_bright_b_cl = "255",
        tpc_gmod_bright_a_cl = "255",
        tpc_gmod_font_r_cl = "135",
        tpc_gmod_font_g_cl = "135",
        tpc_gmod_font_b_cl = "135",
        tpc_gmod_font_a_cl = "255",
        tpc_addon_dark_r_cl = "255",
        tpc_addon_dark_g_cl = "255",
        tpc_addon_dark_b_cl = "255",
        tpc_addon_dark_a_cl = "255",
        tpc_addon_bright_r_cl = "255",
        tpc_addon_bright_g_cl = "255",
        tpc_addon_bright_b_cl = "255",
        tpc_addon_bright_a_cl = "255",
        tpc_addon_font_r_cl = "135",
        tpc_addon_font_g_cl = "135",
        tpc_addon_font_b_cl = "135",
        tpc_addon_font_a_cl = "255",
        tpc_highlight_dark_r_cl = "255",
        tpc_highlight_dark_g_cl = "255",
        tpc_highlight_dark_b_cl = "255",
        tpc_highlight_dark_a_cl = "255",
        tpc_highlight_bright_r_cl = "255",
        tpc_highlight_bright_g_cl = "255",
        tpc_highlight_bright_b_cl = "255",
        tpc_highlight_bright_a_cl = "255",
        tpc_highlight_font_r_cl = "227",
        tpc_highlight_font_g_cl = "0",
        tpc_highlight_font_b_cl = "0",
        tpc_highlight_font_a_cl = "255"
    },
    ["BSDO"] = {
        tpc_gmod_dark_r_cl = "255",
        tpc_gmod_dark_g_cl = "255",
        tpc_gmod_dark_b_cl = "255",
        tpc_gmod_dark_a_cl = "255",
        tpc_gmod_bright_r_cl = "255",
        tpc_gmod_bright_g_cl = "255",
        tpc_gmod_bright_b_cl = "255",
        tpc_gmod_bright_a_cl = "255",
        tpc_gmod_font_r_cl = "135",
        tpc_gmod_font_g_cl = "135",
        tpc_gmod_font_b_cl = "135",
        tpc_gmod_font_a_cl = "255",
        tpc_addon_dark_r_cl = "95",
        tpc_addon_dark_g_cl = "227",
        tpc_addon_dark_b_cl = "220",
        tpc_addon_dark_a_cl = "85",
        tpc_addon_bright_r_cl = "99",
        tpc_addon_bright_g_cl = "255",
        tpc_addon_bright_b_cl = "247",
        tpc_addon_bright_a_cl = "99",
        tpc_addon_font_r_cl = "124",
        tpc_addon_font_g_cl = "124",
        tpc_addon_font_b_cl = "124",
        tpc_addon_font_a_cl = "255",
        tpc_highlight_dark_r_cl = "66",
        tpc_highlight_dark_g_cl = "249",
        tpc_highlight_dark_b_cl = "239",
        tpc_highlight_dark_a_cl = "255",
        tpc_highlight_bright_r_cl = "61",
        tpc_highlight_bright_g_cl = "255",
        tpc_highlight_bright_b_cl = "245",
        tpc_highlight_bright_a_cl = "255",
        tpc_highlight_font_r_cl = "14",
        tpc_highlight_font_g_cl = "113",
        tpc_highlight_font_b_cl = "104",
        tpc_highlight_font_a_cl = "255"
    },
    ["Menta"] = {
        tpc_gmod_dark_r_cl = "255",
        tpc_gmod_dark_g_cl = "255",
        tpc_gmod_dark_b_cl = "255",
        tpc_gmod_dark_a_cl = "255",
        tpc_gmod_bright_r_cl = "255",
        tpc_gmod_bright_g_cl = "255",
        tpc_gmod_bright_b_cl = "255",
        tpc_gmod_bright_a_cl = "255",
        tpc_gmod_font_r_cl = "135",
        tpc_gmod_font_g_cl = "135",
        tpc_gmod_font_b_cl = "135",
        tpc_gmod_font_a_cl = "255",
        tpc_addon_dark_r_cl = "85",
        tpc_addon_dark_g_cl = "227",
        tpc_addon_dark_b_cl = "87",
        tpc_addon_dark_a_cl = "95",
        tpc_addon_bright_r_cl = "99",
        tpc_addon_bright_g_cl = "255",
        tpc_addon_bright_b_cl = "102",
        tpc_addon_bright_a_cl = "99",
        tpc_addon_font_r_cl = "124",
        tpc_addon_font_g_cl = "124",
        tpc_addon_font_b_cl = "124",
        tpc_addon_font_a_cl = "255",
        tpc_highlight_dark_r_cl = "66",
        tpc_highlight_dark_g_cl = "249",
        tpc_highlight_dark_b_cl = "78",
        tpc_highlight_dark_a_cl = "255",
        tpc_highlight_bright_r_cl = "61",
        tpc_highlight_bright_g_cl = "255",
        tpc_highlight_bright_b_cl = "81",
        tpc_highlight_bright_a_cl = "255",
        tpc_highlight_font_r_cl = "14",
        tpc_highlight_font_g_cl = "113",
        tpc_highlight_font_b_cl = "20",
        tpc_highlight_font_a_cl = "255"
    },
    ["Saara"] = {
        tpc_gmod_dark_r_cl = "255",
        tpc_gmod_dark_g_cl = "255",
        tpc_gmod_dark_b_cl = "255",
        tpc_gmod_dark_a_cl = "255",
        tpc_gmod_bright_r_cl = "255",
        tpc_gmod_bright_g_cl = "255",
        tpc_gmod_bright_b_cl = "255",
        tpc_gmod_bright_a_cl = "255",
        tpc_gmod_font_r_cl = "135",
        tpc_gmod_font_g_cl = "135",
        tpc_gmod_font_b_cl = "135",
        tpc_gmod_font_a_cl = "255",
        tpc_addon_dark_r_cl = "227",
        tpc_addon_dark_g_cl = "227",
        tpc_addon_dark_b_cl = "95",
        tpc_addon_dark_a_cl = "85",
        tpc_addon_bright_r_cl = "255",
        tpc_addon_bright_g_cl = "255",
        tpc_addon_bright_b_cl = "100",
        tpc_addon_bright_a_cl = "99",
        tpc_addon_font_r_cl = "124",
        tpc_addon_font_g_cl = "124",
        tpc_addon_font_b_cl = "124",
        tpc_addon_font_a_cl = "255",
        tpc_highlight_dark_r_cl = "249",
        tpc_highlight_dark_g_cl = "249",
        tpc_highlight_dark_b_cl = "66",
        tpc_highlight_dark_a_cl = "255",
        tpc_highlight_bright_r_cl = "255",
        tpc_highlight_bright_g_cl = "255",
        tpc_highlight_bright_b_cl = "62",
        tpc_highlight_bright_a_cl = "255",
        tpc_highlight_font_r_cl = "113",
        tpc_highlight_font_g_cl = "113",
        tpc_highlight_font_b_cl = "14",
        tpc_highlight_font_a_cl = "255"
    },
    ["Tutti Frutti"] = {
        tpc_gmod_dark_r_cl = "255",
        tpc_gmod_dark_g_cl = "255",
        tpc_gmod_dark_b_cl = "255",
        tpc_gmod_dark_a_cl = "255",
        tpc_gmod_bright_r_cl = "255",
        tpc_gmod_bright_g_cl = "255",
        tpc_gmod_bright_b_cl = "255",
        tpc_gmod_bright_a_cl = "255",
        tpc_gmod_font_r_cl = "135",
        tpc_gmod_font_g_cl = "135",
        tpc_gmod_font_b_cl = "135",
        tpc_gmod_font_a_cl = "255",
        tpc_addon_dark_r_cl = "255",
        tpc_addon_dark_g_cl = "83",
        tpc_addon_dark_b_cl = "255",
        tpc_addon_dark_a_cl = "110",
        tpc_addon_bright_r_cl = "160",
        tpc_addon_bright_g_cl = "97",
        tpc_addon_bright_b_cl = "255",
        tpc_addon_bright_a_cl = "83",
        tpc_addon_font_r_cl = "110",
        tpc_addon_font_g_cl = "110",
        tpc_addon_font_b_cl = "110",
        tpc_addon_font_a_cl = "255",
        tpc_highlight_dark_r_cl = "227",
        tpc_highlight_dark_g_cl = "136",
        tpc_highlight_dark_b_cl = "235",
        tpc_highlight_dark_a_cl = "255",
        tpc_highlight_bright_r_cl = "235",
        tpc_highlight_bright_g_cl = "155",
        tpc_highlight_bright_b_cl = "243",
        tpc_highlight_bright_a_cl = "255",
        tpc_highlight_font_r_cl = "92",
        tpc_highlight_font_g_cl = "25",
        tpc_highlight_font_b_cl = "116",
        tpc_highlight_font_a_cl = "255"
    },
    ["Wine"] = {
        tpc_gmod_dark_r_cl = "255",
        tpc_gmod_dark_g_cl = "255",
        tpc_gmod_dark_b_cl = "255",
        tpc_gmod_dark_a_cl = "255",
        tpc_gmod_bright_r_cl = "255",
        tpc_gmod_bright_g_cl = "255",
        tpc_gmod_bright_b_cl = "255",
        tpc_gmod_bright_a_cl = "255",
        tpc_gmod_font_r_cl = "135",
        tpc_gmod_font_g_cl = "135",
        tpc_gmod_font_b_cl = "135",
        tpc_gmod_font_a_cl = "255",
        tpc_addon_dark_r_cl = "255",
        tpc_addon_dark_g_cl = "0",
        tpc_addon_dark_b_cl = "0",
        tpc_addon_dark_a_cl = "44",
        tpc_addon_bright_r_cl = "255",
        tpc_addon_bright_g_cl = "0",
        tpc_addon_bright_b_cl = "0",
        tpc_addon_bright_a_cl = "102",
        tpc_addon_font_r_cl = "118",
        tpc_addon_font_g_cl = "118",
        tpc_addon_font_b_cl = "118",
        tpc_addon_font_a_cl = "255",
        tpc_highlight_dark_r_cl = "238",
        tpc_highlight_dark_g_cl = "144",
        tpc_highlight_dark_b_cl = "144",
        tpc_highlight_dark_a_cl = "255",
        tpc_highlight_bright_r_cl = "246",
        tpc_highlight_bright_g_cl = "160",
        tpc_highlight_bright_b_cl = "160",
        tpc_highlight_bright_a_cl = "255",
        tpc_highlight_font_r_cl = "116",
        tpc_highlight_font_g_cl = "59",
        tpc_highlight_font_b_cl = "59",
        tpc_highlight_font_a_cl = "255"
    }
}
