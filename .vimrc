let $VIM = "$HOME/soft/vim/vim"
"let $VIMRUNTIME="$HOME/usr/share/vim/vim82/"
let $LD_LIBRARY_PATH=$HOME.'/toolchain/clang+llvm-10.0.0/lib:'.$LD_LIBRARY_PATH

set showcmd
set number
nnoremap <F2> :set paste!<CR>
nnoremap <F5> :noh <CR>

"open current file's header or cc file
nnoremap <F3> :call OpenFile()<CR>

"replace by google vim-secheme plug
"highlight CursorLine cterm=underline ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
"hi Normal  ctermfg=100 ctermbg=none
filetype plugin indent on

"uname will encrypt by 亿赛通
"synchronize the unnamed register with the clipboard register
"set clipboard^=unnamed
"set clipboard?

set hlsearch "高亮右边搜索
set splitright "vs向右打开
set splitbelow "sp 向下打开
set tags+=~/.vim/tags/clang_std
set tags+=~/.vim/tags/gcc_std
set tags=./.tags;,.tags
set whichwrap+=<,>,[,]
set backspace=indent,eol,start
set ignorecase
set smartcase
set incsearch

"tab key format set
set wildmode=list:longest,list:full

"default file explore
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] |wincmd p |ene| exe "q" |exe 'cd '.argv()[0] | endif

"gn file default filetype is conf      set colorterm = texmf
autocmd BufRead,BufNewFile *.gn,*.gni set filetype=gn syntax=texmf

"au! is clear set
autocmd BufRead,BufNewFile *.gyp,*.gypi set filetype=gyp syntax=javascript
augroup json_autocmd
  autocmd!
  autocmd FileType json set autoindent
  autocmd FileType json set formatoptions=tcq2l
  autocmd FileType json set textwidth=78 shiftwidth=2
  autocmd FileType json set softtabstop=2 tabstop=8
  autocmd FileType json set expandtab
  autocmd FileType json set foldmethod=syntax
augroup END

augroup c_autocmd 
  autocmd!
  autocmd FileType cpp,gn,c set tabstop=2 shiftwidth=2 expandtab sts=2
augroup END
set autoindent
set cindent

if has("autocmd")
    au BufReadPost * if line("`\"") > 1 && line("`\"") <= line("$") | exe "normal! g`\"" | endif
