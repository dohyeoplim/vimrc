return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "nvimtools/none-ls.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        -- === Global formatting options ===
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true

        -- === nvim-cmp setup for <Tab> navigation ===
        local cmp = require("cmp")
        cmp.setup({
            mapping = {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() and cmp.get_selected_entry() then
                        cmp.confirm({ select = false })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            sources = {
                { name = "nvim_lsp" },
            },
        })

        -- === Mason and LSP setup ===
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local null_ls = require("null-ls")

        mason.setup()

        local function on_attach(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local keymap = vim.keymap.set

            keymap("n", "gd", vim.lsp.buf.definition, opts)
            keymap("n", "gr", vim.lsp.buf.references, opts)
            keymap("n", "K", vim.lsp.buf.hover, opts)
            keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
            keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            keymap("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end, opts)

            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("LspFormatOnSave_" .. bufnr, { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            async = false,
                            timeout_ms = 2000,
                        })
                    end,
                })
            end
        end

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                        telemetry = { enable = false },
                        format = { enable = false },
                    },
                },
            },
            pyright = {},
            clangd = {},
            ts_ls = {},
            eslint = {},
            tailwindcss = {},
        }

        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = true,
        })

        local lspconfig = require("lspconfig")
        for server, config in pairs(servers) do
            lspconfig[server].setup(vim.tbl_deep_extend("force", {
                on_attach = on_attach,
                capabilities = capabilities,
            }, config))
        end

        -- === none-ls (null-ls) setup for formatting ===
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = {
                        "javascript", "typescript", "javascriptreact", "typescriptreact",
                        "json", "yaml", "markdown", "html", "css", "scss", "lua",
                    },
                    extra_args = { "--tab-width", "4" },
                }),
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("NoneLsFormatOnSave_" .. bufnr, { clear = true }),
                        buffer = bufnr,
                        desc = "Format with none-ls",
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(cl)
                                    return cl.name == "null-ls" or cl.name == "none-ls"
                                end,
                                async = false,
                                timeout_ms = 2000,
                            })
                        end,
                    })
                end
            end,
        })
    end,
}
