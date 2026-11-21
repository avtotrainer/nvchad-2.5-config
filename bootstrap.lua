-- Headless first-run setup, called by install.ps1:
--   nvim --headless -c "luafile bootstrap.lua"
-- Installs treesitter parsers and Mason packages, waits for both, then quits.

local function log(msg)
	io.stdout:write(msg .. "\n")
end

local function finish(code)
	vim.schedule(function()
		vim.cmd((code == 0) and "qa!" or ("cq " .. code))
	end)
end

vim.defer_fn(function()
	local ok, err = pcall(function()
		require("lazy").load({ plugins = { "nvim-treesitter", "nvim-lspconfig", "conform.nvim", "nvim-lint" } })

		-- 1) treesitter parsers (list = merged opts.ensure_installed of the spec)
		local spec = require("lazy.core.config").plugins["nvim-treesitter"]
		local opts = require("lazy.core.plugin").values(spec, "opts", false)
		local parsers = opts.ensure_installed or {}
		log("treesitter: installing " .. table.concat(parsers, ", "))
		require("nvim-treesitter").install(parsers):wait(900000)
		log("treesitter: installed " .. table.concat(require("nvim-treesitter").get_installed(), ", "))

		-- 2) Mason packages (NvChad's :MasonInstallAll)
		local mason = require("nvchad.mason")
		log("mason: installing " .. table.concat(mason.get_pkgs(), ", "))
		vim.api.nvim_create_autocmd("User", {
			pattern = "MasonInstallAllComplete",
			once = true,
			callback = function()
				log("mason: done")
				finish(0)
			end,
		})
		mason.install_all()
	end)

	if not ok then
		log("bootstrap error: " .. tostring(err))
		finish(1)
	end
end, 1000)

-- safety net: never hang forever
vim.defer_fn(function()
	log("bootstrap: timeout")
	finish(2)
end, 1800000)
