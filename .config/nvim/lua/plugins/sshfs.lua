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
          vim.api.nvim_feedkeys(":RemoteSSHFSConnect ", "n", false)
        end,
        desc = "Prompt for RemoteSSHFSConnect command",
        noremap = true,
        silent = true,
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
        ui = {
          select_prompts = false,
          confirm = {
            connect = false,
            change_dir = false,
          },
        },
        log = {
          enable = true,
          truncate = true,
          types = {
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
