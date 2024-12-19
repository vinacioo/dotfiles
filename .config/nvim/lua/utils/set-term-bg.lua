local M = {}

local modified = false

local function update_alacritty_background(color)
  local alacritty_config_path = os.getenv("HOME") .. "/.config/alacritty/alacritty.toml"
  local alacritty_config = vim.fn.readfile(alacritty_config_path)
  local in_colors_primary = false
  for i, line in ipairs(alacritty_config) do
    if line:match("^%[colors.primary%]") then
      in_colors_primary = true
    elseif line:match("^%[") then
      in_colors_primary = false
    end
    if in_colors_primary and line:match("^background =") then
      alacritty_config[i] = "background = '" .. color .. "'"
      break
    end
  end
  vim.fn.writefile(alacritty_config, alacritty_config_path)
  -- vim.notify("Updated Alacritty background to: " .. color, vim.log.levels.INFO)
end

M.setup = function()
  vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    callback = function()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      if normal and normal.bg then
        local hex_color = string.format("#%06x", normal.bg)
        -- vim.notify("Hex Color from Neovim: " .. hex_color, vim.log.levels.INFO)
        update_alacritty_background(hex_color)
        modified = true
      else
        vim.notify("Failed to get background color from Neovim", vim.log.levels.ERROR)
      end
    end,
  })

  vim.api.nvim_create_autocmd("UILeave", {
    callback = function()
      if modified then
        update_alacritty_background("#101010")
      end
    end,
  })
end

return M
