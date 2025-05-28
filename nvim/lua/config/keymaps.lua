-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Insert mode Esc helper
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })

-- Enter autoformat blocks
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

-- Visual selection movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Line begining/end movements
vim.api.nvim_set_keymap("n", "E", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "B", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "E", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "B", "^", { noremap = true, silent = true })

-- Panes creation
vim.api.nvim_set_keymap("n", "<leader>=", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>P', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d', ':Alpha<CR>', { noremap = true, silent = true })

-- Page scroll center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Cursor center on search
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Replace curretn word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
