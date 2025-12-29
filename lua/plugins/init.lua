-- vim.opt.rtp:append("~/.config/nvim/lua/custom-neotest-jest/lua")
-- vim.opt.runtimepath:append("~/.config/nvim/lua/custom-neotest-jest/lua")
return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("configs.conform")
		end,
	},

	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
	},

	{
		"stevearc/dressing.nvim",
		lazy = false,
		opts = {},
	},

	{ "nvim-neotest/nvim-nio" },

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"typescript",
				"javascript",
				"go",
				"python",
				"markdown",
				"markdown_inline",
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		config = function()
			require("configs.lint")
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "jest.config.ts",
						env = { CI = true },
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			{ dir = vim.fn.stdpath("config") .. "/lua/custom-neotest-jest", name = "neotest-jest" },
		},
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			local ok, dap = pcall(require, "dap")
			if not ok then
				return
			end

			dap.configurations.typescript = {
				{
					type = "node2",
					name = "node attach",
					request = "attach",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
				},
			}

			dap.adapters.node2 = {
				type = "executable",
				command = "node-debug2-adapter",
				args = {},
			}
		end,
		dependencies = {
			"mxsdev/nvim-dap-vscode-js",
		},
	},

	{
		"rcarriga/nvim-dap-ui",
		config = function()
			require("dapui").setup()

			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},

	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				library = {
					plugins = { "nvim-dap-ui" },
					types = true,
				},
			})
		end,
	},

	{ "tpope/vim-fugitive" },

	{
		"rbong/vim-flog",
		dependencies = { "tpope/vim-fugitive" },
		lazy = false,
	},

	{ "sindrets/diffview.nvim", lazy = false },

	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			local leap = require("leap")
			leap.opts.safe_labels = "sfnut/"
			leap.opts.labels = "sfnut/SFNLHMUGTZ?"
			leap.add_default_mappings() -- ❌ depricated, ამიტომ:
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
		end,
	},

	{ "kevinhwang91/nvim-bqf", lazy = false },

	{
		"folke/trouble.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"folke/todo-comments.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup()
		end,
	},

	-- 🔁 Optional fix loader for deprecated vim.tbl_flatten (place this import if needed)
	-- { import = "plugins.neotest-jest-fix" },
}
