return {
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		branch = "main",
		opts = {
			progress = {
				poll_rate = 0,
				suppress_on_insert = true,
				ignore_done_already = true,
				ignore_empty_message = false,
				display = {
					progress_icon = { pattern = "dots", period = 1 },
				},
			},
			notification = {
				window = {
					normal_hl = "Comment", -- Base highlight group in the notification window
					winblend = 1, -- Background color opacity in the notification window
					border = "none", -- Border around the notification window
					zindex = 45, -- Stacking priority of the notification window
					max_width = 0, -- Maximum width of the notification window
					max_height = 0, -- Maximum height of the notification window
					x_padding = 1, -- Padding from right edge of window boundary
					y_padding = 0, -- Padding from bottom edge of window boundary
					align = "bottom", -- How to align the notification window
					relative = "editor", -- What the notification window position is relative to
				},
			},

			integration = {
				["nvim-tree"] = {
					enable = true,
				},
			},
		},
	},
}
