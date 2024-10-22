return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local configs = require("nvim-treesitter.configs")

		---@diagnostic disable-next-line: missing-fields
		configs.setup({
			-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
			ensure_installed = {
				"bash",
				"css",
				"dockerfile",
				"gitignore",
				"html",
				"http",
				"hurl",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"scss",
				"scss",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			additional_vim_regex_highlightning = false,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-j>",
					node_incremental = "<C-j>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
