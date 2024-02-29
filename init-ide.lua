local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Themes
Plug 'sickill/vim-monokai'
Plug 'morhetz/gruvbox' 
Plug 'blueshirts/darcula'
Plug 'phanviet/vim-monokai-pro'

-- Icons
Plug 'nvim-tree/nvim-web-devicons'

-- IDE Plugins
	Plug 'tree-sitter/tree-sitter' -- Parser Generator Tool (Dependency for other plugins)
	Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}) -- Advanced treesitter based syntax highlighting
	Plug 'Ramenu/lualine.nvim' -- Status/Tabline
	Plug 'nvim-lua/plenary.nvim' -- Dependency of Telescope
	Plug('nvim-telescope/telescope.nvim', {tag = '0.1.5', frozen = 1}) -- Fuzzy Finder
	Plug 'kdheepak/lazygit.nvim' -- Lazygit Integration
	Plug 'windwp/nvim-autopairs' -- Autopairs
	-- Dependencies for nvim-cmp
		Plug 'neovim/nvim-lspconfig'
		Plug 'hrsh7th/cmp-nvim-lsp'
		Plug 'hrsh7th/cmp-buffer'
		Plug 'petertriho/cmp-git'
		Plug 'hrsh7th/cmp-path'
		Plug 'hrsh7th/cmp-cmdline'
		-- Snippet Engine
		Plug 'L3MON4D3/LuaSnip'
		Plug 'saadparwaiz1/cmp_luasnip'
	Plug 'hrsh7th/nvim-cmp'	
	Plug 'Ramenu/nvim-clc' -- Calculator
	Plug 'Ramenu/nvim-cmdrun' -- Command Runner
vim.call('plug#end')

-- Searching for the python provider makes neovim start
-- slowly when opening python files. This disables checking
-- for it completely.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Disabling `netrw` is strongly advised by nvim-tree.
-- `netrw` is a standard neovim plugin that is enabled
-- by default. It provides, amongst other functionality,
-- a file/directory browser. 
--
-- It interferes with nvim-tree and the intended user
-- experience is nvim-tree replacing the `netrw` browser.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.wo.number = true -- Show line numbers
vim.o.ruler = true
vim.o.scl = 'no' -- Hide annoying sidebar next to line numbers
vim.opt.wrap = false -- Don't wrap lines
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.o.cmdheight = 0 -- Hide the command line
vim.opt.clipboard = 'unnamedplus' -- Share clipboards with system
vim.o.laststatus = 3
vim.g.mapleader = ',' -- Leader key

vim.cmd 'colorscheme gruvbox' -- Set default theme

local colors = {
	black            = 232,
	light_black      = 233,
	dark_grey        = 234,
	light_grey       = 243,
	white            = 15,
	yellow           = 11,
	orange           = 208
}

-- Customizing the look of the editor
local BG_COLOR = colors.light_black
local BG_SECONDARY_COLOR = colors.dark_grey
local FG_COLOR = colors.white
vim.api.nvim_set_hl(0, 'Normal', {ctermbg=BG_COLOR, ctermfg=FG_COLOR})
vim.api.nvim_set_hl(0, 'NormalAlt', {ctermbg=BG_COLOR, ctermfg=FG_COLOR})
vim.api.nvim_set_hl(0, 'StatusLine', {ctermbg=BG_COLOR})
vim.api.nvim_set_hl(0, 'ErrorMsg', {ctermbg=BG_COLOR})
vim.api.nvim_set_hl(0, 'NonText', {ctermbg=BG_COLOR, ctermfg=BG_COLOR})
vim.api.nvim_set_hl(0, 'MsgArea', {ctermbg=BG_COLOR, ctermfg=FG_COLOR})
vim.api.nvim_set_hl(0, 'Pmenu', {ctermbg=BG_SECONDARY_COLOR, ctermfg=FG_COLOR})
vim.api.nvim_set_hl(0, 'LineNr', {ctermbg=BG_COLOR, ctermfg=colors.light_grey})

-- Initialize Plugins
local actions = require('telescope.actions')
local cmdrun = require('nvim-cmdrun').cmdrun('./.nvim/tasks.txt')
require('lualine').setup()
require('nvim-autopairs').setup()
require('nvim-clc').setup()
require'telescope'.setup {
	defaults = {
		mappings = {
			i = {
				-- Close on first esc instead of going to normal mode
				['<esc>'] = actions.close,
				['<cr>'] = actions.select_default,
				['<leader>v'] = actions.select_vertical,
				['<leader>h'] = actions.select_horizontal,
			},
		},
	},
}

require'nvim-treesitter.configs'.setup {
	-- parsers that should always be installed
	ensure_installed = {'c', 'cpp', 'python', 'rust'},
	-- Automatically install missing dependencies when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI 
	-- installed locally
	auto_install = false,

	highlight = {
		enable = true,

		-- Disable the syntax highlighting if the file size is too large
		disable = function(lang, buf)
			local max_fs = 500 * 1024 -- 500KiB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_fs then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages	
		additional_vim_regex_highlighting = false,
	},
}
local cmp = require('cmp')
cmp.setup({
	-- REQUIRED: you must specify a snippet engine
	snippet = {
		expand = function(args) 
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		--['-'] = cmp.mapping.select_prev_item(),
		--['='] = cmp.mapping.select_next_item(),
		['`'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.confirm({ select = true }),
	}),
	window = {
		completion = cmp.config.window.bordered({
			border = "double",
			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"
		}),
		documentation = cmp.config.window.bordered({
			border = "double",
			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"
		}),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, 
	{{ name = 'buffer' }}),
})

-- Set up lsgconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- Language server for Rust
lspconfig.rust_analyzer.setup { capabilities = capabilities }
-- Language server for C, C++, Obj-C, CUDA
lspconfig.clangd.setup { capabilities = capabilities }

local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local builtin = require('telescope.builtin')

-- Remap keybindings
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>,', builtin.buffers, {})
vim.keymap.set('n', '<leader>lg', '<Cmd>:LazyGit<CR>', {})
vim.keymap.set('n', '<leader>l', '<Cmd>:vertical resize +5<CR>', {})
vim.keymap.set('n', '<leader>h', '<Cmd>:vertical resize -5<CR>', {})
vim.keymap.set('n', '<leader>1', '<Cmd>:bp<CR>', {})
vim.keymap.set('n', '<leader>2', '<Cmd>:bn<CR>', {})
if cmdrun then
	vim.keymap.set('n', '<leader>r', '<Cmd>:!'..cmdrun['run']..'<CR>')
end

-- Map split focus keys
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

