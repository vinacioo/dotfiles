return {
	{
		"kevinhwang91/nvim-bqf",
		lazy = false,
		keys = {
			{
				"<leader>tq",
				function()
					require("utils.toggle_qf").toggle_qf()
				end,
				silent = true,
				noremap = true,
				desc = "Toggle Quickfix",
			},
		},
	},
}
