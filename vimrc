" filetype support
filetype plugin indent on
syntax on

" it's there, let's use it
runtime macros/matchit.vim

" various settings
set autoindent
set backspace=indent,eol,start
set foldlevelstart=999
set foldmethod=indent
set grepprg=LC_ALL=C\ grep\ -nrsH
set hidden
set incsearch
set noswapfile
set path=.,,**
set ruler
set shiftround
set tags=./tags;,tags;
set wildcharm=<C-z>
set wildmenu

augroup mediumvimrc
  autocmd!
  " automatic location/quickfix window
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost    l* lwindow
  autocmd VimEnter            * cwindow
  autocmd FileType gitcommit nnoremap <buffer> { ?^@@<CR>|nnoremap <buffer> } /^@@<CR>|setlocal iskeyword+=-
augroup END

" files
nnoremap ,f :find *
nnoremap ,s :sfind *
nnoremap ,v :vertical sfind *
nnoremap ,t :tabfind *

" buffers
nnoremap ,b :buffer *
nnoremap ,B :sbuffer *
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap ,a :buffer#<CR>

" tags
nnoremap ,j :tjump /
nnoremap ,p :ptjump /

" definitions
nnoremap ,d :dlist /
nnoremap [D [D:djump<Space><Space><Space><C-r><C-w><S-Left><Left>
nnoremap ]D ]D:djump<Space><Space><Space><C-r><C-w><S-Left><Left>

" matches
nnoremap ,i :ilist /
nnoremap [I [I:ijump<Space><Space><Space><C-r><C-w><S-Left><Left><Left>
nnoremap ]I ]I:ijump<Space><Space><Space><C-r><C-w><S-Left><Left><Left>

" quickfix entries
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>

" search and replace
nnoremap <Space><Space> :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <Space>%       :%s/\<<C-r>=expand("<cword>")<CR>\>/

" grepping
command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr system(&grepprg . ' <args>')

" searching
cnoremap <expr> <Tab>   getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"

" listing
cnoremap <expr> <CR> <SID>CCR()
function! s:CCR()
	command! -bar Z silent set more|delcommand Z
	if getcmdtype() ==# ':'
		let cmdline = getcmdline()
		    if cmdline =~# '\v\C^(dli|il)' | return "\<CR>:" . cmdline[0] . 'jump   ' . split(cmdline, ' ')[1] . "\<S-Left>\<Left>\<Left>"
		elseif cmdline =~# '\v\C^(cli|lli)' | return "\<CR>:silent " . repeat(cmdline[0], 2) . "\<Space>"
		elseif cmdline =~# '\C^changes' | set nomore | return "\<CR>:Z|norm! g;\<S-Left>"
		elseif cmdline =~# '\C^ju' | set nomore | return "\<CR>:Z|norm! \<C-o>\<S-Left>"
		elseif cmdline =~# '\v\C(#|nu|num|numb|numbe|number)$' | return "\<CR>:"
		elseif cmdline =~# '\C^ol' | set nomore | return "\<CR>:Z|e #<"
		elseif cmdline =~# '\v\C^(ls|files|buffers)' | return "\<CR>:b"
		elseif cmdline =~# '\C^marks' | return "\<CR>:norm! `"
		elseif cmdline =~# '\C^undol' | return "\<CR>:u "
		else | return "\<CR>" | endif
	else | return "\<CR>" | endif
endfunction
