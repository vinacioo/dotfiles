return {
	-- LSP Renaming
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
		keys = function()
			vim.keymap.set("n", "<leader>rn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })
		end,
	},
	-- Search and Replace
	{
		"cshuaimin/ssr.nvim",
		keys = {
			{
				"<leader>rs",
				function()
					require("ssr").open()
				end,
				mode = { "n", "x" },
				desc = "Structural Replace",
			},
		},
	},
}
