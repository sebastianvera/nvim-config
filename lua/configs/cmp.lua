local cmp = require("cmp")
local types = require("cmp.types")
local str = require("cmp.utils.str")

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local luasnip = require("luasnip")

-- Do not jump to snippet if i'm outside of it
-- https://github.com/L3MON4D3/LuaSnip/issues/78
luasnip.config.setup({
	region_check_events = "CursorMoved",
	delete_check_events = "TextChanged",
})

local lspkind = require("lspkind")

cmp.setup({
	completion = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, scrollbar = "║" },
	documentation = {
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		scrollbar = "║",
	},
	formatting = {
		fields = {
			cmp.ItemField.Kind,
			cmp.ItemField.Abbr,
			cmp.ItemField.Menu,
		},
		format = lspkind.cmp_format({
			with_text = false,
			before = function(entry, vim_item)
				-- Get the full snippet (and only keep first line)
				local word = entry:get_insert_text()
				if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
					word = vim.lsp.util.parse_snippet(word)
				end
				word = str.oneline(word)

				-- concatenates the string
				-- local max = 50
				-- if string.len(word) >= max then
				-- 	local before = string.sub(word, 1, math.floor((max - 3) / 2))
				-- 	word = before .. "..."
				-- end

				if
					entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
					and string.sub(vim_item.abbr, -1, -1) == "~"
				then
					word = word .. "~"
				end
				vim_item.abbr = word

				return vim_item
			end,
		}),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<c-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),

    ["<c-space>"] = cmp.mapping {
      i = cmp.mapping.complete(),
      c = function(
        _ --[[fallback]]
      )
        if cmp.visible() then
          if not cmp.confirm { select = true } then
            return
          end
        else
          cmp.complete()
        end
      end,
    },
		["<Tab>"] = cmp.mapping.disable,
		["<C-l>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<C-h>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	sources = {
		{ name = "cmp_git" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "buffer", keyword_length = 5, max_item_count = 5 },
	},

	experimental = {
		ghost_text = false,
	},
})

require("cmp").setup.cmdline(":", {
	sources = {
		{ name = "cmdline", keyword_length = 2 },
	},
})
