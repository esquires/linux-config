" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"
let &titlestring=expand("%:t")
set title

set cmdheight=2
let g:echodoc_enable_at_startup = 1
let g:echodoc#enable_force_overwrite = 1
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

" deoplete
if has("nvim")
    let g:deoplete#enable_at_startup = 1
endif

"pathogen plugin
call pathogen#infect()

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
augroup my_neomake_signs
    au!
    autocmd ColorScheme *
        \ hi NeomakeErrorSign ctermfg=red ctermbg=black |
        \ hi NeomakeWarningSign ctermfg=yellow ctermbg=black |
        \ hi NeomakeWarning ctermbg=darkblue
augroup END

nnoremap <leader>c :cnext<CR>
nnoremap <leader>L :lnext<CR>
let g:neomake_tex_enabled_makers=['lacheck_wrapper', 'proselint', 'textidote']
let g:neomake_cpp_enabled_makers=['cpplint', 'cppcheck', 'cppclean', 'flawfinder']
" let g:neomake_cpp_enabled_makers=['cppcheck']
let g:neomake_open_list=0
let g:neomake_highlight_lines=1
let g:neomake_highlight_columns=1
let g:neomake_place_signs=1
let g:neomake_python_enabled_makers=['pylint', 'pydocstyle', 'flake8', 'mypy']
" let g:neomake_python_enabled_makers=[]

let g:neomake_tex_lacheck_wrapper_maker={
    \ 'exe': 'lacheck_wrapper.py',
    \ 'errorformat':
    \ '%-G** %f:,' .
    \ '%E"%f"\, line %l: %m'}

let g:neomake_tex_textidote_maker={
        \ 'exe': "java",
        \ 'args': ['-jar', '~/bin/textidote.jar', '--no-color', '--ignore', 'sh:c:noin,sh:d:001,sh:nobreak,sh:capperiod,sh:figref,sh:d:003', '--output', 'singleline'],
        \ 'errorformat': '%f:%l:%m'
        \ }


let g:neomake_cpp_cppclean_maker={
        \ 'exe': "cpp_static_wrapper.py",
        \ 'args': ['cppclean', '--no-print-cmd'],
        \ 'errorformat': '%f:%l: %m, %f:%l %m'
        \ }

let g:neomake_python_pylint_maker={
    \ 'exe': 'pylint3',
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
    \ 'output_stream': 'both',
    \ 'postprocess': [
    \   function('neomake#postprocess#generic_length'),
    \   function('neomake#makers#ft#python#PylintEntryProcess'),
    \ ]}

let g:neomake_python_pydocstyle_maker={
        \ 'exe': 'pydocstyle',
        \ 'args': [
          \ '--ignore=D100,D101,D102,D103,D104,D105,D107,D203,D213,D416'
        \ ],
        \ 'errorformat':
        \   '%W%f:%l %.%#:,' .
        \   '%+C        %m',
        \ 'postprocess': function('neomake#postprocess#compress_whitespace'),
        \ }

" copied from neomake: autoload/neomake/makers/ft/python.vim
function! CustomMypy() abort
    " NOTE: uses defaults suitable for using it without any config.
    " ignore_missing_imports cannot be disabled in a config then though
    let args = [
                \ '--show-column-numbers',
                \ '--check-untyped-defs',
                \ '--ignore-missing-imports',
                \ '--disallow-untyped-defs',
                \ ]

    " Append '--py2' to args with Python 2 for Python 2 mode.
    if !exists('s:python_version')
        call neomake#makers#ft#python#DetectPythonVersion()
    endif

    let maker = {
        \ 'args': args,
        \ 'output_stream': 'stdout',
        \ 'errorformat':
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%E%f:%l: error: %m,' .
            \ '%W%f:%l: warning: %m,' .
            \ '%I%f:%l: note: %m,' .
            \ '%-GSuccess%.%#,' .
            \ '%-GFound%.%#,'
        \ }
    function! maker.InitForJob(jobinfo) abort
        let maker = deepcopy(self)
        let file_mode = a:jobinfo.file_mode
        if file_mode
            " Follow imports, but do not emit errors/issues for it, which
            " would result in errors for other buffers etc.
            " XXX: dmypy requires "skip" or "error"
            call insert(maker.args, '--follow-imports=silent')
        else
            let project_root = neomake#utils#get_project_root(a:jobinfo.bufnr)
            if empty(project_root)
                call add(maker.args, '.')
            else
                call add(maker.args, project_root)
            endif
        endif
        return maker
    endfunction
    function! maker.supports_stdin(jobinfo) abort
        if !has_key(self, 'tempfile_name')
            let self.tempfile_name = self._get_default_tempfilename(a:jobinfo)
        endif
        let self.args += ['--shadow-file', '%', self.tempfile_name]
        return 0
    endfunction
    function! maker.postprocess(entry) abort
        if a:entry.text =~# '\v^Need type (annotation|comment) for'
            let a:entry.type = 'I'
        endif
    endfunction
    return maker
endfunction

let g:neomake_python_mypy_maker=CustomMypy()

