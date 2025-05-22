-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Helpers
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })

vim.keymap.set("i", "<CR>", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local prev_char = col > 1 and line:sub(col - 1, col - 1) or ""

  if prev_char == ">" or prev_char == "{" or prev_char == "(" or prev_char == "[" then
    return "<CR><Esc>O"
  else
    return "<CR>"
  end
end, { expr = true, noremap = true })

-- Overrides
-- Line begining/end movements
vim.api.nvim_set_keymap("n", "E", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "B", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "E", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "B", "^", { noremap = true, silent = true })
-- Panes creation
vim.api.nvim_set_keymap("n", "<leader>=", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>P', ':q<CR>', { noremap = true, silent = true })
