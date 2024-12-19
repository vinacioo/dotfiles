return {
  {
    -- disable tokyonight for nvchad colorschemes
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- Replace with NvChad's theme loader
        require("nvchad")
      end,
    },
  },
  { "nvim-lualine/lualine.nvim", enabled = false },
  {
    "snacks.nvim",
    opts = {
      indent = { enabled = false },
    },
  },
}
