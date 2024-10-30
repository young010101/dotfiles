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
