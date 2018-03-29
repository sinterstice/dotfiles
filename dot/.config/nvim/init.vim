" Vundle options
filetype off

call plug#begin()

" Misc
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
" Search
" Plug 'vim-scripts/SearchComplete'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" File browsing
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-dispatch'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/a.vim' " Open header file for current file, vice versa
Plug 'djmadeira/minibufexpl.vim'
" Colors & fonts
Plug 'flazz/vim-colorschemes'
Plug 'wellsjo/wells-colorscheme.vim'
" Lang support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go'
Plug 'moll/vim-node'
Plug 'reasonml-editor/vim-reason-plus'
" VimL functions
Plug 'LucHermitte/lh-vim-lib'
Plug 'qwertologe/nextval.vim'
" Enhancements for edit, insert etc
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

filetype plugin indent on    " required" Statusline

" End Vundle options

runtime macros/matchit.vim

"General options
set showcmd
set dictionary=/usr/share/dict/words
syntax on
set synmaxcol=200
set relativenumber
set number
set mouse+=a
" set ttymouse=xterm2
set backspace=indent,eol,start
set termguicolors
set autowrite

" highlight columns longer than 120 characters
highlight ColorColumn guibg=Magenta
call matchadd('ColorColumn', '\%121v', 100)

" enable JavaScript highlighting for .mjs files
au BufRead,BufNewFile *.mjs set filetype=javascript

" File options
"set wildignore=.DS_Store
set hidden
set autoread

"Search options
set ignorecase
set smartcase
set hlsearch
set incsearch

"Keybindings"
let mapleader = ","

" Insert a single character after cursor
nnoremap <Space> a_<Esc>r

" focus nerdtree
map <leader>t :NERDTreeFocusToggle<CR>

" Find the current file in NERDTree
map <leader>f :NERDTreeFind<cr>

" rotate window
map <leader>wr <C-W>r

map <leader>an :ALENext<cr>
map <leader>ap :ALEPrevious<cr>

function! WinMove(key)
	let t:curwin = winnr()
	exec "wincmd ".a:key
	if (t:curwin == winnr()) "we havent moved
		if (match(a:key,'[jk]')) "were we going up/down
			wincmd v
		else
			wincmd s
		endif
		exec "wincmd ".a:key
	endif
endfunction

map <leader>h              :call WinMove('h')<cr>
map <leader>k              :call WinMove('k')<cr>
map <leader>l              :call WinMove('l')<cr>
map <leader>j              :call WinMove('j')<cr>

" open last buffer in vertical split
map <leader>sv              :vert belowright sb #<cr>

" open last buffer in vertical split
map <leader>sh              :belowright sb #<cr>

" close buffer
map <leader>c              :MBEbd<cr>

cnoreabbrev bc<cr> MBEbd<cr>

" reload vim config
map <leader>r :so ~/.config/nvim/init.vim<cr>

" shortcut for turning spellcheck on/off
cnoreabbrev spellon setlocal spell spelllang=en_us
cnoreabbrev spelloff setlocal spell spelllang=

" closes all buffers except the current buffer
function! CloseAllBuffers()
	let all_buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
	let current_buffer = bufnr('%')
	for i in all_buffers
		if i != current_buffer
			execute 'bd ' . i
		endif
	endfor
endfunction
cnoreabbrev bda call CloseAllBuffers()

" switch to last buffer
map <leader>b :b#<cr>

" switch to next buffer, skipping quickfix
map <tab> :bn<cr>:if &buftype ==# 'quickfix'<Bar>bn<Bar>endif<cr>
map <S-tab> :bp<cr>:if &buftype ==# 'quickfix'<Bar>bp<Bar>endif<cr>

" Replace text without overwriting the most recent buffer
vmap r "_dP

" Insert a newline
nmap <leader>o o<Esc>k
nmap <leader>O O<Esc>j

