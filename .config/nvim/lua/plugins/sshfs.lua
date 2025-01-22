return {
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = {
      "RemoteSSHFSConnect",
      "RemoteSSHFSDisconnect",
      "RemoteSSHFSEdit",
      "RemoteSSHFSFindFiles",
      "RemoteSSHFSLiveGrep",
    },
    keys = {
      {
        "<Leader>rc",
        function()
          require("remote-sshfs.api").connect()
        end,
        desc = "Remote SSH Connect",
        noremap = true,
      },
      {
        "<Leader>rd",
        function()
          require("remote-sshfs.api").disconnect()
        end,
        desc = "Remote SSH Disconnect",
        noremap = true,
      },
    },
    config = function()
      require("remote-sshfs").setup({
        connections = {
          ssh_configs = {
            vim.fn.expand("~") .. "/.ssh/config",
          },
        },
        log = {
          enable = true, -- enable logging
          truncate = true, -- truncate logs
          types = { -- enabled log types
            all = true,
            util = true,
            handler = true,
            sshfs = true,
          },
        },
      })
      require("telescope").load_extension("remote-sshfs")
    end,
  },
}
