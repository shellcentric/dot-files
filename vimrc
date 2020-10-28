execute pathogen#infect()

" <Vundle>-------------------------------------------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" </Vundle>------------------------------------------------------------------

" <General>------------------------------------------------------------------
syntax enable
set viminfo=""
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set modelineexpr
let g:netrw_dirhistmax = 0
" </General>-----------------------------------------------------------------

" <COLOR> -------------------------------------------------------------------
set termguicolors
let ayucolor="dark"
colorscheme ayu
" </COLOR> -------------------------------------------------------------------

" <SOUND> No sound at all ---------------------------------------------------
set noerrorbells
set novisualbell
set t_vb=
autocmd! GUIEnter * set vb t_vb=
" </SOUND> ------------------------------------------------------------------

call vundle#end()

" <TABS> --------------------------------------------------------------------
if has("autocmd")
    " Use FileType detection and file-based automatic indenting.
    filetype plugin indent on
    " Use real tab characters in Makefiles.
    autocmd FileType make set ts=4 sw=4 softtabstop=0 noexpandtab
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
endif

" For every other file, use a tab width of four spaces
set ts=4
set sw=4
set softtabstop=4
set expandtab
" </TABS> -------------------------------------------------------------------

