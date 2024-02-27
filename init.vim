call plug#begin()

" Themes
Plug 'morhetz/gruvbox' 
Plug 'blueshirts/darcula', {'for': 'java'}
Plug 'phanviet/vim-monokai-pro', {'for': ['python', 'go']}

call plug#end()

" File extension
let ext = expand('%:e') 

"" Searching for the python provider makes neovim start slowly
"" when opening python files. This disables checking for it
"" completely.
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0

set number " Show line numbers
set nowrap " Don't wrap lines
set tabstop=4 " Number of spaces tabs count for
set shiftwidth=4 " Number of spaces to use for autoindent
set statusline+=%* " Clear the status line
set mouse=a " Enable mouse support

" Use clipboards of vim and system
set clipboard+=unnamedplus

" Set colorscheme based on the file extension
if ext == 'py' || ext == 'go'
	colorscheme monokai_pro
elseif ext == 'java'
	colorscheme darcula
else
	colorscheme gruvbox 
endif

" Customizing the look of the editor
hi Normal cterm=NONE ctermbg=NONE
hi StatusLine cterm=NONE ctermbg=NONE
hi LineNr cterm=NONE ctermbg=NONE
hi NonText cterm=NONE ctermbg=NONE ctermfg=black
