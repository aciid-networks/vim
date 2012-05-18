set nocompatible

let $VIMDIR = matchstr(&rtp, '^.\{-}\ze,')

filetype indent plugin on
syntax on

set hidden
set wildmenu
set showcmd
set hlsearch
" auto change working dir (could have problems with some plugins)
set autochdir

set ignorecase
set smartcase

set whichwrap+=<,>,[,]
set backspace=2
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab

set cindent
set cino=(0,u0,U0

set foldmethod=indent
set foldlevelstart=99
map <C-Space> za
imap <C-Space> <C-O>za

set cscopetag

set nostartofline
set ruler

set visualbell

set number

set cursorline

" move by screen lines, not by real lines
nnoremap j gj
nnoremap k gk
" also in visual mode
vnoremap j gj
vnoremap k gk

" Clear search pattern
map <silent> <Leader>c :let @/ = ""<CR>

" Highlight local variables
let g:TagHighlightSettings={'IncludeLocals':'True'}
function CustomTagHighlight()
	hi LocalVariable guifg=#ff00ff
	hi GlobalVariable guifg=#ff00ff
endfunction
au Syntax c,cpp call CustomTagHighlight()

" Clang compilation options file for Syntastic (if needed)
let g:syntastic_c_config_file = '.clang_complete'
let g:syntastic_cpp_config_file = '.clang_complete'

" Quickfix and compilation shortcuts
autocmd BufReadPost quickfix setlocal nonumber | setlocal colorcolumn=""
map <silent> <F5> :call CompileMe(0)<CR>
imap <F5> <C-O><F5>
map <silent> <S-F5> :call CompileMe(1)<CR>
imap <F5> <C-O><S-F5>
map <silent> <F6> :exec "cclose"<CR>
imap <F6> <C-O><F6>
function CompileMe(run)
	if &modified == 1
		let c = confirm("The current buffer was modified, save changes?", "&Yes\n&No\n&Abort", 3, "Question")
		if c == 1
			:write
		elseif c == 0 || c == 3
			return
		endif
	endif
	TagbarClose
	copen
	if a:run == 0
		silent make
	else
		silent make test
	endif
endfunction

" FuzzyFinder
map <C-F>t :FufBufferTag<CR>
imap <C-F>t <C-O><C-F>t
map <C-F>f :FufFile<CR>
imap <C-F>f <C-O><C-F>f
map <C-F>b :FufBookmarkFile<CR>
imap <C-F>b <C-O><C-F>b
map <C-F>a :FufBookmarkFileAdd<CR>
imap <C-F>a <C-O><C-F>a
let g:fuf_keyOpenTabpage="<S-CR>"
let g:fuf_keyOpenSplit="<C-S>"
let g:fuf_keyOpenVsplit="<C-V>"

" Show most resently used files window
map <F2> :Mru<CR>
imap <F2> <C-O><F2>

" Show undo tree
nnoremap <F3> :GundoToggle<CR>
imap <F3> <C-O><F3>

" Show Tagbar window
map <F4> :TagbarToggle<CR>
imap <F4> <C-O><F4>

" Complete only the current buffer and includes
set complete=.,i

" Complete options (disable preview scratch window)
set completeopt=menu,menuone ",longest

" SuperTab option for context aware completion
let g:SuperTabDefaultCompletionType="context"
set ofu=syntaxcomplete#Complete
let g:SuperTabContextDefaultCompletionType='<c-x><c-o>'
 
" Compatibility with delimitMate expand CR
let g:SuperTabCrMapping=0
let delimitMate_expand_cr=1
let delimitMate_expand_space=1

" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto=0
" Show clang errors in the quickfix window
let g:clang_complete_copen=1

" Select all (ctrl+a)
map <silent> <C-A> gg0vG$
imap <C-A> <ESC><C-A>

" Delete word in insert mode (use C-W like C-BS and C-U like C-S-BS)
imap <C-Del> <C-O>dw
imap <C-S-Del> <C-O>d$

" Move entire line up and down
nnoremap <C-S-DOWN> :m+<CR>==
nnoremap <C-S-UP> :m-2<CR>==
inoremap <C-S-DOWN> <Esc>:m+<CR>==gi
inoremap <C-S-UP> <Esc>:m-2<CR>==gi
vnoremap <C-S-DOWN> :m'>+<CR>gv=gv
vnoremap <C-S-UP> :m-2<CR>gv=gv

if has("gui_running")
	imap <C-Z> <C-O>u

	" Powerline settings
	set laststatus=2
	set encoding=utf-8
	let g:Powerline_symbols = 'fancy'

"	colorscheme inkpot
	colorscheme sift

"	set gfn=ProggyCleanTT\ 12
	set gfn=Monospace\ 8

	set lines=35 columns=110
	set guioptions-=T

	" Create new tab (ctrl+n)
	map <silent> <C-N> :tabnew<CR>
	" Save (ctrl+s)
	map <silent> <C-S> :if expand("%") == ""<CR>:browse confirm w<CR>:else<CR>:confirm w<CR>:endif<CR>
	imap <C-S> <C-O><C-S>
	" Open (ctrl+e)
	map <silent> <C-E> :browse confirm e<CR>
	" Open in new tab (ctrl+n+e)
	map <silent> <C-N><C-E> :browse tabnew<CR>
endif

" Highlight on overlenght
if exists('+colorcolumn')
	set colorcolumn=79
	highlight link OverLength ColorColumn
	exec 'match OverLength /\%'.&cc.'v.\+/'
endif

" Add highlighting on functions and classes for C++
function! EnhanceCppSyntax()
	syn match    cCustomParen    "?=(" contains=cParen,cCppParen
	syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen
	syn match    cCustomScope    "::"
	syn match    cCustomClass    "\w\+\s*::" contains=cCustomScope
	"hi def link cCustomFunc Function
	hi def link cCustomClass Function
endfunction
au Syntax cpp call EnhanceCppSyntax()

" OpenGL syntax highlighting
au FileType c,cpp exec ":source ".$VIMDIR."/syntax/opengl.vim"

" GLSL syntax highlighting
command SetGLSLFileType call SetGLSLFileType()
function SetGLSLFileType()
	for item in getline(1,10)
		if item =~ "#version 400"
			execute ':set filetype=glsl400'
			break
		elseif item =~ "#version 330"
			execute ':set filetype=glsl330'
			break
		else
			execute ':set filetype=glsl'
			break
		endif
	endfor
endfunction
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl SetGLSLFileType
