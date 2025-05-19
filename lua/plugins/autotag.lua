return {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    lazy = false,
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require('nvim-ts-autotag').setup()
    end,
}
