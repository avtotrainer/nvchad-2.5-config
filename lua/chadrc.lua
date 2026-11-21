-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "kanagawa",
  transparency = true,
  statusline = {
    theme = "vscode_colored",
  },
  nvdash = {
    load_on_startup = true,
    header = {
      "██████╗ ██╗   ██╗██████╗ ██████╗ ██╗     ███████╗",
      "██╔══██╗██║   ██║██╔══██╗██╔══██╗██║     ██╔════╝",
      "██████╔╝██║   ██║██████╔╝██████╔╝██║     █████╗  ",
      "██╔═══╝ ██║   ██║██╔══██╗██╔═══╝ ██║     ██╔══╝  ",
      "██║     ╚██████╔╝██║  ██║██║     ███████╗███████╗",
      "╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚══════╝╚══════╝",
    },
  },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    DiffChange = {
      bg = "#464414",
      fg = "none",
    },
    DiffAdd = {
      bg = "#103507",
      fg = "none",
    },
    DiffRemoved = {
      bg = "#461414",
      fg = "none",
    },
  },
}

-- :MasonInstallAll LSP-ებს მხოლოდ მაშინ ხედავს, როცა lspconfig უკვე ჩატვირთულია
-- (ფაილის გახსნის შემდეგ), ამიტომ Windows-ზე სია აქ ცხადადაა.
-- NixOS-ზე ეს ხელსაწყოები nix-იდან მოდის.
if vim.fn.has("win32") == 1 then
  local pkgs = {
    "lua-language-server",
    "pyright",
    "ruff",
    "typescript-language-server",
    "html-lsp",
    "css-lsp",
    "clangd",
  }
  local skip = {}
  if vim.fn.executable("go") == 1 then
    table.insert(pkgs, "gopls")
  else
    skip = { "gopls" } -- Mason-ის gopls-ს Go სჭირდება (install.ps1 -WithGo)
  end
  M.mason = { pkgs = pkgs, skip = skip }
end

return M
