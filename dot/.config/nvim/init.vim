" Vim-Plugged options
filetype off

call plug#begin()

" Misc
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
" Search
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
Plug 'rose-pine/neovim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Lang support
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
" Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go'
Plug 'moll/vim-node'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'Chiel92/vim-autoformat'
" VimL functions
Plug 'LucHermitte/lh-vim-lib'
Plug 'qwertologe/nextval.vim'
" Enhancements for edit, insert etc
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

filetype plugin indent on    " required" Statusline

" End Vundle options

runtime macros/matchit.vim

"General options
set showcmd
syntax on
set synmaxcol=1024
set relativenumber
set number
set mouse+=a
set backspace=indent,eol,start
set termguicolors
set autowrite

" if !empty(glob(".dev_env"))
"     Dotenv .dev_env
" endif

" highlight columns longer than 120 characters
highlight ColorColumn guibg=Magenta
call matchadd('ColorColumn', '\%121v', 100)

" File options
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

" ============== coc stuff ===================

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#insert() :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
inoremap <expr> <S-n> coc#pum#visible() ? coc#pum#prev(1) : "\<S-n>"

" nnoremap <C-n> :ALENext<cr>
" map <leader>d :ALEDetail<cr>

nnoremap <C-n> <Plug>(coc-diagnostic-next)
nnoremap <S-n> <Plug>(coc-diagnostic-prev)
nmap <silent!> gd <Plug>(coc-definition)
nmap <silent!> gy <Plug>(coc-type-definition)
nmap <silent!> gi <Plug>(coc-implementation)
nmap <silent!> gr <Plug>(coc-references)

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

nnoremap <silent> K :call ShowDocumentation()<CR>

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

" xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>=  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json,rust setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ============== end coc stuff ===================

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

" map <leader>g :ALEGoToDefinition<cr>

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
set clipboard=unnamedplus

" search for visually selected text
vnoremap // y/<C-R>"<CR>

vnoremap y "+y

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

"vim-surround settings
let g:surround_99 = "/* \r */"

"MBE settings
let g:miniBufExplMaxSize=3
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplSortBy='number'

""ALE settings
"" \   'typescript': ['eslint', 'tslint'],
"" \   'typescript.tsx': ['eslint', 'tslint --jsx']
"let g:ale_linters = {
"\   'javascript': ['eslint'],
"\   'javascriptreact': ['eslint'],
"\   'typescript': ['tslint'],
"\   'typescriptreact': ['tsserver'],
"\}
"let g:ale_fixers = {
"\   'javascript': ['eslint'],
"\   'javascriptreact': ['eslint'],
"\   'typescript': [],
"\   'typescriptreact': [],
"\   'rust': ['rustfmt']
"\}
"let g:ale_lint_delay = 500
"let g:ale_fix_on_save = 1
"let g:ale_sign_column_always = 1
"let g:ale_sign_error = '❌'
"let g:ale_sign_warning = '⚠️'
"let g:ale_set_highlights = 1

"NERDTree settings
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_smart_startup_focus = 2

"Airline settings
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
  \ '__'     : '-',
  \ 'c'      : 'C',
  \ 'i'      : 'I',
  \ 'ic'     : 'I',
  \ 'ix'     : 'I',
  \ 'n'      : 'N',
  \ 'multi'  : 'M',
  \ 'ni'     : 'N',
  \ 'no'     : 'N',
  \ 'R'      : 'R',
  \ 'Rv'     : 'R',
  \ 's'      : 'S',
  \ 'S'      : 'S',
  \ ''     : 'S',
  \ 't'      : 'T',
  \ 'v'      : 'V',
  \ 'V'      : 'V',
  \ ''     : 'V',
  \ }
let g:airline_stl_path_style = 'short'
let g:airline#extensions#branch#enabled = 0
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" Deoplete settings
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete = 0
let g:python3_host_prog = "/usr/bin/python3.11"

"Ack.vim settings
map <leader>a :ag<space>
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
colorscheme rose-pine
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.pcss set filetype=scss
let g:indentLine_color_term = 239
set guifont=Hack

"Editor options"
set updatetime=300
set signcolumn=yes
