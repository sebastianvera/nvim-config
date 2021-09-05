vim.cmd [[
        augroup ReloadConfig
          autocmd!
          autocmd BufWritePost init.lua,plugins.lua luafile %
        augroup END
]]

require('globals')

-- Auto install packer.nvim if not exists
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print("Downloading packer.nvim...")
    local out = vim.fn.system('git clone https://github.com/wbthomason/packer.nvim '..install_path)
    print(out)
    print("You'll need to restart now")
end
vim.cmd [[ packadd packer.nvim ]]
vim.cmd [[ autocmd BufWritePost plugins.lua PackerCompile ]]

-- Plugins
require('plugins')

require('telescope').setup {
        extensions = {
                override_generic_sorter = false,
                override_file_sorter = true,
        },
        defaults = {
            -- winblend = 5,
        },
        pickers = {
            buffers = {
                sort_lastused = true,
            },
        },
}
require('telescope').load_extension('fzy_native')
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  },
}

-- vim.g.neoterm_shell='zsh'
-- vim.g.neoterm_size='20'
-- vim.g.neoterm_default_mod='belowright'
-- vim.g.neoterm_fixedsize='1'
-- vim.g.neoterm_autoscroll='1'
-- vim.g.neoterm_keep_term_open='1'
-- vim.g.neoterm_autoinsert='0'

-- Mappings --
local map = vim.api.nvim_set_keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map('n', '<leader><leader>', '<C-^>', {noremap = true, silent = true, nowait = true})

map('', '<C-c>', '"+y', {noremap = true, silent = true, nowait = true})
map('', '<C-h>', '<C-w><C-h>', {noremap = true, silent = true, nowait = true})
map('', '<C-j>', '<C-w><C-j>', {noremap = true, silent = true, nowait = true})
map('', '<C-k>', '<C-w><C-k>', {noremap = true, silent = true, nowait = true})
map('', '<C-l>', '<C-w><C-l>', {noremap = true, silent = true, nowait = true})

-- Search mappings: these will make it so that going to the next one in a
-- search will center on the line it's found in.
map('n', 'n', 'nzzzv', {noremap = true, silent = true})
map('n', 'N', 'Nzzzv', {noremap = true, silent = true})
map('n', '<C-d>', '<C-d>zz', {noremap = true, silent = true})
map('n', '<C-u>', '<C-u>zz', {noremap = true, silent = true})
map('n', 'J', 'mzJ`z', {noremap = true, silent = true})

-- Motion mappings
map('n', 'j', 'gj', {noremap = true, silent = true})
map('n', 'k', 'gk', {noremap = true, silent = true})
-- Act like D and C
map('n', 'Y', 'y$', {noremap = true, silent = true})
-- Do not show stupid q: window
map('', 'q:', ':q', {})

map('i', 'jk', '<Esc>', {})
map('v', 'K', ":m '<-2<CR>gv=gv", {noremap = true})
map('v', 'J', ":m '>+1<CR>gv=gv", {noremap = true})

-- Telescope: File mappings
local telescope_map_opts = {noremap = true, silent = true, nowait = true}
map('n', '<leader>ff', [[<cmd>lua require("telescope.builtin").find_files()<cr>]], telescope_map_opts)
map('n', '<leader>fd', [[<cmd>lua require("telescope.builtin").find_files({cwd = vim.fn.expand("%:p:h")})<CR>]], telescope_map_opts)
map('n', '<leader>fg', [[<cmd>lua require("telescope.builtin").live_grep()<cr>]], telescope_map_opts)
map('n', '<leader>fb', [[<cmd>lua require("telescope.builtin").buffers()<cr>]], telescope_map_opts)
map('n', '<leader>fh', [[<cmd>lua require("telescope.builtin").command_history()<cr>]], telescope_map_opts)
map('n', '<leader>fc', [[<cmd>lua require("telescope.builtin").commands()<cr>]], telescope_map_opts)
map('n', '<leader>fv', [[<cmd>lua require("telescope.builtin").find_files({cwd = "~/.config/nvim"})<CR>]], telescope_map_opts)
-- Telescope: Mappings selecting mappings
map('n', '<leader><tab>', [[<cmd>lua require("telescope.builtin").keymaps()<cr>]], telescope_map_opts)
map('x', '<leader><tab>', [[<cmd>lua require("telescope.builtin").keymaps()<cr>]], telescope_map_opts)
map('o', '<leader><tab>', [[<cmd>lua require("telescope.builtin").keymaps()<cr>]], telescope_map_opts)
-- Telescope: LSP mappings
map('n', '<leader>ld', [[<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<cr>]], telescope_map_opts)
map('n', '<leader>lb', [[<cmd>lua require("telescope.builtin").lsp_document_diagnostics()<cr>]], telescope_map_opts)
map('n', '<leader>lo', [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>]], telescope_map_opts)
map('n', '<leader>ga', [[<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>]], telescope_map_opts)
-- Telescope: Vimwiki
map('n', '<leader>wf', [[<cmd>lua require("telescope.builtin").find_files({cwd = "~/vimwiki"})<CR>]], telescope_map_opts)
map('n', '<leader>wg', [[<cmd>lua require("telescope.builtin").live_grep({cwd = "~/vimwiki"})<CR>]], telescope_map_opts)

