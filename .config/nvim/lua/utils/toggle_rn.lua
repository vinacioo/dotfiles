local M = {}

M.toggle_number_mode = function()
	if vim.opt.relativenumber:get() then
		-- If relative number is on, switch to absolute numbering
		vim.opt.number = true
		vim.opt.relativenumber = false
	else
		-- If relative number is off, switch to relative numbering
		vim.opt.number = true
		vim.opt.relativenumber = true
	end
end

return M
