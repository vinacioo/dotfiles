return {
	"linux-cultist/venv-selector.nvim",
	ft = "python",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python", --optional
		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
	},
	lazy = false,
	branch = "regexp", -- This is the regexp branch, use this for the new version
	config = function()
		require("venv-selector").setup({
			debug = true,
			fd_binary_name = "fdfind",
			dap_enabled = true,
			notify_user_on_venv_activation = true,
		})
	end,
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Activate venv" },
		{
			"<leader>vd",
			function()
				require("venv-selector").deactivate()
				vim.cmd("redrawstatus")
			end,
			desc = "Deactivate venv",
		},
	},
}
