return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"echasnovski/mini.icons",
	},
	config = function()
		require("nvim-tree").setup({
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = {
					enable = true,
				},
			},
			hijack_cursor = true,
			renderer = {
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						bottom = "─",
						none = " ",
					},
				},
			},
		})
	end,
	keys = {
		{
			"<C-n>",
			":NvimTreeToggle<CR>",
			mode = "n",
			silent = true,
			desc = "Toggle Nvim Tree",
		},
	},
}
