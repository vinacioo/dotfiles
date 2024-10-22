return {
	-- Formatting
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>rf",
			function()
				require("conform").format({
					async = true,
					lsp_fallback = true,
				})
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { { "prettierd", "prettier" } },
			sh = { "shfmt" },
			markdown = { "markdownlint", "markdownlint-cli2" },

			["_"] = { "trim_whitespace" },
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = false,
		},

		formatters = {
			shfmt = {
				prepend_args = { "-i", "4" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
