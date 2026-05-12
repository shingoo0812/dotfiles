local wezterm = require("wezterm")
local M = {}

local function build_defs(act)
	return {
		{ key = "Enter",     mods = "ALT",       desc = "Show launcher",            action = act.ShowLauncher },
		{ key = "q",         mods = "CTRL",       desc = "Quit application",         action = act.QuitApplication },
		{ key = "[",         mods = "LEADER",     desc = "Split vertical",           action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "]",         mods = "LEADER",     desc = "Split horizontal",         action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "[",         mods = "LEADER|ALT", desc = "Split vertical (WSL)",     action = act.SplitVertical({ args = { "wsl.exe", "-d", "Ubuntu" } }) },
		{ key = "]",         mods = "LEADER|ALT", desc = "Split horizontal (WSL)",   action = act.SplitHorizontal({ args = { "wsl.exe", "-d", "Ubuntu" } }) },
		{ key = "LeftArrow", mods = "ALT",        desc = "Focus pane left",          action = act.ActivatePaneDirection("Left") },
		{ key = "RightArrow",mods = "ALT",        desc = "Focus pane right",         action = act.ActivatePaneDirection("Right") },
		{ key = "UpArrow",   mods = "ALT",        desc = "Focus pane up",            action = act.ActivatePaneDirection("Up") },
		{ key = "DownArrow", mods = "ALT",        desc = "Focus pane down",          action = act.ActivatePaneDirection("Down") },
		{ key = "LeftArrow", mods = "CTRL|ALT",   desc = "Resize pane left",         action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "RightArrow",mods = "CTRL|ALT",   desc = "Resize pane right",        action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "UpArrow",   mods = "CTRL|ALT",   desc = "Resize pane up",           action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "DownArrow", mods = "CTRL|ALT",   desc = "Resize pane down",         action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "z",         mods = "ALT",        desc = "Toggle pane zoom",         action = act.TogglePaneZoomState },
		{ key = "s",         mods = "ALT",        desc = "Swap pane",                action = act.PaneSelect({ mode = "SwapWithActive" }) },
		{ key = "w",         mods = "LEADER",     desc = "Close pane",               action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "t",         mods = "CTRL|SHIFT", desc = "New tab",                  action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "Tab",       mods = "CTRL",       desc = "Next tab",                 action = act.ActivateTabRelative(1) },
		{ key = "Tab",       mods = "CTRL|SHIFT", desc = "Previous tab",             action = act.ActivateTabRelative(-1) },
		{ key = "W",         mods = "CTRL|SHIFT", desc = "Show workspaces",          action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
		{ key = "1",         mods = "CTRL",       desc = "Go to tab 1",              action = act.ActivateTab(0) },
		{ key = "2",         mods = "CTRL",       desc = "Go to tab 2",              action = act.ActivateTab(1) },
		{ key = "3",         mods = "CTRL",       desc = "Go to tab 3",              action = act.ActivateTab(2) },
		{ key = "4",         mods = "CTRL",       desc = "Go to tab 4",              action = act.ActivateTab(3) },
		{ key = "5",         mods = "CTRL",       desc = "Go to tab 5",              action = act.ActivateTab(4) },
		{ key = "6",         mods = "CTRL",       desc = "Go to tab 6",              action = act.ActivateTab(5) },
		{ key = "7",         mods = "CTRL",       desc = "Go to tab 7",              action = act.ActivateTab(6) },
		{ key = "8",         mods = "CTRL",       desc = "Go to tab 8",              action = act.ActivateTab(7) },
		{ key = "9",         mods = "CTRL",       desc = "Go to last tab",           action = act.ActivateTab(-1) },
		{ key = ",",         mods = "CTRL",       desc = "Search",                   action = act.Search("CurrentSelectionOrEmptyString") },
		{ key = "c",         mods = "CTRL|SHIFT", desc = "Copy mode",                action = act.ActivateCopyMode },
		{ key = "=",         mods = "CTRL",       desc = "Increase font size",       action = act.IncreaseFontSize },
		{ key = "-",         mods = "CTRL",       desc = "Decrease font size",       action = act.DecreaseFontSize },
		{ key = "0",         mods = "CTRL",       desc = "Reset font size",          action = act.ResetFontSize },
		{ key = "PageUp",    mods = "SHIFT",      desc = "Scroll page up",           action = act.ScrollByPage(-1) },
		{ key = "PageDown",  mods = "SHIFT",      desc = "Scroll page down",         action = act.ScrollByPage(1) },
		{ key = "p",         mods = "CTRL|SHIFT", desc = "Command palette",          action = act.ActivateCommandPalette },
		{ key = "/",         mods = "LEADER",     desc = "Show this key list",       action = "placeholder" },
	}
end

function M.apply(config, act)
	config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

	config.mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = act.PasteFrom("Clipboard"),
		},
	}

	local defs = build_defs(act)

	-- Build InputSelector choices
	local choices = {}
	for _, def in ipairs(defs) do
		table.insert(choices, {
			id = def.key,
			label = string.format("%-24s  %s", def.mods .. " + " .. def.key, def.desc),
		})
	end

	local help_action = act.InputSelector({
		title = "Keybindings",
		choices = choices,
		fuzzy = true,
		action = wezterm.action_callback(function() end),
	})

	-- Build config.keys, substituting the help placeholder
	local keys = {}
	for _, def in ipairs(defs) do
		table.insert(keys, {
			key = def.key,
			mods = def.mods,
			action = def.action == "placeholder" and help_action or def.action,
		})
	end

	config.keys = keys
end

return M
