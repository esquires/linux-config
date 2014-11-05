" plugin summary
"
"   pathogen:       http://www.vim.org/scripts/script.php?script_id=2332
"
"   nerdtree:       https://github.com/scrooloose/nerdtree
"                   https://github.com/jistr/vim-nerdtree-tabs
"
"   neocomplcache:  https://github.com/Shougo/neocomplcache.vim
"
"   togglelist:     https://github.com/milkypostman/vim-togglelist
"
"   colors:         https://github.com/qualiabyte/vim-colorstepper
"                   https://github.com/flazz/vim-colorschemes
"
"   matchit:        https://github.com/tmhedberg/matchit:
"
"   tabify:
"
"   matlab-fold:
"

" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"

"plugin management
filetype on
filetype plugin on
filetype indent on

"pathogen plugin
call pathogen#infect()

"nerdtree settings
let NERDTreeShowLineNumbers=1
let NERDTreeShowBookmarks=1
nnoremap <leader>e :NERDTreeToggle<CR>
let g:nerdtree_tabs_open_on_gui_startup = 0

"neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_auto_select = 1

" togglelist settings
let g:toggle_list_no_mappings=1
nnoremap <leader>l :call ToggleLocationList()<cr>
nnoremap <leader>q :call ToggleQuickfixList()<cr>

" vim_pdb settings  (always toggle line numbers)
let g:vim_pdb_toggle_lines = 3

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

"in case there are system specific settings
try
    source ~/.vimrc_specific
catch
endtry
