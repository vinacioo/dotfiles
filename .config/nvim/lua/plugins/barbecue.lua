return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	ft = "json",
	event = { "BufReadPost", "BufReadPre", "BufNewFile" },
	version = "*",
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local barbecue = require("barbecue")
		local ui = require("barbecue.ui")

		barbecue.setup({
			show_dirname = false,
			show_basename = false,
			exclude_filetypes = { "netrw", "toggleterm" },
		})

		ui.toggle(false)
	end,
	keys = {
		{
			"<leader>tw",
			function()
				require("barbecue.ui").toggle()
			end,
			desc = "Toggle barbecue winbar",
		},
	},
}