--
map('n', '<leader>x', ':write<CR> :luafile %<CR>', {noremap = true, silent = true, nowait = true})

-- Neoterm
-- local neoterm_map_opts = {noremap = true, silent = true, nowait = true}
-- map('n', '<leader>tk', ':Tkill<CR>', neoterm_map_opts)
-- map('n', '<leader>tc', ':Tclose<CR>', neoterm_map_opts)
-- map('n', '<leader>tl', ':Tclear<CR>', neoterm_map_opts)
-- map('n', '<leader>tt', ':Ttoggle<CR>', neoterm_map_opts)

-- -- Term
-- local term_map_opts = {noremap = true, silent = true, nowait = true}
-- map('t', 'jk', '<C-\\><C-n>', term_map_opts)
-- map('t', '<C-w>h', '<C-\\><C-n><C-w>h', term_map_opts)
-- map('t', '<C-w>j', '<C-\\><C-n><C-w>j', term_map_opts)
-- map('t', '<C-w>k', '<C-\\><C-n><C-w>k', term_map_opts)
-- map('t', '<C-w>l', '<C-\\><C-n><C-w>l', term_map_opts)

-- NvimCompe:
local compe_map_opts = {expr = true, silent = true, noremap = true}
map('i', '<C-Space>', 'compe#complete()', compe_map_opts)
map('i', '<CR>', 'compe#confirm("<CR>")', compe_map_opts)
map('i', '<C-e>', 'compe#close("<C-e>")', compe_map_opts)
map('i', '<C-u>', 'compe#scroll({ "delta": +4 })', compe_map_opts)
map('i', '<C-d>', 'compe#scroll({ "delta": -4 })', compe_map_opts)

-- Vim Sneak
map('', 'f', '<Plug>Sneak_f', {silent=true})
map('', 'F', '<Plug>Sneak_F', {silent=true})
map('', 't', '<Plug>Sneak_t', {silent=true})
map('', 'T', '<Plug>Sneak_T', {silent=true})

