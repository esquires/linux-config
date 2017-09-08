" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"
let &titlestring=expand("%:t")
set title

"enable very magic
nnoremap / /\v
nnoremap ? ?\v
nnoremap <leader>a :qa<cr>
set smartcase

" lvdb
nnoremap <localleader>d :call lvdb#Python_debug()<cr>
nnoremap <leader>n :call lines#ToggleNumber()<cr>

"plugin management
filetype on
filetype plugin on
filetype indent on

" tagbar
nnoremap <localleader>t :TagbarToggle<CR>

" deoplete
if has("nvim")
    let g:deoplete#enable_at_startup = 1
endif

"pathogen plugin
call pathogen#infect()

" togglelist settings
let g:toggle_list_no_mappings=1
nnoremap <leader>l :call ToggleLocationList()<cr>
nnoremap <leader>q :call ToggleQuickfixList()<cr>

" lvdb settings  (always toggle line numbers)
let g:lvdb_toggle_lines = 3
let g:lvdb_close_tabs = 1

" color setup
" backspace/colors
set bs=2

"colorscheme stuff
"change background
set t_Co=256
colorscheme wombat256A
if has("gui_running")
    set spell
else
    "spell check comes out as poor highlighting
    set nospell
endif

" neomake
" errorformat for cppcheck copied from syntastic:
"   https://github.com/vim-syntastic/syntastic/blob/master/syntax_checkers/c/cppcheck.vim
nnoremap <leader>c :cnext<CR>
nnoremap <leader>L :lnext<CR>
let g:neomake_tex_enabled_makers=[]
let g:neomake_cpp_enabled_makers=['cpplint', 'cppcheck', 'cppclean']
let g:neomake_open_list=0
let g:neomake_highlight_lines=1
let g:neomake_python_enabled_makers=['pylint', 'pydocstyle', 'flake8']

let g:neomake_cpp_cppclean_maker={
        \ 'exe': "cpp_static_wrapper.py",
        \ 'args': ['cppclean'],
        \ 'errorformat': '%f:%l: %m, %f:%l %m'
        \ }

let g:neomake_python_pylint_maker={
    \ 'args': [
        \ '--rcfile=~/repos/linux-config/.pylintrc',
        \ '--output-format=text',
        \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"',
        \ '--reports=no'
    \ ],
    \ 'errorformat':
        \ '%A%f:%l:%c:%t: %m,' .
        \ '%A%f:%l: %m,' .
        \ '%A%f:(%l): %m,' .
        \ '%-Z%p^%.%#,' .
        \ '%-G%.%#',
    \ 'output_stream': 'stdout',
    \ 'postprocess': [
    \   function('neomake#postprocess#GenericLengthPostprocess'),
    \   function('neomake#makers#ft#python#PylintEntryProcess'),
    \ ]}

let g:neomake_cpp_cppcheck_maker={
        \ 'exe': 'cpp_static_wrapper.py',
        \ 'args': 'cppcheck',
        \ 'errorformat' :
        \   '[%f:%l]: (%trror) %m,' .
        \   '[%f:%l]: (%tarning) %m,' .
        \   '[%f:%l]: (%ttyle) %m,' .
        \   '[%f:%l]: (%terformance) %m,' .
        \   '[%f:%l]: (%tortability) %m,' .
        \   '[%f:%l]: (%tnformation) %m,' .
        \   '[%f:%l]: (%tnconclusive) %m,' .
        \   '%-G%.%#'}

let g:neomake_cpp_cpplint_maker={
        \ 'exe': executable('cpplint') ? 'cpplint' : 'cpplint.py',
        \ 'args': ['--verbose=3'],
        \ 'errorformat':
        \     '%A%f:%l:  %m [%t],' .
        \     '%-G%.%#',
        \ 'postprocess': function('neomake#makers#ft#cpp#CpplintEntryProcess')
        \ }

let g:neomake_python_pylint_maker={
        \ 'args': [
            \ '--output-format=text',
            \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"',
            \ '--reports=no',
            \ '--disable=import-error,no-member,invalid-name',
            \ '--include-naming-hint=y'
        \ ],
        \ 'errorformat':
            \ '%A%f:%l:%c:%t: %m,' .
            \ '%A%f:%l: %m,' .
            \ '%A%f:(%l): %m,' .
            \ '%-Z%p^%.%#,' .
            \ '%-G%.%#',
        \ 'output_stream': 'stdout',
        \ 'postprocess': [
        \   function('neomake#postprocess#GenericLengthPostprocess'),
        \   function('neomake#makers#ft#python#PylintEntryProcess'),
        \ ]}



" ctrlp
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](git|hg|svn|build|build_dependencies|devel)$',
\ 'file': '\v\.(exe|so(\.\d\.\d\.\d)?|dll|pyc)$',
\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
\ }
nnoremap <localleader>f :CtrlP getcwd()<cr>

"in case there are system specific settings
try
    source ~/.vimrc_specific
catch
endtry

" copied from https://stackoverflow.com/a/7238791
set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let label =  bufname(buflist[winnr - 1])
  return fnamemodify(label, ":t")
endfunction

let g:ct=0
function! PrefixStatusLine()
     set statusline=
     set statusline+=%-4c
     set statusline+=%l/%-6L	"line number / total lines
     set statusline+=%-8y		"show the file-type
endfunction

function! PostfixStatusLine()
     set statusline+=%=			"now go to the right side of the statusline
     set statusline+=%-3m
     set statusline+=%<%f			"full path on the right side
endfunction

function! ToString(inp)
  return a:inp
endfunction

function! MyNeomakeGoodContext(context)
    return has_key(a:context, "jobinfo") && has_key(a:context["jobinfo"], "name") && a:context["jobinfo"]["name"] == "makeprg"
endfunction!

function! MyOnNeomakeInit()
    if MyNeomakeGoodContext(g:neomake_hook_context)
        call PrefixStatusLine()
        set statusline+=building\ \ \
        let g:ct=0
        call PostfixStatusLine()
    endif
endfunction

function! MyOnNeomakeCountsChanged()
    if MyNeomakeGoodContext(g:neomake_hook_context)
        let context = g:neomake_hook_context
        let g:ct = g:ct + 1
        call PrefixStatusLine()
        set statusline+=makeprog...\ \ \
        set statusline+=%{ToString(g:ct)}
        call PostfixStatusLine()
    endif
endfunction

function! MyOnNeomakeFinished()
    if MyNeomakeGoodContext(g:neomake_hook_context)
      let context = g:neomake_hook_context
      call PrefixStatusLine()
      if g:neomake_hook_context['jobinfo']['exit_code'] == '0'
          set statusline+=success\ \ \
      else
          set statusline+=failed\ \ \
      endif
      call PostfixStatusLine()
    endif
endfunction

augroup my_neomake_hooks
    au!
    autocmd User NeomakeCountsChanged nested call MyOnNeomakeCountsChanged()
    autocmd User NeomakeJobFinished nested call MyOnNeomakeFinished()
    autocmd User NeomakeJobInit nested call MyOnNeomakeInit()
augroup END

"making
nnoremap <localleader>m :Neomake!<cr>

autocmd! BufWritePost * Neomake | Neomake!
let g:gen_tags#ctags_auto_gen = 1
