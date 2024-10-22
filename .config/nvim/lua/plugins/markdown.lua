return {
	{
		"MeanderingProgrammer/markdown.nvim",
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
			"norg",
		},
		name = "render-markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("render-markdown").setup({})
			-- Custom configuration for markdown files
			vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "FileType" }, {
				pattern = "markdown",
				callback = function()
					-- Set indent settings
					vim.opt_local.shiftwidth = 2
					vim.opt_local.tabstop = 2

					-- Enable spell checking for pt and en languages
					vim.opt_local.spell = true
					vim.opt_local.spelllang = { "pt", "en" }

					-- Highlight misspelling
					vim.api.nvim_set_hl(0, "SpellBad", {
						sp = "#ffff00",
						underline = true,
					})
				end,
			})
		end,
	},
	{
		"bullets-vim/bullets.vim",
		ft = "markdown",
		init = function()
			vim.g.bullets_checkbox_markers = " -x"
		end,
	},
	{
		"hedyhli/outline.nvim",
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
			"norg",
		},
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {},
	},
	{
		"lukas-reineke/headlines.nvim",
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
			"norg",
		},
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true, -- or `opts = {}`
	},
	{
		"toppair/peek.nvim",
		ft = "markdown",
		opts = {
			app = "browser",
		},
		build = "deno task --quiet build:fast",
		keys = {
			{
				"<leader>mp",
				function()
					require("peek").open()
				end,
				desc = "Open live preview",
			},
		},
	},
}
