return {
	"sindrets/diffview.nvim",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<leader>dv", "<CMD>DiffviewOpen<CR>", mode = { "n" }, desc = "Toggle diff view" },
	},
	config = {
		keymaps = {
			view = {
				["<leader>dv"] = "<CMD>DiffviewClose<CR>",
			},
			file_panel = {
				["<leader>dv"] = "<CMD>DiffviewClose<CR>",
			},
		},
	},

	-- https://www.reddit.com/r/neovim/comments/n2vww8/comment/gwnahs3/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	-- Telescope to specific commit
	-- local action_state = require("telescope.actions.state")
	--
	-- local open_dif = function()
	--     local selected_entry = action_state.get_selected_entry()
	--     local value = selected_entry["value"]
	--     -- close Telescope window properly prior to switching windows
	--     vim.api.nvim_win_close(0, true)
	--     local cmd = "DiffviewOpen " .. value
	--     vim.cmd(cmd)
	-- end
	--
	-- local git_commit = function()
	--     require("telescope.builtin").git_commits({
	--         attach_mappings = function(_, map)
	--             map("n", "<c-o>", open_dif)
	--             return true
	--         end,
	--     })
	-- end
}
