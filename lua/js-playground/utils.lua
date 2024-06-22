local config = require("js-playground.config")
local M = {}

---@param icon string
---@param msg string
---@param type integer
M.notify = function(icon, msg, type)
	local defaults = { icon = icon, timeout = 500, render = "compact" }
	---@diagnostic disable-next-line
	vim.notify.dismiss()
	vim.notify(msg, type, defaults)
end

M.set_status = function(new_status)
	config.status = new_status
end

return M
