return {
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({})
		end,
	},
	{
		"lewis6991/satellite.nvim",
		event = "BufEnter",
		dependencies = {
			"lewis6991/gitsigns.nvim",
		},
		config = function()
			require("satellite").setup({})
		end,
	},
}
