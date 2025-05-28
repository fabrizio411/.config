return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      file_ignore_patterns = {
        "node_modules",
        "%.git/", -- también puedes usar "^%.git/" para ignorar carpetas .git
        "dotfiles",
        ".npm",
        ".ssh",
        ".local",
        ".tmux",
        "dist",
        "build",
      },
    },
  },
}
