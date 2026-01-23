-- lua/plugins/codeium.lua
-- Codeium/Windsurf integration for NvChad (lazy.nvim)
-- Nix-friendly: we will store auth token/config under stdpath("state").

local function has_source(sources, name)
  for _, src in ipairs(sources or {}) do
    if src.name == name then
      return true
    end
  end
  return false
end

return {
  {
    "Exafunction/windsurf.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("configs.codeium").setup()
    end,
  },

  -- Ensure codeium appears as a cmp source (top priority)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}

      if not has_source(opts.sources, "codeium") then
        table.insert(opts.sources, 1, { name = "codeium" })
      end

      return opts
    end,
  },
}
-- lua/plugins/codeium.lua
-- Codeium/Windsurf integration for NvChad (lazy.nvim)
-- Nix-friendly: we will store auth token/config under stdpath("state").

local function has_source(sources, name)
  for _, src in ipairs(sources or {}) do
    if src.name == name then
      return true
    end
  end
  return false
end

return {
  {
    "Exafunction/windsurf.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("configs.codeium").setup()
    end,
  },

  -- Ensure codeium appears as a cmp source (top priority)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}

      if not has_source(opts.sources, "codeium") then
        table.insert(opts.sources, 1, { name = "codeium" })
      end

      return opts
    end,
  },
}

