local M = {}

local modified = false

-- Function to update only the background color in wezterm.lua
local function update_wezterm_background(color)
	local wezterm_config_path = os.getenv("HOME") .. "/.config/wezterm/wezterm.lua"
	local wezterm_config = vim.fn.readfile(wezterm_config_path)

	local in_colors = false
	for i, line in ipairs(wezterm_config) do
		-- Check if we're in the config.colors section
		if line:match("^config%.colors = {") then
			in_colors = true
		elseif line:match("^}") and in_colors then
			in_colors = false
		end
		-- Update the background line only within the colors section
		if in_colors and line:match("^%s*background =") then
			wezterm_config[i] = string.format("    background = '%s',", color)
			break
		end
	end

	-- Write the updated content back to wezterm.lua
	vim.fn.writefile(wezterm_config, wezterm_config_path)
	print("Updated WezTerm background to:", color)
end

M.setup = function()
	vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
		callback = function()
			local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
			if normal and normal.bg then
				local hex_color = string.format("#%06x", normal.bg)
				update_wezterm_background(hex_color)
				modified = true
			else
				vim.notify("Failed to get background color from Neovim", vim.log.levels.ERROR)
			end
		end,
	})

	vim.api.nvim_create_autocmd("UILeave", {
		callback = function()
			if modified then
				update_wezterm_background("#101010") -- Default background color on exit
			end
		end,
	})
end

return M
