return {
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
     -- stylua: ignore
     pattern = { 'help', 'alpha', 'dashboard', 'NvimTree', 'Trouble', 'lazy', 'mason' },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#30343a" })
    end,
  },
}
