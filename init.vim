scriptencoding utf-8

" Options
set clipboard=unnamedplus
set fileformats=unix,dos
set hidden
set ignorecase
set nohlsearch
set noshowmode
set signcolumn=no
set termguicolors
set virtualedit=block

" Tab options
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Custom key mappings
noremap : ,
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
noremap , <Nop>
noremap 0 <Nop>
noremap ^ <Nop>
noremap <C-D> <Nop>
noremap <C-U> <Nop>

" Map Ctrl-W to exit terminal mode and start windows command
" Use Ctrl-C or <Esc> to cancel windows command and stay in normal mode
tmap <C-W> <C-\><C-N><C-W>

" Unset $TERM in shell command if $TERM is vtpcon
if $TERM ==# 'vtpcon'
  set shell=cmd.exe\ /C\ set\ TERM=&&cmd.exe
endif

" Set python3 executable
if has('win32')
  let g:python3_host_prog = 'C:\Users\LexSong\scoop\apps\miniconda3\current\envs\neovim\python.exe'
  if !executable(g:python3_host_prog)
    echoerr "Can't find Conda environment for Neovim"
    unlet g:python3_host_prog
  endif
endif

" Plugins
function PackInit() abort
  packadd minpac
  call minpac#init()
  call minpac#add('chriskempson/base16-vim')
  call minpac#add('dense-analysis/ale')
  call minpac#add('glacambre/firenvim', { 'type': 'opt', 'do': 'packadd firenvim | call firenvim#install(0)'})
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('maximbaz/lightline-ale')
  call minpac#add('numirias/semshi', {'type': 'opt', 'do': 'UpdateRemotePlugins'})
endfunction

command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()
command! PackUpdate call PackInit() | call minpac#update()

" ALE
let g:ale_set_signs = 0
let g:ale_virtualtext_prefix = '▌'

" Display ALE Virtual Text
let g:ale_virtual_text_ns = nvim_create_namespace('ale_virtual_text')

function DisplayALEVirtualText() abort
  for l:buffer in keys(g:ale_buffer_info)
    let l:buffer = str2nr(l:buffer)
    call nvim_buf_clear_namespace(l:buffer, g:ale_virtual_text_ns, 0, -1)
    let l:loclist = ale#engine#GetLoclist(l:buffer)
    for l:err in reverse(copy(l:loclist))
      let l:chunks = GetALEVirtualTextChunks(l:err)
      call nvim_buf_set_virtual_text(l:buffer, g:ale_virtual_text_ns, l:err.lnum-1, l:chunks, {})
    endfor
  endfor
endfunction

function GetALEVirtualTextChunks(err) abort
  let l:text = g:ale_virtualtext_prefix . substitute(a:err.text, '\r', '', 'g')
  if a:err.type is# 'E'
    let l:hl_group = 'ALEVirtualTextError'
  elseif a:err.type is# 'W'
    let l:hl_group = 'ALEVirtualTextWarning'
  else
    let l:hl_group = 'ALEVirtualTextInfo'
  endif
  return [[' ', ''], [l:text, l:hl_group]]
endfunction

augroup ale_virtual_text
  autocmd!
  autocmd User ALELintPost call DisplayALEVirtualText()
  autocmd ColorScheme * silent! call g:Base16hi("ALEVirtualTextError",   g:base16_gui08, g:base16_gui01, g:base16_cterm08, g:base16_cterm01)
  autocmd ColorScheme * silent! call g:Base16hi("ALEVirtualTextWarning", g:base16_gui0A, g:base16_gui01, g:base16_cterm0A, g:base16_cterm01)
  autocmd ColorScheme * silent! call g:Base16hi("ALEVirtualTextInfo",    g:base16_gui0C, g:base16_gui01, g:base16_cterm0C, g:base16_cterm01)
augroup END

" Custom ALE Fixers
function ALEFixerRemoveCR(buffer, lines) abort
  return map(a:lines, {_, line -> substitute(line, '\r', '', 'g')})
endfunction

" Firenvim
if exists('g:started_by_firenvim')
  packadd firenvim
  let g:firenvim_config = {'localSettings': {'.*': {'priority': 0, 'takeover': 'never'}}}
  set guifont=Consolas:h14
  autocmd UIEnter * set laststatus=0
endif

" lightline.vim
let g:lightline = {}

let g:lightline.component_expand = {
\ 'ale_checking': 'lightline#ale#checking',
\ 'ale_errors':   'lightline#ale#errors',
\ 'ale_warnings': 'lightline#ale#warnings',
\ 'ale_infos':    'lightline#ale#infos',
\}

let g:lightline.component_type = {
\ 'ale_errors':   'error',
\ 'ale_warnings': 'warning',
\ 'ale_infos':    'info',
\}

let g:lightline.active = {}
let g:lightline.active.left = [
\ ['mode', 'paste'],
\ ['ale_checking', 'ale_errors', 'ale_warnings', 'ale_infos'],
\ ['readonly', 'filename', 'modified'],
\]

function UpdateLightlineColorscheme() abort
  if exists('g:base16_gui00')
    runtime autoload/lightline/colorscheme/base16.vim
    let g:lightline.colorscheme = 'base16'
  else
    let g:lightline.colorscheme = 'default'
  endif
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

augroup lightline_colorscheme
  autocmd!
  autocmd ColorScheme * silent! call UpdateLightlineColorscheme()
augroup END

" Semshi
if has('python3')
  packadd semshi
endif

let g:semshi#error_sign = v:false
let g:semshi#mark_selected_nodes = 2

augroup semshi_highlights
  autocmd!
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
augroup END

" Colorschemes
silent! colorscheme desert
silent! colorscheme base16-material
