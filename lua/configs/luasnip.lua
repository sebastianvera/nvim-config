local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.setup({
	-- Do not jump to snippet if i'm outside of it
	-- https://github.com/L3MON4D3/LuaSnip/issues/78
	region_check_events = "CursorMoved",
	delete_check_events = "TextChanged",

	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	store_selection_keys = "<c-s>",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "GruvboxOrange" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "GruvboxBlue" } },
			},
		},
	},
})

-- ls.filetype_set("cpp", { "c" })

function _G.snippets_clear()
	for m, _ in pairs(ls.snippets) do
		package.loaded["snippets." .. m] = nil
	end
	ls.snippets = setmetatable({}, {
		__index = function(t, k)
			local ok, m = pcall(require, "snippets." .. k)
			if not ok and not string.match(m, "^module.*not found:") then
				error(m)
			end
			t[k] = ok and m or {}

			require("luasnip.loaders.from_vscode").load({
				include = { k },
				paths = { "~/.local/share/nvim/site/pack/packer/start/friendly-snippets" },
			})
			return t[k]
		end,
	})
end

_G.snippets_clear()

vim.cmd([[
  augroup snippets_clear
  au!
  au BufWritePost ~/.config/nvim/lua/snippets/*.lua lua _G.snippets_clear()
  augroup END
]])

function _G.edit_ft()
	-- returns table like {"lua", "all"}
	local fts = require("luasnip.util.util").get_snippet_filetypes()
	vim.ui.select(fts, {
		prompt = "Select which filetype to edit:",
	}, function(item, idx)
		-- selection aborted -> idx == nil
		if idx then
			vim.cmd("edit ~/.config/nvim/lua/snippets/" .. item .. ".lua")
		end
	end)
end

vim.cmd([[command! LuaSnipEdit :lua _G.edit_ft()]])