-- Abbreviations --
vim.cmd [[ iab arent       aren't ]]
vim.cmd [[ iab becuase     because ]]
vim.cmd [[ iab behaivor    behavior ]]
vim.cmd [[ iab doesnt      doesn't ]]
vim.cmd [[ iab dont        don't ]]
vim.cmd [[ iab edn         end ]]
vim.cmd [[ iab flase       false ]]
vim.cmd [[ iab funciton    function ]]
vim.cmd [[ iab funciton    function ]]
vim.cmd [[ iab funtcion    function ]]
vim.cmd [[ iab hieght      height ]]
vim.cmd [[ iab isnt        isn't ]]
vim.cmd [[ iab iwth        with ]]
vim.cmd [[ iab lieakwise   likewise ]]
vim.cmd [[ iab liek        like ]]
vim.cmd [[ iab mian        main ]]
vim.cmd [[ iab moer        more ]]
vim.cmd [[ iab opne        open ]]
vim.cmd [[ iab previosu    previous ]]
vim.cmd [[ iab pritn       print ]]
vim.cmd [[ iab retrun      return ]]
vim.cmd [[ iab tihs        this ]]
vim.cmd [[ iab succesfully successfully ]]
vim.cmd [[ iab whit        with ]]
vim.cmd [[ iab wieght      weight ]]
vim.cmd [[ iab wiht        with ]]
vim.cmd [[ iab wont        won't ]]

vim.cmd [[ iab <expr> timets strftime("%T") ]]
vim.cmd [[ iab <expr> datets strftime("%F") ]]

-- Settings --

vim.cmd [[ filetype on ]]

-- Global options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.autowrite   = true
vim.opt.backup      = false
vim.opt.completeopt = {'menuone','noselect'}
vim.opt.directory   = {'/var/tmp//','/tmp'}
vim.opt.expandtab   = true
vim.opt.foldenable  = false
vim.opt.hidden      = true
vim.opt.ignorecase  = true
vim.opt.inccommand  = 'nosplit'
vim.opt.lazyredraw  = true
vim.opt.mouse       = 'a'
vim.opt.pumblend    = 5
vim.opt.pumheight   = 10
vim.opt.scrolloff   = 15
vim.opt.shiftwidth  = 4
vim.opt.showmode    = false
vim.opt.showtabline = 1
vim.opt.signcolumn  = 'yes'
vim.opt.spelllang   = {'en_us'}
vim.opt.splitbelow  = true
vim.opt.splitright  = true
vim.opt.swapfile    = false
vim.opt.tabstop     = 4
vim.opt.undodir     = {'/var/tmp//','/tmp'}
vim.opt.undofile    = true
vim.opt.undolevels  = 5000
vim.opt.updatetime  = 300
vim.opt.wrap        = false
vim.opt.writebackup = false
vim.opt.listchars   = { space = '·', trail = '·', precedes= '«', extends = '»', eol='↲', tab='▸ ' }
vim.opt.list        = false
vim.o.termguicolors = true

vim.opt.suffixes = vim.opt.suffixes - '.h'
vim.opt.shortmess = vim.opt.shortmess - 'S'

vim.cmd('colorscheme moonfly')
-- Set variant
-- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
-- vim.g.rose_pine_variant = 'base'

require('lualine').setup({
    options = {
        theme = 'moonfly'
    }
})

require('lsp')
-- Terminal Settings --
vim.cmd([[
    augroup TerminalSettings
        autocmd!
        autocmd TermOpen  * lua vim.wo.winhl = 'Normal:TermNormal'
        autocmd TermOpen  * lua vim.wo.spell = false
        autocmd TermOpen  * lua vim.wo.number = false
    augroup END
]])

-- Vimwiki Settings --
vim.g.vimwiki_conceal_onechar_markers = 0
vim.g.vimwiki_list = {{path = '~/vimwiki/', syntax = 'markdown', ext = '.md'}}

vim.cmd([[
    augroup VimwikiGroup
        autocmd!
        au filetype vimwiki lua vim.opt_local.spell     = true
        au filetype vimwiki lua vim.opt_local.textwidth = 80
        au BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
        au BufNewFile ~/vimwiki/diary/*.md :silent 0r !~/.vim/bin/generate_vimwiki_diary_template '%:t'
        au FileType vimwiki inoremap <silent> <buffer> <expr> <CR>   pumvisible() ? "\<CR>"   : "<Esc>:VimwikiReturn 1 5<CR>"
        au FileType vimwiki inoremap <silent> <buffer> <expr> <S-CR> pumvisible() ? "\<S-CR>" : "<Esc>:VimwikiReturn 2 2<CR>"
    augroup end
]])


vim.cmd([[
    augroup MarkdownGroup
        autocmd!
        au filetype           markdown lua vim.opt_local.spell = true
    augroup end
]])

-- VimTmuxRunner
map('n', '<Leader>sf', ':VtrSendFile<CR>', {noremap = true, silent = true, nowait = true})
map('n', '<Leader>or', ':VtrOpenRunner<CR>', {noremap = true, silent = true, nowait = true})

-- Blane
map('n', '<Leader>x', ':BlaneRun<CR>', {noremap = true, silent = true, nowait = true})
