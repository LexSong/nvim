" Plugins
function! PackInit() abort
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('chriskempson/base16-vim')
endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

" Colorschemes
set termguicolors
silent! colorscheme desert
silent! colorscheme base16-material-darker

set expandtab
set hidden

" Custom key mappings
noremap H 0
noremap J <C-D>
noremap K <C-U>
noremap L $
noremap <Space> :

nnoremap Y y$

" NOP
noremap $ <Nop>
noremap 0 <Nop>
noremap : <Nop>
noremap ^ <Nop>
noremap <C-D> <Nop>
noremap <C-U> <Nop>
