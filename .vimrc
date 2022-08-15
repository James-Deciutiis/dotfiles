"  _______________________________________
" |\ ___________________________________ /|
" | | _                               _ | |
" | |(+)        _           _        (+)| |
" | | ~      _--/           \--_      ~ | |
" | |       /  /             \  \       | |
" | |      /  |               |  \      | |
" | |     /   |               |   \     | |
" | |     |   |    _______    |   |     | |
" | |     |   |    \     /    |   |     | |
" | |     \    \_   |   |   _/    /     | |
" | |      \     -__|   |__-     /      | |
" | |       \_                 _/       | |
" | |         --__         __--         | |
" | |             --|   |--             | |
" | |               |   |               | |
" | |                | |                | |
" | |                 |                 | |
" | |               V I M               | |
" | |   I S   G O O D   F O R   Y O U   | |
" | | _                               _ | |
" | |(+)                             (+)| |
" | | ~                               ~ | |
" |/ ----------------------------------- \|
"  ---------------------------------------
"          James-Deciutiis/vimrc

" Plugins "
call plug#begin('~/.vim/plugged')
    Plug 'preservim/nerdtree'
    Plug 'andrejlevkovitch/vim-lua-format'
    Plug 'ap/vim-css-color' 
    Plug 'ryanoasis/vim-devicons'
    Plug 'liuchengxu/space-vim-theme'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'ajmwagar/vim-deus'
    Plug 'sainnhe/everforest'
    Plug 'tpope/vim-fugitive'
    Plug 'crusoexia/vim-dracula'
    Plug 'mlopes/vim-farin'
    Plug 'domino881/kuczy'
    Plug 'vim-airline/vim-airline'
    Plug 'morhetz/gruvbox'
    Plug 'unikmask/iroh-vim'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'morhetz/gruvbox'
    Plug 'joshdick/onedark.vim'
    Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html']}
call plug#end()

" General vim configurations
set number
set laststatus=2
set tabstop=2
set shiftwidth=2
set cursorline
set softtabstop=2
set expandtab
set noshowmode
set encoding=UTF-8
set hlsearch
set showmatch
set syntax=on

" Splits settings
set splitbelow splitright
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resizing splits
nnoremap <silent> <C-Left> :vertical resize +5 <CR>
nnoremap <silent> <C-Right> :vertical resize -5 <CR>
nnoremap <silent> <C-Up>  :resize +5 <CR>
nnoremap <silent> <C-Down>  :resize -5 <CR>

" Term in Vim settings
nnoremap <C-t> :term <CR>
noremap <Esc>[1;5A <C-w> :h <CR>
set splitbelow
set termwinsize=10*

" Remove all current highlighting
nnoremap <C-c> :noh <CR>

" Save on control - s
nnoremap <C-s> :w :Prettier <CR>

" prettier settings
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" ### Color configurations ###

" forest-bridge theme
" set background=dark
" let g:everforest_background = 'hard'
" colorscheme everforest 

" set background=dark
" colorscheme dracula

" set background=dark
" colorscheme farin 

" set background=dark
" colorscheme iroh

" set background=light
" colorscheme kuczy

set background=dark
colorscheme onedark
" highlightColor = 136

highlight Visual cterm=bold ctermbg=174 ctermfg=NONE

" CoC config
nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

let g:coc_global_extensions = [
\   'coc-snippets',
\   'coc-pairs',
\   'coc-tsserver',
\   'coc-eslint',
\   'coc-prettier',
\   'coc-json',
\]

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" NerdTree Configurations
nnoremap <C-n> :NERDTreeToggle <CR>

" Automatically open NERDTree when vim opens
autocmd VimEnter * NERDTree | wincmd p

" close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Airline settings
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1
let g:airline_branch = ''

let g:airline_theme = 'onedark'
let g:airline_symbols_readonly = ''
let g:airline_symbols_linenr = ''

let g:coc_node_path = "/usr/bin/node"
" Lua formatting 
autocmd BufWrite *.lua call LuaFormat()

packloadall
