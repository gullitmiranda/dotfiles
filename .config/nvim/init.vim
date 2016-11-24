" Plugins
call plug#begin()

Plug 'xolox/vim-misc'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/MatchTagAlways'
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'KabbAmine/vCoolor.vim'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'mbbill/undotree'
Plug 'terryma/vim-multiple-cursors'
Plug 'majutsushi/tagbar'
Plug 'elentok/plaintasks.vim'
Plug 'janko-m/vim-test'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-scripts/PreserveNoEOL'
Plug 'christoomey/vim-run-interactive'
Plug 'janko-m/vim-test'
Plug 'pbrisbin/vim-mkdir'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'lornix/vim-scrollbar'
Plug 'terryma/vim-expand-region'
Plug 'kassio/neoterm'

" Snippet engines
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" languages syntaxes and snippets
Plug 'scrooloose/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'justinj/vim-react-snippets'
Plug 'elzr/vim-json'
Plug 'cespare/vim-toml'
Plug 'isRuslan/vim-es6'
Plug 'tikhomirov/vim-glsl'
Plug 'mattn/emmet-vim'

Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

" autocomplete
Plug 'Valloric/YouCompleteMe', { 'do': './install --all' }
Plug 'marijnh/tern_for_vim', { 'do': 'npm install' }

" Themes
Plug 'ciaranm/inkpot'
Plug 'jonathanfilip/vim-lucius'
Plug 'sjl/badwolf'
Plug 'vim-scripts/darktango.vim'
Plug 'sickill/vim-monokai'
Plug 'iCyMind/NeoSolarized'
Plug 'mhartington/oceanic-next'
Plug 'jdkanani/vim-material-theme'
Plug 'morhetz/gruvbox'

" Plug 'ryanoasis/vim-devicons'

call plug#end()

""" Configurations

set hidden

" Leader
let mapleader = " "

" indentation and scroll
set scrolloff=7 " scroll page when when are N rows from the edge
set smartindent
set modeline
set cursorline
set cursorline
set backspace=indent,eol,start
set showcmd       " display incomplete commands
set incsearch     " do incremental searching

set list
set listchars=tab:»·,trail:·,nbsp:·,eol:¬,extends:>,precedes:<
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.

" Make it obvious where 120 characters is
set textwidth=120
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Use one space, not two, after punctuation.
set nojoinspaces

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set smartcase
set ignorecase
set nohlsearch
set incsearch
set laststatus=2  " Always display the status line
set showtabline=2
set noautochdir

set foldcolumn=0
set foldlevelstart=200
set foldlevel=200  " disable auto folding

let g:indentLine_enabled = 0

nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
vnoremap <Space> zf

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" shel options
if executable('zsh')
  set shell=zsh\ -l
endif
set shellcmdflag=-lc
set showcmd

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exec = 'eslint_d'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_quiet_messages = { 'type': 'style' }
let g:syntastic_mode_map={'mode': 'passive'}

" tabbars and buffers
nmap <S-T> :tabnew<cr>
vmap <S-Tab> <gv
nmap <S-K><S-B> :NERDTreeToggle<CR>
vmap <Tab> >gv
nmap <silent><C-p> :CtrlSpace O<CR>
nmap <C-t> :FZF<CR>
vmap // y/<C-R>"<CR>  " search by selection
map <silent> <leader><s-s><s-b> :call ToggleScrollbar()<cr><Paste>

map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
map ,w :w <C-R>=expand("%:p:h") . "/" <CR>
map ,mk :Mkdir <C-R>=expand("%:p:h") . "/" <CR>
map ,m :Move <C-R>=expand("%:p") <CR>
map ,t :tabnew <C-R>=expand("%:p:h") . "/" <CR>
map ,vs :vsplit <C-R>=expand("%:p:h") . "/" <CR>
map ,s :split <C-R>=expand("%:p:h") . "/" <CR>

" NERDTreeToggle
let g:NERDTreeShowHidden = 1

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }

let g:CtrlSpaceSearchTiming = 100
let g:CtrlSpaceFileEngine = 'auto'
" let g:CtrlSpaceFileEngine = '/usr/local/opt/fzf'
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceCacheDir = expand($HOME)

set rtp+=/usr/local/opt/fzf " enable fzf with fuse search engine

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable("ag")
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  let g:ackprg = 'ag --vimgrep'
  " let g:ackprg = 'ack -s -H --nocolor --nogroup --column --nopager'
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor --hidden -g ""'
endif

" copy and paste
set clipboard+=unnamedplus  " enable use of system clipboard

vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" clear find hihlighting
nnoremap <silent> <Esc><Esc> :noh<CR> :call clearmatches()<CR>

" Comments
filetype plugin on
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

if has("autocmd")  " go back to where you exited
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif

augroup vimrc
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile .glsl.json set filetype=glsl

  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

if has('mouse')
   set mouse=a
   set selectmode=mouse,key
   set nomousehide
endif


" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

imap <Tab> <c-r>=InsertTabWrapper()<cr>
imap <S-Tab> <c-n>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Quicker window movement
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l

" Run commands that require an interactive shell
nmap <Leader>r :RunInInteractiveShell<space>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

if has('termguicolors')
  set termguicolors
  set ttimeout
  set ttimeoutlen=0
endif

" Theme
syntax enable
colorscheme OceanicNext
set background=dark
let g:airline_theme='oceanicnext'


" Always use vertical diffs
set diffopt+=vertical

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

" preserve EOL in end of file
let b:PreserveNoEOL = 1

" Tests
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Control spotify from vim - https://github.com/hnarayanan/shpotify
nnoremap <leader>sn :silent :! spotify next<CR> :redraw!<CR>
nnoremap <leader>sb :silent :! spotify prev<CR> :redraw!<CR>


" languages syntaxes and snippets
let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1

