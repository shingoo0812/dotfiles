local M = {}

function M.apply(config, act)
	config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

	config.mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = act.PasteFrom("Clipboard"),
		},
	}

	config.keys = {
		{
			key = "Enter",
			mods = "ALT",
			action = act.ShowLauncher,
		},
		{
			key = "q",
			mods = "CTRL",
			action = act.QuitApplication,
		},
		-- Pane splits (LEADER prefix avoids conflict with Neovim <C-[>=Escape, <A-[>=resize)
		{
			key = "[",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "]",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "[",
			mods = "LEADER|ALT",
			action = act.SplitVertical({
				args = { "wsl.exe", "-d", "Ubuntu" },
			}),
		},
		{
			key = "]",
			mods = "LEADER|ALT",
			action = act.SplitHorizontal({
				args = { "wsl.exe", "-d", "Ubuntu" },
			}),
		},
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
		{ key = "z", mods = "ALT", action = act.TogglePaneZoomState },
		{ key = "s", mods = "ALT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
		{
			key = "w",
			mods = "LEADER",
			action = act.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "t",
			mods = "CTRL|SHIFT",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
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
		{ key = "1", mods = "CTRL", action = act.ActivateTab(0) },
		{ key = "2", mods = "CTRL", action = act.ActivateTab(1) },
		{ key = "3", mods = "CTRL", action = act.ActivateTab(2) },
		{ key = "4", mods = "CTRL", action = act.ActivateTab(3) },
		{ key = "5", mods = "CTRL", action = act.ActivateTab(4) },
		{ key = "6", mods = "CTRL", action = act.ActivateTab(5) },
		{ key = "7", mods = "CTRL", action = act.ActivateTab(6) },
		{ key = "8", mods = "CTRL", action = act.ActivateTab(7) },
		{ key = "9", mods = "CTRL", action = act.ActivateTab(-1) },
		{
			key = ",",
			mods = "CTRL",
			action = act.Search("CurrentSelectionOrEmptyString"),
		},
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = act.ActivateCopyMode,
		},
		{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = act.ResetFontSize },
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
end

return M
