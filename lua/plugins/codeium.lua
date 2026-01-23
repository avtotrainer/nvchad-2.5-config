-- ~/.config/nvim/lua/plugins/codeium.lua
return {
  -- 1) Windsurf (Codeium)
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    event = "InsertEnter",
    config = function()
      require("configs.codeium")
    end,
  },

  -- 2) nvim-cmp source list-ში codeium-ის დამატება
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, 1, { name = "codeium" })
      return opts
    end,
  },
}

