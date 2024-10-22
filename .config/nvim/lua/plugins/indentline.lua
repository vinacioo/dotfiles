return {
	"lukas-reineke/indent-blankline.nvim",
	enabled = false,
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "│",
			tab_char = "│",
		},
		scope = { enabled = false },
			-- stylua: ignore
			exclude = {
				filetypes = { 'help', 'alpha', 'dashboard', 'NvimTree', 'Trouble', 'lazy', 'mason' },
			},
	},
}