let g:neomake_cpp_cppcheck_maker={
        \ 'exe': 'cpp_static_wrapper.py',
        \ 'args': 'cppcheck',
        \ 'errorformat' :
        \   '[%f:%l:%c]: (%trror) %m,' .
        \   '[%f:%l:%c]: (%tarning) %m,' .
        \   '[%f:%l:%c]: (%ttyle) %m,' .
        \   '[%f:%l:%c]: (%terformance) %m,' .
        \   '[%f:%l:%c]: (%tortability) %m,' .
        \   '[%f:%l:%c]: (%tnformation) %m,' .
        \   '[%f:%l:%c]: (%tnconclusive) %m,' .
        \   '%-G%.%#'}

let g:neomake_cpp_cpplint_maker={
        \ 'exe': executable('cpplint') ? 'cpplint' : 'cpplint.py',
        \ 'args': ['--verbose=3'],
        \ 'errorformat':
        \     '%A%f:%l:  %m [%t],' .
        \     '%-G%.%#',
        \ 'postprocess': function('neomake#makers#ft#cpp#CpplintEntryProcess')
        \ }

let g:neomake_cpp_flawfinder_maker={
        \ 'exe': 'flawfinder',
        \ 'args': ['--quiet', '--dataonly', '--singleline'],
        \ 'errorformat': '%f:%l:  %m,',
        \ 'postprocess': function('neomake#makers#ft#cpp#CpplintEntryProcess')
        \ }

" vimtex
let g:vimtex_fold_enabled = 1

" ctrlp
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](git|hg|svn|build|devel|tmp)$',
\ 'file': '\v\.(exe|so(\.\d\.\d\.\d)?|dll|pyc|pdf|png)$',
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

function! MyNeomakeGoodContext(context)
    return has_key(a:context, "jobinfo") && has_key(a:context["jobinfo"], "name") && a:context["jobinfo"]["name"] == "makeprg"
endfunction!

function! MyOnNeomakeInit()
    if MyNeomakeGoodContext(g:neomake_hook_context)
        let context = g:neomake_hook_context
        let prefix = '%<%f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
        let postfix = ' %#__accent_bold#building'
        let g:airline_section_c = prefix . postfix
    endif 
    call airline#highlighter#reset_hlcache()
    call airline#load_theme()
    call airline#update_statusline()

endfunction

function! MyOnNeomakeFinished()
    if MyNeomakeGoodContext(g:neomake_hook_context)
        let context = g:neomake_hook_context
        let prefix = '%<%f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'

        if g:neomake_hook_context['jobinfo']['exit_code'] == '0'
            let postfix = ' %#__accent_bold#success'
        else
            let postfix = ' %#__accent_bold#failed'
        endif
        let g:airline_section_c = prefix . postfix
    endif 
    call airline#highlighter#reset_hlcache()
    call airline#load_theme()
    call airline#update_statusline()

endfunction

augroup my_neomake_hooks
    au!
    autocmd User NeomakeJobFinished nested call MyOnNeomakeFinished()
    autocmd User NeomakeJobInit nested call MyOnNeomakeInit()
augroup END

"making
function! MyNeomakeCall()
    execute "normal! :Neomake\<CR>"
    if filereadable('Makefile') == 1
        execute "normal! :Neomake!\<CR>"
    endif
endfunction
autocmd! BufWritePost * :call MyNeomakeCall()

" neosnip
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
nnoremap <localleader>s :NeoSnippetMakeCache<cr>
imap <c-k>     <Plug>(neosnippet_expand_or_jump)
smap <c-k>     <Plug>(neosnippet_expand_or_jump)
xmap <c-k>     <Plug>(neosnippet_expand_target)
let g:neosnippet#snippets_directory = "/home/esquires3/.vim/bundle/neosnippet-snippets/neosnippets"

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

function! GetGitPath(fname)
    let p = fnamemodify(a:fname, ':p:h')
    let b = 0
    while p != '/' && b < 30
      let b += 1
      if isdirectory(p . '/.git')
          return a:fname[len(p) + 1:]
      endif 
      let p = fnamemodify(p, ':h')
    endwhile 
    return fnamemodify(a:fname, ':t')
endfunction

function! GetClass(fname)
    return 'Class ' . fnamemodify(a:fname, ':r') . " {\npublic:\n    "
endfunction

function! GetHeaderGuard(fname)
    let include_txt = GetGitPath(a:fname)
    let include_txt = toupper(include_txt)
    let include_txt = substitute(include_txt, "/", "_", "g")
    let include_txt = substitute(include_txt, "-", "_", "g")
    let include_txt = substitute(include_txt, "\\.", "_", "g")
    let include_txt = include_txt . '_'
    return include_txt
endfunction

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
    \   '-pdf',
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

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
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
nnoremap <localleader>gb :Gblame<cr>
nnoremap <localleader>gt :Gcommit<cr>
nnoremap <localleader>gl :Glog --pretty=format:"%h %ad %s %d [%an]" --decorate --date=short -100 --graph<cr>
nnoremap <localleader>gd :Gdiffsplit<cr>

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
