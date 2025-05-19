local api = require("js-playground.api")
local config = require("js-playground.config")
local cmd = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local M = {}

local create_cmds = function()
	cmd("JSPlayground", function(opts)
		local arg = opts.fargs[1]

		if arg == nil or arg == "run" then
			api.run()
			return
		end

		if arg == "stop" then
			api.stop()
			return
		end
	end, {
		desc = "Run JSPlayground",
		nargs = "?",
		complete = function(ArgLead, CmdLine, CursorPos) ---@diagnostic disable-line
			return { "run", "stop" }
		end,
	})
end

local create_autocmds = function()
	autocmd("BufModifiedSet", {
		pattern = { "*.js", "*.mjs", "*.cjs", "*.ts" },
		desc = "Update playground on file write if playground is open",
		group = vim.api.nvim_create_augroup("JSPlaygroundUpdater", { clear = false }),
		callback = function()
			if api.get_status() then
				api.run()
			end
		end,
	})
end

M.setup = function(opts)
	config.setup(opts)
	create_autocmds()
	create_cmds()
end

return M
