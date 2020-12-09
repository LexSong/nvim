" Override default python ftplugin
let b:did_ftplugin = 1

" ALE
let b:ale_fixers = ['black', 'reorder-python-imports', 'ALEFixerRemoveCR']
let b:ale_linters = ['flake8', 'jedils']

set omnifunc=ale#completion#OmniFunc

nmap = <Plug>(ale_fix)

" Update Semshi highlight after ALEFix
augroup update_semshi_highlight
  autocmd!
  autocmd User FileType python ALEFixPost :Semshi highlight
augroup END
