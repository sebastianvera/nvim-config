-- Map keybinds
local nvim_lsp = require("lspconfig")
local configs = require("lsp.configs")

local on_attach = function(client, bufnr)
	-- if client.resolved_capabilities.document_formatting then
	-- 	vim.cmd([[
	--            augroup LspFormatting
	--                autocmd! * <buffer>
	--                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
	--            augroup END
	--            ]])
	-- end

	-- Turn off document formatting so we don't get a list with 2 options
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

local config = { on_attach = on_attach, capabilities = capabilities }

-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md for more lsp servers
-- Use these servers and default configs
-- Add more servers here
local servers = {
	sumneko_lua = configs.generate_sumneko_config(config),
	tsserver = {
		on_attach = function(client, bufnr)
			client.resolved_capabilities.document_formatting = false
			client.resolved_capabilities.document_range_formatting = false
			return on_attach(client, bufnr)
		end,
	},
	"rust_analyzer",
	"gopls",
	emmet_ls = { filetypes = { "html", "css", "typescriptreact", "javascriptreact" } },
}

-- Setup all servers from servers table
for k, val in pairs(servers) do
	if type(val) == "table" then
		local server = k
		local opts = val
		nvim_lsp[server].setup(vim.tbl_extend("force", config, opts))
	else
		local server = val
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

vim.cmd([[
  augroup GO_LSP
    autocmd!
    autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting()
  augroup END
]])
