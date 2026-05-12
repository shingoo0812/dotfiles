-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
package.path = wezterm.config_dir .. "/?.lua;" .. package.path
local keymap = require("keymap")

local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_macos = wezterm.target_triple:find("darwin") ~= nil

config.automatically_reload_config = true
config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font Mono",
	"Noto Sans CJK JP",
	"Noto Color Emoji",
})
config.font_size = 12
config.warn_about_missing_glyphs = false
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

config.color_scheme = "Tokyo Night"
config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
	background = "#110441",
	foreground = "#c0caf5",
}

config.front_end = "OpenGL"
config.max_fps = 60

config.enable_kitty_graphics = true
config.term = "wezterm"

config.enable_scroll_bar = true
config.scrollback_lines = 350000
config.alternate_buffer_wheel_scroll_speed = 3

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25

config.window_decorations = "RESIZE|TITLE"
config.default_cursor_style = "BlinkingBar"
config.window_close_confirmation = "AlwaysPrompt"
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

config.window_background_opacity = 0.88
config.text_background_opacity = 1.0

if is_windows then
	-- config.win32_system_backdrop = "Acrylic"
elseif is_macos then
	config.macos_window_background_blur = 30
elseif is_linux then
	-- Linux doesn't have native blur, but transparency still works
	config.window_background_opacity = 0.88
end

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.hyperlink_rules = wezterm.default_hyperlink_rules()

if is_windows then
	config.launch_menu = {
		{
			label = "PowerShell Core",
			args = { "pwsh.exe", "-NoLogo" },
		},
		{
			label = "Command Prompt",
			args = { "cmd.exe" },
		},
		{
			label = "Ubuntu (WSL)",
			args = { "wsl.exe", "-d", "Ubuntu" },
		},
		{
			label = "Kali (WSL)",
			args = { "wsl.exe" },
		},
	}
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

keymap.apply(config, act)

config.ssh_domains = {
	{
		name = "docker-nvim",
		remote_address = "127.0.0.1:2222",
		username = "root",
	},
}

return config
