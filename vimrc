"https://github.com/crusoexia/vim-monokai
colors monokai
set nocompatible	" use vim defaults

autocmd BufNewFile,BufRead *.less   set filetype=less
autocmd BufNewFile,BufRead *.ts     set filetype=typescript

autocmd Filetype c,cpp                setlocal ai noet ts=8 sw=8 sts=8
autocmd Filetype html                 setlocal ai et ts=4 sw=4 sts=4
autocmd Filetype php                  setlocal ai et ts=4 sw=4 sts=4

set history=100

set tabstop=4		" number of spaces of tab character
set softtabstop=4	" let backspace delete indent
set shiftwidth=4	" number of spaces to (auto)indent
set expandtab		" expand tabs to spaces

"replace tabs exited to spaces
":retab
"Use the following commands to format the entire document
"gg=G

set showmatch
set autoindent		" always set autoindenting on
set pastetoggle=<F12>	" pastetoggle (sane indentation on pastes)

set scrolloff=3	" keep 3 lines when scrolling
set showcmd		" display incomplete commands
set hlsearch		" hilight searches
set incsearch		" do incremental searching
set nobackup		" do not keep a backup file
set number		" show line number
set ignorecase		" ignore case when searching
set whichwrap=b,s,h,l,<,>,[,]	" move freely between files
set colorcolumn=80

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

"set cursorcolumn
set cursorline

syntax on

imap ii <Esc>
imap II <Esc>

" The default leader is '\', but many people prefer ',' as it's in a standard
"location
let mapleader=','

"Smart way to move btw. window
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"search the words when you right click it, but I tried, the shift key is
"necessary, I don't know why.
set mousemodel=popup

"Shift+z to switch in show or hide search highlight
nmap <silent> <S-Z> :set hls!<CR>:set hls?<CR>

"Shift+w to switch in wrap or no wrap
"
nmap <silent> <S-W> :set wrap!<CR>:set wrap?<CR>

" Wrapped lines goes down/up to next row, rather than next line in file
nnoremap j gj
nnoremap k gk

set list
set list listchars=tab:>.,trail:.,extends:#,nbsp:.  " hilight problematic whitespace

":g/^/ call Del()
"can call the function

"to collapse the empty lines just type
":[range]g/^$/,/./-j
"by deafault it will effect on the global

"to delet the empty lines this might be effective
":[range]g/^\s*$/d
"by deafault it will effect on the global

"you might to add the lines number for the hole page ,this is right for you
":[range]s/^/\=strpart(line('.')."  ",0,&ts)
"between the double quotation marks is a the space that the line number row needs
"I think the Tab might be better

"remember ,* will search the cursor words forward ,and # backward

"by deafault ,Ctr+V is mapped to paste on windows ,so you can't use it to
"select block ,but the gvim also remapped this operation to Ctrl+Q ,still the Shift key is necessary
"with the sentances I write in the _vimrc ,it will be more easier by LeftDraggin with the Alt key

"with the command :
":!gcc % -o run.exe && run.exe
"you will compile and run the current c document with the name "run"
"if you are working with a cc work ,gcc might be change to g++
"but for this ,the MinGW or somethings other must install before
"for java ,the command should be :
":!javac %
"in order to run a class project ,java is needed ,so I don't know how to run it in this command by now

"in order to convert the current source to Html file that is easy for web publish ,
":TOhtml
"might be a usefull command ,in the _vimrc file ,there are some neccessary options

"type [number]j in visual mode, the type cursor can go foward [number] lines
"but with the character G, pay attention to the case, the cursor just locates
"the line with the number you typed

":C+F can get the command history window
