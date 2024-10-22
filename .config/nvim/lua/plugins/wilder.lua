return {
	"gelguy/wilder.nvim",
	event = "CmdlineEnter",
	config = function()
		local wilder = require("wilder")
		wilder.setup({ modes = { ":", "/", "?" } })
		wilder.set_option("use_python_remote_plugin", 0)

		wilder.set_option("pipeline", {
			wilder.branch(
				wilder.cmdline_pipeline({
					language = "vim",
					fuzzy = 2,
				}),
				wilder.search_pipeline({
					pattern = wilder.python_fuzzy_pattern(),
					sorter = wilder.python_difflib_sorter(),
					engine = "re",
				})
			),
		})
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer({
				highlighter = wilder.basic_highlighter(),
				left = { " ", wilder.popupmenu_devicons() },
				right = { " ", wilder.popupmenu_scrollbar() },
			})
		)
	end,
}
