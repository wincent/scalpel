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

let s:command=get(g:, 'ScalpelCommand', 'Substitute')
if s:command !=# ''
  execute 'command! -nargs=1 ' . s:command . ' call scalpel#substitute(<q-args>)'
endif

" Change all instances of current word (mnemonic: edit).
execute 'nnoremap <Plug>(ScalpelSubstitute) :' .
      \ s:command .
      \ "/\\v<<C-R>=expand('<cword>')<CR>>//<Left>"

let s:map=get(g:, 'ScalpelMap', 1)
if s:map
  if !hasmapto('<Plug>(ScalpelSubstitute)') && maparg('<leader>e', 'n') ==# ''
    nmap <unique> <Leader>e <Plug>(ScalpelSubstitute)
  endif
endif

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions
