local wezterm = require("wezterm")
local keybinds = require("keybinds")
local act = wezterm.action

local mux = wezterm.mux

return {

	default_prog = { "powershell" },

	color_scheme = "Tokyo Night",
	window_background_opacity = 0.85,
	font = wezterm.font_with_fallback({
		"Hack Nerd Font", -- プライマリフォント
		"Cica", -- フォールバックフォント
	}),
	font_size = 13.0,

	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = false,
	adjust_window_size_when_changing_font_size = false,

	use_ime = true,

	keys = keybinds.keys,
	key_tables = keybinds.key_tables,
	disable_default_key_bindings = true,
	tab_bar_at_bottom = false,

	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 },

}
