set nocompatible

set number
set relativenumber

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatusLineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=%{StatusLineGit()}
set statusline+=\ %F\ %M\ %Y\ %R
set statusline+=%=
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percet:\ %p\%%

set laststatus=2

set showtabline=1

filetype on
syntax on

set shiftwidth=4

set tabstop=4

set expandtab

set nowrap

set incsearch

set ignorecase

set wildmenu

set wildmode=list:longest

set wildignore:*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlxs

colorscheme molokai
