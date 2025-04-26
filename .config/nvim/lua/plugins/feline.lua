return {
  "vinacioo/feline.nvim",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  opts = {
    force_inactive = {
      filetypes = {
        "^dapui_*",
        "^help$",
        "^neotest*",
        "^NvimTree$",
        "^qf$",
      },
    },
    disable = { filetypes = { "^alpha$" } },
  },
  config = function()
    local present, feline = pcall(require, "feline")

    if not present then
      return
    end

    local color = {
      bg_0 = "#202327",
      bg_1 = "#30343a",
      gray_0 = "#40464e",
      gray_1 = "#42464c",
      gray_2 = "#505861",
      gray_3 = "#606975",
      white_darker = "#bdae93",
      white_medium = "#d5c4a1",
      white_lighter_1 = "#ebdbb2",
      white_lighter = "#fbf1c7",
      red = "#fb4934",
      orange = "#fe8019",
      yellow = "#fabd2f",
      green_lime = "#b8bb26",
      green = "#8ec07c",
      blue = "#83a598",
      cyan = "#70C0BA",
      magenta = "#d3869b",
      purple = "#C397D8",
      orange_lighter = "#d65d0e",
    }

    local icons = {
      diagnostic = {
        error = "  ",
        warn = "  ",
        hint = "  ",
        info = "  ",
      },
      diff = {
        added = " ",
        changed = " ",
        removed = " ",
      },
      separators = {
        left_round = "",
        right_round = "",
        square = "▊",
        right = "",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",
      },
    }

    local mode_alias = {
      ["n"] = "NORMAL",
      ["no"] = "OP",
      ["nov"] = "OP",
      ["noV"] = "OP",
      ["no"] = "OP",
      ["niI"] = "NORMAL",
      ["niR"] = "NORMAL",
      ["niV"] = "NORMAL",
      ["nt"] = "NORMAL",
      ["v"] = "VISUAL",
      ["V"] = "LINES",
      [""] = "BLOCK",
      ["s"] = "SELECT",
      ["S"] = "SELECT",
      [""] = "BLOCK",
      ["i"] = "INSERT",
      ["ic"] = "INSERT",
      ["ix"] = "INSERT",
      ["R"] = "REPLACE",
      ["Rc"] = "REPLACE",
      ["Rv"] = "V-REPLACE",
      ["Rx"] = "REPLACE",
      ["c"] = "COMMAND",
      ["cv"] = "COMMAND",
      ["ce"] = "COMMAND",
      ["r"] = "ENTER",
      ["rm"] = "MORE",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      ["t"] = "TERM",
      ["null"] = "NONE",
    }

    local vi_mode_colors = {
      ["NORMAL"] = color.green,
      ["OP"] = color.blue,
      ["INSERT"] = color.cyan,
      ["VISUAL"] = color.yellow,
      ["LINES"] = color.red,
      ["BLOCK"] = color.orange,
      ["REPLACE"] = color.purple,
      ["V-REPLACE"] = color.magenta,
      ["ENTER"] = color.magenta,
      ["MORE"] = color.magenta,
      ["SELECT"] = color.red,
      ["SHELL"] = color.cyan,
      ["TERM"] = color.green,
      ["NONE"] = color.gray_2,
      ["COMMAND"] = color.blue,
    }

    -- Set transparency for NvimTree's non-current statusline
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "#ffffff" }) -- Terminal background color

    -- Navic Setup
    vim.g.navic_available = true
    vim.g.navic_silence = true

    local navic_present, navic = pcall(require, "nvim-navic")
    if navic_present then
      navic.setup({
        separator = " > ",
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("NavicLspAttach", { clear = true }),
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          navic.attach(client, buffer)
        end,
      })
    else
      vim.g.navic_available = false
    end

    local component = {}

    local function get_vim_mode()
      local mode = vim.api.nvim_get_mode().mode
      if mode then
        return mode_alias[mode]
      end
    end

    local function get_mode_color()
      local mode = get_vim_mode()
      if mode then
        return vi_mode_colors[mode]
      end
    end

    component.vi_mode = {
      provider = function()
        local mode = get_vim_mode()
        mode = mode or "TERM"
        if mode then
          return "  " .. mode .. " "
        end
      end,
      hl = function()
        return {
          fg = color.bg_0,
          bg = get_mode_color(),
          style = "bold",
        }
      end,
    }

    component.vi_mode_sep = {
      provider = icons.separators.right,
      hl = function()
        return {
          fg = get_mode_color(),
          bg = color.bg_1,
        }
      end,
    }

    component.git_branch = {
      provider = "git_branch",
      icon = " ",
      hl = {
        fg = color.gray_2,
        bg = color.bg_0,
      },
      left_sep = "block",
      right_sep = "",
    }

    component.file_info = {
      provider = "file_info",
      hl = {
        fg = color.white_darker,
      },
      left_sep = "block",
    }

    component.diagnostic_errors = {
      provider = "diagnostic_errors",
      hl = {
        fg = color.red,
        bg = color.gray_1,
      },
    }

    component.diagnostic_warnings = {
      provider = "diagnostic_warnings",
      hl = {
        fg = color.yellow,
        bg = color.gray_1,
      },
    }

    component.diagnostic_hints = {
      provider = "diagnostic_hints",
      hl = {
        fg = color.cyan,
        bg = color.gray_1,
      },
    }

    component.diagnostic_info = {
      provider = "diagnostic_info",
      hl = {
        fg = color.white_darker,
        bg = color.gray_1,
      },
    }

    component.lsp = {
      provider = "lsp_client_names",
      hl = {
        fg = color.white_darker,
        bg = color.gray_1,
      },
    }

    component.position = {
      provider = "position",
      left_sep = "block",
      right_sep = "block",
      hl = {
        fg = color.white_darker,
        bg = color.bg_0,
      },
    }

    component.line_percentage = {
      provider = "line_percentage",
      hl = {
        fg = color.white_darker,
        bg = color.bg_0,
      },
      left_sep = "block",
      right_sep = "block",
    }

    component.total_lines = {
      provider = function()
        return "%L"
      end,
      hl = {
        fg = color.white_darker,
        bg = color.bg_0,
      },
      left_sep = "block",
      right_sep = "block",
    }

    component.scroll_bar = {
      provider = "scroll_bar",
      hl = {
        fg = color.white_darker,
        style = "bold",
      },
    }

    component.git_add = {
      provider = "git_diff_added",
      hl = {
        fg = color.green,
      },
      left_sep = "",
      right_sep = "",
    }

    component.git_delete = {
      provider = "git_diff_removed",
      hl = {
        fg = color.red,
      },
      left_sep = "",
      right_sep = "",
    }

    component.git_change = {
      provider = "git_diff_changed",
      hl = {
        fg = color.magenta,
      },
      left_sep = "",
      right_sep = "",
    }

    component.separator = {
      provider = " ",
      hl = {
        fg = color.gray_1,
        bg = color.gray_1,
      },
    }
    component.separator_mode_right_bg = {
      provider = "",
      hl = {
        fg = color.bg_1,
        bg = color.bg_0,
      },
    }

    component.separator_lsp_left_0 = {
      provider = "",
      hl = {
        fg = color.bg_1,
        bg = color.bg_0,
      },
    }

    component.separator_lsp_left_1 = {
      provider = "",
      hl = {
        fg = color.gray_1,
        bg = color.bg_1,
      },
    }

    component.separator_lsp_right_0 = {
      provider = "",
      hl = {
        fg = color.gray_1,
        bg = color.bg_1,
      },
    }

    component.separator_lsp_right_1 = {
      provider = "",
      hl = {
        fg = color.bg_1,
        bg = color.bg_0,
      },
    }

    component.file_type = {
      provider = {
        name = "file_type",
        opts = {
          filetype_icon = true,
          case = "lowercase",
        },
      },
      hl = {
        fg = color.white_darker,
      },
      left_sep = "block",
      right_sep = "block",
    }

    -- Add Navic Provider
    component.navic_position = {
      provider = function()
        if vim.g.navic_available then
          return navic.get_location()
        end
      end,
      enabled = function()
        return navic.is_available()
      end,
      hl = {
        fg = color.cyan,
        bg = color.bg_0,
      },
      left_sep = "block",
    }

    -- Venv component
    component.venv = {
      provider = function()
        -- Only display for Python files
        if vim.bo.filetype ~= "python" then
          return ""
        end

        local venv = vim.fn.getenv("VIRTUAL_ENV")
        -- Hide the component completely if no virtual environment is active
        if venv and venv ~= vim.NIL and venv ~= "" then
          local venv_parts = vim.fn.split(venv, "/")
          local venv_name = venv_parts[#venv_parts]
          return "%#VenvIcon#(venv: %#VenvText#" .. venv_name .. "%#VenvIcon#)"
          -- return "%#VenvIcon#%#VenvText# " .. venv_name
        else
          return "" -- Hide when no venv is active
        end
      end,
      hl = function()
        return {
          fg = color.white_darker,
          bg = color.bg_0,
        }
      end,
      left_sep = "block",
      -- right_sep = "block",
      -- on_click = function()
      -- 	require("venv-selector").open()
      -- end,
    }

    -- Selected Lines
    component.selected_lines = {
      provider = function()
        local mode = vim.fn.mode()
        if mode == "v" or mode == "V" or mode == "\22" then -- Visual, Visual Line, Visual Block
          local start_line = vim.fn.line("v")
          local end_line = vim.fn.line(".")
          local count = math.abs(end_line - start_line) + 1
          return tostring(count)
        end
        return ""
      end,
      hl = {
        fg = color.red,
        bg = color.bg_0,
      },
      left_sep = "block",
      right_sep = "block",
    }

    -- Define custom highlights for the icon and the text
    vim.api.nvim_set_hl(0, "VenvIcon", { fg = color.green, bg = color.bg_0 })
    vim.api.nvim_set_hl(0, "VenvText", { fg = color.white_darker, bg = color.bg_0 })

    local left = {
      component.vi_mode,
      component.vi_mode_sep,
      component.separator_mode_right_bg,
      component.file_info,
      component.git_branch,
      component.git_add,
      component.git_delete,
      component.git_change,
    }
    local middle = {
      component.navic_position,
    }
    local right = {
      component.venv,
      component.file_type,
      component.separator_lsp_left_0,
      component.separator_lsp_left_1,
      component.lsp,
      component.diagnostic_errors,
      component.diagnostic_warnings,
      component.diagnostic_info,
      component.diagnostic_hints,
      component.separator_lsp_right_0,
      component.separator_lsp_right_1,
      component.position,
      component.selected_lines,
      component.total_lines,
      component.line_percentage,
    }

    local components = {
      active = {
        left,
        middle,
        right,
      },
    }

    feline.setup({
      components = components,
      theme = {
        bg = color.bg_0,
      },
      vi_mode_colors = vi_mode_colors,
    })
  end,
}
