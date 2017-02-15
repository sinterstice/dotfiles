set nocompatible

" Vundle options
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
" Search
Plugin 'vim-scripts/SearchComplete'
Plugin 'ctrlpvim/ctrlp.vim'
" File browsing
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/a.vim' " Open header file for current file, vice versa
Plugin 'fholgado/minibufexpl.vim'
" Colors & fonts
Plugin 'flazz/vim-colorschemes'
Plugin 'wellsjo/wells-colorscheme.vim'
" Lang support
Plugin 'sheerun/vim-polyglot'
" VimL functions
Plugin 'LucHermitte/lh-vim-lib'
Plugin 'vim-scripts/nextval'
" Enhancements for edit, insert etc
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
if v:version > 703
    Plugin 'Valloric/YouCompleteMe', { 'build' : { 'mac' : './install.sh --gocode-completer --clang-completer --tern-completer --system-libclang', } }
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required" Statusline
" End Vundle options

"General options"
set showcmd
set dictionary=/usr/share/dict/words
syntax on
set relativenumber 
set number
set mouse+=a
set ttymouse=xterm2
set backspace=indent,eol,start

" highlight columns longer than 120 characters
highlight ColorColumn ctermbg=magenta guibg=magenta
call matchadd('ColorColumn', '\%121v', 100)

" File options
"set wildignore=.DS_Store
set hidden

"Search options"
set ignorecase
set smartcase
set hlsearch
set incsearch

"Keybindings"
let mapleader = ","

" focus nerdtree
map <leader>t :NERDTreeFocusToggle<CR>

" Find the current file in NERDTree
map <leader>f :NERDTreeFind<cr>

" rotate window
map <leader>wr <C-W>r

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

" Generate ctags
cnoreabbrev ctags !ctags -R --exclude=node_modules --fields=+l .

" reload vim config
map <leader>r :so ~/.vimrc<cr>

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

" switch to next buffer
map <tab> :bn<cr>
map <S-tab> :bp<cr>

" Replace text without overwriting the most recent buffer
vmap r "_dP

" Insert a newline
nmap <leader>o o<Esc>k
nmap <leader>O O<Esc>j

" Use system clipboard
map <leader>y "*y
map <leader>p "*p

imap ii <Esc>

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

"NERDTree settings
let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_smart_startup_focus = 2

"Airline settings
let g:airline_powerline_fonts = 1

"YCM settings
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_collect_identifiers_from_tags_files = 1

"Ack.vim settings
map <leader>a :ag 
CommandCabbr ag Ack 
let g:ack_use_dispatch = 1
let g:ack_use_cword_for_empty_search = 1

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

function! CtrlPCommand()
	let c = 0
	let wincount = winnr('$')
	" Don't open it here if current buffer is not writable (e.g. NERDTree)
	while !empty(getbufvar(+expand("<abuf>"), "&buftype")) && c < wincount
		exec 'wincmd w'
		let c = c + 1
	endwhile
	exec 'CtrlP'
endfunction
let g:ctrlp_cmd = 'call CtrlPCommand()'
let g:ctrlp_lazy_update = 1

"Fix for crontab: temp file must be edited in place
autocmd filetype crontab setlocal nobackup nowritebackup

" JSX enabled in all JS files
let g:jsx_ext_required = 0

"Indent options"
filetype indent on
set autoindent
set smartindent
set cindent
set shiftwidth=4

"tab settings"
set noexpandtab
set tabstop=4

"Format options"
set formatoptions=tcqn1
colorscheme wellsokai
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.pcss set filetype=scss
let g:indentLine_color_term = 239
set guifont=Hack
