" Override the default python ftplugin
let b:did_ftplugin = 1

" Swap ';' and ':'
set iminsert=1
lnoremap <buffer> ; :
lnoremap <buffer> : ;

" For vim-commentary
setlocal commentstring=#\ %s
