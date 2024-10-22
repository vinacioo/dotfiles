return {
	"stevearc/aerial.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>o", "<cmd>AerialToggle<cr>", desc = "Toggle code outline window" },
	},
	opts = {
		attach_mode = "global",
		backends = { "lsp", "treesitter", "markdown", "man" },
		layout = { min_width = 28 },
		manage_folds = true,
		link_folds_to_tree = true,
		link_tree_to_folds = true,
		show_guides = true,
		filter_kind = false,
		autojump = true,
		guides = {
			mid_item = "├ ",
			last_item = "└ ",
			nested_top = "│ ",
			whitespace = "  ",
		},
	},
}
