-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Cambiar la cantidad de lineas minimas debajo/sobre cursor
vim.o.scrolloff = 8

-- Eliminar autocompletados de comentarios en enters
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- Eliminar las opciones 'c', 'r' y 'o' de formatoptions
    vim.bo.formatoptions = vim.bo.formatoptions:gsub("[cro]", "")
  end,
})
