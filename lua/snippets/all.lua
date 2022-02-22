local ls = require("luasnip")

local s = ls.snippet
local f = ls.function_node

local date = function()
	return { os.date("%Y-%m-%d") }
end

local snippets = {
	s({
		trig = "date",
		namr = "Date",
		dscr = "Date in the form of YYYY-MM-DD",
	}, { f(date) }),
}

return snippets
