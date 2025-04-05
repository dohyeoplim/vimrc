-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Window resizing
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Exit terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Highlight on search, automatic noh
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Compile & Run
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.api.nvim_set_keymap(
            'n',
            '<F4>',
            ':w<CR>:!clang % -o %:r<CR>',
            { noremap = true, silent = true }
        )

        vim.api.nvim_set_keymap(
            'n',
            '<F5>',
            ':w<CR>:!clang % -o %:r && ./%:r<CR>',
            { noremap = true, silent = true }
        )
    end,
})

-- Debugging
vim.keymap.set("n", "<F6>", function()
    require("dap").continue()
end, { desc = "Start/Continue Debugging" })

vim.keymap.set("n", "<F10>", function()
    require("dap").step_over()
end, { desc = "Step Over" })

vim.keymap.set("n", "<F11>", function()
    require("dap").step_into()
end, { desc = "Step Into" })

vim.keymap.set("n", "<F12>", function()
    require("dap").step_out()
end, { desc = "Step Out" })

vim.keymap.set("n", "<leader>b", function()
    require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "<leader>B", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Set Conditional Breakpoint" })

vim.keymap.set("n", "<leader>dr", function()
    require("dap").repl.open()
end, { desc = "Open REPL" })

vim.keymap.set("n", "<leader>dl", function()
    require("dap").run_last()
end, { desc = "Run Last Debugging Session" })
