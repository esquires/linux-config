
" togglelist settings
function! s:GetBufferList() 
  redir =>buflist 
  silent! ls 
  redir END 
  return buflist 
endfunction

function! QuickFixIsOpen()
  " adapted from ToggleList.vim
  for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))') 
    if bufwinnr(bufnum) != -1
      return 1
    endif
  endfor
  return 0
endfunction

function! QuickFixWrapper()
  call ToggleQuickfixList()
  if QuickFixIsOpen()
    wincmd l
    wincmd j
    wincmd J
  endif

endfunction

let g:toggle_list_no_mappings=1
nnoremap <leader>l :call ToggleLocationList()<cr>
nnoremap <leader>q :call QuickFixWrapper()<cr>
