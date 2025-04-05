return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jose-elias-alvarez/null-ls.nvim", -- for formatters
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local null_ls = require("null-ls")

        mason.setup()
        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                "clangd",
                "ts_ls",
                "eslint",
                "tailwindcss"
            },
        })

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

            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })

            if client.server_capabilities.documentFormattingProvider then
                client.server_capabilities.documentFormattingProvider = true
            end

            client.server_capabilities.signatureHelpProvider = false
        end

        -- LSP: lua
        lspconfig.lua_ls.setup({
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    format = { enable = true },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false },
                },
            },
        })

        -- LSP: python
        lspconfig.pyright.setup({
            on_attach = on_attach,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        })

        -- LSP: C/C++
        lspconfig.clangd.setup({
            on_attach = on_attach,
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=never",
                "--fallback-style=webkit",
            },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            init_options = { clangdFileStatus = true },
        })

        -- LSP: JS/TS
        lspconfig.ts_ls.setup({
            on_attach = on_attach,
            filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        })

        -- Formatter 설정 (null-ls + prettierd)
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettierd.with({
                    filetypes = {
                        "javascript",
                        "typescript",
                        "javascriptreact",
                        "typescriptreact",
                        "json",
                        "yaml",
                        "markdown",
                        "html",
                        "css",
                        "scss",
                    },
                }),
            },
            on_attach = on_attach,
        })
    end,
}
