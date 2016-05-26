" Copyright 2016-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

function! scalpel#substitute(patterns, line1, line2, count) abort
  if a:count == -1
    " No range supplied, operate on whole buffer.
    let l:currentline=a:line1
    let l:firstline=1
    let l:lastline=line('$')
  else
    let l:firstline=a:line1 <= a:line2 ? a:line1 : a:line2
    let l:lastline=a:line2 >= a:line2 ? a:line2 : a:line1
    let l:currentline=l:firstline
  endif
  if match(a:patterns, '\v^/[^/]*/[^/]*/$') != 0
    echomsg 'Invalid patterns: ' . a:patterns
    echomsg 'Expected patterns of the form "/foo/bar/".'
    return
  endif
  if getregtype('s') != ''
    let l:register=getreg('s')
  endif
  normal! qs
  redir => l:replacements
  try
    execute l:currentline . ',' . l:lastline . 's' . a:patterns . 'gce#'
  catch /^Vim:Interrupt$/
    return
  finally
    normal! q
    let l:transcript=getreg('s')
    if exists('l:register')
      call setreg('s', l:register)
    endif
  endtry
  redir END
  if len(l:replacements) > 0
    " At least one instance of pattern was found.
    let l:last=strpart(l:transcript, len(l:transcript) - 1)
    if l:last ==# 'l' || l:last ==# 'q' || l:last ==# ''
      " User bailed.
      return
    elseif l:last ==# 'a'
      " Loop around to top of range/file and continue.
      " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
      if l:currentline > l:firstline
        " Drop c flag.
        execute l:firstline . ',' . l:currentline . '-&gce'
      endif
     return
    endif
  endif

  " Loop around to top of range/file and continue.
  " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
  if l:currentline > l:firstline
    execute l:firstline . ',' . l:currentline . '-&gce'
  endif
endfunction
