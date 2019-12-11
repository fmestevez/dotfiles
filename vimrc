" Don't try to be vi compatible
set nocompatible
set nobackup
set nowritebackup

" Helps force plugins to load correctly when it is turned back on below
filetype off

" TODO: Load plugins here (pathogen or vundle)

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" TODO: Pick a leader key
" let mapleader = ","

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

" fzf - the fuzzy finder of all the things
let g:fzf_files_options =
  \ '--reverse ' .
  \ '--preview ' .
  \ '"(bat --style=numbers --color=always {} || cat {}) '.
  \ '2> /dev/null | head -'.&lines.'"'
let g:fzf_layout = { 'down': '~60%' }
nnoremap <C-p> :Files<cr>
let $FZF_DEFAULT_COMMAND = 
  \ 'ag --hidden ' .
  \ '--ignore .git ' .
  \ '--ignore node_modules ' .
  \ '--ignore bower_components ' .
  \ '--ignore www ' .
  \ '--ignore target ' .
  \ '--ignore dist ' .
  \ '-l -g "" 2> /dev/null'

" Autoload Plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Fugitive
nnoremap \<space> :Gstatus<cr>

" Markdown
hi def link markdownH1Delimiter           PreProc
hi def link markdownH2Delimiter           Type
hi def link markdownH3Delimiter           Directory

" COC
" don't give |ins-completion-menu| messages.
set shortmess+=c

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <TAB> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<TAB>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [r <Plug>(coc-diagnostic-prev)
nmap <silent> ]r <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" show documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

" show error, otherwise documentation, on hold
function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#util#has_float() == 0)
    silent call CocActionAsync('doHover')
  endif
endfunction
function! s:show_hover_doc()
  call timer_start(200, 'ShowDocIfNoDiagnostic')
endfunction
autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

" common editor actions
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup cocgroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Show all diagnostics
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

" Markdown Header Mappings - Easy setting of markdown headers
"------------------------------------------------------------

function! s:SmartLevelFourHeader()
  call s:DeleteExistingUnderline()
  call s:DeleteExistingLeadingHeaderMarks()
  s/^/#### /
  silent! call repeat#set("\<Plug>SmartLevelFourHeader")
endfunction

function! s:SmartLevelThreeHeader()
  call s:DeleteExistingUnderline()
  call s:DeleteExistingLeadingHeaderMarks()
  s/^/### /
  silent! call repeat#set("\<Plug>SmartLevelThreeHeader")
endfunction

function! s:OnLastLineOfFile()
  return line('.') == line('$')
endfunction

function! s:DeleteExistingLeadingHeaderMarks()
  silent! s/^#\{1,6} //
endfunction

function! s:DeleteExistingUnderline()
  if !s:OnLastLineOfFile()
    let saved_cursor = getpos(".")
    +1g/\v^[-=]+$/d
    call setpos('.', saved_cursor)
  endif
endfunction

function! s:SmartUnderline(char)
  call s:DeleteExistingUnderline()
  call s:DeleteExistingLeadingHeaderMarks()
  let underline = repeat(a:char, len(getline('.')))
  call append(line('.'), underline)
  if a:char == '='
    silent! call repeat#set("\<Plug>UnderlineH1", v:count)
  else
    silent! call repeat#set("\<Plug>UnderlineH2", v:count)
  end
endfunction

nnoremap <silent> <Plug>UnderlineH1 :call <sid>SmartUnderline('=')<cr>
nnoremap <silent> <Plug>UnderlineH2 :call <sid>SmartUnderline('-')<cr>
nnoremap <silent> <Plug>SmartLevelThreeHeader :call <sid>SmartLevelThreeHeader()<cr>
nnoremap <silent> <Plug>SmartLevelFourHeader :call <sid>SmartLevelFourHeader()<cr>
nmap <leader>u1 <Plug>UnderlineH1
nmap <leader>u2 <Plug>UnderlineH2
nmap <leader>u3 <Plug>SmartLevelThreeHeader
nmap <leader>u4 <Plug>SmartLevelFourHeader

call plug#begin('~/.local/share/nvim/plugged')

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'kaicataldo/material.vim'
Plug 'myusuf3/numbers.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mxw/vim-jsx'
Plug 'chemzqm/vim-jsx-improve', { 'for': 'javascript.jsx' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() }}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-solargraph'
Plug 'nelstrom/vim-markdown-folding'

call plug#end()

" Color scheme (terminal)
syntax enable
set background=dark
colorscheme material 

" Set the register and xcip
set clipboard+=unnamedplus
