return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-\>]],
			shade_terminals = false,
			-- add --login so ~/.zprofile is loaded
			shell = "zsh --login",
		})
	end,
	keys = {
		{ [[<C-\>]] },
		{
			"<leader>Tv",
			function()
				local count = vim.v.count1
				require("toggleterm").toggle(count, 0, vim.loop.cwd(), "vertical")
			end,
			desc = "ToggleTerm (vertical)",
		},
		{
			"<leader>Th",
			function()
				local count = vim.v.count1
				require("toggleterm").toggle(count, 10, vim.loop.cwd(), "horizontal")
			end,
			desc = "ToggleTerm (horizontal)",
		},
		{
			"<leader>Tf",
			function()
				local count = vim.v.count1
				require("toggleterm").toggle(count, 0, vim.loop.cwd(), "float")
			end,
			desc = "ToggleTerm (float)",
		},
	},
	opts = {
		-- size = function(term)
		-- 	if term.direction == "horizontal" then
		-- 		return 15
		-- 	elseif term.direction == "vertical" then
		-- 		return 10
		-- 	end
		-- end,

		size = 20,
	},
}
