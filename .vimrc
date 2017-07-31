call pathogen#infect()
call pathogen#helptags()
set number
set hidden
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*pyc,*/node_modules/*
set ignorecase
set smartcase
set backspace=indent,eol,start
set nomodeline " Don't try to interpret modelines
syntax on

filetype off

nnoremap <SPACE> <Nop>
let mapleader="\<space>" " Set leader key to space

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'einars/js-beautify'
Bundle 'ludovicchabant/vim-gutentags'
let g:gutentags_exclude = ['*.js']
Bundle 'majutsushi/tagbar'
    let g:tagbar_sort = 0

let g:ale_linters = {
\   'python': ['flake8'],
\}

"python-mode Config"

" let g:pymode_lint = 0
" let g:pymode_doc = 0
" let g:pymode_lint_message = 1
" let g:pymode_lint_cwindow = 0
" let g:pymode_options_max_line_length = 115
" let g:pymode_folding = 0
" let g:pymode_doc_bind = 'K'
" let g:pymode_trim_whitespaces = 0
" let g:pymode_breakpoint = 0
" 
" let g:pymode_rope = 1
" let g:pymode_rope_rename_bind = \"<leader>rr"
" let g:pymode_rope_autoimport = 1
" let g:pymode_rope_autoimport_bind = '<leader>ra'
" 
" let g:pymode_breakpoint_bind = '<leader>dldb'

" Disables window for documentation. Crucial.
set completeopt=menu

" Bundle 'scrooloose/:help syntasticsyntastic'
"     let g:syntastic_python_checkers=['python']
"     let g:syntastic_haskell_checkers=['ghc_mod']
"     let g:syntastic_javascript_checkers=['eslint']
"     let g:syntastic_disabled_filetypes=['py'] " Let pymode do the highlighting
    " let g:pymode_lint_on_write = 0
    " let g:pymode_lint_ignore = ""
    " let g:syntastic_haskell_ghc_mod_exec = '~/.cabal/bin/ghc-mod'
    " let g:syntastic_python_checkers=['pylint']

" flake8
let g:flake8_show_in_gutter=1
let g:flake8_show_quickfix=0  " don't show

" greplace
set grepprg=ag

let g:grep_cmd_opts = '--line-numbers --noheading'

autocmd BufWritePost *.py call Flake8()
autocmd FileType python map <buffer> <leader>p :call Flake8()<CR>
" Auto-detect indentation
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

Bundle 'tpope/vim-sleuth'

Plugin 'szw/vim-tags'

filetype plugin on
filetype indent on

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
nnoremap ; :
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

set hlsearch
set incsearch

set expandtab
set tabstop=4
set shiftwidth=4
set textwidth=110
if exists("+colorcolumn")       " use colorcolumn if supported
  let &colorcolumn = &textwidth
  hi ColorColumn ctermbg=Yellow
endif
set autoindent
set smartindent
set ofu=syntaxcomplete#Complete

imap <C-d> import ipdb; ipdb.set_trace()<esc>
imap <C-f> require 'pry'; binding.pry<esc>
imap <C-s> from django.test import TestCaseclass Test(TestCase):def setUp(self):pass<esc>


set runtimepath^=~/.vim/bundle/ctrlp.vim " Use ctrl-p
" Exclude gitignore files
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']


set nocompatible          " duh
set history=1000          " longer history
set autoread              " reload changed files when focus returns
set modeline              " enable modelines

set nobackup      " don't save backup files
set nowritebackup " don't save backup files
set noswapfile    " don't create .swp files

set ruler                      " show cursor position, etc.
set showcmd                    " display commands in progress at the bottom


hi LineNr ctermfg=DarkGray ctermbg=Black
hi diffAdded ctermfg=DarkGreen ctermbg=Black
hi diffRemoved ctermfg=DarkRed ctermbg=Black
hi diffFile ctermfg=darkcyan ctermbg=Black

" Mappings

" Allow ctrl-p to search through tags
nnoremap <leader>. :CtrlPTag<cr>

" treat moving vertically on a wrapped line as two different lines
nnoremap j gj
nnoremap k gk

" automatic brace closing
inoremap {<CR>  {<CR>}<Esc>O
inoremap [<CR>  [<CR>]<Esc>O

" underlining
nnoremap <LEADER>= yyp<C-v>$r=
nnoremap <LEADER>- yyp<C-v>$r-

set list listchars=trail:.,tab:>. " highlight trailing whitespace
"autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace on save

au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.ejs set filetype=html

let g:autofenc_enable = 1 " enable auto fenc (helps determine file encoding)
let g:vim_tags_use_language_field = 1 " allow tags to be autocompleted

map <leader>a :Ag<space>
map <leader>b :CtrlPBuffer<CR>
map <leader>e :TagbarToggle<CR>

" git and diff stuff
map <leader>d2 :diffget //2 <bar> diffupdate<CR>
map <leader>d3 :diffget //3 <bar> diffupdate<CR>
map <leader>dg :diffget <bar> diffupdate<CR>
map <leader>do :diffoff<CR>
map <leader>dp :diffput <bar> diffupdate<CR>
map <leader>dt :diffthis<CR>
map <leader>du :diffupdate<CR>
map <leader>gb :Gblame -w<CR>
map <leader>gc :Gcommit<CR>
map <leader>ga :Gcommit --amend<CR>
map <leader>gh :GHComment<space>
map <leader>gg :Gist -b<space>
map <leader>gd :Gvdiff<space>
map <leader>gs :Gstatus<CR>
map <leader>gw :Gwrite<CR>
map <leader>y "+y
map <leader>p "+p
map <leader>P "+P

nmap g* :Ag -w <C-R><C-W><space>

:colorscheme slate

