-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- OS Detection
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_macos = wezterm.target_triple:find("darwin") ~= nil

-- ===== Basic Settings =====
config.automatically_reload_config = true
config.initial_cols = 120
config.initial_rows = 28

-- ===== Font Settings =====
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font Mono", -- Primary text
	"Noto Sans CJK JP", -- Japanese
	"Noto Color Emoji", -- Emojis
})
config.font_size = 12
config.warn_about_missing_glyphs = false
-- Enable ligatures (e.g., -> =>)
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- ===== Color Scheme =====
config.color_scheme = "AdventureTime"
config.colors = {
	cursor_bg = "#FFFFFF",
	cursor_border = "#FFFFFF",
}

-- ===== GPU Rendering =====
config.front_end = "OpenGL"
config.max_fps = 60

-- ===== Scroll Settings =====
config.enable_scroll_bar = true
config.scrollback_lines = 350000
-- Scroll speed for mouse wheel
config.alternate_buffer_wheel_scroll_speed = 3

-- ===== Tab Bar Settings =====
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25

-- ===== Window Settings =====
config.window_decorations = "RESIZE|TITLE"
config.default_cursor_style = "BlinkingBar"
config.window_close_confirmation = "AlwaysPrompt"
-- Window padding
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

-- ===== Transparency Settings =====
config.window_background_opacity = 1.0 -- Opaque for better readability

-- OS Specific Settings
if is_windows then
	-- Windows specific logic
elseif is_macos then
	-- macOS blur effects
	-- config.macos_window_background_blur = 20
elseif is_linux then
	-- Linux specific logic
end

-- ===== Alt/Option Key Settings =====
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- ===== Hyperlink Settings =====
-- Detect URLs and make them clickable
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ===== Mouse Bindings =====
-- Right click to paste
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
}

if is_windows then
	-- Launcher menu definitions
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
	-- Set default shell to pwsh
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- ===== Key Bindings =====
config.keys = {
	-- ===== Launching Launcher Menu =====
	{
		key = "Enter",
		mods = "ALT",
		action = act.ShowLauncher,
	},
	-- ===== Application Operations =====
	{
		key = "q",
		mods = "CTRL",
		action = act.QuitApplication,
	},

	-- ===== Pane Splitting (Default) =====
	-- Vertical Split (CTRL + [)
	{
		key = "[",
		mods = "CTRL",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Horizontal Split (CTRL + ])
	{
		key = "]",
		mods = "CTRL",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- ===== Pane Splitting (Explicit Ubuntu) =====
	-- Vertical Split (CTRL + SHIFT + [)
	{
		key = "[",
		mods = "ALT",
		action = act.SplitVertical({
			args = { "wsl.exe", "-d", "Ubuntu" },
		}),
	},
	-- Horizontal Split (CTRL + SHIFT + ])
	{
		key = "]",
		mods = "ALT",
		action = act.SplitHorizontal({
			args = { "wsl.exe", "-d", "Ubuntu" },
		}),
	},

	-- ===== Pane Navigation =====
	-- Alt + Arrow keys to move between panes
	{
		key = "LeftArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Down"),
	},

	-- ===== Pane Resizing =====
	-- Ctrl + Alt + Arrow keys to resize panes
	{
		key = "LeftArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},

	-- ===== Toggle zoom Pane =====
	{ key = "z", mods = "ALT", action = act.TogglePaneZoomState },

	-- ===== Close Pane =====
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentPane({ confirm = true }),
	},

	-- ===== Tab Operations =====
	-- New Tab (Ctrl+Shift+T)
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Switch Tabs (Ctrl+Tab / Ctrl+Shift+Tab)
	{
		key = "Tab",
		mods = "CTRL",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "Tab",
		mods = "CTRL|SHIFT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "W",
		mods = "CTRL|SHIFT",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	-- Select Tab by Number (Ctrl+1-9)
	{
		key = "1",
		mods = "CTRL",
		action = act.ActivateTab(0),
	},
	{
		key = "2",
		mods = "CTRL",
		action = act.ActivateTab(1),
	},
	{
		key = "3",
		mods = "CTRL",
		action = act.ActivateTab(2),
	},
	{
		key = "4",
		mods = "CTRL",
		action = act.ActivateTab(3),
	},
	{
		key = "5",
		mods = "CTRL",
		action = act.ActivateTab(4),
	},
	{
		key = "6",
		mods = "CTRL",
		action = act.ActivateTab(5),
	},
	{
		key = "7",
		mods = "CTRL",
		action = act.ActivateTab(6),
	},
	{
		key = "8",
		mods = "CTRL",
		action = act.ActivateTab(7),
	},
	{
		key = "9",
		mods = "CTRL",
		action = act.ActivateTab(-1),
	},

	-- ===== Search =====
	{
		key = "/",
		mods = "CTRL",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},

	-- ===== Copy Mode =====
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = act.ActivateCopyMode,
	},

	-- ===== Font Size Adjustment =====
	{
		key = "=",
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.ResetFontSize,
	},

	-- ===== Scrolling =====
	{
		key = "PageUp",
		mods = "SHIFT",
		action = act.ScrollByPage(-1),
	},
	{
		key = "PageDown",
		mods = "SHIFT",
		action = act.ScrollByPage(1),
	},
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = act.ActivateCommandPalette,
	},
}

-- Finally, return the configuration to wezterm:
return config
