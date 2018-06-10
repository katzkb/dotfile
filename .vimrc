" 基本設定
"フォントの設定
set guifont=Ricty\ 10

" エンコードの設定
set encoding=utf-8

" ファイルエンコードの設定
set fileencoding=utf-8

" スワップファイル作らない
set noswapfile

" バックアップファイル作らない
set nobackup

" ファイル上書き前のバックアップを作らない
set nowritebackup

" 行番号表示
set nu

" 右下に表示される行・列番号を表示
set ruler

" 自動インデントを有効
set autoindent

" タブの幅
set tabstop=4

" 自動挿入されるインデントの幅
set shiftwidth=4

" タブ入力時の幅
set softtabstop=4

" 閉じ括弧入力時に対応する括弧を強調する
set showmatch

" showmatch設定の秒数(0.1秒単位)
set matchtime=4

" インクリメンタルサーチのON(検索文字入力中から検索)
set incsearch

" 検索語を強調表示
set hlsearch

" 検索がファイル末尾まで進んだら、ファイルの先頭から再び検索
set wrapscan

" 検索文字列の大文字小文字を無視
set ignorecase

" ただし大文字が含まれている場合、それは区別する
set smartcase

" ステータスラインの強制表示
set laststatus=2

" ステータスラインにファイルネームとかいろいろ表示
set statusline=%F%r%h%=

" コマンドラインは2行用意
set cmdheight=2

" コマンドライン補完
set wildmenu wildmode=longest:full,full

" デリートキーの有効化
set t_kD=^?

" バックスペースキーの動作を普通のテキストエディタと同じようにする
set backspace=start,eol,indent

" バックスペースで改行を削除
set backspace=2

" 行頭の余白でTabした時shiftwidthの数だけインデント
set smarttab

" 新しい行で高度なインデントを行う
set smartindent

" 行の先頭や末尾からカーソルキーで移動可にする
set whichwrap=b,s,[,],,~

" 新しいウィンドウを下に開く
set splitbelow

" 新しいウィンドウを右に開く
set splitright

" 長いテキストの折り返し
set wrap

" 自動的に改行が入るのを無効化
set textwidth=0

" カーソルのある行を強調表示
set cursorline

" シンタックスハイライトON
syntax on

" Thanks防ぎ
let &titleold=getcwd()

" 外部でファイルに変更があった時は読み直す
set autoread

" windows環境でフォルダ区切り文字はバックスラッシュの変わりにスラッシュを用いる
set shellslash

" Unicodeで行末が変になる問題を解決
set ambiwidth=double

" 行間での移動をシームレスにする
set whichwrap+=h,l,<,>,[,],b,s

" カーソルを常に画面中央に表示
set scrolloff=999

" 文字がない場所にもカーソルを移動できるようにする
set virtualedit=all

" タブをスペースとして挿入
set expandtab

" コメント行を改行したとき、自動的にコメントを付与するのを禁止する
set fo-=ro

" ビジュアルベルの無効化
set novisualbell

" スクリーンベルの無効化
set visualbell t_vb=

" 不可視文字の表示
set list

" 不可視文字の表示設定
set listchars=tab:>-,trail:-,extends:»,precedes:«,nbsp:%

" ペーストモードをデフォルトでオン
set paste

" キーバインド関係の設定
" 括弧の自動補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>)]})]}

" 検索単語の自動エスケープ
" cnoremap <expr> / (getcmdtype() == '/') '\/' : '/'

" 検索単語が画面の真ん中に来るようにする
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" 表示行単位で移動させない
nnoremap <Up> gk
nnoremap <Down> gj
nnoremap j gj
nnoremap k gk

" TAB でウィンドウ間を移動
nnoremap <TAB> <C-w>w

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" ESCを二回押すことでハイライトを消す
" nmap <silent> <Esc><Esc> :nohlsearch<CR>

" タブ操作関係
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

" unite.vim
" インサートモードで開始
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" その他の設定
" PHPのタブを4文字に設定
au filetype php setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab

" cakephpの拡張子をhtmlとして認識させる
au BufRead,BufNewFile *.ctp set filetype=html

" HTML, javaScriptのタブを2文字に設定
au filetype html,javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

" 保存時に行末の空白を削除する
"autocmd BufWritePre * :%s/\s\+$//ge

" 保存時にtabをスペースに変換
"autocmd BufWritePre * :%s/\t/ /ge

" vimdiffの色設定
highlight DiffAdd cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText cterm=bold ctermfg=10 ctermbg=21

"php用の設定
let php_sql_query = 1
let php_baselib = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1

"cake用の設定
let g:cakephp_enable_fix_mode = 1
let g:cakephp_app = "/var/www/html/cake/app"

"自動設定
let g:cakephp_enable_auto_mode = 1

" neocomplcacheを起動時に有効化
let g:neocomplcache_enable_at_startup = 1

"スニペットフォルダの指定
"let g:neocomplcache_snippets_dir = $HOME.'/.vim/mysnippets'
let g:neosnippet#snippets_directory=$HOME.'/.vim/mysnippets'

"辞書ファイル指定
autocmd FileType php :set dictionary=~/.vim/dictionary/php.dictionary

"zencoding-vim
let g:user_zen_leader_key = ''

"言語別に対応させる
let g:user_zen_settings = {
\ 'lang' : 'ja',
\ 'html' : {
\ 'filters' : 'html',
\ 'indentation' : ' '
\ },
\ 'css' : {
\ 'filters' : 'fc',
\ },
\}
"}

"MarkDown用の設定
let g:vim_markdown_liquid=1
let g:vim_markdown_frontmatter=1
let g:vim_markdown_math=1
au BufRead,BufNewFile *.{txt,text,md} set filetype=markdown

"coffe用の設定
autocmd FileType coffee setlocal sw=2 sts=2 ts=2 et
au BufRead,BufNewFile,BufReadPre *.coffee set filetype=coffee

" pair close checker.
" from othree vimrc ( http://github.com/othree/rc/blob/master/osx/.vimrc )
function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf

if has("autocmd")
    "ファイルタイプの検索を有効にする
    filetype plugin on
    "そのファイルタイプにあわせたインデントを利用する
    filetype indent on
    " これらのftではインデントを無効に
    "autocmd FileType php filetype indent off

    autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
    autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
    autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
    autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
    autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
    autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
    autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
endif
