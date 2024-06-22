local M = {}

---@type boolean
M.status = false

local defaults = {}

M.options = {}

M.setup = function(opts)
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

return M
