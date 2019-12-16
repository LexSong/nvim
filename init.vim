" Options
set clipboard=unnamedplus
set fileformats=unix,dos
set hidden
set termguicolors
set virtualedit=block

" Tab options
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

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
" Use Ctrl-C or <Esc> to cancel windows command and stay in normal mode
tmap <C-W> <C-\><C-N><C-W>

" Plugins
function! PackInit() abort
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('numirias/semshi')
  call minpac#add('chriskempson/base16-vim')
endfunction

command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()
command! PackUpdate call PackInit() | call minpac#update()

" Semshi
let g:semshi#error_sign = v:false
let g:semshi#mark_selected_nodes = 2

" Semshi highlights
autocmd ColorScheme * silent! call g:Base16hi("semshiLocal",           g:base16_gui08, "", g:base16_cterm08, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiGlobal",          g:base16_gui0A, "", g:base16_cterm0A, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiImported",        g:base16_gui0A, "", g:base16_cterm0A, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiParameter",       g:base16_gui08, "", g:base16_cterm08, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiParameterUnused", g:base16_gui08, "", g:base16_cterm08, "", "underline")
autocmd ColorScheme * silent! call g:Base16hi("semshiFree",            g:base16_gui08, "", g:base16_cterm08, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiBuiltin",         g:base16_gui0E, "", g:base16_cterm0E, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiAttribute",       g:base16_gui0D, "", g:base16_cterm0D, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiSelf",            g:base16_gui0F, "", g:base16_cterm0F, "")
autocmd ColorScheme * silent! call g:Base16hi("semshiUnresolved",      g:base16_gui0A, "", g:base16_cterm0A, "", "underline")
autocmd ColorScheme * silent! call g:Base16hi("semshiSelected",        g:base16_gui0C, "", g:base16_cterm0C, "", "underline")

" Colorschemes
silent! colorscheme desert
silent! colorscheme base16-material-darker
