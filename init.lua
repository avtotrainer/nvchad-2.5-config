-- LuaRocks local path setup (for jsregexp etc.)
pcall(function()
	local rocks_path = vim.fn.expand("~/.luarocks/share/lua/5.1/?.lua;~/.luarocks/share/lua/5.1/?/init.lua")
	local rocks_cpath = vim.fn.expand("~/.luarocks/lib/lua/5.1/?.so")
	if not string.find(package.path, rocks_path, 1, true) then
		package.path = package.path .. ";" .. rocks_path
	end
	if not string.find(package.cpath, rocks_cpath, 1, true) then
		package.cpath = package.cpath .. ";" .. rocks_cpath
	end
end)

vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
		config = function()
			require("options")
		end,
	},

	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("nvchad.autocmds")
require("configs.cmpconfig")
vim.schedule(function()
	require("mappings")
end)
