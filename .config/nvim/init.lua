require("config.options")
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
require("config.lazy")
-- (method 2, for non lazyloaders) to load all highlights at once
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
require("config.autocmds")
require("config.keymaps")

-- Set terminal background
-- require("utils.set-terminal-bg-wez").setup()
