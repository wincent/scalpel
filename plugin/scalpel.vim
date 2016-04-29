" Copyright 2016-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:ScalpelLoaded') || &compatible || v:version < 700
  finish
endif
let g:ScalpelLoaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

let s:command=get(g:, 'ScalpelCommand', 'Scalpel')
if s:command ==# ''
  finish
elseif match(s:command, '\v\C^[A-Z][A-Za-z]*$') == -1
  echoerr 'g:ScalpelCommand must contain only letters and start with a ' .
        \ 'capital letter'
  finish
endif
execute 'command! -nargs=1 ' . s:command . ' call scalpel#substitute(<q-args>)'

" Change all instances of current word (mnemonic: edit).
execute 'nnoremap <Plug>(Scalpel) :' .
      \ s:command .
      \ "/\\v<<C-R>=expand('<cword>')<CR>>//<Left>"

let s:map=get(g:, 'ScalpelMap', 1)
if s:map
  if !hasmapto('<Plug>(Scalpel)') && maparg('<leader>e', 'n') ==# ''
    nmap <unique> <Leader>e <Plug>(Scalpel)
  endif
endif

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions
