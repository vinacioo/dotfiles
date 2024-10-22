return {
	"dstein64/vim-startuptime",
	cmd = "StartupTime",
	config = function()
		vim.g.startuptime_tries = 10
	end,
	keys = {
		{
			"<leader><S-t>",
			"<cmd>StartupTime<cr>",
			desc = "Startup time",
		},
	},
}
