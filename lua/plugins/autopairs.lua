return {
    "windwp/nvim-autopairs",
    config = function()
        local npairs = require("nvim-autopairs")

        npairs.setup({
            check_ts = true,
        })

        -- local Rule = require("nvim-autopairs.rule")
    end,
}
