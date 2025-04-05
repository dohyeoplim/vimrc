-- return {
--     'marko-cerovac/material.nvim',
--     config = function()
--         require('material').setup({
--             contrast = {
--                 sidebars = true,
--                 floating_windows = true,
--             },
--             styles = {
--                 comments = { italic = true },
--                 keywords = { bold = true },
--                 functions = { italic = true, bold = true },
--             },
--         })
--         vim.cmd 'colorscheme material-deep-ocean'
--     end
-- }

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        vim.cmd 'colorscheme catppuccin-latte'
    end
}
