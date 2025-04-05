vim.cmd("language en_US")
vim.cmd("set encoding=utf-8")
vim.cmd("set fileencodings=utf-8,cp949")

vim.g.have_nerd_font = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false -- Use statueline instead.
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true -- Display whitespaces
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- black hole register로 d,x,c 시 yank 안되도록..
vim.keymap.set({ "n", "v" }, "d", [["_d]], { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "x", [["_x]], { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "c", [["_c]], { noremap = true, silent = true })

-- Yank 시 visual 유지
vim.keymap.set("x", "y", function()
    if vim.fn.visualmode() == "v" then
        vim.cmd('normal! ygvv')
    else
        vim.cmd('normal! ygv')
    end
end, { noremap = true, silent = true })

vim.keymap.set("x", "Y", function()
    local start = vim.fn.getpos("'<")
    local finish = vim.fn.getpos("'>")
    vim.cmd("normal! y")
    vim.fn.cursor(start[2], 1)
    vim.cmd("normal! V")
    vim.fn.cursor(finish[2], 999)
end, { noremap = true, silent = true })

vim.keymap.set("x", "<C-y>", function()
    if vim.fn.visualmode() == "\22" then
        vim.cmd('normal! ygv<C-v>')
    else
        vim.cmd('normal! ygv')
    end
end, { noremap = true, silent = true })

-- $d를 g_d로 매핑
vim.keymap.set("v", "$", "g_", { noremap = true, silent = true })