" for simplicity,  au BufReadPost * exe "normal! g`\"", is Okay.
endif

"打开头文件或者cc
function! OpenFile()
    let l:name=@% "or expand('%:p') 
    let l:prefix = expand('%:r')
    let l:suffix = expand('%:e')
    if (suffix == 'h')
	exec "vsplit ".l:prefix.'.cc'
    elseif (suffix == 'cc')
	exec "vsplit ".l:prefix.'.h'
    end
endfunction

if has('gui')
  set guioptions-=e
endif
if exists("+showtabline")
  function MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= ' '
      let s .= i . ':'
      "let s .= winnr . '/' . tabpagewinnr(i,'$') "form n/m
      let s .=tabpagewinnr(i,'$')  
      let s .= ' %*'
      let s .= (i == t ? '%#TabLineFill#' : '%#TabLine#')
      let bufnr = buflist[winnr - 1]
      let j=1
      while j <= tabpagewinnr('1','$')
        let bufmodified = getbufvar(bufnr, "&mod")
        if bufmodified
          let s .= '[+] '
        endif
        break
        let j = j + 1
      endwhile
      let file = bufname(bufnr)
      let buftype = getbufvar(bufnr, 'buftype')
      if buftype == 'nofile'
        if file =~ '\/.'
          let file = substitute(file, '.*\/\ze.', '', '')
        endif
      else
        let file = fnamemodify(file, ':p:t')
      endif
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file
      let i = i + 1
    endwhile
    "let s .= '%T%#TabLineFill#%='
    let s .= '%T%#TabLine#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
endif

"plug
call plug#begin('~/.vim/plugged')
set shell=/bin/bash
" Uncomment the following to have Vim jump to the last position when
" reopening a file


" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'ludovicchabant/vim-gutentags'
" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

"ycm"
Plug 'Valloric/YouCompleteMe', { 'do': 'CXXFLAGS=\"-stdlib=libc++ -std=c++17\" CC=clang CXX=clang++ ./install.py --ninja --clangd-completer --clang-completer' }
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clangd-completer' }

"clang complete"
"Plug 'xavierd/clang_complete'

"highlight"
Plug 'octol/vim-cpp-enhanced-highlight'

" Initialize plugin system

" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plug 'google/vim-glaive'
"color
Plug 'google/vim-colorscheme-primary'
"surround
Plug 'tpope/vim-surround' 
"tagbar"
Plug 'majutsushi/tagbar'
"markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

"注释
Plug 'preservim/nerdcommenter'

"auto pair
Plug 'jiangmiao/auto-pairs'

"complete
"Plug 'jayli/vim-easycomplete'

"floaterm
Plug 'voldikss/vim-floaterm'
"asyncrun
Plug 'skywind3000/asyncrun.vim'
call plug#end()

call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.

Glaive codefmt plugin[mappings]
Glaive codefmt clang_format_style=chromium

"gutentags config
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
"let g:gutentags_project_root = ['.root', '.svn', '.repo', '.hg', '.project', 'src', '.git']
"
"" 所生成的数据文件的名称
"let g:gutentags_ctags_tagfile = '.tags'
"
"" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
"let s:vim_tags = expand('~/.cache/tags')
"let g:gutentags_cache_dir = s:vim_tags
"
"" 配置 ctags 的参数
"let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
"let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
"let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"
"" 检测 ~/.cache/tags 不存在就新建
"if !isdirectory(s:vim_tags)
"   silent! call mkdir(s:vim_tags, 'p')
"endif

"ycm config
"set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
"let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
let g:ycm_extra_conf_globlist = ['~/chromium_v73/v73_103/*','~/v5.0_mtk/v5.0/*']
let g:ycm_global_ycm_extra_conf = '/home/SERAPHIC/chenghao.xie/v7.0/v7.0/src/tools/vim/chromium.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 1
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = "/home/SERAPHIC/chenghao.xie/toolchain/clang+llvm-9.0.0/bin"
let g:ycm_goto_buffer_command = 'tab'

"set completeopt=menu,menuone

noremap gf :tab YcmCompleter GoToInclude<CR>
noremap <leader>jc :rightbelow vertical YcmCompleter GoToDeclaration<CR>
noremap <leader>jd :rightbelow vertical YcmCompleter GoToDefinition<CR>
"inoremap <c-z> <NOP>

"default ycm 
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
"let g:ycm_semantic_triggers =  {
"           \ 'c,cc,cpp,python,java,go,erlang,perl': ['re!\w{4}'],
"           \ 'cs,lua,javascript': ['re!\w{2}'],
"           \ }



"cpp highlight

let g:ycm_filetype_whitelist = { 
  \ "c":1,
  \ "cpp":1, 
  \ "objc":1,
  \ "sh":1,
  \ "zsh":1,
  \ "zimbu":1,
  \ }

let g:cpp_class_scope_highlight = 1

let g:cpp_member_variable_highlight = 1

let g:cpp_class_decl_highlight = 1

let g:cpp_experimental_simple_template_highlight = 1

"nerdcommenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

"autoformat
augroup autoformat_settings
  ""autocmd FileType bzl AutoFormatBuffer buildifier
  ""autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  ""autocmd FileType dart AutoFormatBuffer dartfmt
  ""autocmd FileType go AutoFormatBuffer gofmt
  ""autocmd FileType gn AutoFormatBuffer gn
  ""autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  ""autocmd FileType java AutoFormatBuffer google-java-format
 "" autocmd FileType python AutoFormatBuffer yapf
  """"autocmd FileType python AutoFormatBuffer autopep8
augroup END

"tagbar
nmap <F8> :TagbarToggle<CR>

"Plug google vim-color secheme setting
syntax enable
set t_Co=256
set background=dark "light|dark"
let g:colorscheme_primary_enable_transparent_bg = 1
set termguicolors
colorscheme primary

"auto pair
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '':''}
let g:AutoPairsMapBS = 0

"NERDCommenterMappings
let g:NERDCustomDelimiters = {
    \ 'gn': { 'left': '#'},
\ }
"asynctask
let g:asyncrun_mode = 'floaterm-reuse'
let g:asyncrun_open = 8

noremap <F5> :AsyncRun -mode=term -pos=floaterm-reuse -cwd=$(VIM_FILEDIR) 

source ~/.vim/vimrc/filetypes.vim
source ~/.vim/autoload/mojom.vim
