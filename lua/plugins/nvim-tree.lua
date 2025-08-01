return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 30,
                side = "right",
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            },
        })

        vim.keymap.set("n", "\\", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
}
