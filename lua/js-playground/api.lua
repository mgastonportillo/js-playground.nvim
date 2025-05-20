local utils = require("js-playground.utils")
local config = require("js-playground.config")
local M = {}

local winnr = nil
local bufnr = nil

---@type fun(): integer, integer
local function winbuf_handler()
	if bufnr and winnr and vim.api.nvim_win_is_valid(winnr) then
		return winnr, bufnr
	end

	local width = vim.o.columns
	local height = vim.o.lines

	local win_width = math.floor(width * 0.45)
	local win_height = height - 2

	local opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = 1,
		col = width - win_width,
		style = "minimal",
		border = "single",
	}

	bufnr = vim.api.nvim_create_buf(false, true)
	winnr = vim.api.nvim_open_win(bufnr, false, opts)

	return winnr, bufnr
end

local is_supported_filetype = function()
	local supported_ft = { "javascript", "mjs", "cjs", "typescript" }
	for _, ft in ipairs(supported_ft) do
		if vim.bo.ft == ft then
			return true
		end
	end
	return false
end

local is_version_gte = function(v1, v2)
	for i = 1, math.max(#v1, #v2) do
		local n1 = v1[i] or 0
		local n2 = v2[i] or 0
		if n1 > n2 then
			return true
		elseif n1 < n2 then
			return false
		end
	end
	return true
end

local get_typescript_version = function()
	local handle = io.popen("node -v 2>/dev/null")
	if handle then
		local version = handle:read("*a")
		handle:close()
		version:gsub("^v", "")
		return version
	end
	return ""
end

local can_run_typescript = function(v)
	local t = {}
	for num in v:gmatch("%d+") do
		table.insert(t, tonumber(num))
	end
	if is_version_gte(t, { 22, 6, 0 }) then
		return true
	else
		return false
	end
end

local get_typescript_tags = function(v)
	local t = {}
	for num in v:gmatch("%d+") do
		table.insert(t, tonumber(num))
	end
	if is_version_gte(t, { 22, 7, 0 }) then
		return "--experimental-transform-types "
	elseif is_version_gte(t, { 22, 6, 0 }) then
		return "--experimental-strip-types "
	end
	return ""
end

local run_js_code = function()
	if not is_supported_filetype() then
		utils.notify(" ⛔", "JSPlayground: File is not .js, .mjs nor .cjs", vim.log.levels.WARN)
		return
	end

	local ts_arg = ""
	if vim.bo.ft == "typescript" then
		local v = get_typescript_version()
		if can_run_typescript(v) then
			ts_arg = get_typescript_tags(v)
		else
			utils.notify(" ⛔", "JSPlayground: Update your node version to support typescript", vim.log.levels.WARN)
			return
		end
	end

	utils.set_status(true)
	local current_file = vim.fn.expand("%:p")
	local start_time = vim.uv.hrtime()
	local cmd = "node " .. ts_arg .. current_file .. " 2>&1"
	local output = vim.fn.system(cmd)
	local end_time = vim.uv.hrtime()
	local elapsed_ms = (end_time - start_time) / 1e6 -- it's nanoseconds
	local _, buf = winbuf_handler()
	vim.g.jsplayground_buf = buf

	vim.api.nvim_buf_set_lines(buf, 0, 1, false, { string.format("Execution time: %.2f ms", elapsed_ms), "" })
	vim.api.nvim_buf_set_lines(buf, 2, -1, false, vim.split(output, "\n"))

	if vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "jsplayground" then
		vim.api.nvim_set_option_value("filetype", "jsplayground", { buf = buf })
	end
end

local close_window = function()
	if winnr and vim.api.nvim_win_is_valid(winnr) then
		vim.api.nvim_win_close(winnr, true)
	end
	utils.set_status(false)
end

M.get_status = function()
	return config.status
end

M.run = function()
	run_js_code()
end

M.stop = function()
	close_window()
end

return M