" Increment/decrement
nmap <silent> = <Plug>nextvalInc
nmap <silent> - <Plug>nextvalDec

" Insert a newline at the current position
nmap <Enter> i<Enter><Esc>

" Use system clipboard
set clipboard=unnamed
map <leader>y "*y
map <leader>p "*p

imap jk <Esc>

" search for visually selected text
vnoremap // y/<C-R>"<CR>

"Aliases"
" function to define aliases (from http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev)
function! CommandCabbr(abbreviation, expansion)
	execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
" Use it on itself to define a simpler abbreviation for itself.
CommandCabbr ccab CommandCabbr

"Allows Vim to automatically create directories to save a file
function! s:MkNonExDir(file, buf)
	if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
		let dir=fnamemodify(a:file, ':h')
		if !isdirectory(dir)
			call mkdir(dir, 'p')
		endif
	endif
endfunction
augroup BWCCreateDir
	autocmd!
	autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

function! StrTrim(txt)
	return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

"LanguageClient settings
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
	\ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio']
    \ }

"MBE settings
let g:miniBufExplMaxSize=3
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplSortBy='number'

"ALE settings
let g:ale_fixers = {
\   'javascript': ['eslint'],
\}
let g:ale_fix_on_save = 1
" let g:ale_sign_error = '❌'
" let g:ale_sign_warning = '⚠️'
let g:ale_sign_column_always = 1 
let g:ale_set_highlights = 1

"NERDTree settings
let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_smart_startup_focus = 2

"Airline settings
let g:airline_powerline_fonts = 1

" Deoplete settings
let g:deoplete#enable_at_startup = 1

"YCM settings
" set completeopt-=preview
" let g:ycm_min_num_of_chars_for_completion = 3
" let g:ycm_add_preview_to_completeopt = 0
" let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_min_num_identifier_candidate_chars = 5
" let g:ycm_show_diagnostics_ui = 0
" let g:ycm_seed_identifiers_with_syntax = 1
" let g:ycm_use_ultisnips_completer = 0
" let g:ycm_semantic_triggers =  {
" 	\   'c' : ['->', '.'],
" 	\   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
" 	\             're!\[.*\]\s'],
" 	\   'ocaml' : ['.', '#'],
" 	\   'cpp,objcpp' : ['->', '.', '::'],
" 	\   'perl' : ['->'],
" 	\   'php' : ['->', '::'],
" 	\   'cs,java,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
" 	\   'javascript' : ['.', '{ '],
" 	\   'ruby' : ['.', '::'],
" 	\   'lua' : ['.', ':'],
" 	\   'erlang' : [':'],
" 	\ }

"Ack.vim settings
map <leader>a :ag
CommandCabbr ag Ack
"let g:ack_use_dispatch = 1
let g:ack_use_cword_for_empty_search = 1
let g:ack_default_options = ''

" Use ag
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

"ctrlp settings
if executable('ag')
	" Use Ag over Grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

	let g:ctrlp_use_caching = 0
endif
let g:ctrlp_working_path_mode = 0

"FZF settings
function! CtrlPCommand()
	let c = 0
	let wincount = winnr('$')
	" Don't open it here if current buffer is not writable (e.g. NERDTree)
	while !empty(getbufvar(+expand("<abuf>"), "&buftype")) && c <= wincount
		exec 'wincmd w'
		let c = c + 1
	endwhile
	exec 'FZF'
endfunction

map <C-p> :call CtrlPCommand()<cr>

"Fix for crontab: temp file must be edited in place
autocmd filetype crontab setlocal nobackup nowritebackup

" JSX enabled in all JS files
let g:jsx_ext_required = 0

"Indent options"
filetype indent on
set autoindent
set smartindent
set cindent
set expandtab
set tabstop=4
set shiftwidth=4

"Format options"
set formatoptions=tcqn1
colorscheme wellsokai
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.pcss set filetype=scss
let g:indentLine_color_term = 239
set guifont=Hack
