vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("utils.set-term-bg").setup()

-- (method 2, for non lazyloaders) to load all highlights at once
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end
