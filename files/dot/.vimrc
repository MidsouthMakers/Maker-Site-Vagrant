
"Uncomment the following to have Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" supa-awesome syntax highlighting
syntax on
filetype on
set background=dark
" set cakephp's template extension
au BufNewFile,BufRead *.ctp set filetype=php


" auto close html tags while editing
" au Filetype html,xml,xsl,php source ~/.vim/scripts/closetag.vim

set foldmethod=indent "zo to open, zc to close
set foldlevel=99

set number	" turn on line numbers
set showmatch	" show matching braces and brackets
set hlsearch	" highlight search results
set incsearch	" show the first matching result while searching for results
set history=0	" disable our search history

" Intellisense!
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
setlocal omnifunc=syntaxcomplete#Complete
"set cot+=menuone

" always have some lines of text when scrolling
set scrolloff=5

"for mouse support inside screen
set ttymouse=xterm2
set mouse=a

" use tabs but let them look like spaces
set autoindent
set noexpandtab
set tabstop=3
set shiftwidth=3
