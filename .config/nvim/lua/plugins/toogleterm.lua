return {
	"akinsho/toggleterm.nvim",
	cmd = { "ToggleTerm", "TermExec" },
	event = { "BufReadPost", "BufNewFile" },
	-- opts = {
	-- 	on_create = function()
	-- 		vim.opt.foldcolumn = "0"
	-- 		vim.opt.signcolumn = "no"
	-- 	end,
	-- },
	config = function()
		require("toggleterm").setup({
			direction = "vertical",
			size = function(term)
				if term.direction == "horizontal" then
					return 20
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.5
				end
			end,
			open_mapping = [[<C-\>]],
			insert_mappings = true,
			terminal_mappings = true,
			hide_numbers = true,
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		})
		-- The below config is not workin yet, it should work for lazygit
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			count = 2,
			direction = "float",
		})

		vim.keymap.set("n", "\\g", function()
			lazygit:toggle()
		end, { noremap = true, silent = true })

		vim.keymap.set("t", "\\g", function()
			lazygit:toggle()
		end, { noremap = true, silent = true })
	end,
	keys = {
		{
			"<M-h>",
			"<cmd>ToggleTerm direction=horizontal name=Terminal<cr>",
			mode = { "n", "t" },
			desc = "ToggleTerm horizontal",
		},
		{
			"<M-f>",
			"<cmd>ToggleTerm direction=float name=Terminal<cr>",
			mode = { "n", "t" },
			desc = "ToggleTerm float",
		},
		{
			"<M-v>",
			"<cmd>ToggleTerm direction=vertical name=Terminal<cr>",
			mode = { "n", "t" },
			desc = "ToggleTerm vertical",
		},
		{ "<ESC>", [[<C-\><C-n>]], mode = "t" },
	},
}
