call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'},
Plug 'lervag/vimtex',
Plug 'vim-airline/vim-airline',
Plug 'vim-airline/vim-airline-themes',
Plug 'scrooloose/nerdtree',
Plug 'Xuyuanp/nerdtree-git-plugin',
Plug 'vim-syntastic/syntastic',
Plug 'jiangmiao/auto-pairs',
Plug 'MarcWeber/vim-addon-mw-utils',
Plug 'kana/vim-textobj-user',
Plug 'fadein/vim-FIGlet',
Plug 'preservim/nerdcommenter',
Plug 'frazrepo/vim-rainbow',
Plug 'jiangmiao/auto-pairs',
Plug 'lifepillar/vim-mucomplete',
Plug 'rust-lang/rust.vim',
Plug 'nikolvs/vim-sunbather',
Plug 'itchyny/lightline.vim',
Plug 'sonph/onehalf', {'rtp': 'vim/'},
Plug 'nvim-tree/nvim-web-devicons',
Plug 'akinsho/bufferline.nvim', { 'tag': '*' },
Plug 'bleakwind/vim-bufferlist',
Plug 'bleakwind/vim-filelist',
Plug 'enricobacis/vim-airline-clock',
Plug 'psliwka/vim-smoothie',

"Initialize plugin system
call plug#end()

" set nocompatible              " be iMproved, required
" filetype off                  " required
" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" Plugin 'VundleVim/Vundle.vim'
" Plugin 'tpope/vim-fugitive'
" Plugin 'git://git.wincent.com/command-t.git'
" Plugin 'file:///home/gmarik/path/to/plugin'
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Bundle 'sonph/onehalf', {'rtp': 'vim/'}
" call vundle#end()            " required
" filetype plugin indent on    " required

"vim
:set nu
:set noeb vb t_vb=
":colorscheme evening
:let mapleader = " "
":set spell
:let g:vimtex_compiler_enabled = 0
:set spell spelllang=en_gb,en_us,en
:set nospell
:colorscheme onehalfdark
:let g:airline_theme='onehalfdark'
:set mouse=a
:set clipboard=unnamed
"vim

"leader-map
nmap <leader>f <Plug>(coc-codeaction)
xmap <leader>f <Plug>(coc-codeaction)
nmap <leader>a <Plug>(coc-codeaction-cursor)
nnoremap <leader>ss :setlocal spell!<CR>
"nmap <leader>c <Plug>(NERDCommenter-comment)
"nmap <leader>u <Plug>(NERDCommenter-uncomment)
nnoremap <leader>tt :botright terminal<CR>
nnoremap <leader>tn :NERDTreeToggle<CR>
nnoremap <Leader>mm :set mouse=a<CR>
nnoremap <Leader>mn :set mouse=<CR>
nnoremap <S-Up> :resize -1<CR>
nnoremap <S-Down> :resize +1<CR>
nnoremap <S-Left> :vertical resize -1<CR>
nnoremap <S-Right> :vertical resize +1<CR>
nnoremap <leader>tf :FilelistOpen<CR>
"leader-map

"Visual Scroll Bar (Show percentage only)
"" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" function! ScrollIndicator()
"     let current = line('.')
"     let total = line('$')
"     let percent = (current * 100) / total
"     echo '[' . repeat('=', percent/5) . '>'
" endfunction
" autocmd CursorMoved,CursorMovedI * call ScrollIndicator()

"Airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:#extensions#tabline#enabled = 1
if !exists('g:_symbols')
let g:airline_symbols = {}
endif
"let g:_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
"let g:_right_sep = '▶'
let g:airline_right_alt_sep = '❮'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
"Airline

"NERDCommenter
filetype plugin on
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_java = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
"NERDCommenter

"Rainbow
"au FileType c,cpp,objc,objcpp call rainbow#load()
let g:rainbow_active = 1
"Rainbow

"Auto-pairs
au Filetype FILETYPE let b:AutoPairs = {"(": ")"}
au FileType php      let b:AutoPairs = AutoPairsDefine({'<?' : '?>', '<?php': '?>'})
"Auto-pairs

"mucomplete
let g:mucomplete#enable_auto_at_startup = 1
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c
let g:mucomplete#chains = {
    \ 'default' : ['dict', 'keyn', 'uspl'],
    \ }
set dictionary+=/usr/share/dict/words
set complete+=kspell
set dictionary+=/usr/share/vim/vim90/spell/en.utf-8.sug
set dictionary+=/usr/share/vim/vim90/spell/en.utf-8.spl
let g:mucomplete#completion_delay = 0
"mucomplete

"rust
syntax enable
filetype plugin indent on
let g:rustfmt_command = "rustfmt"
autocmd filetype rust nnoremap <F5> : <bar> exec 'RustRun'<CR>
autocmd filetype rust nnoremap <F6> : <bar> exec 'RustTest'<CR>
"rust

"bufferline
set termguicolors
"bufferline

"bufferlist
" " Set 1 enable bufferlist (default: 0)
" let g:bufferlist_enabled = 1
" " Set 1 autostart bufferlist (default: 0)
" let g:bufferlist_autostart = 1
" " Position of bufferlist: 'top', 'bottom', 'left', 'right' (default: 'top')
" let g:bufferlist_position = 'top'
" " Window width for vertical position (default: 20)
" let g:bufferlist_winwidth = 20
" " Window height for horizontal position (default: 1)
" let g:bufferlist_winheight = 1
" " Enable bufferlist restoration (default: 0)
" let g:bufferlist_reopen = 1
" " Path for storing bufferlist data (default: $HOME/.vim/bufferlist)
" "let g:bufferlist_datapath = g:config_dir_data.'bufferlist'
" "Tab color format - [dark cterm, dark gui, light cterm, light gui]
" " Normal buffers
" let g:bufferlist_hldefnor = '#FFFFFF'
" " Modified buffers
" let g:bufferlist_hldefmod = '#F56C6C'
" " Current normal buffer
" let g:bufferlist_hlcurnor = '#67C23A'
" " Current modified buffer
" let g:bufferlist_hlcurmod = '#E0575B'
" " Visible normal buffer
" let g:bufferlist_hlvisnor = '#67C23A'
" " Visible modified buffer
" let g:bufferlist_hlvismod = '#E0575B'
" " Separator
" let g:bufferlist_hlsepnor = '#AAAAAA'
"bufferlist

"filelist
" Set 1 enable filelist (default: 0)
let g:filelist_enabled = 1
" Set 1 autostart filelist (default: 0)
let g:filelist_autostart = 0
" Position of the filelist window: 'left' or 'right' (default: 'left')
let g:filelist_position = 'left'
" Width of the filelist window (default: 30)
let g:filelist_winwidth = 20
" Default directory to show (default: getcwd())
let g:filelist_mainpath = getcwd()
" Set 1 Show hidden files (default: 0)
let g:filelist_showhide = 0
" Set Bookmark place (default: $HOME.'/.vim/filelist')
let g:filelist_datapath = $HOME.'/.vim/filelist'
"filelist

" "scrollbar
" " Prevents loading by telling the plugin it's already loaded. You'll have
" " to :call ToggleScrollbar()<CR> if you want to load it manually.
" " Default characters to use in the scrollbar.
" let g:loaded_scrollbar=1
" map <leader>sb :call ToggleScrollbar()<cr>
" "scrollbar

"airline_clock
" let g:airline#extensions#clock#format = '%H:%M:%S'
" let g:airline#extensions#clock#updatetime = 1000
"
