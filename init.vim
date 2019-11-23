" Plugins
function! PackInit() abort
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('vim-python/python-syntax')
  call minpac#add('chriskempson/base16-vim')
endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

" Enable all syntax highlighting in vim-python/python-syntax
let g:python_highlight_all = 1

" Colorschemes
set termguicolors
silent! colorscheme desert
silent! colorscheme base16-material-darker

set clipboard=unnamedplus
set expandtab
set hidden
set virtualedit=block

" Custom key mappings
noremap H 0
noremap J <C-D>
noremap K <C-U>
noremap L $
noremap M J
noremap <Space> :
noremap <C-W><Space> :

nnoremap Y y$

" NOP
noremap $ <Nop>
noremap 0 <Nop>
noremap : <Nop>
noremap ^ <Nop>
noremap <C-D> <Nop>
noremap <C-U> <Nop>

" Map ESC to clear search highlighting
nnoremap <silent> <Esc> :nohlsearch<CR>

" Map Ctrl-W to exit terminal mode and start windows command
" Use Ctrl-C, <Esc>, <Space>, or other keys to cancel windows command and stay in normal mode
tmap <C-W> <C-\><C-N><C-W>
