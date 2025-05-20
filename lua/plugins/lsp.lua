return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "nvimtools/none-ls.nvim",          -- null-ls fork
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    -- === Global indent settings ===
    vim.opt.tabstop    = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab  = true

    -- === nvim-cmp: <Tab> to navigate, <CR> to confirm only if selected ===
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

    -- === Mason & LSPConfig setup ===
    require("mason").setup()
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig        = require("lspconfig")

    -- shared on_attach for all LSP servers
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      local keymap = vim.keymap.set

      keymap("n", "gd",         vim.lsp.buf.definition, opts)
      keymap("n", "gr",         vim.lsp.buf.references, opts)
      keymap("n", "K",          vim.lsp.buf.hover, opts)
      keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      keymap("n", "<leader>f",  function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- list of LSP servers and any per-server settings
    local servers = {
      lua_ls     = {
        settings = {
          Lua = {
            runtime   = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry  = { enable = false },
            format     = { enable = false },  -- disable Lua's own formatter
          },
        },
      },
      pyright    = {},
      clangd     = {},
      ts_ls = {},  -- correct name for TypeScript server
      eslint     = {},
      tailwindcss= {},
    }

    mason_lspconfig.setup({
      ensure_installed   = vim.tbl_keys(servers),
      automatic_installation = true,
    })

    for name, cfg in pairs(servers) do
      lspconfig[name].setup(vim.tbl_deep_extend("force", {
        on_attach    = on_attach,
        capabilities = capabilities,
      }, cfg))
    end

    -- === null-ls (none-ls) for prettierd sync format-on-save ===
    local null_ls = require("null-ls")
    local fmt_grp = vim.api.nvim_create_augroup("LspFormatting", {})

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
        if client.name == "null-ls" and client.supports_method("textDocument/formatting") then
          -- clear any previous autocmds in this group for this buffer
          vim.api.nvim_clear_autocmds({ group = fmt_grp, buffer = bufnr })
          -- sync format on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            group   = fmt_grp,
            buffer  = bufnr,
            desc    = "Sync format with null-ls before save",
            callback= function()
              vim.lsp.buf.format({
                bufnr      = bufnr,
                filter     = function(c) return c.name == "null-ls" end,
                async      = false,
                timeout_ms = 2000,
              })
            end,
          })
        end
      end,
    })
  end,
}
