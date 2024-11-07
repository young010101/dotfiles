" ## 基础设置
" -------------------------
" 设置 UTF-8 编码
set encoding=utf-8
set fileencoding=utf-8

" 显示行号和相对行号
set number
set relativenumber

" 高亮搜索和搜索逐字高亮
set hlsearch
set incsearch

" 打开语法高亮
syntax on

" 设置智能缩进和自动缩进
set autoindent
set smartindent
set tabstop=4       " 一个Tab等于4个空格
set shiftwidth=4    " 每次自动缩进使用4个空格
set expandtab       " 使用空格代替Tab

" 显示匹配的括号
set showmatch

" 启用鼠标支持
set mouse=a

" 取消兼容模式，启用 Vim 全功能
set nocompatible

" 设置行宽标尺，适用于查看代码超长
set colorcolumn=80

" 开启行末标志显示
set list
set listchars=tab:»·,trail:·,extends:>,precedes:<

" 状态栏增强，显示更多信息
set laststatus=2
set ruler
set showcmd

" 禁用备份文件
"set nobackup
"set noswapfile
"set nowritebackup

" 命令补全增强
set wildmenu

" 显示滚动偏移行数，使光标上下滚动时留有上下文
set scrolloff=5
set sidescrolloff=5

" 启用持久化的历史记录
set undofile
set undodir=~/.vim/undodir

" ## 视觉美化
" -----------
" 配色方案
colorscheme desert

" 启用 256 色模式
set t_Co=256

" 高亮当前行
set cursorline

" 高亮搜索时的匹配
set incsearch
set hlsearch

" 自定义状态栏
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%l/%L]\ [%p%%]

" ## 键盘映射

" Leader 键设置为空格
let mapleader = " "

" 快速保存
nnoremap <leader>w :w<CR>

" 快速退出
nnoremap <leader>q :q<CR>

" 快速切换窗口
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" 在可视模式下按Tab键缩进代码块
vnoremap < <gv
vnoremap > >gv

" 取消高亮搜索
nnoremap <leader><space> :nohlsearch<CR>

" 用 jk 作为快速进入普通模式的映射（从插入模式返回）
inoremap jk <ESC>

" ## 配置插件
" ---------------------------
" vim-plug 插件开始区域
call plug#begin()
"
" 文件浏览器插件 NERDTree
Plug 'preservim/nerdtree' 
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
call plug#end()

" ## 插件配置示例
" -----------
" 启动 NERDTree 并绑定快捷键
nnoremap <leader>n :NERDTreeToggle<CR>

" 配置 lightline 主题
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" coc.nvim 配置
" 使用 <Tab> 补全
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
