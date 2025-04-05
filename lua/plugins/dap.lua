return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "theHamsta/nvim-dap-virtual-text",
            config = function()
                require("nvim-dap-virtual-text").setup()
            end,
        },
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "nvim-neotest/nvim-nio" },
            config = function()
                require("dapui").setup()
            end,
        },
    },
    config = function()
        local dap = require("dap")
        dap.adapters.c = {
            type = "executable",
            command = "lldb",
            name = "lldb",
        }
        dap.configurations.c = {
            {
                name = "Launch",
                type = "c",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = true,
                args = {},
                runInTerminal = false,
            },
        }
    end,
}
