return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = true,
  init = false,
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[

   ▄████████  ▄████████ ▀█████████▄  ▄██████████▄
  ███    ███ ███    ███   ███    ███ ▀        ▄██
  ███    █▀  ███    ███   ███    ███        ▄██▀
 ▄███▄▄▄     ███    ███  ▄███▄▄▄██▀       ▄██▀
▀▀███▀▀▀   ▀███████████ ▀▀███▀▀▀██▄     ▄██▀
  ███        ███    ███   ███    ██▄  ▄██▀
  ███        ███    ███   ███    ███ ███▄       ▄
  ███        ███    █▀  ▄█████████▀  ▀██████████▀
                                     ▄▄▄▄  ▄   ▄ ▄ ▄▄▄▄
                                     █   █ █   █ ▄ █ █ █
                                     █   █  ▀▄▀  █ █   █
                                                 █

    ]]

    dashboard.section.header.val = vim.split(logo, "\n")
    dashboard.section.header.opts.hl = "AlphaHeader" -- asigna el highlight

    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("r", " " .. " Recent files", [[<cmd> lua LazyVim.pick("oldfiles")() <cr>]]),
      dashboard.button("c", " " .. " Config", "<cmd> lua LazyVim.pick.config_files()() <cr>"),
      dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      dashboard.button("x", " " .. " Lazy Extras", "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8

    -- 🔵 define los colores del logo y otras secciones
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#afd7af", bold = true })     -- azul claro
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#c1c2c4", bold = true })    -- verde
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#afd7af", italic = true }) -- púrpura
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#7dcfff", italic = true })   -- cian

    return dashboard
  end,

  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)
  end,
}
