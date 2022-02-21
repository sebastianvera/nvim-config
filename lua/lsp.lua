-- Map keybinds
local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
	-- if client.resolved_capabilities.document_formatting then
	-- 	vim.cmd([[
 --            augroup LspFormatting
 --                autocmd! * <buffer>
 --                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
 --            augroup END
 --            ]])
	-- end

	if client.name == "gopls" or client.name == "sumneko_lua" then
		client.resolved_capabilities.document_formatting = false
	end

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local opts = { noremap = true, silent = true }
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gh", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<Leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	require("lsp_signature").on_attach({
		bind = true,
		hint_prefix = "🧸 ",
		handler_opts = { border = "rounded" },
	})
end

-- Add completion capabilities (completion, snippets)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md for more lsp servers
-- Use these servers and default configs
-- Add more servers here
local servers = {
	"sumneko_lua",
	"tsserver",
	"rust_analyzer",
	"gopls",
}

local config = { on_attach = on_attach, capabilities = capabilities }

--- Generates a config table for lspconfig
--- @return table
local function generate_sumneko_config()
	-- Configure lua language server for neovim development
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	local sumneko_root_path = "/Users/rope/Code/lua-language-server/"
	local lua_settings = {
		Lua = {
			runtime = {
				-- LuaJIT in the case of Neovim
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "P", "G" },
			},
			telemetry = { enable = false },
			workspace = {
				preloadFileSize = 180,
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	}
	local luadev = require("lua-dev").setup({
		library = {
			vimruntime = true,
			types = true,
			plugins = false,
		},
		lspconfig = lua_settings,
	})
	local _config = vim.tbl_extend("keep", config, luadev)
	_config.cmd = { sumneko_root_path .. "bin/lua-language-server", "-E", sumneko_root_path .. "main.lua" }
	return _config
end

require("null-ls").setup({
	debug = true,
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.formatting.goimports,
		require("null-ls").builtins.code_actions.gitsigns,
		require("null-ls").builtins.diagnostics.golangci_lint,
	},
})

-- Setup all servers from servers table
for _, server in pairs(servers) do
	if server == "sumneko_lua" then
		local sumneko_config = generate_sumneko_config()
		nvim_lsp[server].setup(sumneko_config)
	else
		nvim_lsp[server].setup(config)
	end
end

-- Change icons for Lsp Diagnostic
local signs = { Error = "", Warn = "", Info = "כֿ", Hint = "" }
for sign, icon in pairs(signs) do
	vim.fn.sign_define(
		"DiagnosticSign" .. sign,
		{ text = icon, texthl = "Diagnostic" .. sign, linehl = false, numhl = "Diagnostic" .. sign }
	)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		prefix = "◉",
	},
})

-- function org_imports(wait_ms)
--   local params = vim.lsp.util.make_range_params()
--   params.context = {only = {"source.organizeImports"}}
--   local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
--   for _, res in pairs(result or {}) do
--     for _, r in pairs(res.result or {}) do
--       if r.edit then
--         vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
--       else
--         vim.lsp.buf.execute_command(r.command)
--       end
--     end
--   end
-- end

vim.cmd([[
  augroup GO_LSP
    autocmd!
    autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting()
  augroup END
]])
-- autocmd BufWritePre *.go :silent! lua org_imports(3000)
