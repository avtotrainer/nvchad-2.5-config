-- ~/.config/nvim/lua/configs/codeium.lua
local M = {}

M.setup = function()
  require("codeium").setup({
    -- NixOS-თვის wrapper (თუ steam-run PATH-შია)
    wrapper = vim.fn.exepath("steam-run") ~= "" and "steam-run" or nil,

    -- cmp source default-ად true-ა, მაგრამ აქაც შეიძლება დაფიქსირება
    enable_cmp_source = true,

    -- სურვილისამებრ inline (virtual text) მინიშნებები
    virtual_text = {
      enabled = true,
      manual = false,
      map_keys = true,

      -- Tab-ის ნაცვლად სხვა accept ღილაკი (კონფლიქტის თავიდან ასარიდებლად)
      key_bindings = {
        accept = "<C-g>",
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
  })
end

return setmetatable({}, {
  __call = function()
    M.setup()
  end,
})

