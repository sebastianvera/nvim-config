-- Mappings --
local map = vim.api.nvim_set_keymap

map("n", "<leader><leader>", "<C-^>", { noremap = true, silent = true, nowait = true })

map("c", "Q", "q", {})
map("c", "W", "w", {})

map("", "<C-c>", '"+y', { noremap = true, silent = true, nowait = true })
map("", "<C-h>", "<C-w><C-h>", { noremap = true, silent = true, nowait = true })
map("", "<C-j>", "<C-w><C-j>", { noremap = true, silent = true, nowait = true })
map("", "<C-k>", "<C-w><C-k>", { noremap = true, silent = true, nowait = true })
map("", "<C-l>", "<C-w><C-l>", { noremap = true, silent = true, nowait = true })

-- Search mappings: these will make it so that going to the next one in a
-- search will center on the line it's found in.
map("n", "n", "nzzzv", { noremap = true, silent = true })
map("n", "N", "Nzzzv", { noremap = true, silent = true })
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
map("n", "J", "mzJ`z", { noremap = true, silent = true })

-- Motion mappings
map("n", "j", "gj", { noremap = true, silent = true })
map("n", "k", "gk", { noremap = true, silent = true })
-- Act like D and C
map("n", "Y", "y$", { noremap = true, silent = true })
-- Do not show stupid q: window
map("", "q:", ":q", {})

map("i", "jk", "<Esc>", {})
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })

-- Telescope: File mappings
local telescope_map_opts = { noremap = true, silent = true, nowait = true }
map("n", "<leader>ff", [[<cmd>lua require("telescope.builtin").find_files()<cr>]], telescope_map_opts)
map("n", "<leader>fr", [[<cmd>lua require("telescope.builtin").oldfiles()<cr>]], telescope_map_opts)
map(
	"n",
	"<leader>fd",
	[[<cmd>lua require("telescope.builtin").find_files({cwd = vim.fn.expand("%:p:h"), hidden = true})<CR>]],
	telescope_map_opts
)
map("n", "<leader>fg", [[<cmd>lua require("telescope.builtin").live_grep()<cr>]], telescope_map_opts)
map("n", "<leader>fb", [[<cmd>lua require("telescope.builtin").buffers()<cr>]], telescope_map_opts)
map("n", "<leader>fh", [[<cmd>lua require("telescope.builtin").command_history()<cr>]], telescope_map_opts)
map("n", "<leader>fc", [[<cmd>lua require("telescope.builtin").commands()<cr>]], telescope_map_opts)
map(
	"n",
	"<leader>fv",
	[[<cmd>lua require("telescope.builtin").find_files({cwd = "~/.config/nvim"})<CR>]],
	telescope_map_opts
)
-- Telescope: Mappings selecting mappings
map("n", "<leader><tab>", [[<cmd>lua require("telescope.builtin").keymaps()<cr>]], telescope_map_opts)
map("x", "<leader><tab>", [[<cmd>lua require("telescope.builtin").keymaps()<cr>]], telescope_map_opts)
map("o", "<leader><tab>", [[<cmd>lua require("telescope.builtin").keymaps()<cr>]], telescope_map_opts)
-- Telescope: LSP mappings
map("n", "<leader>lb", [[<cmd>lua require("telescope.builtin").diagnostics({bufnr=0})<cr>]], telescope_map_opts)
map("n", "<leader>lo", [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>]], telescope_map_opts)
map("n", "<leader>ga", [[<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>]], telescope_map_opts)
--
map("n", "<leader>x", ":write<CR> :luafile %<CR>", { noremap = true, silent = true, nowait = true })
map("n", "<leader>vi", ":e ~/.config/nvim/init.lua<CR>", { noremap = true, silent = true, nowait = true })
map("n", "<leader>a", [[<cmd>CodeActionMenu<cr>]], { noremap = true, silent = true, nowait = true })

-- Vim Sneak
map("", "f", "<Plug>Sneak_f", { silent = true })
map("", "F", "<Plug>Sneak_F", { silent = true })
map("", "t", "<Plug>Sneak_t", { silent = true })
map("", "T", "<Plug>Sneak_T", { silent = true })

-- VimTmuxRunner
map("n", "<Leader>sf", ":VtrSendFile<CR>", { noremap = true, silent = true, nowait = true })
map("n", "<Leader>or", ":VtrOpenRunner<CR>", { noremap = true, silent = true, nowait = true })

-- Luasnip
local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set("i", "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

vim.keymap.set("i", "<c-h>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end)

vim.keymap.set("n", "<leader>sp", "<cmd>LuaSnipEdit<cr>")
