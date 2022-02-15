vim.cmd [[
        augroup ReloadConfig
          autocmd!
          autocmd BufWritePost init.lua,plugins.lua luafile %
        augroup END
]]

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

require('globals')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('keybinds')

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
vim.o.background  = 'dark'
vim.o.encoding    = 'UTF-8'
vim.o.smartindent = true
vim.o.rnu         = true
vim.o.number      = true
vim.o.cursorline  = true
vim.o.autowrite   = true
vim.o.backup      = false
vim.o.completeopt = 'menuone,noselect'
vim.o.foldenable  = false
vim.o.hidden      = true
vim.o.ignorecase  = true
vim.o.inccommand  = 'nosplit'
vim.o.incsearch   = true
vim.o.lazyredraw  = true
vim.o.mouse       = 'a'
vim.o.scrolloff   = 8
vim.o.sidescroll  = 5
vim.o.shiftwidth  = 2
vim.o.tabstop     = 2
vim.o.expandtab   = true
vim.o.showmode    = false
vim.o.showmatch   = true
vim.o.showtabline = 1
vim.o.signcolumn  = 'yes'
vim.o.spelllang   = 'en_us'
vim.o.splitbelow  = true
vim.o.splitright  = true
vim.o.swapfile    = false
vim.o.undodir     = "/Users/rope/.vim/undodir"
vim.o.undofile    = true
vim.o.undolevels  = 5000
vim.o.updatetime  = 300
vim.o.wrap        = false
vim.o.writebackup = false
vim.o.list        = false
vim.o.termguicolors = true

vim.opt.listchars   = { space = '·', trail = '·', precedes= '«', extends = '»', eol='↲', tab='▸ ' }
vim.opt.suffixes = vim.opt.suffixes - '.h'
vim.opt.shortmess = vim.opt.shortmess - 'S'

require('lsp')
require('plugins')

vim.cmd([[
    augroup MarkdownGroup
        autocmd!
        au filetype markdown lua vim.opt_local.spell = true
    augroup end
]])

vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
