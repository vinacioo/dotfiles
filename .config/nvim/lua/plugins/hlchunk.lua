return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	enabled = false,
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = false,
			},
			line_num = {
				enable = false,
			},
			indent = {
				enable = false,
			},
		})
	end,
}
