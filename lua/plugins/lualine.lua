return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = "|",
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'branch', 'diff', 'diagnostics' },
            },
        })
    end,
}
