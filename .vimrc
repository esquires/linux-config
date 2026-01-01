" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"
let &titlestring=expand("%:t")
set title

set cmdheight=2
let spellfile=expand('%:p:h') . '.spellfile.utf-16.add'

nnoremap <localleader>q :q<cr>

" see https://github.com/neovim/neovim/issues/7663
function! InsertOnTerm()
    if expand('%f')[:3] == 'term'
        startinsert
    endif 
endfunction

if has("nvim")
    set guicursor=
    tnoremap <M-[> <C-\><C-n>
    nnoremap <C-h> <C-\><C-n>gT:call InsertOnTerm()<cr>
    tnoremap <C-h> <C-\><C-n>gT:call InsertOnTerm()<cr>
    nnoremap <C-l> <C-\><C-n>gt:call InsertOnTerm()<cr>
    tnoremap <C-l> <C-\><C-n>gt:call InsertOnTerm()<cr>
    tnoremap <M-w> <C-\><C-n>w
    command! Newterm :tabnew | term
    set scrollback=100000
endif 

" temporary fix until this works natively in the terminal
set autoread
au FocusGained * :checktime

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

"pathogen plugin
"call pathogen#infect()

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

" lvdb settings  (always toggle line numbers)
let g:lvdb_toggle_lines = 3
let g:lvdb_close_tabs = 1

" color setup
" backspace/colors
set bs=2

"colorscheme stuff
"change background
set t_Co=256
if has("gui_running")
    set spell
else
    "spell check comes out as poor highlighting
    set nospell
endif

" neomake
" errorformat for cppcheck copied from syntastic:
"   https://github.com/vim-syntastic/syntastic/blob/master/syntax_checkers/c/cppcheck.vim
augroup my_neomake_signs
    au!
    autocmd ColorScheme *
        \ hi NeomakeErrorSign ctermfg=red ctermbg=black |
        \ hi NeomakeWarningSign ctermfg=yellow ctermbg=black |
        \ hi NeomakeWarning ctermbg=darkblue
augroup END

nnoremap <leader>c :cnext<CR>
nnoremap <leader>L :lnext<CR>

" vimtex
let g:vimtex_fold_enabled = 1

" ctrlp
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](git|hg|svn|build|devel|tmp)$',
\ 'file': '\v\.(exe|so(\.\d\.\d\.\d)?|dll|pyc|pdf|png|npy)$',
\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
\ }
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:30,results:30'

function SetCtrlPIgnore(rm_submodules)
    if a:rm_submodules
        let g:ctrlp_custom_ignore['dir'] = '\v[\/](git|hg|svn|build|devel|tmp|submodules)$'
    else
        echom 'bar'
        let g:ctrlp_custom_ignore['dir'] = '\v[\/](git|hg|svn|build|devel|tmp)$'
    endif
endfunction

nnoremap <c-p> :call SetCtrlPIgnore(1)<cr>:cal ctrlp#init(0, {})<cr>
nnoremap <localleader>f :call SetCtrlPIgnore(0)<cr>:CtrlP getcwd()<cr>
nnoremap <localleader>b :call SetCtrlPIgnore(0)<cr>:CtrlPBuffer<cr>

"in case there are system specific settings
try
    source ~/.vimrc_specific
catch
endtry

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_log_ignore = ['*']

let g:vimtex_compiler_progname="nvr"

let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'nvim',
    \ 'background' : 1,
    \ 'build_dir' : 'build',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \   '-xelatex',
    \   '-bibtex',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
\}

let g:vimtex_quickfix_latexlog = {
      \ 'default' : 1,
      \ 'general' : 1,
      \ 'references' : 1,
      \ 'overfull' : 1,
      \ 'underfull' : 0,
      \ 'font' : 1,
      \ 'ignore_filters': ['Package caption Warning'],
      \ 'packages' : {
      \   'default' : 1,
      \   'natbib' : 1,
      \   'biblatex' : 1,
      \   'babel' : 1,
      \   'hyperref' : 0,
      \   'scrreprt' : 1,
      \   'fixltx2e' : 1,
      \   'titlesec' : 1,
      \ },
\}
let g:vimtex_quickfix_autoclose_after_keystrokes=1

let g:tex_flavor = 'latex'
let g:vimtex_quickfix_open_on_warning=1
let g:vimtex_fold_enabled=1
au! BufRead * normal zR

" airline
let g:airline_extensions = ['tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_splits = 0

" fugitive
nnoremap <localleader>gs :G<cr>}jj<c-w>H
nnoremap <localleader>gb :Git blame<cr>
nnoremap <localleader>gt :Git commit<cr>
nnoremap <localleader>gl :Gclog --pretty=format:"%h %ad %s %d [%an]" --decorate --date=short -100 --graph<cr>
nnoremap <localleader>gd :Gdiffsplit<cr>
nnoremap <localleader>gco :Git checkout 
" push current branch
nnoremap <localleader>gp :Git push origin HEAD<cr>

" LanguageClient-neovim
" Required for operations modifying multiple buffers like rename.
set hidden
let g:LanguageClient_serverCommands = {
  \ 'cpp': ['/usr/lib/llvm-6.0/bin/clangd'],
  \ 'python': ['pyls'],
  \ }
let g:LanguageClient_diagnosticsList = "Disabled"
let g:LanguageClient_diagnosticsEnable = 0
nnoremap <localleader>s :call LanguageClient_contextMenu()<CR>
call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)

" vim-wordmapping
let g:wordmotion_mappings = {'W': '', 'B': '', 'E': ''}

set concealcursor=

" vim-markdown
let g:vim_markdown_auto_insert_bullets = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_math = 1
