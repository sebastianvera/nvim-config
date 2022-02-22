local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local fmta = require("luasnip.extras.fmt").fmta

local snippets = {
	s("p", { t("print(vim.inspect("), i(1, "foo"), t("))"), i(0) }),
	s(
		"nsf",
		fmta(
			[[
        local ls = require("luasnip")

        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local fmt = require("luasnip.extras.fmt").fmt

        local snippets = {
          <>
        }

        return snippets
      ]],
			{
				i(1, "sn"),
			}
		)
	),
  s("ns", fmta([[s("<>", <>),<>]], {i(1, "trigger"), i(2), i(0)})),
}

return snippets
