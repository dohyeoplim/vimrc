return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = {
                ['<C-y>'] = cmp.mapping.confirm({
                    select = true,
                }),

                ['<CR>'] = function(fallback)
                    fallback()
                end,

                ['<C-n>'] = cmp.mapping.select_next_item({
                    behavior = cmp.SelectBehavior.Insert,
                }),

                ['<C-p>'] = cmp.mapping.select_prev_item({
                    behavior = cmp.SelectBehavior.Insert,
                }),

                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),

            },
            sources = cmp.config.sources({
                { name = "copilot" },
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            }),
        })
    end,
}
