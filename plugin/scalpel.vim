" Change all instances of current word (mnemonic: edit).
nnoremap <Leader>e :Substitute/\v<<C-R>=expand('<cword>')<CR>>//<Left>

command! -nargs=1 Substitute call scalpel#substitute(<q-args>)
