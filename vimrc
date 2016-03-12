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
NeoBundle 'bling/vim-airline'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'waylan/vim-markdown-extra-preview'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'wellsjo/wells-colorscheme.vim'
NeoBundle 'wting/rust.vim'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'evidens/vim-twig'
NeoBundle 'LucHermitte/lh-vim-lib'
NeoBundle 'LucHermitte/local_vimrc'
NeoBundle 'fatih/vim-go'
NeoBundle 'vim-scripts/nextval'
NeoBundle 'jistr/vim-nerdtree-tabs'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'vim-scripts/a.vim'
NeoBundle 'vim-scripts/SearchComplete'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jdonaldson/vaxe'
NeoBundle 'fholgado/minibufexpl.vim'
if v:version > 703
    NeoBundle 'Valloric/YouCompleteMe', { 'build' : { 'mac' : './install.sh --clang-completer --system-libclang --omnisharp-completer', } }
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
set number
set mouse=a
set backspace=indent,eol,start

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

" focus MBE
map <leader>f :MBEFocus<CR>

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

" hide window
map <leader>wh              :hide<cr>

" open last buffer in vertical split
map <leader>s              :vert belowright sb #<cr>

" close buffer
map <leader>c              :MBEbd<cr>

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

" hide Syntastic windows
" map <leader>r :SyntasticReset<cr>

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

"Airline settings
let g:airline_powerline_fonts = 1

so ~/.vimrc-style
