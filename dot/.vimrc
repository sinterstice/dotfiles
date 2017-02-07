"NeoBundle Scripts-----------------------------
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Refer to |:NeoBundle-examples|.
" Statusline
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-fugitive'
" Search
NeoBundle 'vim-scripts/SearchComplete'
NeoBundle 'ctrlpvim/ctrlp.vim'
" File browsing
NeoBundle 'mileszs/ack.vim'
NeoBundle 'jistr/vim-nerdtree-tabs'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'vim-scripts/a.vim' " Open header file for current file, vice versa
NeoBundle 'fholgado/minibufexpl.vim'
" Colors & fonts
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'wellsjo/wells-colorscheme.vim'
" Lang support
NeoBundle 'wting/rust.vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'fatih/vim-go'
" VimL functions
NeoBundle 'LucHermitte/lh-vim-lib'
NeoBundle 'vim-scripts/nextval'
" Enhancements for edit, insert etc
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-commentary'
if v:version > 703
    NeoBundle 'Valloric/YouCompleteMe', { 'build' : { 'mac' : './install.sh --gocode-completer --clang-completer --tern-completer --system-libclang', } }
endif
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"End NeoBundle Scripts-------------------------

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

" close window
map <leader>wc :wincmd q<cr>

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

map <C-w>J	:vertical resize -5<cr>

" hide window
map <leader>wh              :hide<cr>

" open last buffer in vertical split
map <leader>s              :vert belowright sb #<cr>

" close buffer
map <leader>c              :MBEbd<cr>

" reload vim config
map <leader>r :so ~/.vimrc<cr>

" shortcut for closing a buffer without messing up windows
cnoreabbrev bc MBEbd

" shortcut for turning spellcheck on/off
cnoreabbrev spellon setlocal spell spelllang=en_us
cnoreabbrev spelloff setlocal spell spelllang=

cnoreabbrev ea set autoread | checktime | set noautoread 

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

set clipboard=unnamed

" yank to system clipboard
map <leader>y "*y

" Put from system clipboard
map <leader>p "*p

" Insert a newline
map <leader>o i<cr><C-[>

"Aliases"
" function to define aliases (from http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev)
function! CommandCabbr(abbreviation, expansion)
  execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
" Use it on itself to define a simpler abbreviation for itself.
CommandCabbr ccab CommandCabbr

" Search alias for ack.vim
CommandCabbr ag Ack 

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

"Fix for crontab: temp file must be edited in place
autocmd filetype crontab setlocal nobackup nowritebackup

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
