
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
