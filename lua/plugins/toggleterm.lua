return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<C-\>]], -- Ctrl+\로 터미널 열기
            direction = "horizontal", -- 수평 터미널
            close_on_exit = true,
            shell = vim.o.shell,
        })
    end,
}
