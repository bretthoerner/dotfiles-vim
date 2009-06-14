set nocompatible                    " Turn off vi-compatability mode, must be first line
set encoding=utf-8                  " Set unicode codec to UTF-8
syntax on                           " Use syntax highlighting
filetype on                         " Detect the filetype
filetype indent on                  " Load filetype indent file
filetype plugin on                  " Load filetype plugins
set history=1000                    " Number of history lines to rememeber
set showcmd                         " Display incomplete commands
set nobackup                        " Do not create a backup file
set nostartofline                   " Don't jump to first character when paging
set showmatch                       " Show matching braces
set matchtime=10                    " Blink matching brackets for one second
set confirm                         " Rather than :q etc failing, prompt to force
set ffs=unix,dos,mac                " Support all three file formats
set isk+=_,$,@,%,#,-                " Don't use these as word dividers
set wildmenu                        " Turn on completion menu for commands
set wildignore+=*~,*.o,*.obj,*.bak,*.exe,*.pyc,*.pyo,*.swp,.DS_Store,*.db,tags
set ruler                           " Always show line and column numbers
set cmdheight=2                     " Make Command-line 2 tall
set lazyredraw                      " Do not redraw while running macros (faster)
set hidden                          " Can change buffers without saving
set backspace=2                     " Allow backspace to go beyond insert and newlines
set whichwrap+=<,>,h,l,b,s,[,]      " Make backspace and cursor keys wrap too
set shortmess=atI                   " Shortens messages to avoid 'press a key' prompt
set report=0                        " Report when anything is changed via :...
set visualbell t_vb=                " Don't blink
set noerrorbells                    " Don't make noise
set hlsearch                        " Highlight searched for phrases
set incsearch                       " Do highlight as you type you search phrase
set ignorecase                      " Search case insensitively
set smartcase                       " ... unless we search for something uppercase
set scrolloff=5                     " Keep 5 lines (top/bottom) for scope
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [%l/%L\ (%p%%)]
set laststatus=2                    " Always show the status line
set formatoptions=tcrqn             " See Help (complex)
set autoindent                      " Indent same as previous line
set tabstop=4                       " Tab spacing
set softtabstop=4                   " Backspace will remove 4 spaces (a tab)
set shiftwidth=4                    " Sets length for < and > visual indent
set smarttab                        " Use shiftwidth for tab at ^
set expandtab                       " Tabs made up of spaces
set esckeys                         " Cursor keys in insert mode
set completeopt-=preview            " Don't show complete preview info
set complete-=t,i                   " Don't complete based on tags
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$

if has("gui_running")
    set lines=50
    set columns=120
    set background=dark
    set guioptions-=T               " Remove toolbar
    set mouse=a                     " Use mouse for all
    hi normal guibg=black
    colorscheme brookstream
endif

" Omnicomplete
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType ruby set omnifunc=rubycomplete#Complete
imap <C-F> <C-X><C-O>

" Make wq case insensitive
command -nargs=* Q q <args>         " :Q quits
command -nargs=* W w <args>         " :W saves
command -nargs=* Wq wq <args>       " :Wq quits and saves
command -nargs=* WQ wq <args>       " :WQ quits and saves

" cscope options
if has("cscope")
    set cscopetag           " Use both cscope and ctags for 'ctrl-]', ':ta' and 'vim -t'
    set csto=0              " Check cscope for definition before ctags
    set cscopeverbose       " Show a message when cscope DB is added
endif

" Move between tabs
map <F1> :tabp<CR>
map <F2> :tabn<CR>

" NERDTree Plugin
map <F3> :NERDTreeToggle<CR>
let NERDTreeWinSize=35
" Mirror wildignore to NERDTreeIgnore
let NERDTreeIgnore=[]
for ignored in split(&wildignore, ",")
    let ignored = substitute(ignored, "^\*", "", "")
    let ignored = substitute(ignored, "\*", "\.*", "g")
    let ignored = substitute(ignored, "\\.", "\\\\.", "g")
    let ignored = substitute(ignored, "\\~", "\\\\~", "g")
    let ignored = substitute(ignored, "$", "\$", "")
    call add(NERDTreeIgnore, ignored)
endfor
unlet ignored

" Tlist Plugin
map <F4> :TlistToggle<CR>
let Tlist_Enable_Fold_Column=0
let Tlist_WinWidth=35
let Tlist_GainFocus_On_ToggleOpen = 1      " Focus on the taglist when its toggled
let Tlist_Close_On_Select = 1              " Close when something's selected  

" Enable custom syntax plugins
au BufRead,BufNewFile nginx.conf set ft=nginx
au BufRead,BufNewFile *.mkd set ft=mkd
au BufRead,BufNewFile *.jinja.html set ft=htmljinja
au BufRead,BufNewFile *.jinja set ft=jinja

" Enable closetag for html / xml
au Filetype html,htmldjango,xml,xsl runtime scripts/closetag.vim

" F5 to toggle Paste
map <F5> :call Paste_on_off()<CR>
imap <F5> <C-O>:call Paste_on_off()<CR>
let paste_mode = 0
func! Paste_on_off()
        if g:paste_mode == 0
                set paste
                let g:paste_mode = 1
                echo "Paste mode: ON"
        else
                set nopaste
                let g:paste_mode = 0
                echo "Paste mode: OFF"
        endif
        return
endfunc

" F6 to toggle List
map <F6> :call List_on_off()<CR>
imap <F6> <C-O>:call List_on_off()<CR>
let list_mode = 0
func! List_on_off()
        if g:list_mode == 0
                set list
                let g:list_mode = 1
                echo "List mode: ON"
        else
                set nolist
                let g:list_mode = 0
                echo "List mode: OFF"
        endif
        return
endfunc

" F7 to highlight extra whitespace
map <F7> :call Whitespace_on_off()<CR>
imap <F7> <C-O>:call Whitespace_on_off()<CR>
let extra_whitespace = 0
func! Whitespace_on_off()
        if g:extra_whitespace == 0
                syn match ExtraWhitespace /\s\+$\| \+\ze\t/
                hi ExtraWhitespace ctermbg=1 guibg=#FF0000
                let g:extra_whitespace = 1
                echo "Whitespace mode: ON"
        else
                syntax clear ExtraWhitespace
                hi clear ExtraWhitespace
                let g:extra_whitespace = 0
                echo "Whitespace mode: OFF"
        endif
        return
endfunc

