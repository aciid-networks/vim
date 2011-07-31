set nocompatible

filetype indent plugin on
syntax on
colorscheme inkpot

set hidden
set wildmenu
set showcmd
set hlsearch

set ignorecase
set smartcase

set backspace=indent,eol,start
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

set nostartofline
set ruler

set visualbell

set number

set cursorline

" Complete only the current buffer and includes
set complete=.,i

" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest

" SuperTab option for context aware completion
let g:SuperTabDefaultCompletionType="context"
 
" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto=0
" Show clang errors in the quickfix window
let g:clang_complete_copen=1

" Select all (ctrl+a)
:map <silent> <C-A> gg0vG$
:imap <C-A> <ESC><C-A>

" Delete word for insert mode
fu! DeleteBeginWord()
	normal db
	if col("$")-col(".") == 1
		normal x
	endif
endfu
fu! DeleteBeginLine()
	normal d0
	if col("$")-col(".") == 1
		normal x
	endif
endfu
:imap <C-BS> <C-O>:call DeleteBeginWord()<CR>
:imap <C-Del> <C-O>d<S-Right>
:imap <C-S-BS> <C-O>:call DeleteBeginLine()<CR>
:imap <C-S-Del> <C-O>d<End>

" Highlight on overlenght
if exists('+colorcolumn')
	set colorcolumn=79
	highlight link OverLength ColorColumn
	exec 'match OverLength /\%'.&cc.'v.\+/'
endif

if has("gui_running")
	:imap <C-Z> <C-O>u

	set gfn=ProggyCleanTT\ 12

	set lines=35 columns=110
	set guioptions-=T

	" Save (ctrl+s)
	:map <silent> <C-S> :if expand("%") == ""<CR>:browse confirm w<CR>:else<CR>:confirm w<CR>:endif<CR>
	:imap <C-S> <C-O><C-S>
	" Open (ctrl+e)
	:map <silent> <C-E> :browse confirm e<CR>
	:imap <C-E> <C-O><C-E>
	" Open in new tab (ctrl+n)
	:map <silent> <C-T> :browse tabnew<CR>
	:imap <C-T> <C-O><C-T>
endif
